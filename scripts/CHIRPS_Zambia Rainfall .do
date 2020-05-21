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

replace camp = "Matushi" if camp == "1"
replace camp = "Batoke" if camp == "Ba"
replace camp = "Batoke" if camp == "Batoka"
replace camp = "Batoke" if camp == "Batoka "
replace camp = "Batoke" if camp == "batoka"
replace camp = "Batoke" if camp == " batoka"
replace camp = "Batoke" if camp == " Batoka"
replace camp = "Batoke" if camp == "Batoko"
replace camp = "Mwase" if camp == "Chafwamba"
replace camp = "Chikanda" if camp == "Chakanda"
replace camp = "Chikanda" if camp == " Chikanda"
replace camp = "Chikanda" if camp == "Chikanda "
replace camp = "Chikanda" if camp == " Chikanda "
replace camp = "Chikanda" if camp == "chikanda"
replace camp = "Chasefu" if camp == "Chasavu"
replace camp = "Chasefu" if camp == "CHASEFU"
replace camp = "Chasefu" if camp == "Chasevu"
replace camp = "Chasefu" if camp == "Chasefu "
replace camp = "Chikanda" if camp == "Chikanda"
replace camp = "Chikomeni" if camp == "CHIKOMENE"
replace camp = "Chikomeni" if camp == "Chikomene mukaya"
replace camp = "Chikomeni" if camp == "Chikomeni "
replace camp = "Chikomeni" if camp == "Chikomene"
replace camp = "Chikomeni" if camp == "Chikomeni mukaya"
replace camp = "Chikomeni" if camp == "Chikomeni Mukaya"
replace camp = "Chikomeni" if camp == "Chikumeni"
replace camp = "Mulakupikwa" if camp == "Chikwemba"
replace camp = "Chisefu" if camp == "Chisa "
replace camp = "Chisefu" if camp == "Chisa"
replace camp = "Chisefu" if camp == "Chisefu"
replace camp = "Chisefu" if camp == "Chisefu "
replace camp = "Chisefu" if camp == "Chisefu Magodi"
replace camp = "Chisefu" if camp == "Chisefu Magodi "
replace camp = "Chisefu" if camp == "Chisefu Magondi"
replace camp = "Chitongo" if camp == "Chitongo"
replace camp = "Chitongo" if camp == "chitongo"
replace camp = "Chitongo" if camp == "  Chitongo"
replace camp = "Chitongo" if camp == "Chitongo "
replace camp = "Chitongo" if camp == " Chitongo "
replace camp = "Kashitu" if camp == "Doesn't know" 
replace camp = "Kashitu" if camp == "Doesn't know" 
replace camp = "Mabanda" if camp == "Doesn't know"
replace camp = "Ibenga" if camp == "Fulabunga"
replace camp = "Gamela" if camp == "Gamela"
replace camp = "Gamela" if camp == "Gamela "
replace camp = "Gamela" if camp == "GAMELA"
replace camp = "Ibenga" if camp == "Ibenga"
replace camp = "Ibenga" if camp == "ibenga"
replace camp = "Ibenga" if camp == "Ibenga "
replace camp = "Ngabo" if camp == "Ingonwe"
replace camp = "Kaindu" if camp == "Kaindu"
replace camp = "Kaindu" if camp == "Kaindu "
replace camp = "Kaindu" if camp == "Kaingu"
replace camp = "Kakaindu" if camp == "Kaka"
replace camp = "Kakaindu" if camp == "Kaka "
replace camp = "Kakaindu" if camp == "KAKA"
replace camp = "Kakaindu" if camp == "Kakaindu"
replace camp = "Kakaindu" if camp == "Kaka"
replace camp = "Kakwiya" if camp == "Kakweya"
replace camp = "Kakwiya" if camp == "Kakwiya"
replace camp = "Kakwiya" if camp == "Kakwiya "
replace camp = "Kalengwa" if camp == "Kalengwa"
replace camp = "Kalengwa" if camp == "kalengwa"
replace camp = "Kalengwa" if camp == "Kalengwa "
replace camp = "Kalengwa" if camp == " Kalengwa"
replace camp = "Kalengwa" if camp == "Kalengwe"
replace camp = "Kalombe" if camp == "Kalombe"
replace camp = "Kalombe" if camp == "Kalombe "
replace camp = "Kalombe" if camp == "KALOMBE"
replace camp = "Kawimbe" if camp == "KAWIMBE"
replace camp = "Kalwanyembe" if camp == "Kalwanyambe"
replace camp = "Kalwanyembe" if camp == "kalwanyembe"
replace camp = "Kalwanyembe" if camp == "Kalwanyemba"
replace camp = "Kalwanyembe" if camp == "Kalwanyembe"
replace camp = "Kalwanyembe" if camp == "Kalwanyembe "
replace camp = "Kalwanyembe" if camp == "kalwanyembo"
replace camp = "Kalwanyembe" if camp == "Kalwe"
replace camp = "Kalwanyembe" if camp == "Kalwenyembe"
replace camp = "Kalweo" if camp == "Kalweo"
replace camp = "Kalweo" if camp == "kalweo"
replace camp = "Kalweo" if camp == "Kalweo "
replace camp = "Kalweo" if camp == "Kalwewo"
replace camp = "Kamzoole" if camp == "Kamuzoole "
replace camp = "Kamzoole" if camp == "Kamuzoole"
replace camp = "Kamzoole" if camp == "Kamuzoowele"
replace camp = "Kamzoole" if camp == "Kamuzoowole "
replace camp = "Kamzoole" if camp == "Kamuzoowole"
replace camp = "Kamzoole" if camp == "Kamzoole "
replace camp = "St Anthony" if camp == "Kapopo"
replace camp = "Nyampande" if camp == "Kasanila camp"
replace camp = "St Anthony" if camp == "Kashiba"
replace camp = "Kashitu" if camp == "Kashitu"
replace camp = "Kashitu" if camp == "kashitu"
replace camp = "Kashitu" if camp == "Kashitu "
replace camp = "Kashitu" if camp == "Kashutu"
replace camp = "Chisefu" if camp == "Kasisi"
replace camp = "Masansa" if camp == "Katema Myunga"
replace camp = "Katuba" if camp == "Katuba"
replace camp = "Katuba" if camp == "katuba"
replace camp = "Katuba" if camp == "Katuba "
replace camp = "Kawimbe" if camp == "Kawimbe "
replace camp = "Nkhanga" if camp == "KHANGA"
replace camp = "Nkhanga" if camp == "Khanga"
replace camp = "Kikonge" if camp == "Kikonde"
replace camp = "Kikonge" if camp == "kikonge"
replace camp = "Kikonge" if camp == "Kikonde "
replace camp = "Kikonge" if camp == "Kikonge "
replace camp = "Chisefu" if camp == "Kisasa"
replace camp = "Chisefu" if camp == "kisasa"
replace camp = "Kashitu" if camp == "Kishitu"
replace camp = "Lwamala" if camp == "Luamala"
replace camp = "Lwamala" if camp == "lwamala"
replace camp = "Lwamala" if camp == "Luamala "
replace camp = "Lwamala" if camp == "Lumwana"
replace camp = "Lwamala" if camp == "Luwamala"
replace camp = "Lwamala" if camp == "Lwamala "
replace camp = "Mubanga" if camp == "M"
replace camp = "Maala" if camp == "Maala"
replace camp = "Maala" if camp == "maala"
replace camp = "Maala" if camp == "Maala "
replace camp = "Maala" if camp == " Maala"
replace camp = "Mabanda" if camp == "Mabanda "
replace camp = "Mabanda" if camp == "MAbanda"
replace camp = "Mabanda" if camp == " Mabanda"
replace camp = "Macha" if camp == "Macha"
replace camp = "Macha" if camp == "macha"
replace camp = "Macha" if camp == "Macha "
replace camp = "Macha" if camp == " Macha"
replace camp = "Chisefu" if camp == "Magodi"
replace camp = "Chisefu" if camp == "Magondi"
replace camp = "Chisefu" if camp == "Magondi "
replace camp = "Chisefu" if camp == "Magondi Chisefu"
replace camp = "Masansa" if camp == "Mansansa"
replace camp = "Masansa" if camp == "Mansansa "
replace camp = "Masansa" if camp == "MASANSA"
replace camp = "Masansa" if camp == "Mansasa"
replace camp = "Masansa" if camp == "Masasa "
replace camp = "Masansa" if camp == "Masansa "
replace camp = "Manyama" if camp == "Manyama"
replace camp = "Manyama" if camp == "manyama"
replace camp = "Manyama" if camp == "Manyama "
replace camp = "Manyama" if camp == "  Manyama "
replace camp = "Katuba" if camp == "Masangano"
replace camp = "Masansa" if camp == "Masansa"
replace camp = "Masansa" if camp == "Masasa"
replace camp = "Masuku" if camp == "Masku"
replace camp = "Masuku" if camp == "Masuka"
replace camp = "Masuku" if camp == " Masuku"
replace camp = "Masuku" if camp == "Masuku "
replace camp = "Masuku" if camp == " Masuku "
replace camp = "Masuku" if camp == "MASUKU"
replace camp = "Mipundu" if camp == "Matipa"
replace camp = "Matushi" if camp == "Matushi "
replace camp = "Matushi" if camp == " Matushi "
replace camp = "Matushi" if camp == " Matushi"
replace camp = "Matushi" if camp == "matushi"
replace camp = "Kakwiya" if camp == "Mawanda "
replace camp = "Kakwiya" if camp == "Mawanda"
replace camp = "Kaindu" if camp == "Kaindu/manyama"
replace camp = "Kaindu" if camp == "Mayoyo"
replace camp = "Mbabala" if camp == "Mbabala "
replace camp = "Mbabala" if camp == "mbabala"
replace camp = "Mbabala" if camp == "MBABALA"
replace camp = "Mabanda" if camp == "Mbanda"
replace camp = "Mboole" if camp == "Mboole "
replace camp = "Mboole" if camp == "MBOOLE"
replace camp = "Ibenga" if camp == "Milofi"
replace camp = "Ibenga" if camp == "Milofyi"
replace camp = "Mipundu" if camp == "mimpundu"
replace camp = "Minga" if camp == "MINGA"
replace camp = "Minga" if camp == "Minga Stop"
replace camp = "Minga" if camp == "Minga stop"
replace camp = "Minga" if camp == "Minga "
replace camp = "Mipundu" if camp == "Mipundu "
replace camp = "Mipundu" if camp == "mipundu"
replace camp = "Mipundu" if camp == "Mimpundu"
replace camp = "Mishikishi" if camp == "Mishikishi "
replace camp = "Mishikishi" if camp == "Mishikiti"
replace camp = "Mishikishi" if camp == "Mishkishi"
replace camp = "Mishikishi" if camp == "mishikishi"
replace camp = "Myooye" if camp == "Miyooye"
replace camp = "Nkumbi" if camp == "MKUMBI"
replace camp = "Masansa" if camp == "Mkushi"
replace camp = "Moboola" if camp == "MOOBOLA"
replace camp = "Moboola" if camp == "Moobola "
replace camp = "Moboola" if camp == "moobola"
replace camp = "Moboola" if camp == "moboola"
replace camp = "Moboola" if camp == "Moboola "
replace camp = "Katuba" if camp == "Mpongwe"
replace camp = "Mubanga" if camp == " Mubanga"
replace camp = "Mubanga" if camp == "Mubanga "
replace camp = "Mubanga" if camp == "MUBANGA"
replace camp = "Mucheleka" if camp == "Mucheleka"
replace camp = "Mundu Nkweto" if camp == "Mudugweto"
replace camp = "Mukaya" if camp == "Mukaya"
replace camp = "Mukaya" if camp == "Mukaya "
replace camp = "Mukaya" if camp == "  Mukaya "
replace camp = "Mulakupikwa" if camp == "Mukulapikwa"
replace camp = "Mukumpu" if camp == "Mukumbu"
replace camp = "Mukumpu" if camp == "Mukumbu b"
replace camp = "Mukumpu" if camp == "Mukumpu "
replace camp = "Mulakupikwa" if camp == "Mulakupekwa"
replace camp = "Mulakupikwa" if camp == "Mulakupekwa "
replace camp = "Mulakupikwa" if camp == "Mulakupika"
replace camp = "Mulakupikwa" if camp == "Mulakupikwa "
replace camp = "Mulakupikwa" if camp == "MULAKUPIKWA"
replace camp = "Mubanga" if camp == " Mulilansolo"
replace camp = "Mubanga" if camp == "Mulilansolo "
replace camp = "Ibenga" if camp == "Mulilatambo"
replace camp = "Ibenga" if camp == "Mulinatambo"
replace camp = "Mumbi B" if camp == "Mumbai B"
replace camp = "Mumbi B" if camp == "Mumbi"
replace camp = "Mumbi B" if camp == "Mumbi "
replace camp = "Mumbi B" if camp == "Mumbi A"
replace camp = "Mumbi B" if camp == "MUMBI B"
replace camp = "Mumbi B" if camp == "  Mumbi B"
replace camp = "Mumena" if camp == "Mumena "
replace camp = "Mumena" if camp == "mumena"
replace camp = "Mumena" if camp == " Mumena "
replace camp = "Mundu Nkweto" if camp == "Munda Nkweto"
replace camp = "Mundu Nkweto" if camp == "Mundo kwendo"
replace camp = "Mundu Nkweto" if camp == "MUNDU NKWETO"
replace camp = "Mundu Nkweto" if camp == "Mundo Kwendo"
replace camp = "Mundu Nkweto" if camp == "Mundu Nkweto "
replace camp = "Mundu Nkweto" if camp == "Mundu nkweto"
replace camp = "Mundu Nkweto" if HHID == 40231012
replace camp = "Mundu Nkweto" if HHID == 40231001
replace camp = "Mundu Nkweto" if camp == "Mundo Nkwendo"
replace camp = "Mundu Nkweto" if camp == "Mundo Nkweto"
replace camp = "Mundu Nkweto" if camp == "Mundu"
replace camp = "Mundu Nkweto" if camp == "Mundu "
replace camp = "Mundu Nkweto" if camp == "Mundu Nkweto"
replace camp = "Mundu Nkweto" if camp == "Mundu NKWETO "
replace camp = "Mundu Nkweto" if camp == "Mundugweto"
replace camp = "Mundu Nkweto" if camp == "Mundungweto"
replace camp = "Mundu Nkweto" if camp == "Mundungwetu"
replace camp = "Mukumpu" if camp == "Munkumpu "
replace camp = "Mukumpu" if camp == " Munkumpu "
replace camp = "Mucheleka" if camp == "Munwakubili"
replace camp = "Munyambala" if camp == "Munyama"
replace camp = "Munyambala" if camp == "Munyambala "
replace camp = "Munyambala" if camp == "munyambala"
replace camp = "Munyambala" if camp == "Munyambara"
replace camp = "Munyambala" if camp == "Munyambara "
replace camp = "Mishikishi" if camp == "Mushikili"
replace camp = "Kalombe" if camp == "Musofu"
replace camp = "Kalombe" if camp == "Musofu "
replace camp = "Matushi" if camp == "Mutushi"
replace camp = "Munyambala" if camp == "Muyambaka"
replace camp = "Mwase" if camp == "Mwale II"
replace camp = "Mwase" if camp == "Mwase "
replace camp = "Mwase" if camp == "Mwase 2"
replace camp = "Mwase" if camp == "MWASE 2"
replace camp = "Mwase" if camp == "Mwase II"
replace camp = "Myooye" if camp == " Myooye"
replace camp = "Myooye" if camp == "myooye"
replace camp = "Myooye" if camp == "Myooye "
replace camp = "Myooye" if camp == " Myooye "
replace camp = "Myooye" if camp == "Myooyo"
replace camp = "Myooye" if camp == "Myoye"
replace camp = "Nalubanda" if camp == "Nalubana"
replace camp = "Nalubanda" if camp == "nalubanda"
replace camp = "Nalubanda" if camp == "Nalubanda "
replace camp = "Nalubanda" if camp == "  Nalubana"
replace camp = "Nalubanda" if camp == "NALUBANDA"
replace camp = "Nalubanda" if camp == "Nambuluma"
replace camp = "Ngabo" if camp == "Ngaabo"
replace camp = "Ngabo" if camp == "Ngabo "
replace camp = "Ngabo" if camp == "ngabo"
replace camp = "Ngabo" if camp == "NGABO"
replace camp = "Ngabo" if camp == " Ngaabo"
replace camp = "Ngabo" if camp == "Ngabo"
replace camp = "Ngabo" if camp == " Ngabo"
replace camp = "Ngabo" if camp == "  Ngabo"
replace camp = "Ngabo" if camp == "Ngambo"
replace camp = "Ngabo" if camp == "Ngobe"
replace camp = "St Anthony" if camp == "Nil"
replace camp = "Nkumbi" if camp == "Nkambi"
replace camp = "Nkhanga" if camp == "Nkhanga"
replace camp = "Nkhanga" if camp == "Nkhanga "
replace camp = "Nkhanga" if camp == "Nkhanka"
replace camp = "Nkolonga" if camp == " Nkolonga"
replace camp = "Nkolonga" if camp == "Nkolonga "
replace camp = "Nkolonga" if camp == "NKOLONGA"
replace camp = "Nkula" if camp == " Nkula"
replace camp = "Nkula" if camp == "Nkula "
replace camp = "Nkula" if camp == "NKULA"
replace camp = "Nkumbi" if camp == "Nkumbi "
replace camp = "Nondo" if camp == "Nonco"
replace camp = "Nondo" if camp == "Nondo "
replace camp = "Nondo" if camp == "NONDO"
replace camp = "Mawanda" if camp == "None" 
replace camp = "Minga" if camp == "None" 
replace camp = "Minga" if camp == "None" 
replace camp = "Munyambala" if camp == "Nyambala"
replace camp = "Nyampande" if camp == "Nyambose"
replace camp = "Nyampande" if camp == "Nyampande "
replace camp = "Mipundu" if camp == "Nyenyezi agricultural camp"
replace camp = "Popota" if camp == "POPOTA"
replace camp = "Popota" if camp == "Popota "
replace camp = "Popota" if camp == "popota"
replace camp = "Popota" if camp == "Popota A"
replace camp = "Popota" if camp == "Popota B"
replace camp = "Kashitu" if camp == "Rinato"
replace camp = "Mabanda" if camp == "Saili"
replace camp = "Katuba" if camp == "Saluki"
replace camp = "Masansa" if camp == "SANSA"
replace camp = "Senga" if camp == "SENGA"
replace camp = "Senga" if camp == "Senga "
replace camp = "Senga" if camp == "Senga Hill"
replace camp = "Senga" if camp == "Senga Hill "
replace camp = "Senga" if camp == "Senga hill"
replace camp = "Chikanda" if camp == "Shamakanda"
replace camp = "Kaindu" if camp == "Shintoko"
replace camp = "Sibanyati" if camp == "Sibanyati "
replace camp = "Sibanyati" if camp == "SIBANYATI"
replace camp = "Sibanyati" if camp == "Sibanyati A"
replace camp = "Sibanyati" if camp == "Sibanyati camp"
replace camp = "Sibanyati" if camp == "Sibanyi"
replace camp = "Sibanyati" if camp == "Sibanyiti"
replace camp = "Singani" if camp == "Sigani"
replace camp = "Singani" if camp == "Singani "
replace camp = "Sibanyati" if camp == "Simanyati"
replace camp = "Singani" if camp == "SINGANI"
replace camp = "Singani" if camp == "Singani posalunganda"
replace camp = "Singani" if camp == "Singani TBZ"
replace camp = "Mishikishi" if camp == "Sobe"
replace camp = "St Anthony" if camp == "St Anthony "
replace camp = "St Anthony" if camp == "St Antony"
replace camp = "St Anthony" if camp == "St Antony "
replace camp = "St Anthony" if camp == "St antony"
replace camp = "St Anthony" if camp == "St. Anthony "
replace camp = "St Anthony" if camp == "St antony"
replace camp = "St Anthony" if camp == "St. Anthony"
replace camp = "Mabanda" if camp == "Xxx"
replace camp = "Mumbi B" if camp == "Xxx"
replace camp = "Mumbi B" if camp == "Xxx"
replace camp = "Mumbi B" if camp == "Xxxx"
replace camp = "Minga" if camp == "Ziyai"
replace camp = "Chisefu" if camp == "Chasefu"
replace camp = "Moboola" if camp == "Moobola"

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
xtset camp_num agyr

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



