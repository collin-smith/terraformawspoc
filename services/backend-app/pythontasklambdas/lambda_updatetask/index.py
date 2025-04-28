import boto3
import json
import logging
import os
import pymysql
import random
import datetime

#Sample JSON request
#{
#    "id":"2",
#    "title":"My new UPDATED Task",
#    "priority":"1",
#    "notes":"I should really do this UPDATED TASK!",
#    "duedate":"2025-06-24 13:23:30"
#}

def get_secret(secret_name):
    print("getsecret")
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    return secret

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event, context):

    logger.info("Starting lambda execution")
    try:
        secret_name = os.environ['SECRET_NAME']
        database_name = os.environ['DB_NAME']
        secret = get_secret(secret_name)
        connection = pymysql.connect(
            host=secret['host'],
            user=secret['username'],
            password=secret['password'],
            db=database_name
        )
         #Examine some of the event properties
        path = event['path']
        httpMethod = event['httpMethod']
        queryStringParameters = event['queryStringParameters']
        #Not for GETS body = json.loads(event.get('body', '{}'))

        #Extract the customer name from the request body
        body = json.loads(event.get('body', '{}'))

        id = body['id']
        title = body['title']
        priority = body['priority']
        notes = body['notes']
        duedate = body['duedate']

        sql_string1 = f"UPDATE TASK SET TITLE='%s', PRIORITY=%s, NOTES='%s', DUEDATE='%s' , UPDATED=now() WHERE ID=%s"
        sql = sql_string1 % (title,priority,notes,duedate,id)
        logger.info("SQL=%s",sql)
        success = False
        try:
            with connection.cursor() as cursor:
                # Add Record record to Customer table
                cursor.execute(sql)
                connection.commit()
                success = True
        finally:
            connection.close()

        #Start to formulate the response
        json_data = [{
             "success" : success}]
    
        logger.info("logger.info json_data=%s",json_data)

        return {
            'statusCode': 200,
             'headers': {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',  # Use '*' for allowing any origin, or specify a domain to restrict access
        'Vary': 'Origin',
        'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',  # Optionally add other methods your API supports
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,Access-Control-Allow-Origin,Access-Control-Allow-Methods',  # Optionally specify other headers your API accepts

                },
            'body': json.dumps(json_data)
        }
    except Exception as e:
        logger.error('Error during Lambda execution', exc_info=True)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }
