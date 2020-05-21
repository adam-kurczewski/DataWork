*Date Created: September 22, 2019
*Date Edited: May 21, 2020
*Author: Original code produced by Nicolas Gatti, edited by Patrese Anderson, adapted by Adam Kurczewski 
*Contents: First part of the file imports the raw data and reshapes (Large data file time consuming). Second part of do file creates rainfall variables for analysis and descriptive statistics. 

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"


*import raw data and reshape and save file

import excel "C:\Users\kurczew2\Box\Research\HICPS\Data\CHIRPS_Zambia_daily.xlsx",  firstrow


label variable A "Date"

foreach var of varlist * {
local x: variable label `var'
rename `var' X`x'
}

*set date as time series
rename XDate date
tsset date
gen month = month(date)
gen day = day(date)
gen year = year(date)

* mismatched 'observations' preventing reshaping
drop X30127001 X30127002 X30127003 X30127005 ///
 X30127006 X30127009 X30127010 X30127011 X30127012 ///
 X30127014 X30127016 X30127017 X50141023

 
*** WARNING: this will take some time to run ***
reshape long X, i(date) j(HHID) string


*var cleaning and export
rename X rainfall
label variable rainfall "Daily rainfall at HH level"

sort HHID date
order  HHID date
save "dailyrainXhhid", replace



/// This do file works with daily rainfall data to create rainfall variables ///

*Takes the daily data at the HHID and aggregates it to the camp level. Creates other necessary variables at camp, district and provincial spatial scales. 

use "dailyrainXhhid", clear
destring HHID, replace 
xtset HHID date

merge m:1 HHID using "2016 HICPS.dta", keepusing(camp province district)

drop if _merge!=3

encode camp, gen(camp_num) 


***collapse from HHID to camp level data by mean 
collapse (mean) rainfall, by(date province district camp)
label var rainfall "Daily rainfall by camp" 
encode camp, gen(camp_num)

label var province "Province"
label var district "District"
label var camp "Camp" 

gen month = month(date)
gen day = day(date)
gen year = year(date)


gen mdate = ym(year,month)
format mdate %tm


*gen ag season variable 
gen agyr=.
foreach i of num 2001/2019{
	replace agyr= `i'+1 if inrange(mdate, ym(`i', 6), ym(`i'+1,6))
}
drop if missing(agyr) 


**gen longterm moving averages and standard deviation over ag years of total rainfall by camp

preserve 
collapse (sum) rainfall, by(agyr province district camp camp_num) 
drop if rainfall==0

*getting repeated time value error...
*xtset camp_num agyr

rangestat (sd) rainfall, by(camp) interval(agyr -9 0)
rangestat (mean) rainfall, by(camp) interval(agyr -9 0)

label var rainfall_sd "10 yr moving SD of rainfall" 
label var rainfall_mean "10 yr moving mean of rainfall" 

gen z_rain=(rainfall-rainfall_mean)/rainfall_sd
gen posz=(z_rain>=1)
gen negz=(z_rain<=-1) 

keep if agyr>2014 
save "Longterm avg_sd", replace 
restore

merge m:1 camp agyr using "Longterm avg_sd" 
rename rainfall_sd LTrainfall_sd
rename rainfall_mean LTrainfall_mean

*sum rainfall over ag year and drop obs if equal to zero these are obv incorrect observations
bysort camp agyr: egen agyr_total=sum(rainfall) 
drop if agyr_total==0
label var agyr_total "Total RF by agyr" 

***gen rainfall shock variables 
egen xt10_rain=xtile(agyr_total),by(camp) n(10)
egen xt5_rain=xtile(agyr_total), by(camp) n(5) 
gen neg10=(xt10_rain==1)
gen neg20=(xt5_rain==1)
gen pos10=(xt10_rain==10)
gen pos20=(xt5_rain==5) 


***gen monthly averages
/* 
preserve 
collapse (sum) rainfall, by(month agyr province district camp camp_num)
bysort camp month: egen monthly_mean=mean(rainfall) 
bysort camp month: egen monthly_sd=sd(rainfall) 
collapse(mean) monthly_mean monthly_sd, by(camp month)
label var monthly_mean "Mean of monthly rainfall" 
label var monthly_sd "SD of monthly rainfall" 
save "Monthly avg_sd", replace   
restore 
*/

