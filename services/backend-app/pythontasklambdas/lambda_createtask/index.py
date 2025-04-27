import boto3
import json
import logging
import os
import pymysql
import random
import datetime

#Sample JSON request
#{
#    "title":"My new Task",
#    "priority":"1",
#    "notes":"I should really do this!",
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
        title = body['title']
        priority = body['priority']
        notes = body['notes']
        duedate = body['duedate']

        success = False
        logger.info("DueDate=%s",duedate)
        sql_string1 = f"INSERT INTO TASK (TITLE, PRIORITY, NOTES, DUEDATE ,CREATED , UPDATED) VALUES ('%s',%s,'%s','%s', now(), now())"
        sql = sql_string1 % (title,priority,notes,duedate)
        logger.info("SQL=%s",sql)
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
             "success" : success
         }]
    
        logger.info("logger.info json_data=%s",json_data)

        return {
            'statusCode': 200,
             'headers': {
                "Access-Control-Allow-Origin" : "*", 
                "Access-Control-Allow-Credentials" : "true",
                "Access-Control-Allow-Methods": 'GET, POST, PUT, DELETE, OPTIONS'
                },
            'body': json.dumps(json_data)
        }
    except Exception as e:
        logger.error('Error during Lambda execution', exc_info=True)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }



