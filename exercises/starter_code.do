* Set working directory here
cd /users/nick/github/instructionalmaterials/defensiveprogramming/exercises

* Load polity data
use polity, clear

* Merge with wdi (use the var country_name)
rename country country_name
merge 1:1 country_name using wdi

**********
* Let's run some regressions!
**********

* Basic specification
reg polity natural_resources_pct_gdp

* Add in some economic controls
reg polity natural_resources_pct_gdp gdp_per_cap urban_pct

* Well, let's add population. Maybe only holds for small countries.
reg polity natural_resources_pct_gdp gdp_per_cap population urban_pct

* Oh, but what about health? That could be important for... OK, I don't have a great reason it
* would matter. But this is just for fun.
reg polity natural_resources_pct_gdp gdp_per_cap population urban_pct life_expectancy maternal_death_risk under5_mortality
