*Date Created: September 22, 2019
*Date Edited: May 21, 2020
*Author: Original code produced by Nicolas Gatti, edited by Patrese Anderson, adapted by Adam Kurczewski 
*Contents: First part of the file imports the raw data and reshapes (Large data file time consuming). Second part of do file creates rainfall variables for analysis and descriptive statistics. 

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

*import raw data and reshape and save file

import excel "CHIRPS_Zambia_monthly.xlsx", firstrow


foreach var of varlist * {
local x: variable label `var'
rename `var' X`x'
}

*set date as time series
rename Xyear year
rename Xmonth date
tsset date
gen month = month(date)
*gen day = day(date)
*gen year = year(date)

* mismatched 'observations' preventing reshaping of daily data
*drop X30127001 X30127002 X30127003 X30127005 ///
* X30127006 X30127009 X30127010 X30127011 X30127012 ///
* X30127014 X30127016 X30127017 X50141023

 
*** WARNING: this will take some time to run ***
reshape long X, i(date) j(hh) string


*var cleaning and export
rename X rainfall
label variable rainfall "Monthly rainfall at HH level"

*rename hh HHID

sort hh date
order hh date rainfall
replace rainfall = "" if rainfall == "NaN"
destring rainfall, replace


save "monthlyrainXhhid", replace

/// This do file works with daily rainfall data to create rainfall variables ///

*Takes the daily data at the HHID and aggregates it to the camp level. Creates other necessary variables at camp, district and provincial spatial scales. 
use "monthlyrainXhhid", clear

destring hh, gen(hh1) i(hh) 

joinby hh1 using HHID.dta, _merge(merge1) unmatched(master)
*tab merge1
replace HHID = hh1

xtset HHID date

joinby HHID using hh_geo_info.dta, _merge(merge2) unmatched(master)

*merge m:1 HHID using "2016 HICPS.dta", keepusing(camp province district)
*drop if _merge!=3
rename camp_code camp_num

***collapse from HHID to camp level data by mean 
collapse (mean) rainfall, by(date province district district_code camp camp_num)

label var rainfall "monthly rainfall by camp" 
*encode camp, gen(camp_num)

label var province "Province"
label var district "District"
label var camp "Camp" 

gen month = month(date)
*gen day = day(date)
gen year = year(date)


gen mdate = ym(year,month)
format mdate %tm


*gen ag season variable 
gen agyr=.

* X/2019 = cutoff for moving avergae adjust as necessary/desired
* 2009 - 10 year avg
* 1999 - 20 year
* 1989 - 30 year
*1981 - 38 year (entire dataset)

foreach i of num 2008/2019{
	replace agyr= `i'+1 if inrange(mdate, ym(`i', 6), ym(`i'+1,6))
}



* drop years outside of avg cutoff above (1981 = no missings created aka 38yr avg calculated)
drop if missing(agyr) 


**gen longterm moving averages and standard deviation over ag years of total rainfall by camp

preserve 
collapse (sum) rainfall, by(agyr province district camp camp_num) 
*drop if rainfall==0

*getting repeated time value error...
xtset camp_num agyr

rangestat (sd) rainfall, by(camp) interval(agyr -9 0)
rangestat (mean) rainfall, by(camp) interval(agyr -9 0)

* adjust time interval for moving avg. as desired
label var rainfall_sd "long run moving SD of rainfall" 
label var rainfall_mean "long run moving mean of rainfall" 

gen z_rain=(rainfall-rainfall_mean)/rainfall_sd
gen posz=(z_rain>=1)
gen negz=(z_rain<=-1) 

*keep if agyr>2014 
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

order province district camp camp_num date mdate year agyr month

*drop if year<2015

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

save "Rainfall by camp-monthly.10yr", replace
*destring district, replace
replace district = "101" if district == "Mkushi"
replace district = "102" if district == "Mumbwa"
replace district = "201" if district == "Mpongwe"
replace district = "202" if district == "Masaiti"
replace district = "301" if district == "Lundazi"
replace district = "302" if district == "Petauke"
replace district = "401" if district == "Mbala"
replace district = "402" if district == "Chinsali"
replace district = "501" if district == "Mufumbwe"
replace district = "502" if district == "Solwezi"
replace district = "601" if district == "Choma"
replace district = "602" if district == "Namwala"
destring district, replace

