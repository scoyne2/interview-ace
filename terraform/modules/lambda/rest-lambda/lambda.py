import base64
import json
import psycopg2
import os

host = os.environ.get('host')
user = os.environ.get('user')
password = os.environ.get('password')
database = os.environ.get('database')

conn = psycopg2.connect(user=user, password=password, host=host, database=database)

def lambda_handler(event, context):

    decoded_dict = event

    with conn.cursor() as cur:
        query = """
            INSERT INTO users (id, allow_notifications, days_of_streak, overall_progress, remaining_tasks)
            VALUES ('{}', {}, {}, {}, {})
            ON CONFLICT (id)
            DO UPDATE SET
              allow_notifications = EXCLUDED.allow_notifications,
              days_of_streak = EXCLUDED.days_of_streak,
              overall_progress = EXCLUDED.overall_progress,
              remaining_tasks = EXCLUDED.remaining_tasks;
        """.format(decoded_dict["user_id"], decoded_dict["allow_notifications"], decoded_dict["days_of_streak"], decoded_dict["overall_progress"], decoded_dict["remaining_tasks"])
        cur.execute(query)
        cur.close()
    conn.commit()
            
    return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
                'Access-Control-Allow-Credentials': 'true',
                'Content-Type': 'application/json'
            },
            'body': f'Profile updated for user {decoded_dict["user_id"]}'
        }
