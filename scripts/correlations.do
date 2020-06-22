/// Aspirations and Weather Correlations ///

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

use HICPS_RISK.dta, clear

*keep if year == 2019
sort HHID year


* camp median for replacement
bysort camp2 year: egen rank_land_median = median(rank_land_10)
bysort camp2 year: egen rank_livestock_median = median(rank_livestock_10)
bysort camp2 year: egen rank_asset_median = median(rank_asset_10)
 
 
* median replacement
sort HHID year
replace rank_land_10 = rank_land_median if rank_land_10 == . & year == 2019

* conditional median replacements
** IF livestock is important to the HHs village AND they report it missing -> median replace
** IF livestock is NOT improtant to village and missing -> 0 livestock aspirations
sort HHID year
gen livestock_noreplace = rank_livestock_10
replace rank_livestock_10 = rank_livestock_median if rank_livestock_10 == . & year == 2019 & people_livestock == 1


sort HHID year
replace rank_asset_10 = rank_asset_median if rank_asset_10 == . & year == 2019


*normalize aspirations measures
egen zland_asp = std(rank_land_10)
egen zlivestock_asp = std(rank_livestock_10)
egen zasset_asp = std(rank_asset_10)
egen zlivestock_noreplace = std(livestock_noreplace)

*recode weights
gen weighted_importance_land = importance_land
gen weighted_importance_livestock = importance_livestock
gen weighted_importance_assets = importance_assets

foreach var in weighted_importance_land weighted_importance_livestock weighted_importance_assets {
	replace `var' = 5 if `var' == 3
	replace `var' = 3 if `var' == 5
	replace `var' = 2 if `var' == 6
	replace `var' = 1 if `var' == 7
	replace `var' = 1 if `var' == .
}

foreach var in exp_how_land exp_how_asset exp_how_livestock {
	replace `var' = 0 if `var' == 4
}

* not important = 1
* slightly important = 2
* moderatly important = 3
* important = 4
* very important = 5

*weight normalized individual dimensions
gen zweighted_aspirations_land = zland_asp * weighted_importance_land
gen zweighted_aspirations_livestock = zlivestock_asp * weighted_importance_livestock
gen zweighted_aspirations_asset = zasset_asp * weighted_importance_asset
gen zw_live_NOREP = zlivestock_noreplace * weighted_importance_livestock

*aggregated weighted and normalized dimensions
gen zaspirations = zweighted_aspirations_land + zweighted_aspirations_livestock + zweighted_aspirations_asset

*w/o livestock
gen zaspirations_nolivestock = zweighted_aspirations_land + zweighted_aspirations_asset


* splitting rainfall events to identify specific events incurred
split rainfall_events, p(",") destring

gen late_rain = 0
replace late_rain = 1 if rainfall_events1 == 1

gen dry_spell = 0
replace dry_spell = 1 if rainfall_events1 == 2 | rainfall_events2 == 2

gen low_rain = 0
replace low_rain = 1 if rainfall_events1 == 3 | rainfall_events2 == 3 | rainfall_events3 == 3

gen warm_temps = 0
replace warm_temps = 1 if rainfall_events1 == 4 | rainfall_events2 == 4 | rainfall_events3 == 4 | rainfall_events4 == 4

gen flooding = 0
replace flooding = 1 if rainfall_events1 == 5 | rainfall_events2 == 5 | rainfall_events3 == 5 | rainfall_events4 == 5 

gen other_rainfall = 0
replace other_rainfall = 1 if rainfall_events1 == 6 | rainfall_events2 == 6 | rainfall_events3 == 6 | rainfall_events4 == 6 | rainfall_events5 == 6


		 
***** Correlations *****

*= Histograms & Frequency Tables =*

/*

Aspirations by province
Change by province 
ALL quantitative control variables



*Kernel density of aspirations at different numbers of shocks

*===* importance of creating 2018 drought number indicator *===*
replace droughtint = 0 if droughtint <0


kdensity droughtint if year == 2016, ///
addplot(kdensity droughtint if year == 2017 || kdensity droughtint if year == 2018 || kdensity droughtint if year == 2019) ///
title(Drought Length x Year) ///
legend(label(1 "2016") label(2 "2017") label(3 "2018") label(4 "2019"))


*===* non-normalized aspirations by number of droughts *===*
kdensity rank_land_10 if n_drought == 0, title(Land Aspirations x N droughts) addplot(kdensity rank_land_10 if n_drought == 1 || kdensity rank_land_10 if n_drought == 2) ///
legend(label(1 "No droughts") label (2 "1 drought") label(3 "2 droughts"))

kdensity rank_livestock_10 if n_drought == 0, title(Livestock Aspirations x N droughts) addplot(kdensity rank_livestock_10 if n_drought == 1 || kdensity rank_livestock_10 if n_drought == 2) ///
legend(label(1 "No droughts") label (2 "1 drought") label(3 "2 droughts"))

kdensity rank_asset_10 if n_drought == 0, title(Asset Aspirations x N droughts) addplot(kdensity rank_asset_10 if n_drought == 1 || kdensity rank_asset_10 if n_drought == 2) ///
legend(label(1 "No droughts") label (2 "1 drought") label(3 "2 droughts"))

*/
	
***** Results *****
*xtset district


*======= Extra Control Ideas ======*
* s_n_hat2 - 2019 risk aversion coefficient
* latearrival - Q234: how many weeks late did rains arrive
* daysnorain - Q235: how many days without rain is harmful to maize
* daysdrought - Q236: how many days without rain does HH consider a drought
* droughtint - Q238: length of dry spell in 2019 growing season
* droughtfreq - Q239: how often HH experiences a drought
* rains - Q2310: prediciton of rains next season
* forecast_rain - Q2311: condifence in prediction (from rains)
* prepared - Q2314: how likely are you to be prepared for drought
* activities_drought - Q2315: Are there activities you can do to prepare for drought
* forecast_use - Q242: did you use forecasts in the last growing season
* forecast_aware -Q243:  are you aware of weather forecasts
* predict_rains - Q2411: how does your rainfall prediction ability compare to 10 years ago

* formal_loan - Q926: Has anyone in the household taken out a formal loan past 12 months
* borrow500 - Q927: borrow 500 kwacha formal or informal (Y/N)
* borrow2500 - Q927: borrow 2500 kwacha formal or informal (Y/N)
* borrow10000 - Q927: borrow 10000 kwacha formal or informal (Y/N)