label define districts ///
	101 "Mkushi" 102 "Mumbwa" ///
	201 "Mpongwe" 202 "Masaiti" /// 
	301 "Lundazi" 302 "Petauke" ///
	401 "Mbala" 402 "Mungwi" ///
	501 "Mufumbwe" 502 "Solwezi" ///
	601 "Choma" 602 "Namwala"

label values district districts

collapse (mean) z_rain neg10 neg20 pos10 pos20 posz negz agyr_total xt10_rain xt5_rain rainfall_start rainfall_end max_spell_days zero_rain, by(agyr camp district)

*rename merge vars to match master
rename agyr year
rename camp camp3

save "Rainfall shocks by camp agyr-monthly.10yr", replace 
export excel using "rainfallXcamp-10yr.xlsx", firstrow(var) replace














**********************************************************************************

*============================== CHIRPS DAILY ====================================*

**********************************************************************************

clear all
set more off
*cd "C:\Users\kurczew2\Box\Research\HICPS\Data"
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

import excel "CHIRPS_Zambia_daily-clean", firstrow


foreach var of varlist * {
local x: variable label `var'
rename `var' t`x'
}

*set date as time series
rename t date
tsset date
gen month = month(date)
gen day = day(date)
gen year = year(date)
order date month day year

*drop if year != 2019


* mismatched 'observations' preventing reshaping of daily data
drop t30127001 t30127002 t30127003 t30127005 ///
	t30127006 t30127009 t30127010 t30127011 t30127012 ///
	t30127014 t30127016 t30127017 t50141023
	

reshape long t, i(date) j(hh) string

rename t rainfall
label var rainfall "Daily rainfall by HH"

sort hh date
destring hh, gen(hh1) i(hh) 
rename hh1 HHID
xtset HHID date

joinby HHID using hh_geo_info.dta, _merge(merge2) unmatched(master)

rename camp_code camp_num

****************************

label var province "Province"
label var district "District"
label var camp "Camp" 


gen mdate = ym(year,month)
format mdate %tm


*gen ag season variable 
gen agyr=.

foreach i of num 2015/2019{
	replace agyr= `i'+1 if inrange(mdate, ym(`i', 6), ym(`i'+1,6))
}

drop if missing(agyr)


*generate a season variable
xtset HHID date 
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
sort HHID date
gen ma_rainfall = (rainfall + L1.rainfall + L2.rainfall + L3.rainfall + L4.rainfall) / 5

gen rainfall_first = 0
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2015) & date<=mdy(04,31,2016))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2016) & date<=mdy(04,31,2017))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2017) & date<=mdy(04,31,2018))
replace rainfall_first = 1 if ma_rainfall >= 10 & (date>=mdy(9,1,2018) & date<=mdy(04,31,2019))


*gen variable with the first ocurrence of rainfall by season
sort HHID season date
by HHID season: egen rainfall_start= min(date/(rainfall_first == 1))
format rainfall_start %td

by HHID season: egen rainfall_end= max(date/(rainfall_first == 1))
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


bysort HHID agyr: egen zero_rain=sum(zero_rainfall)

order date agyr HHID district camp zero_rain

*max num of days without rain during agyr by HH by year
collapse (max) zero_rain, by(HHID agyr district camp)
drop if agyr > 2019
rename agyr year
rename camp camp3
rename zero_rain daily_zero_rain

*'encode' districts for merge
replace district = "101" if district == "Mkushi"
replace district = "102" if district == "Mumbwa"
replace district = "201" if district == "Mpongwe"
replace district = "202" if district == "Masaiti"
replace district = "301" if district == "Lundazi"
replace district = "302" if district == "Petauke"
replace district = "401" if district == "Mbala"
replace district = "402" if district == "Chinsali"
replace district = "501" if district == "Mufumbwe"
replace district = "502" if district == "Solwezi"
replace district = "601" if district == "Choma"
replace district = "602" if district == "Namwala"
destring district, replace

label define districts ///
	101 "Mkushi" 102 "Mumbwa" ///
	201 "Mpongwe" 202 "Masaiti" /// 
	301 "Lundazi" 302 "Petauke" ///
	401 "Mbala" 402 "Mungwi" ///
	501 "Mufumbwe" 502 "Solwezi" ///
	601 "Choma" 602 "Namwala"

label values district districts

save "daily0rainXhhid", replace














