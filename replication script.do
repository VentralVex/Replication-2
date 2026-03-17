use "/Users/aditpakala/Downloads/Replication 2/panel.dta", clear

* Create lagged wheat production
encode country, gen(country_id)
xtset country_id year
gen wheat_prod_lag = L.us_wheat_prod

* Create instrument and interactions
gen instrument = wheat_prod_lag * avg_prob_food_aid
gen gdppc_x_prob = real_GDPPC * avg_prob_food_aid
gen dem_pres_x_prob = democratic_president * avg_prob_food_aid
gen oil_x_prob = real_oil_price * avg_prob_food_aid
gen mil_aid_x_year = military_aid * avg_prob_food_aid
gen econ_aid_x_year = economic_aid * avg_prob_food_aid
gen cereal_imports_x_year = avg_net_imports_cereals_pc * avg_prob_food_aid
gen cereal_prod_x_year = avg_cereal_prod_pc * avg_prob_food_aid

* Encode country and region-year for fixed effects
egen region_year = group(region year)

* --------------------
* Panel A: OLS
* --------------------

* Col 1
reghdfe has_conflict wheat_aid, absorb(country_id region_year) vce(cluster country_id)
eststo ols1

* Col 2
reghdfe has_conflict wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob, absorb(country_id region_year) vce(cluster country_id)
eststo ols2

* Col 3 (same as 2 without weather, so identical here)
reghdfe has_conflict wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob, absorb(country_id region_year) vce(cluster country_id)
eststo ols3

* Col 4
reghdfe has_conflict wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo ols4

* Col 5 (baseline)
reghdfe has_conflict wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo ols5

* Col 6: intrastate
reghdfe has_intrastate wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo ols6

* Col 7: interstate
reghdfe has_interstate wheat_aid gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo ols7

* --------------------
* Panel B: Reduced form
* --------------------

reghdfe has_conflict instrument, absorb(country_id region_year) vce(cluster country_id)
eststo rf1

reghdfe has_conflict instrument gdppc_x_prob dem_pres_x_prob oil_x_prob, absorb(country_id region_year) vce(cluster country_id)
eststo rf2

reghdfe has_conflict instrument gdppc_x_prob dem_pres_x_prob oil_x_prob, absorb(country_id region_year) vce(cluster country_id)
eststo rf3

reghdfe has_conflict instrument gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo rf4

reghdfe has_conflict instrument gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo rf5

reghdfe has_intrastate instrument gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo rf6

reghdfe has_interstate instrument gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year, absorb(country_id region_year) vce(cluster country_id)
eststo rf7

* --------------------
* Panel C & D: 2SLS
* --------------------

ivreghdfe has_conflict (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv1

ivreghdfe has_conflict gdppc_x_prob dem_pres_x_prob oil_x_prob (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv2

ivreghdfe has_conflict gdppc_x_prob dem_pres_x_prob oil_x_prob (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv3

ivreghdfe has_conflict gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv4

ivreghdfe has_conflict gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv5

ivreghdfe has_intrastate gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv6

ivreghdfe has_interstate gdppc_x_prob dem_pres_x_prob oil_x_prob mil_aid_x_year econ_aid_x_year cereal_imports_x_year cereal_prod_x_year (wheat_aid = instrument), absorb(country_id region_year) cluster(country_id)
eststo iv7

* --------------------
* Output table
* --------------------

esttab ols1 ols2 ols3 ols4 ols5 ols6 ols7 using "table2_panelA.tex", ///
    keep(wheat_aid) se r2 nostar label replace ///
    booktabs compress nomtitle

esttab rf1 rf2 rf3 rf4 rf5 rf6 rf7 using "table2_panelB.tex", ///
    keep(instrument) se r2 nostar label replace ///
    booktabs compress nomtitle

esttab iv1 iv2 iv3 iv4 iv5 iv6 iv7 using "table2_panelC.tex", ///
    keep(wheat_aid) se r2 nostar label replace ///
    booktabs compress nomtitle
