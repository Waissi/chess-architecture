import boto3
from base64 import b64decode

def lambda_handler(event, context):
    service = b64decode(event['body']).decode('utf-8')
    if service == "server":
        client = boto3.client('elbv2')
        response = client.describe_load_balancers(Names=['chess-server-lb'])
        if response:
            for lb in response['LoadBalancers']:
                address = lb['DNSName']
                return {
                    'statusCode': 200,
                    'body':address
                }
        return {
            'statusCode': 404,
            'body':"could not find any running server"
        }
    elif service == "allocator":
        client = boto3.client('ec2')
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


