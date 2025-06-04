import json
from base64 import b64decode
import boto3
from boto3.dynamodb.conditions import Attr

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('chess_server_db')

def lambda_handler(event, context):
    if event['requestContext']['http']['method'] == 'GET':
        playerId = b64decode(event['body']).decode('utf-8')
        gameData = table.scan(FilterExpression=Attr('gameId').contains(playerId))
        if 'Items' in gameData:
            return {
                'statusCode': 200,
                'body': gameData['Item']['game']
            }
        else:
            return {
                'statusCode': 404,
                'body': json.dumps('Game not found')
            }
    elif event['requestContext']['http']['method'] == 'POST':
        body = b64decode(event['body']).decode('utf-8')
        game = json.loads(body)
        id = game['id']
        response = table.put_item(Item={'gameId': id, 'game': body})
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            return {
                'statusCode': 200,
            }
        else:
            return {
                'statusCode': 500,
            }
    elif event['requestContext']['http']['method'] == 'DELETE':
        gameId = b64decode(event['body']).decode('utf-8')
        response = table.delete_item(Key={'gameId': gameId})
        if response['ResponseMetadata']['HTTPStatusCode'] == 200:
            return {
                'statusCode': 200,
            }
        else:
            return {
                'statusCode': 500,
            }
