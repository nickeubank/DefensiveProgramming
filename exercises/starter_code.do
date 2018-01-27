* Set working directory here
cd /users/nick/github/instructionalmaterials/defensiveprogramming/exercises

* Load WDI data.
* Provides data on all possibly included countries.
use wdi, clear

* Merge with polity.
* Should be a perfect subset of WDI data.
rename country_name country
merge 1:1 country using polity.dta

**********
* Let's run some regressions!
**********

* Basic specification
reg polity natural_resources_pct_gdp gdp_per_cap

* Does life expectancy matter?
reg polity natural_resources_pct_gdp gdp_per_cap life_expectancy

* What about under 5 mortality?
reg polity natural_resources_pct_gdp gdp_per_cap under5_mortality

* Maybe maternal dealth risk
reg polity natural_resources_pct_gdp gdp_per_cap maternal_death_risk
