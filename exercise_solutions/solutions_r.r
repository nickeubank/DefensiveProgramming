

# Set your working directory here
setwd("/users/nick/github/InstructionalMaterials/DefensiveProgramming/exercise_solutions/")

# Load data. Need foreign packages. Can be
# installed with command `install_package("foreign")` if
# you don't already have it!
library(foreign)

# Load world development indicators
wdi = read.dta("wdi.dta")

  # In this case duplicate entries are perfect duplicates,
  # so I can just drop
wdi = wdi[ !duplicated(wdi$country_name), ]

# Load polity scores
polity = read.dta("polity.dta")

#####
# Bring two datasets together
#####
  # Check for duplicates
  stopifnot( !anyDuplicated(polity$country) )
  stopifnot( !anyDuplicated(wdi$country_name) )

  # Fix a few names
  polity[polity$country == "Myanmar (Burma)", 'country'] = "Myanmar"
  polity[polity$country == "Russia", 'country'] = "Russian Federation"

wdi$temp = 1
merged = merge(polity, wdi, by.x="country", by.y="country_name", all.x=TRUE, all.y=FALSE)

  # Make sure all polities merged with a wdi entry
  stopifnot( !any( is.na(merged$temp) ) )

# Run some regressions! Let's see if resource curse is dependent on various
# measures of public health!

base_specification = 'polity ~ natural_resources_pct_gdp + gdp_per_cap'

# Basic specification
model1 = lm( paste(base_specification) , merged)

# Does life expectancy matter?
model2 = lm( paste(base_specification, ' + life_expectancy'), merged)

# What about under 5 mortality?
model3 = lm(paste(base_specification, ' + under5_mortality'), merged)

# Maybe maternal dealth risk
model4 = lm(paste(base_specification, ' + maternal_death_risk'), merged)

library(stargazer)
stargazer(list(model1, model2, model3, model4), title="Resource curse and public health",
          type="latex", dep.var.caption="Polity Score",
          dep.var.labels.include=FALSE,
          out='resource_curse_regressions.tex' )
