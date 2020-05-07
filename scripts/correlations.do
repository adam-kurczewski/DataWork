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
replace rank_livestock_10 = rank_livestock_median if rank_livestock_10 == . & year == 2019 & people_livestock == 1


sort HHID year
replace rank_asset_10 = rank_asset_median if rank_asset_10 == . & year == 2019


*normalize aspirations measures
egen zland_asp = std(rank_land_10)
egen zlivestock_asp = std(rank_livestock_10)
egen zasset_asp = std(rank_asset_10)

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


*weight normalized individual dimensions
gen zweighted_aspirations_land = zland_asp * weighted_importance_land
gen zweighted_aspirations_livestock = zlivestock_asp * weighted_importance_livestock
gen zweighted_aspirations_asset = zasset_asp * weighted_importance_asset

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



*** summary table and global control variable ***
estpost sum hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_father educ_mother
label var hh_head_age2 "Age"
label var hh_head_sex2 "Sex"
label var hh_head_edu2 "Educ"
label var hh_num2 "Household Size"
label var educ_father "Fathers Educ"
label var educ_mother "Mothers Educ"
eststo sumtable
esttab sumtable, cell((mean sd(par) max)) nonumbers mtitles("Controls") l
* 84 hhheads aged 0?? 



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

sum droughtfreq if year == 2019

gen droughtfreq2 = 0
replace droughtfreq2 = 0 if droughtfreq == 11 | droughtfreq == .
replace droughtfreq2 = 1 if droughtfreq == 10
replace droughtfreq2 = 1 if droughtfreq == 9
replace droughtfreq2 = 1 if droughtfreq == 8
replace droughtfreq2 = 1 if droughtfreq == 7
replace droughtfreq2 = 1 if droughtfreq == 6
replace droughtfreq2 = 2 if droughtfreq == 5
replace droughtfreq2 = 2 if droughtfreq == 4
replace droughtfreq2 = 3 if droughtfreq == 3
replace droughtfreq2 = 5 if droughtfreq == 2
replace droughtfreq2 = 10 if droughtfreq == 1
	
label var droughtfreq2 "Drought Frequency"

*****
sum rains if year == 2019
gen rains2 = rains
replace rains2 = -1 if rains == 1
replace rains2 = 0 if rains == 3 | rains == 4
replace rains2 = 1 if rains == 2
replace rains2 = 0 if rains2 == . & year != 2016

sum forecast_rain if year == 2019
replace forecast_rain = 0 if forecast_rain == . & year == 2019 & rains == 4

*****
sum prepared if year == 2019
replace prepared = 2 if prepared == . & year == 2019

gen prepared2 = 0
replace prepared2 = 2 if prepared == 1 
replace prepared2 = 1 if prepared == 2
replace prepared2 = 0 if prepared == 3 | prepared == 4


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

global controlX ihs_income2 formal_loan2 credit2 migrant remittances2 farmland2 livestock_index2 asset_pca  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2 
	
** summary stats for all controls
estpost sum hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father $controlX if year == 2019
eststo sumtableX


************************************************************

*rename labels for variable interpretation in table
label var educ_father "educ_father"
label var educ_mother "educ_mother"
label var s_n_hat2 "risk aversion"
label var ihs_income2 "income"
label var rains2 "rains"
label var prepared2 "prepared"
label var activities_drought2 "activities_drought"
label var forecast_use2 "forecast_use"
label var formal_loan2 "formal_loan"
label var credit2 "credit"
label var migrant3 "migrant"
label var remittances2 "remittances"
label var farmland2 "land"
label var livestock_index2 "tropical livestock index"
label var asset_pca "PCA score"


esttab sumtableX, cell((mean sd(par) min max)) nonumbers l


**********************************
* Complete Control Variable List *
**********************************

* demographics
*	hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
* coping ability
*	ihs_income2 formal_loan credit2 farmland livestock asset_pca migrant2 remittances2 activities_drought ///
* future perceptions
*	s_n_hat2 rains prepared forecast_use predict_rains ///
* interactions
*	incomeXndrought
*	incomeXdroughtint
*	incomeXdroughtfreq
*	creditXndrought
*	creditXdroughtint
*	creditXdroughtfreq
	


*==================================================================================*

********************** Shock Variable Creation *************************************

*==================================================================================*


*rank_laterain etc = what has the biggest neg. impact on your maize yields

/*
reg zaspirations late_rain
reg zaspirations dry_spell
reg zaspirations low_rain
reg zaspirations warm_temps
reg zaspirations flooding
reg zaspirations other_rainfall
*/
		
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
kdensity severedrought_length if drought == 1, ///
addplot(kdensity severedrought_length if drought == 0) ///
xline(0.334, lp(dash) lc(gs0)) ///
title(Severe Drought Prediction: Density Plot) ///
legend(label(1 "Experienced Severe Drought") label(2 "No Severe Drought")) ///
saving("C:\Users\kurczew2\Box\Research\HICPS\Visuals\preddensity.PNG", replace)

*================================================================================*
*        Sample cutoff as identified in 'overlap' R code
*			predicitons utilize drought status and drought lengths from 
*			2016 2017 & 2019
*				linear: 0.3789834
*				logit:  0.3563631
*				probit: 0.3579245 
*================================================================================*

sort HHID year
gen drought2 = 0
gen drought2_logit = 0
gen drought2_probit = 0


* severe drought if predicted value >= X
replace drought2 = 1 if severedrought_length >= 0.33308633


replace drought2_logit = 1 if severedrought_length_logit >= 0.31353457


replace drought2_probit = 1 if severedrought_length_p >= 0.31786554




* predictive model comparisons - using cutoff as identified in 'overlap' R code
*gen linear_drought = severedrought_length if severedrought_length >=  & year == 2018 

*gen logit_drought = severedrought_length_logit if severedrought_length_logit >=  & year == 2018 

*gen probit_drought = severedrought_length_p if severedrought_length_p >=  & year == 2018

*tabstat linear_drought logit_drought probit_drought , s(count mean sd)




** Summary Table for deciding what level is acceptable for determing 2018 drought status
* 2016




/*
exp_late
exp_dryspell
exp_lowtotal
exp_warm
exp_flood


replace rainint = . if year == 2018
replace rainint = 1 if droughtint > daysdrought & droughtint > daysnorain & year == 2018
replace rainint = 2 if droughtint <= daysdrought & droughtint >= daysnorain & year == 2018
replace rainint = 4 if droughtint <= daysdrought & droughtint < daysnorain & year == 2018

replace rainint = 6 if exp_flood == 1 & year == 2018
*/
 

* total number of years a household experienced a severe drought
sort HHID year
bysort HHID: egen n_drought = total(drought)

* dummy for a HH experiencing 2 or more severe droughts
gen drought_2years = 0 
replace drought_2years = 1 if n_drought >= 2





/*
bysort HHID: replace zaspirations = zaspirations[_n+1] if year < 2019
bysort HHID: replace zaspirations = zaspirations[_n+1] if year < 2018
bysort HHID: replace zaspirations = zaspirations[_n+1] if year < 2017
sort HHID year
*/

gen change_livestock = .
replace change_livestock = -1 if exp_how_livestock == 0
replace change_livestock = 0 if change_exp_livestock == 0
replace change_livestock = 1 if exp_how_livestock == 1

gen change_land = .
replace change_land = -1 if exp_how_land == 0
replace change_land = 0 if change_exp_land == 0
replace change_land = 1 if exp_how_land == 1
replace change_land = 0 if change_land == . & year == 2019

gen change_asset = .
replace change_asset = -1 if exp_how_asset == 0
replace change_asset = 0 if change_exp_asset == 0
replace change_asset = 1 if exp_how_asset == 1	

* assuming that missing data for change in livestock aspirations is equal to no change in livestock asps (no asps then to no asps now) treating as 0
replace change_livestock = 0 if change_livestock == . & year == 2019
gen ag_asp_change = change_livestock + change_land + change_asset


save HICPS_predicted, replace



*=====================================================================================*

************************************* RESULTS *****************************************

*=====================================================================================*


keep if year == 2019

*****************************
** Interactions to Include **
*****************************

