*=================================*
***Aspirations Data Exploration***
*=================================*

*********************************************************************************************************************

/* 
1. Define all outcome variables that are of interest for correlations
*	a. aggregate aspirations
*	b. aspirations by dimension (3)
*	c. aspirations gap - aggregate: control for 'starting point' aka their orignial rank within a dimension? (rank_DIMENSION)
*	d. input usage as determined by quantity of basal or top dressing fertilizer used on all plantings this season
*	e. How to use "change" variables: exp_how_DIMENSION - categorical variables as dependent variable
2. Address Dummy Variable Concern
3. Select all "controls" - these will be the variables suspected of being correllated with the outcomes
4. Ensure that all variables are a. "clean" b. defined with labels
5. Regress against all outcomes
*/

*********************************************************************************************************************

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS"

* once a complete cleaning file is created use it in the RISK.do prior to this analysis
use HICPS_RISK.dta, clear



*********************
* Data Manipulation *
*********************


************************************************************************************************************/*
/* CURRENT CONCERN:
does stata (or R) know what is omitted if I leave the generated binaruy variables as such and omit one myself?
*/
*************************************************************************************************************/

*subset to only include observations with 
keep if year == 2019

*separate multiple rainall event reports
split rainfall_events, p(",")

forvalues i = 1/5 {
	destring rainfall_events`i', replace
}

* dummies for experiencing certain weather events in 18/19
gen late_rain = 0
gen dry_spell = 0
gen low_seasonal_rain = 0
gen warm_temps = 0
gen flooding = 0
gen rainfall_other = 0

replace late_rain = 1 if rainfall_events1 == 1
label var late_rain "Experienced late rains in the 2018-2019 growing season"

replace dry_spell = 1 if rainfall_events1 == 2 | rainfall_events2 == 2
label var late_rain "Experienced a dry spell in the 2018-2019 growing season"

replace low_seasonal_rain = 1 if rainfall_events1 == 3 | rainfall_events2 == 3 | rainfall_events3 == 3
label var late_rain "Experienced lower than average seasonal rainfall in the 2018-2019 growing season"

replace warm_temps = 1 if rainfall_events1 == 4 | rainfall_events2 == 4 | rainfall_events3 == 4 | rainfall_events4 == 4
label var late_rain "Experienced warmer than average temperatures in the 2018-2019 growing season"

replace flooding = 1 if rainfall_events1 == 5 | rainfall_events2 == 5 | rainfall_events3 == 5 | rainfall_events4 == 5 | rainfall_events5 == 5
label var late_rain "Experienced flooding in the 2018-2019 growing season"

* growing seasons affected by drought
split drought_seasons, generate() p(",") destring 

* dummies for specific drought seasons affected
gen drought_19 = 0
gen drought_18 = 0
gen drought_17 = 0
gen drought_16 = 0

replace drought_19 = 1 if drought_seasons1 == 1
label var drought_19 "Experienced a drought in the 2018-2019 growing season"

replace drought_18 = 1 if drought_seasons1 == 2 | drought_seasons2 == 2
label var drought_18 "Experienced a drought in the 2017-2018 growing season"

replace drought_17 = 1 if drought_seasons1 == 3 | drought_seasons2 == 3 | drought_seasons3 == 3
label var drought_17 "Experienced a drought in the 2016-2017 growing season"

replace drought_16 = 1 if drought_seasons1 == 4 | drought_seasons2 == 4 | drought_seasons4 == 3 | drought_seasons4 == 4
label var drougth_16 "Experienced a drought in the 2015-2016 growing season"




*********************
* Outcome Variables *
*********************

** Aspirations **

* Aggregate Aspirations
gen agg_asp = rank_land_10 + rank_livestock_10 + rank_asset_10
label var agg_asp "Aggregated aspirations for land, livestock and assets in 10 years"

gen agg_asp_nolivestock = rank_land_10 + rank_asset_10
label var agg_asp_nolivestock "Aggregated aspirations for land and assets in 10 years"

* Disaggregate aspirations measures exist in data already
* rank_land_10
* rank_livestock_10
* rank_asset_10


* Aspirations Gaps
gen asp_size_land = rank_land_10 - rank_land
label var asp_size_land "Difference between aspired level of land ownership and current ownerhsip"

gen asp_size_livestock = rank_livestock_10 - rank_livestock
label var asp_size_livestock "Difference between aspired level of livestock ownership and current ownerhsip"

gen asp_size_asset = rank_asset_10 - rank_asset
label var asp_size_asset "Difference between aspired level of asset ownership and current ownerhsip"


* Aggregate Aspirations Gap (magnitude of aspirations across all dimensions)
gen aggregate_asp_gap = asp_size_land + asp_size_livestock + asp_size_asset
label var aggregate_asp_gap "Aggregatred difference between aspirations and current ownership levels for all dimensions"
gen aggregate_asp_gap_nolivestock = asp_size_land  + asp_size_asset
label var aggregate_asp_gap_nolivestock "Aggregatred difference between aspirations and current ownership levels for all dimensions minus livestock"

** Input Usage **

*13.24 -  qbasal_n: how much basal dressing fertilizer was applied (kgs)
*13.25 - qtop_n: how much top dressing fertilizer was applied (kgs)
** this excludes any nonsynthetic fertilizers such as manure

* data missing due to skip logic from previous Q asking if certain types of fert was used
forvalues i = 1/5 {
	replace qbasal_`i' = 0 if qbasal_`i' == .
	replace qtop_`i' = 0 if qtop_`i' == .
}

* create aggregate synthetic fertilizer usage variables
gen qbasal_total = qbasal_1 + qbasal_2 + qbasal_3 + qbasal_4 + qbasal_5
label var qbasal_total "Aggregated basal fertilizer usage across all 5 plantings"

gen qtop_total = qtop_1 + qtop_2 + qtop_3 + qtop_4 + qtop_5
label var qtop_total "Aggregated top dressing fertilizer usage across all 5 plantings"

gen qfert_total = qbasal_total + qtop_total
label var qfert_total "Total synthetic fertilizer usage across all 5 plantings in 18/19"


*Q20.7 - vfert - how much of FISP voucher was spent on fertilizer
replace vfert = 0 if vfert == .

*Q13.23 - ferts_n(1-5 depending on # of maize plantings): what types of fertilizers were used for this planting (current)

** Farm Managment Techniques more broadly?
*Q13.26 - inter_n - Did you intercrop this season?

** Changes in aspirations - TBH not sure how to use these as outcomes...
replace exp_how_livestock = 0 if exp_how_livestock == .
replace exp_how_land = 0 if exp_how_land == .
replace exp_how_asset = 0 if exp_how_asset == .

label define change 1 "Higher" 4 "Lower" 0 "No Change"
label value exp_how_livestock exp_how_land exp_how_asset change

label var exp_how_livestock "How has aspirations for livestock changed"
label var exp_how_land "How has aspirations for land changed"
label var exp_how_asset "How has aspirations for assets changed"



************
* Controls *
************

*weather - ommiting flooding
global weather late_rain dry_spell low_seasonal_rain warm_temps 

* drought season dummies - omitting 2016
global drought drought_19 drought_18 drought_17

*risk coeff: s_n_hat

*various rainfall events: ib3.rainfall_19
label define rainfall 1 "Severe drought" 2 "Moderate drought" 3 "Average" 4 "Above Average" 5 "Too much"
label value rainfall_19 rainfall

*aspirations - input regressions
global aspirations rank_land_10 rank_livestock_10 rank_asset_10


***************
* Regressions *
***************

* aspirations by dimension
reg rank_land_10 $weather $drought s_n_hat ib3.rainfall_19 
reg rank_livestock_10 $weather $drought s_n_hat ib3.rainfall_19
reg rank_asset_10 $weather $drought s_n_hat ib3.rainfall_19

* aggregated aspirations 
reg agg_asp $weather $drought s_n_hat ib3.rainfall_19
reg agg_asp_nolivestock $weather $drought s_n_hat ib3.rainfall_19

* aspirations gaps by dimensions
reg asp_size_land $weather $drought s_n_hat ib3.rainfall_19 
reg asp_size_livestock $weather $drought s_n_hat ib3.rainfall_19 
reg asp_size_asset $weather $drought s_n_hat ib3.rainfall_19 

* aggregate asirations gap
reg aggregate_asp_gap $weather $drought s_n_hat ib3.rainfall_19 
reg aggregate_asp_gap_nolivestock $weather $drought s_n_hat ib3.rainfall_19 

* reported change in aspirations
*logit exp_how_land $weather $drought s_n_hat ib3.rainfall_19

* kgs of fertilizers against aspirations
reg qfert_total $aspirations
 
 
/* 
1. Define all outcome variables that are of interest for correlations
*	a. aggregate aspirations
*	b. aspirations by dimension (3)
*	c. aspirations gap - aggregate: control for 'starting point' aka their orignial rank within a dimension? (rank_DIMENSION)
*	d. input usage as determined by quantity of basal or top dressing fertilizer used on all plantings this season
*	e. How to use "change" variables: exp_how_DIMENSION - categorical variables as dependent variable
2. Address Dummy Variable Concern
3. Select all "controls" - these will be the variables suspected of being correllated with the outcomes
4. Ensure that all variables are a. "clean" b. defined with labels
5. Regress against all outcomes
*/