* farmland - Q112: total farmland for BASELINE growing season (2016)

* livestock - Q920: aggregate of number of livestock at ENDLINE (2019)

* 



*===========* Control Var Cleaning *===========*
sort HHID year


****************
* Demographics *
****************

* weirdness in the data regarding birth_1 and hh_head_birth.........
gen hh_head_age2 = hh_head_age if year == 2016
replace hh_head_age2 = (2016 - birth_1) if hh_head_birth == . & hh_head_age != (2016 - birth_1)
replace hh_head_age2 = (2016-birth_1) if hh_head_age2 <= 8
bysort HHID: replace hh_head_age2 = hh_head_age2[_n-1] if year > 2016

gen hh_head_sex2 = hh_head_sex
bysort HHID: replace hh_head_sex2 = hh_head_sex2[_n-1] if year > 2016

gen hh_head_edu2 = hh_head_edu if year == 2016
bysort HHID: replace hh_head_edu2 = hh_head_edu2[_n-1] if year > 2016

gen hh_num2 = hh_num
bysort HHID: replace hh_num2 = hh_num2[_n-1] if year > 2016


*** parents edu ***
replace educ_father = 11 if educ_father == .
replace educ_mother = 11 if educ_mother == .

label define parent_educ ///
	4 "None" 5 "Some Primary" 6 "Completed Primary" 7 "Some Secondary" ///
	8 "Completed Secondary" 9 "Some Post-Secondary" 10 "Masters" 11 "Unknown" 12 "PhD" 
	
label values educ_father parent_educ
label values educ_mother parent_educ


*===================================================================================================*

global controls hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_father educ_mother i.district
		   *dum1 dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10 dum11 dum12

*===================================================================================================*


		   
		   
**********
* Income *
**********

** need to make sure they are in all years?
sum income
replace income = r(mean) if income > 200000

*adjust income so that only baseline income is considered
gen income2 = 0
replace income2 = income if year == 2016

bysort HHID: replace income2 = income2[_n-1] if year > 2016

ssc install ihstrans
ihstrans income2
* new var = ihs_income2

		   
		   
*****************
* Risk Aversion *
*****************

gen s_n_hat2 = 0
replace s_n_hat2 = s_n_hat if year == 2019

bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2019
bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2018
bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2017

***************
* Expenditure *
***************

sort HHID year

* weekly
replace food_budget_7day = 0 if food_budget_7day == .

sum talktime_budget_7day year
replace talktime_budget_7day = r(mean) if talktime_budget_7day == .

* monthly
replace veterinary_cost_month = 0 if veterinary_cost_month == .

sum clothing_cost_month
replace clothing_cost_month = r(mean) if clothing_cost_month == .

sum transportation_cost_month
replace transportation_cost_month = r(mean) if transportation_cost_month == .

sum alcohol_cost_month
replace alcohol_cost_month = r(mean) if alcohol_cost_month == .

sum other_cost_month
replace other_cost_month = r(mean) if other_cost_month == .

* yearly
bysort HHID: replace school_fees = school_fees[_n+1] if year < 2017

bysort HHID: replace medical_exp = medical_exp[_n+1] if year < 2017

* annual aggregate
gen yearly_expenditure = ((food_budget_7day*4) + (talktime_budget_7day*4)) ///
	+ (veterinary_cost_month + clothing_cost_month + transportation_cost_month + alcohol_cost_month + other_cost_month)*12 ///
	+ (school_fees + medical_exp)
	
gen annual_percap_expenditure = yearly_expenditure / hh_num if year == 2016

gen annual_percap_expenditure2 = annual_percap_expenditure
replace annual_percap_expenditure2 = annual_percap_expenditure2[_n-1] if year > 2016




***********************
* Perception controls *
***********************

sort HHID year

sum latearrival if year == 2019
replace latearrival = 0 if latearrival == . & year == 2019 & late_rain == 0

sum daysnorain
bysort HHID: replace daysnorain = daysnorain[_n-1] if year > 2018
replace daysnorain = r(mean) if daysnorain == .

sum daysdrought if year == 2019
replace daysdrought = r(mean) if daysdrought == . & year == 2019

sum droughtint if year == 2019


* drought frequency - expectation of future droughts
sum droughtfreq if year == 2019

*droughtfreq = expected number of droughts over a 10 year time interval
gen droughtfreq2 = 0
replace droughtfreq2 = 0 if droughtfreq == 11 | droughtfreq == .
replace droughtfreq2 = 10/10 if droughtfreq == 10
replace droughtfreq2 = 10/9 if droughtfreq == 9
replace droughtfreq2 = 10/8 if droughtfreq == 8
replace droughtfreq2 = 10/7 if droughtfreq == 7
replace droughtfreq2 = 10/6 if droughtfreq == 6
replace droughtfreq2 = 10/5 if droughtfreq == 5
replace droughtfreq2 = 10/4 if droughtfreq == 4
replace droughtfreq2 = 10/3 if droughtfreq == 3
replace droughtfreq2 = 10/2 if droughtfreq == 2
replace droughtfreq2 = 10/1	 if droughtfreq == 1
	
label var droughtfreq2 "Expected drought freq over 10 years"

*label define droughtfreq ///
*	10 "every year" 9 "every other year" 3 "every 3 years" 4 "every 4 years" 5 "every 5 years" ///
*	6 "every 6 years" 7 "every 7 years" 8 "every 8 years" 9 "every 9 years" 10 "every 10 years" ///
*	0 "never"
*	
*label values droughtfreq2 droughtfreq

*****
sum rains if year == 2019
gen rains2 = rains
replace rains2 = -1 if rains == 1
replace rains2 = 0 if rains == 3 | rains == 4
replace rains2 = 1 if rains == 2
replace rains2 = 0 if rains2 == . & year != 2016
label var rains2 "Expected rain next season"

sum forecast_rain if year == 2019
replace forecast_rain = 0 if forecast_rain == . & year == 2019 & rains == 4

*****
sum prepared if year == 2019
replace prepared = 2 if prepared == . & year == 2019

gen prepared2 = 0
replace prepared2 = 2 if prepared == 1 
replace prepared2 = 1 if prepared == 2
replace prepared2 = 0 if prepared == 3 | prepared == 4

label define prepared ///
	0 "unlikely/idk" 1 "somewhat likely" 2 "very likely"
	
label values prepared2 prepared


*****
sum activities_drought 
gen activities_drought2 = 0
replace activities_drought2 = 1 if activities_drought == 1

*****
sum forecast_use
gen forecast_use2 = 0
replace forecast_use2 = 1 if forecast_use == 1


sum forecast_aware
replace forecast_aware = 1 if forecast_aware == . & forecast_use == 1

*****
sum predict_rains if year == 2019
gen predict_rains2 = 0
replace predict_rains2 = -1 if predict_rains == 1
replace predict_rains2 = 0 if predict_rains == 3 | predict_rains == 4
replace predict_rains2 = 1 if predict_rains == 2



*******************
* Credit controls *
*******************
sort HHID year

sum formal_loan if year == 2016
gen formal_loan2 = formal_loan if year == 2016
replace formal_loan2 = formal_loan2[_n-1] if year > 2016


sum borrow500 borrow2500 borrow10000 if year == 2019

gen credit = 0
replace credit = 500 if borrow500 == 1 & borrow2500 == 0 & borrow10000 == 0
replace credit = 2500 if borrow500 == 0 & borrow2500 == 1 & borrow10000 == 0
replace credit = 10000 if borrow500 == 0 & borrow2500 == 0 & borrow1000 == 1 

* baseline max credit amount
gen credit2 = credit if year == 2016
replace credit2 = credit2[_n-1] if year > 2016




*****************
* Land controls *
*****************

sum farmland

* baseline farmland
gen farmland2 = farmland if year == 2016
replace farmland2 = farmland2[_n-1] if year > 2016

**********************
* Livestock controls *
**********************

sort HHID year

* 2019 livestock
sum female_cattle_number goat_sheep_number poultry_number ///
 oxen_number breeding_bull_number if year == 2019



/// Creating Tropical Livestock Index for HICPS households
foreach var of varlist female_cattle_number* breeding_bull* oxen* ///
poultry_number* goat_sheep_number* {
  replace `var' = 0 if `var'==.
}

gen cow_tlu = (0.70 * female_cattle_number) + (0.70 * breeding_bull) + (oxen * 0.70)
gen chick_tlu = (poultry_number * 0.01)
gen goat_tlu = (goat_sheep_number * 0.10)

gen livestock_index = 0
la var livestock_index "index of livestock created through tropical livestock units"
replace livestock_index = cow_tlu + chick_tlu + goat_tlu

* 2019 livestock index
gen livestock_index2 = livestock_index if year == 2019
replace livestock_index2 = livestock_index2[_n+3] if livestock_index2 == . & year == 2016
replace livestock_index2 = livestock_index2[_n-1] if livestock_index2 == . & year > 2016

******************
* Asset controls *
******************

sort HHID year

/// Creating Asset Index for HICPS households
_strip_labels asset_phone_change tv_change radio_change bike_change ///
motorcycle_change water_pump_change plough_change ox_carts_change ///
sprayers_change vehicle_change solar_change

foreach var of varlist asset_phone_change* tv_change* radio_change* ///
bike_change* motorcycle_change* water_pump_change* plough_change* ///
ox_carts_change* sprayers_change* vehicle_change* solar_change* {
  replace `var' = -3 if `var'== 4
  replace `var' = 0 if `var'== 5
  replace `var' = -1 if `var'== 2
  replace `var' = -2 if `var'== 3
  replace `var' = 3 if `var'== 1
  replace `var' = 1 if `var'== 6
  replace `var' = 2 if `var'== 7
  replace `var' = 0 if `var'== .
}

gen phone17 = asset_phone + asset_phone_change
replace phone17 = 0 if phone17 <0
la var phone17 "# of phones owned by HH"

gen tv17 = tv + tv_change
replace tv17 = 0 if tv17 <0
la var tv17 "# of tvs owned by HH"

gen radio17 = radio + radio_change
replace radio17 = 0 if radio17 <0
replace radio17 = 0 if radio17 == .
la var radio17 "# of radios owned by HH"

gen bicycle17 = bike + bike
replace bicycle17 = 0 if bicycle17 <0
la var bicycle17 "# of bicycles owned by HH"

gen motorcycle17 = motorcycle + motorcycle_change
replace motorcycle17 = 0 if motorcycle17 <0
la var motorcycle17 "# of motorcycles owned by HH"

gen pump17 = water_pump + water_pump_change
replace pump17 = 0 if pump17 <0
la var pump17 "# of water pumps owned by HH"

gen plough17 = plough_change + plough
replace plough17 = 0 if plough17 <0
la var plough17 "# of ploughs owned by HH"

gen ox_carts17 = ox_carts_change + ox_carts
replace ox_carts17 = 0 if ox_carts17 <0
la var ox_carts17 "# of oxen carts owned by HH"

gen sprayers17 = sprayers + sprayers_change
replace sprayers17 = 0 if sprayers17 <0
la var sprayers17 "# of chemical sprayers owned by HH"

gen vehicle17 = vehicle + vehicle_change
replace vehicle17 = 0 if vehicle17 <0
la var vehicle17 "# of motorvehicles owned by HH"

gen solar17 = solar + solar_change
replace solar17 = 0 if solar17 <0
la var solar17 "# of solar panels owned by HH"

gen iron_sheet17 = 0
replace iron_sheet17 = 0 if iron_sheets_change == 1 & iron_sheets == 1
replace iron_sheet17 = 1 if iron_sheets_change == 0 & iron_sheets == 1
replace iron_sheet17 = 0 if iron_sheets_change == 0 & iron_sheets == 0
la var iron_sheet17 "HH has iron roof sheets (1=yes)"

summarize phone17 tv17 radio17 bicycle17 motorcycle17 pump17 plough17 sprayers17 ///
ox_carts17 vehicle17 iron_sheet17 solar17

tab phone17,m
tab tv17,m
tab radio17,m
tab bicycle17,m
tab motorcycle17,m
tab pump17,m
tab plough17,m
tab ox_carts17,m
tab sprayers17,m
tab vehicle17,m
tab solar17,m
tab iron_sheet17,m


