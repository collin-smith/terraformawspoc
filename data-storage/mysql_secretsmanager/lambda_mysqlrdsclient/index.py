import boto3
import json
import logging
import os
import pymysql
import datetime

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_secret(secret_name):
    client = boto3.client('secretsmanager')
    response = client.get_secret_value(SecretId=secret_name)
    secret = json.loads(response['SecretString'])
    return secret

def handler(event, context):
    print(event)

    try:
        now = datetime.datetime.now()
        serverDateTime = now.strftime("%m/%d/%Y, %H:%M:%S")

        secret_name = os.environ['SECRET_NAME']
        database_name = os.environ['DB_NAME']
        secret = get_secret(secret_name)
        connection = pymysql.connect(
            host=secret['host'],
            user=secret['username'],
            password=secret['password'],
            db=database_name
        )


        sql_string = f"SELECT NOW();"
        databaseTime = "No Time"
        try:
            with connection.cursor() as cursor:
                # Run a sample query
                cursor.execute("SELECT NOW();")
                result = cursor.fetchone()
                now = result[0]
                databaseTime = ""+ now.strftime("%m/%d/%Y, %H:%M:%S")
                logger.info(f"RESULT: {result[0]}")
        finally:
            connection.close()

        #Start to formulate the response
        json_data = [{
                      "databaseTime": databaseTime, 
                      "serverTime": serverDateTime
                        }]
    
        logger.info("logger.info json_data=%s",json_data)

        return {
            'statusCode': 200,
             'headers': {
                "Access-Control-Allow-Origin": "*",
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
