import requests
from pprintpp import pprint as pp
import csv
import json

# Refer to the coingecko API documentation for all endpoints.
# Make a call to get all of the coins using the /coins/list endpoint
response = requests.get('https://api.coingecko.com/api/v3/coins/list')

pp(dir(response))
# Some key parts of 'response'
# status_code is the HTTP response code
# headers are the HTTP headers from the Server
# json is the payload parsed as JSON if appropriate
# text is the response data as a string
# content is the response data as raw byes

# Here we want to get the JSON response data and save it as a csv file

# Get the list as JSON from the response data
coin_list = response.json()

# create a csv file to write the info to. Enumerate allows us to write the keys only
# only for the first row and only values after that.
with open('coins.csv', 'w', encoding="utf-8", newline='') as f:
    csv_writer = csv.writer(f)
    for index, item in enumerate(coin_list):
        if index == 0:
            csv_writer.writerow(item.keys())
        csv_writer.writerow(item.values())
