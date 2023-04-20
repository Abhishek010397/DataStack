import boto3
import os 

def run_ssm_command(instance_id):
    print("Going to SSM")
    ssm_client = boto3.client('ssm')
    response = ssm_client.send_command(
        InstanceIds=[instance_id],
        DocumentName='AWS-RunShellScript',
        Parameters={
            'commands': [' cd /home/ssm-user/scripts/ && sh batch_script.sh']
            
        }
    )
    return response

def lambda_handler(event, context):
    instance_id = os.environ.get("INSTANCE_ID")
    response = run_ssm_command(instance_id)
    if response['Command']['Status'] == 'Pending':
        run_ssm_command(instance_id)
    else:
        print('Success')