/// Principal component analysis
pca phone17 tv17 radio17 bicycle17 pump17 plough17 sprayers17 ox_carts17 ///
iron_sheet17 solar17 motorcycle17 vehicle17
predict pc1 pc2 pc3, score
sum pc1
correlate pc1 pc2 pc3

gen assets_raw = pc1
la var assets_raw "asset index score created through PCA"

sum assets_raw
scalar min_asset = -r(min)

gen assets_0min = assets_raw + scalar(min_asset)

sum assets_0min
*1.06 is the minimum of the index.

la var assets_0min "asset index raw score with 0 as the minimum"

* baseline pca score
gen asset_pca = assets_0min if year == 2016
sum asset_pca if year == 2016
replace asset_pca = r(mean) if asset_pca == . & year == 2016
replace asset_pca = asset_pca[_n-1] if year > 2016
	
********************
* Migrant controls *
********************
sort HHID year

* 2019 migrant stock
gen migrant = 0
replace migrant = 1 if mem_remain != .
replace migrant = 1 if mig1_exist == 1

bysort HHID: egen migrant2 = total(migrant)
gen migrant3 = 0
replace migrant3 = 1 if migrant2 >= 1


***************
* remittances *
***************

sort HHID year
foreach var in mig1_money mig2_money mig3_money mig4_money mig5_money {
	replace `var' = 0 if `var' == .
}

gen remittances = 0
replace remittances = mig1_money + mig2_money + mig3_money + mig4_money + mig5_money
gen remittances2 = remittances if year == 2016
bysort HHID: replace remittances2 = remittances2[_n-1] if year > 2016

 
*************************************
 *** Additional Control Variable ***
*************************************

sort HHID year

global controlX credit2 migrant farmland2 livestock_index2 asset_pca  ///
	rains2 prepared2 activities_drought2 
	
** summary stats for all controls
estpost sum hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father $controlX if year == 2019
eststo sumtableX


************************************************************

*rename labels for variable interpretation in table
label var hh_head_age2 "age"
label var hh_head_sex2 "sex"
label var hh_head_edu2 "educ"
label var hh_num2 "household size"
label var educ_father "father educ"
label var educ_mother "mother educ"
label var rains2 "rains"
label var prepared2 "prepared"
label var activities_drought2 "activities_drought"
label var credit2 "credit"
label var migrant3 "migrant"
label var farmland2 "land"
label var livestock_index2 "tropical livestock index"
label var asset_pca "PCA score"



*==================================================================================*

********************** Shock Variable Creation *************************************

*==================================================================================*


* weather shock variables 

** 2018 - predict the likelihood of reporting severe drought based on length of drought reported

*** identifying number of droughts experienced ***
replace rainint = rainfall_19 if year == 2019
replace rainint = 4 if rainint == 3

* whether a year was a drought year
gen drought = 0
replace drought = 1 if rainint ==1
*cleaning
summarize droughtint
replace droughtint = r(mean) if droughtint == . | droughtint < 0 & dry_spell == 1
replace droughtint = 0 if droughtint < 0

*prediction
reg drought droughtint $controls if year != 2018
eststo dlengthhat
*esttab dlengthhat
predict severedrought_length, xb

* alternate prediction models for comparison
logit drought droughtint $controls if year != 2018
predict severedrought_length_logit

probit drought droughtint $controls if year != 2018
predict severedrought_length_p

gen drought_logit = drought
gen drought_probit = drought


** Visuals
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals"

kdensity severedrought_length if drought == 1, ///
addplot(kdensity severedrought_length if drought == 0) ///
xline(0.334, lp(dash) lc(gs0)) ///
title(Severe Drought Prediction: Density Plot) ///
legend(label(1 "Experienced Severe Drought") label(2 "No Severe Drought")) ///
saving("preddensity.PNG", replace)


* reduction is aspirations
twoway function y=normalden(x), range(-4 4) ///
	title("Distribution of Land Aspirations") ///
	subtitle("Change in Aspirations") ///
	xtitle("") ytitle("") ///
	xline(-.9, lc(gs0)) ///
	xline(1.2) ///
	xline(-0.4) ///
	xlabel(-0.9 "H1" 1.2 "A1" -0.4 "A2")
	
* reduction in current econ standing
twoway function y=normalden(x), range(-4 4) ///
	title("Distribution of Land Aspirations") ///
	subtitle("Change in Economic Standing") ///
	xtitle("") ytitle("") ///
	xline(-.9, lc(gs0)) ///
	xline(-1.9, lc(gs0)) ///
	xline(1.2) ///
	xlabel(-0.9 "H1" -1.9 "H2" 1.2 "A1")
	
* reduction in both
twoway function y=normalden(x), range(-4 4) ///
	title("Distribution of Land Aspirations") ///
	subtitle("Change in Economic Standing and Aspirations") ///
	xtitle("") ytitle("") ///
	xline(-2.1, lc(gs0)) ///
	xline(-1.4, lc(gs0)) ///
	xline(1.2) ///
	xline(0.2) ///
	xlabel(-1.4 "H1" -2.1 "H2" 1.2 "A1" 0.2 "A2")
	

*================================================================================*
*        Sample cutoff as identified in 'overlap' R code
*			predicitons utilize drought status and drought lengths from 
*			2016 2017 & 2019
*				linear: 0.3789834
*				logit:  0.3563631
*				probit: 0.3579245 
*================================================================================*
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

sort HHID year
gen drought2 = 0
gen drought2_logit = 0
gen drought2_probit = 0


* severe drought if predicted value >= X
replace drought2 = 1 if severedrought_length >= 0.33308633


replace drought2_logit = 1 if severedrought_length_logit >= 0.31353457


replace drought2_probit = 1 if severedrought_length_p >= 0.31786554


estpost sum drought drought2 drought2_logit drought2_probit if year == 2016
eststo droughts16

estpost sum drought drought2 drought2_logit drought2_probit if year == 2017
eststo droughts17

estpost sum drought drought2 drought2_logit drought2_probit if year == 2018
eststo droughts18

estpost sum drought drought2 drought2_logit drought2_probit if year == 2019
eststo droughts19

estout droughts16 droughts17 droughts18 droughts19, cell(sum) ml(2016 2017 2018 2019)

