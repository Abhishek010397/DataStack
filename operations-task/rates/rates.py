import psycopg2
from datetime import datetime
import boto3
import json
from flask import Flask, request, jsonify
from psycopg2.extras import DictCursor
from werkzeug.exceptions import BadRequest
import re


secret_name = "flaskwebapp/rds/rds-postgres-secret"
region_name = "ap-southeast-1"
session = boto3.session.Session()
client = session.client(
    service_name='secretsmanager',
    region_name=region_name
)

try:
    response = client.get_secret_value(
        SecretId=secret_name
    )
except ClientError as e:
    raise e
​
​
secret_data = json.loads(response['SecretString'])
# Extract database connection details
db_host = secret_data['DB_HOST']
db_user = secret_data['DB_USER']
db_pass = secret_data['DB_PASSWORD']
db_dbname = secret_data['DB_NAME']
​
​
def extract_host_port(text):
    pattern = r'^(.*):(\d+)$'
    match = re.search(pattern, text)
    if match:
        host = match.group(1)
        port = int(match.group(2))
        return host, port
    else:
        return None, None
​
def create_app():
    """Creat the server application"""
    app = Flask(__name__)
​
    # Make JSON output pretty by default
    app.config["JSONIFY_PRETTYPRINT_REGULAR"] = True
    host,port = extract_host_port(db_host)
    conn = psycopg2.connect(
            host = host,
            port = port,
            database = db_dbname,
            user = db_user,
            password = db_pass
    )
​
    def get_cursor():
        """Get database dict cursor."""
        cur = conn.cursor(cursor_factory=DictCursor)
        return cur
​
    def get_rows(query, params=None):
        """Get all rows from a database query"""
        cur = get_cursor()
        cur.execute(query, params)
        rows = cur.fetchall()
        return rows
​
    def aggregate_to_dto(row):
        """Transform a database dict row into a json serializable dict."""
        dto = {
            "price": float(row["price"]) if row["price"] is not None else None,
            "day": row["day"].isoformat(),
            "count": row["count"],
        }
        return dto
​
    def parse_iso_date(value):
        """ Try to parse a value into a datetime """
        try:
            datetime.strptime(value, "%Y-%m-%d")
            return value
        except Exception:
            return None
​
    @app.route("/")
    def hello_world():
        return jsonify({
            "message": "Hello world!"
        })
​
    @app.route("/rates", methods=["GET"])
    def get_rates():
        """
            Get average price per day in a timespan using portcode or region
            slugs.
        """
        orig_code = request.args.get("orig_code")
        dest_code = request.args.get("dest_code")
        date_from = parse_iso_date(request.args.get("date_from"))
        date_to = parse_iso_date(request.args.get("date_to"))
​
        if not date_from or not date_to:
            raise BadRequest("Invalid date arguments")
        if orig_code and dest_code:
            return get_rates_using_codes(
                date_from, date_to, orig_code, dest_code
            )
        raise BadRequest("Invalid location arguments")
​
    def get_rates_using_codes(date_from, date_to, orig_code, dest_code):
        rows = get_rows(
            (
                """SELECT
                    CASE WHEN a.count < 3 THEN null ELSE a.price END AS price,
                    d.day,
                    a.count
                FROM
                (
                    SELECT (
                        generate_series(
                            %(date_from)s, %(date_to)s, '1 day'::interval
                        )
                    )::date as day
                ) d
                LEFT OUTER JOIN (
                    SELECT AVG(price) AS price, day, COUNT(*) AS count
                    FROM prices
                    WHERE
                        orig_code = %(orig_code)s AND
                        dest_code = %(dest_code)s AND
                        day >= %(date_from)s AND
                        day <= %(date_to)s
                    GROUP BY day, orig_code, dest_code
                ) AS a ON d.day = a.day
                ORDER BY day DESC"""
            ),
            {
                "date_from": date_from,
                "date_to": date_to,
                "orig_code": orig_code,
                "dest_code": dest_code
            }
        )
​
        rates = [aggregate_to_dto(row) for row in rows]
        return jsonify({"rates": rates})
​
    return app