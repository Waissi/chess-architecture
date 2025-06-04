import boto3
from base64 import b64decode

def lambda_handler(event, context):
    client = boto3.client('ec2')
    service = b64decode(event['body']).decode('utf-8')
    if service == "server":
        custom_filter = [{"Name": "tag:Name", "Values": ["chess_server"]}]
        response = client.describe_instances(Filters=custom_filter)
        for reservation in response['Reservations']:
            for instance in reservation['Instances']:
                if instance['State']['Name'] == 'running':
                    address = instance['PublicIpAddress']
                    return {
                        'statusCode': 200,
                        'body':address
                    }
        return {
            'statusCode': 404,
            'body':"could not find any running server"
        }
    elif service == "allocator":
        custom_filter = [{"Name": "tag:Name", "Values": ["chess_allocator"]},]
        response = client.describe_instances(Filters=custom_filter)
        if response and response['Reservations'] and len(response['Reservations'][0]['Instances']) > 0:
            instance = response['Reservations'][0]['Instances'][0]
            if instance['State']['Name'] == 'running':
                address = instance['PublicIpAddress']
                return {
                    'statusCode': 200,
                    'body':address
                }
        return {
            'statusCode': 404,
            'body':"could not find any running allocator"
        }
    return {
        'statusCode': 404,
        'body': f"could not find service {service}"
    }

