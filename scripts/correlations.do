/// Aspirations and Weather Correlations ///

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Code1"

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

*tabulate province, g(provdum)

* need to add more perception variables such as drought_freq etc
** need to make sure they are in all years?
sum income
replace income = r(mean) if income > 200000

*adjust income so that only baseline income is considered
gen income2 = 0
replace income2 = income if year == 2016

bysort HHID: replace income2 = income2[_n-1] if year > 2016

* 2016 risk aversion coeff.
gen s_n_hat2 = 0
replace s_n_hat2 = s_n_hat if year == 2016

bysort HHID: replace s_n_hat2 = s_n_hat2[_n-1] if year > 2016


global controls hh_head_age hh_head_sex hh_head_edu hh_num s_n_hat2 income2 i.district
		   *dum1 dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10 dum11 dum12


* summary stats for controls
estpost sum hh_head_age hh_head_sex hh_head_edu hh_num s_n_hat2 income2
eststo sumtable
esttab sumtable, cell((mean sd(par) min max)) nonumbers mtitles("Controls")

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
replace droughtint = r(mean) if droughtint == . | droughtint < 0

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

* severe drought if predicted value >= mean in 2018?
replace drought = 1 if severedrought_length >= 0.5 & year == 2018
* 46 changes made

replace drought_logit = 1 if severedrought_length_logit >= 0.5 & year == 2018
* 29 changes made

replace drought_probit = 1 if severedrought_length_p >= 0.5 & year == 2018
* 15 changes made


* Summary Table for deciding what level is acceptable for determing 2018 drought status
estpost summarize droughtint drought severedrought_length if year == 2016
eststo sum2016

estpost summarize droughtint drought severedrought_length if year == 2017
eststo sum2017

estpost summarize droughtint drought severedrought_length if year == 2018
eststo sum2018

estpost summarize droughtint drought severedrought_length if year == 2019
eststo sum2019

esttab sum2016 sum2017 sum2018 sum2019, cell(mean sd(par)) nonumber mlabels("2016" "2017" "2018" "2019")



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


*** Reg cleaning ***

keep if year == 2019

sum daysdrought, d
replace daysdrought = r(mean) if daysdrought == .

* replacing with "other", need to revist this...
replace rains_reasons = 8 if rains_reasons == .
*===============================================*

sum prepared
replace prepared = r(mean) if prepared == .

sum zaspirations
replace zaspirations = r(mean) if zaspirations == .


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

gen change_asset = .
replace change_asset = -1 if exp_how_asset == 0
replace change_asset = 0 if change_exp_asset == 0
replace change_asset = 1 if exp_how_asset == 1	

* assuming that missing data for change in livestock aspirations is equal to no change in livestock asps (no asps then to no asps now) treating as 0
** need to find support for this with correlations
replace change_livestock = 0 if change_livestock == .
gen ag_asp_change = change_livestock + change_land + change_asset


	
	
	
***** Results *****
*xtset district

**** Shock: number of droughts

*** aspirations: levels

** w/o livestock
reg zaspirations_nolivestock n_drought $controls, base
eststo aspnolive

** w/ livestock
reg zaspirations n_drought $controls, base
eststo aspwlive

** individual dimension outcomes
reg zweighted_aspirations_land n_drought $controls, base
eststo aspland
reg zweighted_aspirations_livestock n_drought $controls, base
eststo asplive
reg zweighted_aspirations_asset n_drought $controls, base
eststo aspass

*** Aspirations: change

* by dimensions
reg change_land n_drought $controls
eststo daspland
reg change_livestock n_drought $controls
eststo dasplive
reg change_land n_drought $controls
eststo daspass


* aggregate change
reg ag_asp_change n_drought $controls
eststo dagasp

** output
esttab aspnolive aspwlive aspland asplive aspass using stataexample1.doc, compress replace

esttab dagasp daspland dasplive daspass using stataexample2.doc, compress replace


 
*** outcome: intensity (length) of drought

*w/o livestock
xtreg zaspirations_nolivestock droughtint $controls, base
eststo intaspnolive

*w/ livestock (full aggregate)
xtreg zaspirations droughtint $controls, base
eststo intaspwlive

*by dimension
xtreg zweighted_aspirations_land droughtint $controls, base
eststo intaspland

xtreg zweighted_aspirations_livestock droughtint $controls, base
eststo intasplive

xtreg zweighted_aspirations_asset droughtint $controls, base
eststo intaspass

*** Aspirations: change

* by dimension change
xtreg change_land droughtint $controls
eststo intdaspland

xtreg change_livestock droughtint $controls
eststo intdasplive

xtreg change_land droughtint $controls
eststo intdaspass

* aggregate change
xtreg ag_asp_change droughtint $controls
eststo intagasp

** output
esttab intaspnolive intaspwlive intaspland intasplive intaspass using stataexample3.doc, compress replace

esttab intaspland intasplive intaspass intagasp using stataexample4.doc, compress replace
		

*** Outcome: experiencing 2 or more droughts
reg zaspirations_nolivestock ib0.drought_2years $controls, baselevels

reg zweighted_aspirations_land ib0.drought_2years $controls baselevels
reg zweighted_aspirations_asset ib0.drought_2years $controls baselevels

reg change_land ib0.drought_2years $controls, baselevels
reg change_livestock ib0.drought_2years $controls, baselevels
reg change_land ib0.drought_2years $controls, baselevels

reg ag_asp_change ib0.drought_2years $controls, baselevels


/*
sum income
scalar incomeM = r(mean)
reg zaspirations n_drought if income > incomeM & year == 2019