* Income with shocks
gen incomeXndrought = ihs_income2 * n_drought
gen incomeXdroughtint = ihs_income2 * droughtint
gen incomeXdroughtfreq = ihs_income2 * droughtfreq

gen creditXndrought = credit2 * n_drought
gen creditXdroughtint = credit2 * droughtint
gen creditXdroughtfreq = credit2 * droughtfreq


**** Shock: number of droughts

global varlistndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father i.district ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2 
	
**********

* simple
global varlist1_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///

* simple++
global varlist3_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2 

* simple ++ interation
global varlist4_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2  ///
	incomeXndrought creditXndrought
	

															************************
															*** ndrought: levels ***
															************************													
cd "C:\Users\kurczew2\Box\Research\HICPS\Visuals"													

									************
									** SIMPLE **
									************


** w/o livestock **
reg zaspirations_nolivestock n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 2.1: Number of Droughts on Aspirations Level w/o Livestock)
	
reg zaspirations_nolivestock n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg zaspirations_nolivestock n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg zaspirations_nolivestock n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)



** individual dimension outcomes **
*land
reg zweighted_aspirations_land n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 2.2: Number of Droughts on Land Aspirations Level)
	
reg zweighted_aspirations_land n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg zweighted_aspirations_land n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg zweighted_aspirations_land n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)


* livestock
reg zweighted_aspirations_livestock n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 2.3: Number of Droughts on Livestock Aspirations Level)
	
reg zweighted_aspirations_livestock n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg zweighted_aspirations_livestock n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg zweighted_aspirations_livestock n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)
	

* asset
reg zweighted_aspirations_asset n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT4.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 2.4: Number of Droughts on Asset Aspirations Level)
	
reg zweighted_aspirations_asset n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT4.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg zweighted_aspirations_asset n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT4.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg zweighted_aspirations_asset n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHT4.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)
	
	

	
															**************************************
															********* ndrought: change ***********
															**************************************

	
** change by dimensions **

* land 
reg change_land n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 3.1: Number of Droughts on Land Aspirations Change)
	
reg change_land n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg change_land n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg change_land n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)
	
	
* livestock
reg change_livestock n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 3.2: Number of Droughts on Livestock Aspirations Change)
	
reg change_livestock n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg change_livestock n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg change_livestock n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)
	
	
* asset
reg change_asset n_drought $varlist1_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Table 3.3: Number of Droughts on Asset Aspirations Change)
	
reg change_asset n_drought $varlist2_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_ndrought) addtext(District FE, YES)
	
reg change_asset n_drought $varlist3_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_ndrought) addtext(District FE, YES)

reg change_asset n_drought $varlist4_ndrought i.district, base
	outreg2 using "outregASPxNDROUGHTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_ndrought) addtext(District FE, YES)
	
	
	


	
	
	
															*******************************
															**** droughtint: asp levels ****
															*******************************
															
															
															
															
															
* simple
global varlist1_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///

* simple++
global varlist3_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2 

* simple ++ interation
global varlist4_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2  ///
	incomeXndrought creditXndrought												

*******************************

** w/o livestock **
reg zaspirations_nolivestock droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 4.1: Drought Length on Aspirations Level w/o Livestock)
	
reg zaspirations_nolivestock droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg zaspirations_nolivestock droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg zaspirations_nolivestock droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)



** individual dimension outcomes **
*land
reg zweighted_aspirations_land droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 4.2: Drought Length on Land Aspirations Level)
	
reg zweighted_aspirations_land droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg zweighted_aspirations_land droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg zweighted_aspirations_land droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)


* livestock
reg zweighted_aspirations_livestock droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 4.3: Drought Length on Livestock Aspirations Level)
	
reg zweighted_aspirations_livestock droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg zweighted_aspirations_livestock droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg zweighted_aspirations_livestock droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)
	

* asset
reg zweighted_aspirations_asset droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT4.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 4.4: Drought Length on Asset Aspirations Level)
	
reg zweighted_aspirations_asset droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT4.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg zweighted_aspirations_asset droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT4.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg zweighted_aspirations_asset droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxDROUGHTINT4.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)

	
	
													******************************
													*** droughtint: asp change ***
													******************************


	
