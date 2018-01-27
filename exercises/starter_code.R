

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
merged = merge(polity, wdi, by.x="country", by.y="country_name", all.x=TRUE, all.y=FALSE)

# Run some regressions! Let's see if resource curse is dependent on various
# measures of public health!

# Basic specification
model1 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap' , merged)

# Does life expectancy matter?
model2 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + life_expectancy', merged)

# What about under 5 mortality?
model3 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + under5_mortality', merged)

# Maybe maternal dealth risk
model4 = lm('polity ~ natural_resources_pct_gdp + gdp_per_cap + maternal_death_risk + ', merged)
