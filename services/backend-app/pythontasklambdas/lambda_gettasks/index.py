import boto3
import json
import logging
import os
import pymysql
import random
import datetime

#SHOW DATABASES;

#CREATE DATABASE POC;
#USE POC;
#CREATE TABLE TASK
#(
#ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
#TITLE VARCHAR(100),
#PRIORITY INT NOT NULL,
#NOTES VARCHAR(1000),
#DUEDATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
#CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
#UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
#);


#INSERT INTO TASK (TITLE,PRIORITY,NOTES,DUEDATE,CREATED,UPDATED) VALUES ("Something important", 1, "I should really get this done!","2026-06-24 13:23:30",CURRENT_TIMESTAMP(),CURRENT_TIMESTAMP());




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

         #Examine some of the event properties
        path = event['path']
        httpMethod = event['httpMethod']
        queryStringParameters = event['queryStringParameters']
        #Not for GETS body = json.loads(event.get('body', '{}'))

        secret_name = os.environ['SECRET_NAME']
        database_name = os.environ['DB_NAME']
        secret = get_secret(secret_name)
        connection = pymysql.connect(
            host=secret['host'],
            user=secret['username'],
            password=secret['password'],
            db=database_name
        )

        sql_string = f"SELECT ID, TITLE,PRIORITY,NOTES,DATE_FORMAT(DUEDATE, '%Y-%m-%d %H:%i:%s'),DATE_FORMAT(CREATED, '%Y-%m-%d %H:%i:%s'),DATE_FORMAT(UPDATED, '%Y-%m-%d %H:%i:%s') FROM TASK ORDER BY DUEDATE ASC"
        number_of_records = 0
        datarows = []
        try:
            with connection.cursor() as cursor:
                # Select records from CUSTOMER table
                cursor.execute(sql_string)
                for row in cursor:
                    number_of_records += 1
                    logger.info(row)
                    datarows.append(row)
                connection.commit()
        finally:
            connection.close()

        #Iterate data set to create formed json
        n = len(datarows)
        items = []
        for i in range(n):
            row_data = {}
            row_data["id"] = datarows[i][0]
            row_data["title"] = datarows[i][1]
            row_data["priority"] = datarows[i][2]
            row_data["notes"] = datarows[i][3]
            row_data["duedate"] = datarows[i][4]
            row_data["created"] = datarows[i][5]
            row_data["updated"] = datarows[i][6]
            items.append(row_data)
            logger.info(datarows[i])

        #Start to formulate the response
        #json_data = [{
        #              "data" : items,
        #                }]
    
        #logger.info("logger.info json_data=%s",json_data)

        return {
            'statusCode': 200,
             'headers': {
                "Access-Control-Allow-Origin" : "*", 
                "Access-Control-Allow-Credentials" : "true",
                "Access-Control-Allow-Methods": 'GET, POST, PUT, DELETE, OPTIONS'
                },
            'body': json.dumps(items)
        }
    except Exception as e:
        logger.error('Error during Lambda execution', exc_info=True)
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)}),
        }



