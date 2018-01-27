#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Jan 24 13:11:18 2018

@author: Nick
"""
import pandas as pd
import os
os.chdir('/users/nick/github/instructionalmaterials/defensiveprogramming/')
polity = pd.read_excel('exercise_builder/polity.xls')
wdi = pd.read_csv('exercise_builder/WDI.csv', na_values='..')

# Thin out
polity = polity.query("year == 2010")[['scode', 'country', 'democ', 'autoc', 'polity']]
polity = polity[polity.country != "Taiwan"]
polity = polity[pd.notnull(polity.country)]

replaces = [{"old": "Bosnia", "new": "Bosnia and Herzegovina"}, 
            {"old": "Cape Verde", "new": "Cabo Verde"}, 
            {"old": "Congo Brazzaville", "new": "Congo, Rep."}, 
            {"old": "Congo Kinshasa", "new": "Congo, Dem. Rep."}, 
            {"old": "East Timor", "new": "Timor-Leste"}, 
            {"old": "Egypt", "new": "Egypt, Arab Rep."}, 
            {"old": "Gambia", "new": "Gambia, The"}, 
            {"old": "Iran", "new": "Iran, Islamic Rep."}, 
            {"old": "Ivory Coast", "new": "Cote d'Ivoire"}, 
            {"old": "Korea North", "new": "Korea, Dem. People's Rep."}, 
            {"old": "Korea South", "new": "Korea, Rep."}, 
            {"old": "Kyrgyzstan", "new": "Kyrgyz Republic"}, 
            {"old": "Laos", "new": "Lao PDR"}, 
            {"old": "Macedonia", "new": "Macedonia, FYR"}, 
            {"old": "Syria", "new": "Syrian Arab Republic"}, 
            {"old": "UAE", "new": "United Arab Emirates"}, 
            {"old": "Venezuela", "new": "Venezuela, RB"}, 
            {"old": "Yemen", "new": "Yemen, Rep."}]

for r in replaces:
    polity['country'] = polity.country.str.replace(r['old'], r['new'])

renames = {'Country Name': 'country_name', 
          'Country Code': 'country_code',
          'GDP per capita, PPP (constant 2011 international $) [NY.GDP.PCAP.PP.KD]': 'gdp_per_cap',
          'Literacy rate, adult total (% of people ages 15 and above) [SE.ADT.LITR.ZS]': 'literacy_rate',
          'Total natural resources rents (% of GDP) [NY.GDP.TOTL.RT.ZS]': 'natural_resources_pct_gdp',
          'Population, total [SP.POP.TOTL]': 'population',
          'Urban population (% of total) [SP.URB.TOTL.IN.ZS]': 'urban_pct',
          'Life expectancy at birth, total (years) [SP.DYN.LE00.IN]': 'life_expectancy',
          'Lifetime risk of maternal death (%) [SH.MMR.RISK.ZS]': 'maternal_death_risk',
          'Mortality rate, under-5 (per 1,000 live births) [SH.DYN.MORT]': 'under5_mortality'}

wdi = wdi.rename(renames, axis = 'columns')
    
wdi = wdi[list(renames.values())]
wdi = wdi[pd.notnull(wdi.country_name)]
wdi['country_name'] = wdi.country_name.str.replace(u"(\u2018|\u2019)", "'")

# Add duplicate rows to WDI as bug to be caught with test. 
start = len(wdi)
wdi = pd.concat([wdi, wdi.sample(5)])
assert len(wdi) == start + 5

wdi.to_stata('exercises/wdi.dta')
polity.to_stata('exercises/polity.dta')

a = pd.merge(wdi, polity, how='outer', left_on='country_name', right_on='country', 
             indicator=True, validate='m:1')

# Russia and Myanmar have deliberately different spellings
assert not (a._merge != "right_only").all()
