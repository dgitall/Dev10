# -*- coding: utf-8 -*-
"""
Created on Tue Jan  4 22:17:14 2022

@author: Darrell
"""
from bs4 import BeautifulSoup
import requests

from pprintpp import pprint as pp

def getHTML(url):
    response = requests.get(url)
    return response.text

# Get the HTML from the website
html = getHTML("https://www.countrycode.org")

# Parse the data
soup = BeautifulSoup(html,'html.parser')

table = soup.find('table',attrs = {'class':'main-table'})

# Loop through the rows and put the cells in the right places in the 
# dictionary in the list
# The list to store our dictionaries for each line
countries = []
for row in table.find_all('tr'):
    cells = row.find_all('td')
    # The dictionary we will place values in
    country = {}
    # Country name is in first cell
    country['name'] = cells[0].string    
    # Split up the country ISO codes into two values
    countrycodes = cells[2].string
    country['iso-2'] = countrycodes.split('/')[0]
    country['iso-3'] = countrycodes.split('/')[1]
    
    if(len(cells) > 4):
        country['population'] = cells[3].string
        if(len(cells) > 5):
            country['area'] = cells[4].string
            if(len(cells) > 6):
                countrygdp = cells[5].string
                if countrygdp is not None:
                    country['gdp'] = countrygdp.split(' ')[0]
                    country['gdpunits'] = countrygdp.split(' ')[1]
                else:
                    country['gdp'] = None
                    country['gdp'] = None
            else:
                country['gdp'] = None
                country['gdp'] = None
        else:
            country['area'] = None
    else:
        country['population'] = None

    
    countries.append(country)

pp(countries)
