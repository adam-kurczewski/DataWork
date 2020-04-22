/// Aspirations and Weather Correlations ///

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

use HICPS_RISK.dta, clear

*keep if year == 2019
sort HHID year

/* addressing missing livestock aspirations
bysort camp2 year: egen rank_livestock_mean = median(rank_livestock_10)
 
sort HHID year


replace rank_livestock_10 = rank_livestock_mean if rank_livestock_10 == . & year == 2019 & people_livestock == 1
replace rank_livestock_10 = 0 if rank_livestock_10 == . & year == 2019 & people_livestock == 0

sort HHID year

bysort HHID: replace rank_livestock_10 = rank_livestock_10[_n+1] if year < 2019
bysort HHID: replace rank_livestock_10 = rank_livestock_10[_n+1] if year < 2018
bysort HHID: replace rank_livestock_10 = rank_livestock_10[_n+1] if year < 2017
*/

*cleaning
foreach var in rank_land_10 rank_livestock_10 rank_asset_10 {
	sum `var'
	replace `var' = r(mean) if `var' == . & year == 2019
}

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


* controls

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

* 2019 risk aversion coeff.
gen s_n_hat2 = 0
replace s_n_hat2 = s_n_hat if year == 2019

bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2019
bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2018
bysort HHID: replace s_n_hat2 = s_n_hat2[_n+1] if year < 2017


* summary stats for controls
gen hh_head_age2 = hh_head_age if year == 2016
bysort HHID: replace hh_head_age2 = hh_head_age2[_n-1] if year > 2016

gen hh_head_sex2 = hh_head_sex
bysort HHID: replace hh_head_sex2 = hh_head_sex2[_n-1] if year > 2016

gen hh_head_edu2 = hh_head_edu if year == 2016
bysort HHID: replace hh_head_edu2 = hh_head_edu2[_n-1] if year > 2016

gen hh_num2 = hh_num
bysort HHID: replace hh_num2 = hh_num2[_n-1] if year > 2016

estpost sum hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2
label var hh_head_age2 "Age"
label var hh_head_sex2 "Sex"
label var hh_head_edu2 "Educ"
label var hh_num2 "Household Size"
eststo sumtable
esttab sumtable, cell((mean sd(par) max)) nonumbers mtitles("Controls") l

global controls hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 i.district
		   *dum1 dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10 dum11 dum12

*==================== 84 hhheads aged 0?? =======================*

		 
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







**** Variable Creation *****

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
xline(0.3368, lp(dash) lc(gs0)) ///
title(Severe Drought Prediction: Density Plot) ///
legend(label(1 "Experienced Severe Drought") label(2 "No Severe Drought")) ///
saving("C:\Users\kurczew2\Box\Research\HICPS\Visuals\preddensity.PNG", replace)



* predictive model comparisons - using 0.378983394986607 cutoff as identified in 'overlap' R code
gen linear_drought = severedrought_length if severedrought_length >= 0.378983394986607 & year == 2018 

gen logit_drought = severedrought_length_logit if severedrought_length_logit >= 0.378983394986607 & year == 2018 

gen probit_drought = severedrought_length_p if severedrought_length_p >= 0.378983394986607 & year == 2018

tabstat linear_drought logit_drought probit_drought , s(count mean sd)


*================================================================================*
*        Cutoff: using 0.378983394986607 as identified in 'overlap' R code            												 *
*================================================================================*

sort HHID year
* severe drought if predicted value >= X & in 2018
replace drought = 1 if severedrought_length >= 0.378983394986607 & year == 2018
* 355 changes made

replace drought_logit = 1 if severedrought_length_logit >= 0.378983394986607 & year == 2018
* 348 changes made

replace drought_probit = 1 if severedrought_length_p >= 0.378983394986607 & year == 2018
* 344 changes made




* Summary Table for deciding what level is acceptable for determing 2018 drought status
estpost summarize droughtint drought severedrought_length if year == 2016
eststo sum2016

estpost summarize droughtint drought severedrought_length if year == 2017
eststo sum2017

estpost summarize droughtint drought severedrought_length if year == 2018
eststo sum2018

estpost summarize droughtint drought severedrought_length if year == 2019
eststo sum2019

label var droughtint "droughtlength" 
label var drought "drought"
label var severedrought_length "drought_hat"

esttab sum2016 sum2017 sum2018 sum2019, cell(mean sd(par)) nonumber mlabels("2016" "2017" "2018" "2019") l



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
** need to find support for this with correlations
replace change_livestock = 0 if change_livestock == . & year == 2019
gen ag_asp_change = change_livestock + change_land + change_asset


save HICPS_predicted, replace

	
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
replace droughtfreq = 4 if droughtfreq == . & year == 2019

sum rains if year == 2019

sum forecast_rain if year == 2019
replace forecast_rain = 0 if forecast_rain == . & year == 2019 & rains == 4

sum prepared if year == 2019
replace prepared = 2 if prepared == . & year == 2019

sum activities_drought if year == 2019

sum forecast_use

sum forecast_aware
replace forecast_aware = 1 if forecast_aware == . & forecast_use == 1

sum predict_rains if year == 2019
replace predict_rains = r(mean) if predict_rains == . & year == 2019


*******************
* Credit controls *
*******************
sort HHID year

sum formal_loan if year == 2019

sum borrow500 borrow2500 borrow10000 if year == 2019


*****************
* Land controls *
*****************

sum farmland if year == 2019


**********************
* Livestock controls *
**********************

sort HHID year

sum female_cattle_number goat_sheep_number poultry_number ///
pigs_number oxen_number breeding_bull_number if year == 2019

foreach var in female_cattle_number goat_sheep_number poultry_number pigs_number oxen_number breeding_bull_number {
	bysort HHID year: replace `var' = 0 if `var' == . & year == 2019
}

* 2019 livestock counts
gen livestock = female_cattle_number + goat_sheep_number + poultry_number ///
	+ pigs_number + oxen_number + breeding_bull_number if year == 2019


******************
* Asset controls *
******************

sort HHID year

sum asset_phone tv radio bike motorcycle water_pump ///
	plough sprayers ox_carts vehicle if year == 2019
	
gen asset = asset_phone + tv + radio + bike + motorcycle + water_pump ///
	+ plough + sprayers + ox_carts + vehicle if year == 2019
	
********************
* Migrant controls *
********************
sort HHID year
replace mig1_exist = 0 if mig1_exist == . & year != 2019
replace mig2_exist = 0 if mig2_exist == 2 | mig2_exist == . & year != 2019


gen migrant = 0
replace migrant = mig1_exist + mig2_exist
replace migrant = mem_remain if year == 2019
replace migrant = 0 if migrant == .
bysort HHID: egen migrant2 = total(migrant)


sort HHID year
foreach var in mig1_money mig2_money mig3_money mig4_money mig5_money {
	replace `var' = 0 if `var' == .
}

gen remittances = 0
replace remittances = mig1_money + mig2_money + mig3_money + mig4_money + mig5_money
bysort HHID: egen remittances2 = total(remittances) 


* Additional Control Global Var

keep if year == 2019
sort HHID year

global controlX s_n_hat2 ihs_income2 latearrival daysnorain daysdrought droughtint ///
	droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains ///
	formal_loan borrow500 borrow2500 borrow10000 migrant remittances farmland livestock asset
	
** summary stats for additional controls
estpost sum hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 $controlX
eststo sumtableX

*rename labels for variable interpretation in table
label var s_n_hat2 "risk aversion"
label var ihs_income2 "income"
label var latearrival "latearrival"
label var daysnorain "daysnorain"
label var daysdrought "daysdrought"
label var droughtint "droughtint"
label var droughtfreq "droughtfreq"
label var rains "rains"
label var prepared "prepared"
label var activities_drought "activities_drought"
label var forecast_use "forecast_use"
label var forecast_aware "forecast_aware"
label var predict_rains "predict_rains"
label var formal_loan "formal_loan"
label var borrow500 "borrow500"
label var borrow2500 "borrow2500"
label var borrow10000 "borrow10000"
label var migrant "migrant"
label var remittances "remittances"
label var farmland "land"
label var livestock "livestock"
label var asset "assets"

esttab sumtableX, cell((mean sd(par) min max)) nonumbers l


*===============================================*

*****************************
** Interactions to Include **
*****************************

* Income with shocks
gen incomeXndrought = ihs_income2 * n_drought
gen incomeXdroughtint = ihs_income2 * droughtint


*===============================================*

**** Shock: number of droughts

global varlist_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ihs_income2 ///
s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains ///
formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset incomeXndrought migrant2 remittances2

															***************************
															*** aspirations: levels ***
															***************************
															
															

									************
									** SIMPLE **
									************

global varlist1_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2

** w/o livestock **
reg zaspirations_nolivestock n_drought $controls , base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT1.doc", replace ///
	ctitle(No Livestock)  ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Figure 2.1: Demographics)


** w/ livestock **
reg zaspirations n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT1.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab


** individual dimension outcomes **
reg zweighted_aspirations_land n_drought $controls , base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT1.doc", append ///
	ctitle(Land) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_livestock n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT1.doc", append ///
	ctitle(Livestock) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_asset n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT1.doc", append ///
	ctitle(Assets) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab


										*******************
										** SIMPLE+coping **
										*******************


global varlist2_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2
	
global controlX2 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 
	
** w/o livestock **
reg zaspirations_nolivestock n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT2.doc", replace ///
	ctitle(No Livestock)  ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab title(Figure 2.2: Demographics & Coping Ability)


** w/ livestock **
reg zaspirations n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT2.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab


** individual dimension outcomes **
reg zweighted_aspirations_land n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT2.doc", append ///
	ctitle(Land) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_livestock n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT2.doc", append ///
	ctitle(Livestock) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_asset n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT2.doc", append ///
	ctitle(Assets) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab


										***************************
										** SIMPLE+copong+weather **
										***************************
										

global varlist3_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains
	
global controlX3 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains
	
** w/o livestock **
reg zaspirations_nolivestock n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT3.doc", replace ///
	ctitle(No Livestock)  ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab title(Figure 2.3: Demographics, Coping Ability, & Weather Perceptions)


** w/ livestock **
reg zaspirations n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT3.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab


** individual dimension outcomes **
reg zweighted_aspirations_land n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT3.doc", append ///
	ctitle(Land) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_livestock n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT3.doc", append ///
	ctitle(Livestock) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_asset n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT3.doc", append ///
	ctitle(Assets) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab


										*******************************
										** SIMPLE+coping+weather+INT **
										*******************************
										
										
global varlist4_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains ///
	incomeXndrought

** w/o livestock **
reg zaspirations_nolivestock n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT4.doc", replace ///
	ctitle(No Livestock)  ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab title(Figure 2.4: Demographics, Coping Ability, Weather Perceptions & Income Interaction)


** w/ livestock **
reg zaspirations n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT4.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab


** individual dimension outcomes **
reg zweighted_aspirations_land n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT4.doc", append ///
	ctitle(Land) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_livestock n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT4.doc", append ///
	ctitle(Livestock) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab


reg zweighted_aspirations_asset n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHT4.doc", append ///
	ctitle(Assets) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab

	

															*****************************************
															********* Aspirations: change ***********
															*****************************************
																				
																				

									**************
									*** Simple ***
									**************

global varlist1_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2									
									
* aggregate change
reg ag_asp_change n_drought $controls , base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange1.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab title(Figure 3.1: Demographics)

* by dimensions
reg change_land n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange1.doc", append ///
	ctitle(Land) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab

reg change_livestock n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange1.doc", append ///
	ctitle(Livestock) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab

reg change_asset n_drought $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange1.doc", append ///
	ctitle(Assets) ///
	keep($varlist1_ndrought) addtext(District FE, YES) lab
	
	
	

									*********************
									*** Simple+coping ***
									*********************
									
global varlist2_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2
	
global controlX2 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2
	

* aggregate change
reg ag_asp_change n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange2.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab title(Figure 3.2: Demographics & coping ability)

* by dimensions
reg change_land n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange2.doc", append ///
	ctitle(Land) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab

reg change_livestock n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange2.doc", append ///
	ctitle(Livestock) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab

reg change_asset n_drought $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange2.doc", append ///
	ctitle(Assets) ///
	keep($varlist2_ndrought) addtext(District FE, YES) lab

	
	
										*****************************
										*** Simple+coping+weather ***
										*****************************
										
global varlist3_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains
	
global controlX3 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains
	
	
* aggregate change
reg ag_asp_change n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange3.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab title(Figure 3.3: Demographics, coping ability, & weather perceptions)

* by dimensions
reg change_land n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange3.doc", append ///
	ctitle(Land) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab

reg change_livestock n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange3.doc", append ///
	ctitle(Livestock) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab

reg change_asset n_drought $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange3.doc", append ///
	ctitle(Assets) ///
	keep($varlist3_ndrought) addtext(District FE, YES) lab
	
	
									*********************************
									*** Simple+coping+weather+INT ***
									*********************************
									
global varlist4_ndrought n_drought hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains ///
	incomeXndrought
	

* aggregate change
reg ag_asp_change n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange4.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab title(Figure 3.4: Demographics, coping ability, weather perceptions, & interactions)

* by dimensions
reg change_land n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange4.doc", append ///
	ctitle(Land) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab

reg change_livestock n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange4.doc", append ///
	ctitle(Livestock) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab

reg change_asset n_drought $controls $controlX3 incomeXndrought, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxNDROUGHTchange4.doc", append ///
	ctitle(Assets) ///
	keep($varlist4_ndrought) addtext(District FE, YES) lab


	
															*******************************
															**** droughtin: asp levels ****
															*******************************



 
*** outcome: intensity (length) of drought

										**************
										*** simple ***
										**************


global varlist1_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2
 

*w/o livestock
reg zaspirations_nolivestock droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT1.doc", replace ///
	ctitle(No Livestock) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Figure 4.1: Demographics)

*w/ livestock (full aggregate)
reg zaspirations droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT1.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

*by dimension
reg zweighted_aspirations_land droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT1.doc", append ///
	ctitle(Land) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_livestock droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT1.doc", append ///
	ctitle(Livestock) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_asset droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT1.doc", append ///
	ctitle(Assets) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab
	
		
		
		
										*********************
										*** simple+coping ***
										*********************
										
global varlist2_droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2
										
global controlX2 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 

*w/o livestock
reg zaspirations_nolivestock droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT2.doc", replace ///
	ctitle(No Livestock) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab title(Figure 4.2: Demographics & Coping Ability)

*w/ livestock (full aggregate)
reg zaspirations droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT2.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

*by dimension
reg zweighted_aspirations_land droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT2.doc", append ///
	ctitle(Land) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_livestock droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT2.doc", append ///
	ctitle(Livestock) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_asset droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT2.doc", append ///
	ctitle(Assets) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

	
	
										*****************************
										*** simple+coping+weather ***
										*****************************

global varlist3_droughtint droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains  

global controlX3 ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains
	
	*w/o livestock
reg zaspirations_nolivestock droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT3.doc", replace ///
	ctitle(No Livestock) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab title(Figure 4.3: Demographics, Coping Ability, & Weather Perceptions)

*w/ livestock (full aggregate)
reg zaspirations droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT3.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab

*by dimension
reg zweighted_aspirations_land droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT3.doc", append ///
	ctitle(Land) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_livestock droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT3.doc", append ///
	ctitle(Livestock) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_asset droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT3.doc", append ///
	ctitle(Assets) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab
	
	
									*********************************
									*** simple+coping+weather+INT ***
									*********************************

global varlist4_droughtint droughtint droughtint hh_head_age2 hh_head_sex2 hh_head_edu2 hh_num2 ///
	ihs_income2 formal_loan borrow500 borrow2500 borrow10000 farmland livestock asset migrant2 remittances2 ///
	s_n_hat2 latearrival daysnorain daysdrought droughtfreq rains prepared activities_drought forecast_use forecast_aware predict_rains ///
	incomeXdroughtint
						
									
*w/o livestock
reg zaspirations_nolivestock droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT4.doc", replace ///
	ctitle(No Livestock) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab title(Figure 4.3: Demographics, Coping Ability, & Weather Perceptions)

*w/ livestock (full aggregate)
reg zaspirations droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT4.doc", append ///
	ctitle(All Dimensions) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab

*by dimension
reg zweighted_aspirations_land droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT4.doc", append ///
	ctitle(Land) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_livestock droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT4.doc", append ///
	ctitle(Livestock) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab

reg zweighted_aspirations_asset droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINT4.doc", append ///
	ctitle(Assets) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab
				

	

	
	
													******************************
													*** droughtint: asp change ***
													******************************
														
							**************
							*** simple ***
							**************	

* aggregate change
reg ag_asp_change droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange1.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab title(Figure 5.1: Demographics)

* by dimension change
reg change_land droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange1.doc", append ///
	ctitle(Land) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

reg change_livestock droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange1.doc", append ///
	ctitle(Livestock) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

reg change_asset droughtint $controls, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange1.doc", append ///
	ctitle(Asset) ///
	keep($varlist1_droughtint) addtext(District FE, YES) lab

	
							*********************
							*** simple+coping ***
							*********************
	
* aggregate change
reg ag_asp_change droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange2.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab title(Figure 5.2: Demographics & coping ability)

* by dimension change
reg change_land droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange2.doc", append ///
	ctitle(Land) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

reg change_livestock droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange2.doc", append ///
	ctitle(Livestock) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

reg change_asset droughtint $controls $controlX2, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange2.doc", append ///
	ctitle(Asset) ///
	keep($varlist2_droughtint) addtext(District FE, YES) lab

	
								*****************************
								*** simple+coping+weather ***
								*****************************
								
* aggregate change
reg ag_asp_change droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange3.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab title(Figure 5.3: Demographics, coping ability, & weather perceptions)

* by dimension change
reg change_land droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange3.doc", append ///
	ctitle(Land) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab

reg change_livestock droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange3.doc", append ///
	ctitle(Livestock) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab

reg change_asset droughtint $controls $controlX3, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange3.doc", append ///
	ctitle(Asset) ///
	keep($varlist3_droughtint) addtext(District FE, YES) lab
	
	
	
								*********************************
								*** simple+coping+weather+INT ***
								*********************************
								
* aggregate change
reg ag_asp_change droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange4.doc", replace ///
	ctitle(Aggregate Change) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab title(Figure 5.4: Demographics, coping ability, weather perceptions & interaction)

* by dimension change
reg change_land droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange4.doc", append ///
	ctitle(Land) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab

reg change_livestock droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange4.doc", append ///
	ctitle(Livestock) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab

reg change_asset droughtint $controls $controlX3 incomeXdroughtint, base
	outreg2 using "C:\Users\kurczew2\Box\Research\HICPS\Visuals\outregASPxDROUGHTINTchange4.doc", append ///
	ctitle(Asset) ///
	keep($varlist4_droughtint) addtext(District FE, YES) lab