asdoc sum drought drought2 drought2_logit drought2_probit if year == 2016, replace
replace drought2_logit = 1 if severedrought_length_logit >= 0.31353457


replace drought2_probit = 1 if severedrought_length_p >= 0.31786554
 
 
* total number of years a household experienced a severe drought
sort HHID year
bysort HHID: egen n_drought = total(drought2)





* recoding aspirations change variable
gen change_livestock = .
replace change_livestock = 0 if exp_how_livestock == 0
replace change_livestock = 1 if change_exp_livestock == 0
replace change_livestock = 2 if exp_how_livestock == 1

gen change_land = .
replace change_land = 0 if exp_how_land == 0
replace change_land = 1 if change_exp_land == 0
replace change_land = 1 if change_land == . & year == 2019
replace change_land = 2 if exp_how_land == 1


gen change_asset = .
replace change_asset = 0 if exp_how_asset == 0
replace change_asset = 1 if change_exp_asset == 0
replace change_asset = 2 if exp_how_asset == 1	

* label ordinal var
label define ordinal 0 "decrease" 1 "unchanged" 2 "increase"

foreach var in change_land change_livestock change_asset {
	label value `var' ordinal
}

* assuming that missing data for change in livestock aspirations is equal to no change in livestock asps (no asps then to no asps now) treating as 0
replace change_livestock = 0 if change_livestock == . & year == 2019
gen ag_asp_change = change_livestock + change_land + change_asset


* Labelling outcome vars for outputs
label var zaspirations_nolivestock "Aspirations (No Livestock)"
label var zweighted_aspirations_land "Land Aspirations"
label var zweighted_aspirations_livestock "Livestock Aspirations"
label var zweighted_aspirations_asset "Asset Aspirations"
label var change_livestock "Livestock change"
label var change_land "Land change"
label var change_asset "Asset change"


save HICPS_predicted, replace
use HICPS_predicted, clear
	

	
	
*======================================================================================*

********************* merging CHIRPS ***************************************************

*======================================================================================*

decode camp2, g(camp3)
* merge using district camp agyr renaming agyr to year

************ MONTHLY ****************

*30
*joinby district camp3 year using "Rainfall shocks by camp agyr-monthly.30yr", _merge(merge3) unmatched(both)
*save HICPS-CHIRPS.30yr, replace


*10
joinby district camp3 year using "Rainfall shocks by camp agyr-monthly.10yr", _merge(merge3) unmatched(both)
save HICPS-CHIRPS.10yr, replace

drop if year < 2016 | year > 2019

* total # of years where rainfall was in the bottom 10% of X year rainfall distribution
bysort HHID: egen total_neg10 = total(neg10)

* total # of years where rainfall was in the bottom 20% of X year rainfall distribution
bysort HHID: egen total_neg20 = total(neg20)

* total # of years where growing season total rainfall was at least one standard deviation less than X year total
bysort HHID: egen total_negz = total(negz)
tab total_negz
drop zero_rain


*********************************** DAILY ********************************************

joinby HHID district camp3 year using "daily0rainXhhid", _merge(merge_daily) unmatched(master)

***********************************************************************************************************







*=========================================================================================*
*=========================================================================================*
*=========================================================================================*

******************************** Summary / Correlations ***********************************

*=========================================================================================*
*=========================================================================================*
*=========================================================================================*

cd "C:\Users\kurczew2\Box\Research\HICPS\Data"
save "HICPS-preresults", replace
*use HICPS-preresults, clear

cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals"



*****************************

*** Total Varlist Summary ***

*****************************


*retain varlist including those vars not used in final speciifcation as a record of complete list
gen prep = 0
replace prep = 1 if prepared2 >= 1

global varlist_master hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prep activities_drought2


asdoc sum $varlist_master if year == 2019, label ///
	title(Table X: Summary Statitics) ///
	save(master_sumtable.doc), replace


*******************

*** Aspirations ***

*******************

label var rank_land_10 "Land Aspirations"
label var rank_livestock_10 "Livestock Aspirations"
label var rank_asset_10 "Asset Aspirations"
label var weighted_importance_land "Land Importance"
label var weighted_importance_livestock "Livestock Importance"
label var weighted_importance_assets "Asset Importance"
	
***
* histogram code in R for individual aspirations levels (easily adaptable into stata if needed)
***

	
	
***********************

*** Weather Summary ***

***********************

label var n_drought "Subjective Number of Droughts"
label var droughtint "Subjective Drougth Length"
label var total_negz "CHIRPS Number of Droughts"
label var daily_zero_rain "CHIRPS Drought Length"
label var district "District"



*** percieved weather
* num droughts (proportion drought years by district)
asdoc table district year, ///
	contents(mean drought2) dec(3) center ///
	title(Table X: Subjective Yearly Drought Statistics by District) ///
	save(predictdrougthsum.doc) replace
	
* num droughts - reported
asdoc table district year, ///
	contents(mean drought) dec(3) center ///
	title(Table X: Subjective Yearly Drought Statistics by District) ///
	save(actualdrougthsum.doc) replace
	
* drought length 
kdensity droughtint, ///
	xlabel(0(14)105) ///
	xtick(0(7)90) ///
	title(Subjective Drought Length) ///
	note(x axis tick marks in 7-day intervals)
	
	


*** CHIRPS weather
gen below_avg_rain = 0
replace below_avg_rain = 1 if z_rain < 0

* CHIRPS drought proportion
asdoc table district year, ///
	contents(mean below_avg_rain) dec(3) center ///
	title(Table X: CHIRPS Yearly Drought Statistics by District) ///
	save(CHIRPSdroughtsum.doc) replace

* chirps drought length
kdensity daily_zero_rain, ///
	xlabel(0(14)105) ///
	xtick(0(7)105) ///
	title(Objective Drought Length) ///
	note(x axis tick marks in 7-day intervals)





*==================*

*** Correltaions ***

*==================*

*num droughts
asdoc table total_negz n_drought if year == 2019, ///
	title(Table X: Perceived vs Actual Drought Incidence) ///
	save(perceivedXactual.doc), replace
	


* drought lengths
twoway scatter droughtint daily_zero_rain if year == 2019, ///
	jitter(6) ///
	xlabel(0(5)30) ///
	xtick(0(2.5)30) ///
	ytick(0(25)150) ///
	title(Perceived vs Actual Drought Lengths) ///
	note()
	

*** Aspirations and Various Weather Shocks

*Aspirations and Different Levels of Subjective Drought
kdensity rank_land_10 if n_drought <= 1, ///
	addplot(kdensity rank_land_10 if n_drought > 1) ///
	title(Land Aspiraitons by Perceived Droughts) ///
	legend(label(1 "1 or 0 droughts") label(2 "More than 1 drought"))
	
kdensity rank_livestock_10 if n_drought <= 1, ///
	addplot(kdensity rank_livestock_10 if n_drought > 1) ///
	title(Livestock Aspiraitons by Perceived Droughts) ///
	legend(label(1 "1 or 0 droughts") label(2 "More than 1 drought"))

kdensity rank_asset_10 if n_drought <= 1, ///
	addplot(kdensity rank_asset_10 if n_drought > 1) ///
	title(Asset Aspiraitons by Perceived Droughts) ///
	legend(label(1 "1 or 0 droughts") label(2 "More than 1 drought"))

	
* Asp and Subj Drought Length
sum droughtint
scalar mean1 = r(mean)
kdensity rank_land_10 if droughtint < mean1, ///
	addplot(kdensity rank_land_10 if droughtint >= mean1) ///
	title(Land Aspiraitons by Perceived Drought Length) ///
	legend(label(1 "Below Average Drougth Length") label(2 "Above Average Drought Length"))

kdensity rank_livestock_10 if droughtint < mean1, ///
	addplot(kdensity rank_livestock_10 if droughtint >= mean1) ///
	title(Livestock Aspiraitons by Perceived Drought Length) ///
	legend(label(1 "Below Average Drougth Length") label(2 "Above Average Drought Length"))

kdensity rank_asset_10 if droughtint < mean1, ///
	addplot(kdensity rank_asset_10 if droughtint >= mean1) ///
	title(Asset Aspiraitons by Perceived Drought Length) ///
	legend(label(1 "Below Average Drougth Length") label(2 "Above Average Drought Length"))

	
* Asp and Preparedness
kdensity rank_land_10 if prepared2 == 0, ///
	addplot(kdensity rank_land_10 if prepared2 == 1 || kdensity rank_land_10 if prepared2 == 2) ///
	title("Land Aspirations and" "Level of Subjective Drought Preparedness") ///
	legend(label(1 "Not Prepared") label(2 "Somewhat Prepared") label(3 "Prepared"))
	
kdensity rank_livestock_10 if prepared2 == 0, ///
	addplot(kdensity rank_livestock_10 if prepared2 == 1 || kdensity rank_livestock_10 if prepared2 == 2) ///
	title("Livestock Aspirations and" "Level of Subjective Drought Preparedness") ///
	legend(label(1 "Not Prepared") label(2 "Somewhat Prepared") label(3 "Prepared"))
	
kdensity rank_asset_10 if prepared2 == 0, ///
	addplot(kdensity rank_asset_10 if prepared2 == 1 || kdensity rank_asset_10 if prepared2 == 2) ///
	title("Asset Aspirations and" "Level of Subjective Drought Preparedness") ///
	legend(label(1 "Not Prepared") label(2 "Somewhat Prepared") label(3 "Prepared"))
	
*=====================================================================================*

************************************* RESULTS *****************************************

*=====================================================================================*


keep if year == 2019

*****************************
** Interactions to Include **
*****************************

gen creditXndrought = credit2 * n_drought
gen creditXdroughtint = credit2 * droughtint
gen creditXdroughtfreq = credit2 * droughtfreq2
gen creditXnegz = credit2 * total_negz
gen creditXzerorain = credit2 * daily_zero_rain

* prepared
gen preparedXndrought = prepared2 * n_drought
gen preparedXdroughtint = prepared2 * droughtint
gen preparedXdroughtfreq = prepared2 * droughtfreq
gen preparedXnegz = prepared2 * total_negz
gen preparedXzerorain = prepared2 * daily_zero_rain

* activities
gen activityXndrought = activities_drought2 * n_drought
gen activityXdroughtint = activities_drought2 * droughtint
gen activityXdroughtfreq = activities_drought2 * droughtfreq
gen activityXnegz = activities_drought2 * total_negz
gen activityXzerorain = activities_drought2 * daily_zero_rain 


**** Shock: number of droughts

*retain varlist including those vars not used in final speciifcation as a record of complete list
global varlist_master n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father i.district ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 
	
**********




															************************
															*** ndrought: levels ***
															************************													
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\ndrought"

* simple
global varlist1_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXndrought preparedXndrought activityXndrought
	
	

									************
									** SIMPLE **
									************
									
foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zw_live_NOREP zweighted_aspirations_asset {
	reg `var' $varlist1_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xndrought.doc, replace ///
		ctitle(" ") ///
		keep ($varlist1_ndrought) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist2_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xndrought.doc, append ///
		ctitle(" ") ///
		keep ($varlist2_ndrought) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist3_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xndrought.doc, append ///
		ctitle(" ") ///
		keep ($varlist3_ndrought) addtext(District FE, YES) title(Table X.X:)
}



	
	

	
															**************************************
															********* ndrought: change ***********
															**************************************