drop _merge 
merge m:1 camp month using "Monthly avg_sd" 
drop _merge 

order province district camp camp_num date mdate year agyr month day 

drop if year<2015

*generate a season variable
xtset camp_num date 
gen rain_season = .
replace rain_season = 2016 	if (date>=mdy(9,1,2015) & date<=mdy(04,31,2016))
replace rain_season = 2017  if (date>=mdy(9,1,2016) & date<=mdy(04,31,2017))
replace rain_season = 2018  if (date>=mdy(9,1,2017) & date<=mdy(04,31,2018))
replace rain_season = 2019  if (date>=mdy(9,1,2018) & date<=mdy(04,31,2019))

*gen monthly rainfall 3
bysort camp mdate: egen S = sum(rainfall)

*gen rainy season rainfall
bysort camp rain_season: egen season_rainfall = sum(rainfall)

*moving average from 5 days to calculate first day that rainfall is more than 10 mm
sort camp_num date
gen ma_rainfall = (rainfall + L1.rainfall + L2.rainfall + L3.rainfall + L4.rainfall) / 5

gen rainfall_first = 0
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2015) & date<=mdy(04,31,2016))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2016) & date<=mdy(04,31,2017))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2017) & date<=mdy(04,31,2018))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2018) & date<=mdy(04,31,2019))


*gen variable with the first ocurrence of rainfall by season
sort camp season date
by camp season: egen rainfall_start= min(date/(rainfall_first == 1))
format rainfall_start %td

by camp season: egen rainfall_end= max(date/(rainfall_first == 1))
format rainfall_end %td




*gen days with zero rainfall ***these are generated within the rainy season need to generate variables which take into account the start and end of the rainy season. 
gen zero_rainfall = 0
replace zero_rainfall = 1 if rainfall == 0 & !missing(rain_season) & rainfall_start<=date & date<=rainfall_end

gen actual_seasonB=(rainfall_start<=date & date<=rainfall_end)

gen actual_season=.
replace actual_season = 2016 	if (date>=mdy(9,1,2015) & date<=mdy(04,31,2016)) & actual_seasonB==1
replace actual_season = 2017  if (date>=mdy(9,1,2016) & date<=mdy(04,31,2017)) & actual_seasonB==1
replace actual_season = 2018  if (date>=mdy(9,1,2017) & date<=mdy(04,31,2018)) & actual_seasonB==1
replace actual_season = 2019  if (date>=mdy(9,1,2018) & date<=mdy(04,31,2019)) & actual_seasonB==1


bysort camp agyr: egen zero_rain=sum(zero_rainfall)



sort camp_num actual_season date
by camp_num actual_season: gen spell = sum(zero_rainfall != zero_rainfall[_n-1])

sort camp_num actual_season date 
by camp_num actual_season spell, sort: gen days_spell = (cond(zero_rainfall, _n, 0))

***gen longest dryspell 
bysort camp_num actual_season: egen max_spell_days=max(days_spell)


/*
label var rainfall "Rainfall by Camp" 
label var camp_num "Numeric Camp" 
label var month "Month" 
label var day "Day"
label var year "Year" 
label var mdate "Date" 
label var rain_season "Agricultural rain season" 
label var monthly_rainfall "Monthly accumulated rainfall" 
label var season_rainfall "Seasonal accumulated rainfall" 
label var ma_rainfall "Moving 5 day avg rainfall" 
label var rainfall_start "First day of rainfall" 
label var rain_zero "Number of days with zero rainfall" 
label var agyr "Agricultural year" 
drop zero_rainfall rainfall_first  ma_rainfall 
*/

save "Rainfall by camp", replace

collapse (mean) z_rain neg10 neg20 pos10 pos20 posz negz agyr_total xt10_rain xt5_rain rainfall_start rainfall_end max_spell_days zero_rain, by(agyr camp district)

save "Rainfall shocks by camp agyr", replace 



