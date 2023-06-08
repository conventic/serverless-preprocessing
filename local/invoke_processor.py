from __future__ import print_function

import json
import urllib

print('Processing local files...')

base_url = 'https://d37ci6vzurychx.cloudfront.net/trip-data/'
years = range(2009, 2023)
months = range(1,13)


def iterate_files():
    for year in years:
        for month in months:
            if year == 2023 and month > 2: # 2023-02 is the latest dataset.
                return
            formatted_month = "{:02d}".format(month) # Add leading zeroes
            dataset_name = "yellow_tripdata_{}-{}".format(year, formatted_month)
            filename = "{}.parquet".format(dataset_name)
            url = "{}{}".format(base_url, filename)
            print('Process: ', filename, url)
            # TODO: invoke actual processor with filename

iterate_files()