/*
** change by dimensions **

* land 
ologit change_land n_drought $varlist1_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange1.doc", replace eform cti(odds ratio) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 3.1: Number of Droughts on Land Aspirations Change)
	
ologit change_land n_drought $varlist2_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange1.doc", append eform cti(odds ratio) ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
ologit change_land n_drought $varlist3_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange1.doc", append eform cti(odds ratio) ///
	keep($varlist3_ndrought) addtext(District FE, YES)
	
	
* livestock
ologit change_livestock n_drought $varlist1_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange2.doc", replace eform cti(odds ratio) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 3.2: Number of Droughts on Livestock Aspirations Change)
	
ologit change_livestock n_drought $varlist2_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange2.doc", append eform cti(odds ratio) ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
ologit change_livestock n_drought $varlist3_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange2.doc", append eform cti(odds ratio) ///
	keep($varlist3_ndrought) addtext(District FE, YES)
	
	
* asset
ologit change_asset n_drought $varlist1_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange3.doc", replace eform cti(odds ratio) ///
	keep($varlist1_ndrought) addtext (District FE, YES) lab title(Table 3.3 Number of Droughts on Asset Aspirations Change)
	
	
ologit change_asset n_drought $varlist2_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange3.doc", append eform cti(odds ratio) ///
	keep($varlist2_ndrought) addtext (District FE, YES)
	
ologit change_asset n_drought $varlist3_ndrought i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTchange3.doc", append eform cti(odds ratio) ///
	keep($varlist3_ndrought) addtext (District FE, YES)
	
	
	
**** Proportional Odds Assumption Tests ***
	
*omodel logit change_asset n_drought $varlist4_ndrought district

*brant, detail
*/
	
	



	
	
	
															*******************************
															**** droughtint: asp levels ****
															*******************************
															
															
															
															
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\droughtint"		
											
