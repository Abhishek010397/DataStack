FROM python:3-slim-buster

# Set noninteractive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update && apt-get install -y python3-pip
RUN pip install -U gunicorn
WORKDIR /app
COPY ./operations-task/rates/* /app/
RUN pip install -r /app/requirements.txt
EXPOSE 3000

CMD ["gunicorn", "-b", ":3000", "wsgi"]

