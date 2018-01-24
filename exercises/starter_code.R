

# Set your working directory here
setwd("/users/nick/github/InstructionalMaterials/DefensiveProgramming/exercises/")

# Load data. Need foreign packages. Can be 
# installed with command `install_package("foreign")` if 
# you don't already have it!
library(foreign)

# Load world development indicators
wdi = read.dta("wdi.dta")

# Load polity scores
polity = read.dta("polity.dta")

# Bring two datasets together
merged = merge(polity, wdi, by.x="country", by.y="country_name")

# Run some regressions! Let's see if resource curse is true. 
# (Yes, I know: a single cross-section is not a legitimate test -- 
# just want something semi-real!)

# Basic specification
model1 = lm('polity ~ natural_resources_pct_gdp', merged)

# Add in some economic controls
model2 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + urban_pct', merged)

# Well, let's add population. Maybe only holds for small countries.
model3 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + population + urban_pct ', merged)

# Oh, but what about health? That could be important for... OK, I don't have a great reason it 
# would matter. But this is just for fun. 
model4 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + population + urban_pct + life_expectancy + maternal_death_risk + under5_mortality', merged)

