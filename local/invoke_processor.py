from __future__ import print_function

import json
import urllib
import datetime
from lambda_functions.preprocessor.lambda_function import handler

print('Processing local files...')

base_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'
years = range(2009, 2023)
months = range(1,13)


def invoke_processor(file_name):
    # Define the payload for the Lambda function
    payload = {
        "Records": [
            {
                "Sns": {
                    "Message": file_name
                }
            }
        ]
    }
    handler(payload, {})
    print("Invoked preprocess function for file_name: ", file_name)


def iterate_files():
    for year in years:
        for month in months:
            if year == 2023 and month > 2: # 2023-02 is the latest dataset.
                return
            formatted_month = "{:02d}".format(month) # Add leading zeroes
            dataset_name = "yellow_tripdata_{}-{}".format(year, formatted_month)
            file_name = "{}.parquet".format(dataset_name)
            url = "{}{}".format(base_url, file_name)
            print('Process: ', file_name, url)
            invoke_processor(file_name)

print("Start time: ", datetime.datetime.now())
iterate_files()
print("End time: ", datetime.datetime.now())