* simple
global varlist1_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++
global varlist3_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXdroughtint preparedXdroughtint activityXdroughtint
	 											

*******************************


foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xndroughtint.doc, replace ///
		ctitle(" ") ///
		keep ($varlist1_droughtint) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist2_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xndroughtint.doc, append ///
		ctitle(" ") ///
		keep ($varlist2_droughtint) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist3_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xndroughtint.doc, append ///
		ctitle(" ") ///
		keep ($varlist3_droughtint) addtext(District FE, YES) title(Table X.X:)
}

	
	
													******************************
													*** droughtint: asp change ***
													******************************

/*
	
** change by dimensions **
* land 
ologit change_land droughtint $varlist1_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange1.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.1: Drought Length on Land Aspirations Change)
	
ologit change_land droughtint $varlist2_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange1.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
ologit change_land droughtint $varlist3_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange1.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtint) addtext(District FE, YES)

	
	
* livestock
ologit change_livestock droughtint $varlist1_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange2.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.2: Drought Length on Livestock Aspirations Change)
	
ologit change_livestock droughtint $varlist2_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange2.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
ologit change_livestock droughtint $varlist3_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange2.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtint) addtext(District FE, YES)

	
	
* asset
ologit change_asset droughtint $varlist1_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange3.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.3: Drought Length on Asset Aspirations Change)
	
ologit change_asset droughtint $varlist2_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange3.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
ologit change_asset droughtint $varlist3_droughtint i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTINTchange3.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtint) addtext(District FE, YES)

	
	
	
**** Proportional Odds Assumption Tests ***
	
*omodel logit change_asset n_drought $varlist4_ndrought district

*brant, detail
*/
	
	
														***************************
														* droughtfreq: asp levels *
														***************************
														
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\droughtfreq"
														
* simple
global varlist1_droughtfreq droughtfreq2 hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_droughtfreq droughtfreq2 hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++
global varlist3_droughtfreq droughtfreq2 hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXdroughtfreq preparedXdroughtfreq activityXdroughtfreq
	
	
***************************************************************************************************************************
	
	

foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_droughtfreq i.district, vce(cl HHID) base
		outreg2 using `var'Xdroughtfreq.doc, replace ///
		ctitle(" ") ///
		keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table X.X:)
		
	reg `var' $varlist2_droughtfreq i.district, vce(cl HHID) base
		outreg2 using `var'Xdroughtfreq.doc, append ///
		ctitle(" ") ///
		keep($varlist2_droughtfreq) addtext(District FE, YES)
		
	reg `var' $varlist3_droughtfreq i.district, vce(cl HHID) base
		outreg2 using `var'Xdroughtfreq.doc, append ///
		ctitle(" ") ///
		keep($varlist3_droughtfreq) addtext(District FE, YES)
}




	
	
/*
	
													******************************
													*** droughtfreq: asp change ***
													******************************
	
	
** change by dimension **
* land change
ologit change_land droughtfreq2 $varlist1_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange1.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.1: Drought Frequency on Land Aspirations Change)
	
ologit change_land droughtfreq2 $varlist2_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange1.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
ologit change_land droughtfreq2 $varlist3_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange1.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)
	
	
* livestock change
ologit change_livestock droughtfreq2 $varlist1_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange2.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.2: Drought Frequency on Livestock Aspirations Change)
	
ologit change_livestock droughtfreq2 $varlist2_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange2.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
ologit change_livestock droughtfreq2 $varlist3_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange2.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)
	
	
	
* asset change
ologit change_asset droughtfreq2 $varlist1_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange3.doc", replace eform cti(odds ratio) ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.3: Drought Frequency on Asset Aspirations Change)
	
ologit change_asset droughtfreq2 $varlist2_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange3.doc", append eform cti(odds ratio) ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
ologit change_asset droughtfreq2 $varlist3_droughtfreq i.district, or vce(cl HHID) base
	outreg2 using "NDROUGHTFREQchange3.doc", append eform cti(odds ratio) ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)
	
	
**** Proportional Odds Assumption Tests ***
	
*omodel logit change_asset n_drought $varlist4_ndrought district

*brant, detail






*********************************************

*** preparedness & subjective experienced *** 

*********************************************

* shocks against prepation / expectation vars
reg n_drought rains2 prepared2 activities_drought2 forecast_use2 i.district, base
	outreg2 using "droughtXprepared.doc", replace ///
	keep(rains2 prepared2 activities_drought2 forecast_use2) addtext(District FE, YES) title(Table X.X: Drought, Preparedness, and Expectations)
	
reg droughtint rains2 prepared2 activities_drought2 forecast_use2 i.district, base
	outreg2 using "droughtXprepared.doc", append ///
	keep(rains2 prepared2 activities_drought2 forecast_use2) addtext(District FE, YES)
	
reg droughtfreq2 rains2 prepared2 activities_drought2 forecast_use2 i.district, base
	outreg2 using "droughtXprepared.doc", append ///
	keep(rains2 prepared2 activities_drought2 forecast_use2) addtext(District FE, YES)
	
reg droughtfreq2 i.rainfall_19 droughtint i.district, base
	outreg2 using "droughtfreqXweather.doc", replace ///
	addtext(District FE, YES)
*/





	
	**********************************************************************
	
	*===================== CHIRPS REGRESSION CHECKS =====================*
	
	**********************************************************************

	
* NUMBER OF DROUGHTS EQUIVALENT

cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\total_negz"


* simple
global varlist1_negz total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_negz total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_negz total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXnegz preparedXnegz activityXnegz
	

foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_negz i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz10yr.doc, replace ///
		ctitle(" ") ///
		keep($varlist1_negz) addtext(District FE, YES) lab title(Table X.X:)
		
	reg `var' $varlist2_negz i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz10yr.doc, append ///
		ctitle(" ") ///
		keep($varlist2_negz) addtext(District FE, YES)
		
	reg `var' $varlist3_negz i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz10yr.doc, append ///
		ctitle(" ") ///
		keep($varlist3_negz) addtext(District FE, YES)
}





* DROUGHT LENGTH EQUIVALENT
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\daily_zero_rain"

* simple
global varlist1_zerorain daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_zerorain daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_zerorain daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXzerorain preparedXzerorain activityXzerorain
	

foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_zerorain i.district, vce(cl HHID) base
		outreg2 using `var'Xnorain.doc, replace ///
		ctitle(" ") ///
		keep($varlist1_zerorain) addtext(District FE, YES) lab title(Table X.X:)
		
	reg `var' $varlist2_zerorain i.district, vce(cl HHID) base
		outreg2 using `var'Xnorain.doc, append ///
		ctitle(" ") ///
		keep($varlist2_zerorain) addtext(District FE, YES)
		
	reg `var' $varlist3_zerorain i.district, vce(cl HHID) base
		outreg2 using `var'Xnorain.doc, append ///
		ctitle(" ") ///
		keep($varlist3_zerorain) addtext(District FE, YES)
}