** change by dimensions **
* land 
reg change_land droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.1: Drought Length on Land Aspirations Change)
	
reg change_land droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg change_land droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg change_land droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)
	
	
* livestock
reg change_livestock droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.2: Drought Length on Livestock Aspirations Change)
	
reg change_livestock droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg change_livestock droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg change_livestock droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughint) addtext(District FE, YES)
	
	
* asset
reg change_asset droughtint $varlist1_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Table 5.3: Drought Length on Asset Aspirations Change)
	
reg change_asset droughtint $varlist2_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtint) addtext(District FE, YES)
	
reg change_asset droughtint $varlist3_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtint) addtext(District FE, YES)

reg change_asset droughtint $varlist4_droughtint i.district, base
	outreg2 using "outregASPxNDROUGHTINTchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtint) addtext(District FE, YES)
	
	
	
	
	
														***************************
														* droughtfreq: asp levels *
														***************************
														
* simple
global varlist1_droughtfreq droughtfreq hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father

* simple+
global varlist2_droughtfreq droughtfreq hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///

* simple++
global varlist3_droughtfreq droughtfreq hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2 

* simple ++ interation
global varlist4_droughtfreq droughtfreq hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 educ_mother educ_father ///
	ihs_income2 formal_loan2 credit2 farmland2 livestock_index2 asset_pca migrant3 remittances2  ///
	s_n_hat2 rains2 prepared2 activities_drought2 forecast_use2  ///
	incomeXndrought creditXndrought	
***************************************************************************************************************************
	
** w/o livestock **
reg zaspirations_nolivestock droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 6.1: Drought Frequency on Aspirations Level w/o Livestock)
	
reg zaspirations_nolivestock droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg zaspirations_nolivestock droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg zaspirations_nolivestock droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)

	
** by dimension
* land
reg zweighted_aspirations_land droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 6.2: Drought Frequency on Land Aspirations Level)
	
reg zweighted_aspirations_land droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg zweighted_aspirations_land droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg zweighted_aspirations_land droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)
	
	
* livestock
reg zweighted_aspirations_livestock droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 6.3: Drought Frequency on Livestock Aspirations Level)
	
reg zweighted_aspirations_livestock droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg zweighted_aspirations_livestock droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg zweighted_aspirations_livestock droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)

	
* assets
reg zweighted_aspirations_asset droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ4.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 6.4: Drought Frequency on Asset Aspirations Level)
	
reg zweighted_aspirations_asset droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ4.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg zweighted_aspirations_asset droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ4.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg zweighted_aspirations_asset droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxDROUGHTFREQ4.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)
	
	
													******************************
													*** droughtfreq: asp change ***
													******************************
	
	
** change by dimension **
* land change
reg change_land droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange1.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.1: Drought Frequency on Land Aspirations Change)
	
reg change_land droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg change_land droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg change_land droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange1.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)
	
	
* livestock change
reg change_livestock droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange2.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.2: Drought Frequency on Livestock Aspirations Change)
	
reg change_livestock droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg change_livestock droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg change_livestock droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange2.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)
	
	
	
* asset change
reg change_asset droughtfreq $varlist1_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange3.doc", replace ///
	ctitle(" ") ///
	keep($varlist1_droughtfreq) addtext(District FE, YES) lab title(Table 7.3: Drought Frequency on Asset Aspirations Change)
	
reg change_asset droughtfreq $varlist2_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist2_droughtfreq) addtext(District FE, YES)
	
reg change_asset droughtfreq $varlist3_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist3_droughtfreq) addtext(District FE, YES)

reg change_asset droughtfreq $varlist4_droughtfreq i.district, base
	outreg2 using "outregASPxNDROUGHTFREQchange3.doc", append ///
	ctitle(" ") ///
	keep($varlist4_droughtfreq) addtext(District FE, YES)
	



**************************************************************************************************************************************

cd "C:\Users\kurczew2\Box\Research\HICPS\Data"





