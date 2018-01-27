* Set working directory here
cd /users/nick/github/instructionalmaterials/defensiveprogramming/exercise_solutions

* Load WDI data.
* Provides data on all possibly included countries.
use wdi, clear

    * Have to get rid of duplicates!
    * They're prefect duplicates, so
    * doesn't require force option.
    duplicates drop


* Merge with polity.
* Should be a perfect subset of WDI data.
rename country_name country

    * Fix imperfect merge values
    replace country = "Myanmar (Burma)" if country == "Myanmar"
    replace country = "Russia" if country == "Russian Federation"

merge 1:1 country using polity.dta

* Since polity is a perfect subset, then all should merge!
assert _m != 2

**********
* Let's run some regressions!
**********

* Put common controls into a macro to prevent duplication
local base_specification = "polity natural_resources_pct gdp_per_cap"


* Export via esttab!
set more off
eststo clear

* Basic specification
eststo: reg `base_specification'

* Does life expectancy matter?
eststo: reg `base_specification' life_expectancy

* What about under 5 mortality?
eststo: reg `base_specification' under5_mortality

* Maybe maternal dealth risk
eststo: reg `base_specification' maternal_death_risk

esttab

esttab using resource_curse_regressions.tex, label replace ///
	  title("Resource Curse and Public Health! \label{resourcecurseregressions}")