* BOTH MEASURES OF NUM OF DROUGHTS
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\negz_ndrought"

* simple
global varlist1_negz_ndrought n_drought total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_negz_ndrought n_drought total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_negz_ndrought n_drought total_negz hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXnegz preparedXnegz activityXnegz ///
	creditXndrought preparedXndrought activityXndrought

	
foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_negz_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz_ndrought.doc, replace ///
		ctitle(" ") ///
		keep ($varlist1_negz_ndrought) addtext(District FE, YES) lab title(Table X.X:)
		
	reg `var' $varlist2_negz_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz_ndrought.doc, append ///
		ctitle(" ") ///
		keep ($varlist2_negz_ndrought) addtext(District FE, YES) lab title(Table X.X:)
		
	reg `var' $varlist3_negz_ndrought i.district, vce(cl HHID) base
		outreg2 using `var'Xnegz_ndrought.doc, append ///
		ctitle(" ") ///
		keep ($varlist3_negz_ndrought) addtext(District FE, YES) lab title(Table X.X:)
}



* BOTH MEASURES OF DROUGHT LENGTH
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\zerorain_droughtint"

* simple
global varlist1_zerorain_droughtint droughtint daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_zerorain_droughtint droughtint daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_zerorain_droughtint droughtint daily_zero_rain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2 ///
	creditXzerorain preparedXzerorain activityXzerorain ///
	creditXdroughtint preparedXdroughtint activityXdroughtint
	

foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_zerorain_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xzerorain_droughtint.doc, replace ///
		ctitle(" ") ///
		keep ($varlist1_zerorain_droughtint) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist2_zerorain_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xzerorain_droughtint.doc, append ///
		ctitle(" ") ///
		keep ($varlist2_zerorain_droughtint) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist3_zerorain_droughtint i.district, vce(cl HHID) base
		outreg2 using `var'Xzerorain_droughtint.doc, append ///
		ctitle(" ") ///
		keep ($varlist3_zerorain_droughtint) addtext(District FE, YES) title(Table X.X:)
}




/*
* REPLICATING KOSEC 2017 - USING TOTAL SD FROM MEAN RAINFALL AS SHOCK

cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals\sdrain"



* simple
global varlist1_sdrain neg_zrain pos_zrain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_sdrain neg_zrain pos_zrain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///

* simple++interaction
global varlist3_sdrain neg_zrain pos_zrain hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	credit2 farmland2 livestock_index2 asset_pca migrant3  ///
	rains2 prepared2 activities_drought2
	
	

foreach var in zaspirations_nolivestock zweighted_aspirations_land zweighted_aspirations_livestock zweighted_aspirations_asset {
	reg `var' $varlist1_sdrain i.district, vce(cl HHID) base
		outreg2 using `var'Xsdrain.doc, replace ///
		ctitle(" ") ///
		keep ($varlist1_sdrain) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist2_sdrain i.district, vce(cl HHID) base
		outreg2 using `var'Xsdrain.doc, append ///
		ctitle(" ") ///
		keep ($varlist2_sdrain) addtext(District FE, YES) title(Table X.X:)
		
	reg `var' $varlist3_sdrain i.district, vce(cl HHID) base
		outreg2 using `var'Xsdrain.doc, append ///
		ctitle(" ") ///
		keep ($varlist3_sdrain) addtext(District FE, YES) title(Table X.X:)
}
*/

* coef dotplot
quietly eststo perc_agg_ndrought: reg zaspirations_nolivestock n_drought $varlist3_ndrought i.district, vce(cl HHID) 

quietly eststo perc_asset_droughtint: reg zweighted_aspirations_asset droughtint $varlist3_droughtint i.district, vce(cl HHID)

quietly eststo actual_agg_negz: reg zaspirations_nolivestock total_negz $varlist3_negz i.district, vce(cl HHID)

quietly eststo actual_agg_zerorain: reg zaspirations_nolivestock daily_zero_rain $varlist3_zerorain i.district, vce(cl HHID)

quietly eststo expec_agg: reg zaspirations_nolivestock droughtfreq2 $varlist3_droughtfreq i.district, vce(cl HHID)


coefplot (perc_agg_ndrought perc_asset_droughtint actual_agg_negz actual_agg_zerorain expec_agg), ///
	keep(n_drought droughtint total_negz daily_zero_rain droughtfreq2) ///
	yline(0) ///
	vertical ///
	title("Regression Coefficients of Various" "Weather Shocks on Aspirations") ///
	coeflabels(n_drought="perceived drought incidence" ///
				droughtint="perceived drought length" ///
				total_negz="actual drought incidence" ///
				daily_zero_rain="actual drought length" ///
				droughtfreq2="expected drought frequency", wrap(10)) 
	
**************************************************************************************************************************************

cd "C:\Users\kurczew2\Box\Research\HICPS\Data"





