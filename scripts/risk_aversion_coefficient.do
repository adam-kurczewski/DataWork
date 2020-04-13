/// Risk Coefficient Predicted Value ///

clear all
set more off
cd "C:\Users\kurczew2\Box\Research\HICPS\Data"


*** do I need to run/use the 2019 cleaning file prior to running this?
*** may create problems in exploration/playground if so...

use HICPS_all, clear

bysort HHID: replace province = province[_n-1] if year > 2016


*identify observation unit and time
xtset HHID year

* camp cleaning 

sort year
by year: count if year != .

*drop if HHID == .
*drop if survey_date == .

duplicates report HHID
duplicates tag HHID, gen(duplicate)
tab duplicate, nolabel
*drop if duplicate == 0
*drop if _merge == 2
*duplicates report HHID

// create time variable from string
gen double datetime = clock(enddate, "MD20Yhm")
format datetime %tc
*gen year = yofd(dofc(datetime))

sort HHID year
xtset HHID year

order HHID year, before(startdate)

*shp2dta using gadm36_ZMB_2.shp, database(zambia.dta) ///
*coordinates(zambia_coord) gencentroids(c_) genid(zambia_id) replace

by HHID: replace district = district[_n-1] if district == .

replace province = 6 if province == .
gen NAME_2 = "Mkushi" if district == 101
replace NAME_2 = "Mumbwa" if district == 102
replace NAME_2 = "MPongwe" if district == 201
replace NAME_2 = "Masaiti" if district == 202
replace NAME_2 = "Lundazi" if district == 301
replace NAME_2 = "Petauke" if district == 302
replace NAME_2 = "Mbala" if district == 401
replace NAME_2 = "Mungwi" if district == 402
replace NAME_2 = "Mufumbwe" if district == 501
replace NAME_2 = "Solwezi" if district == 502
replace NAME_2 = "Choma" if district == 601
replace NAME_2 = "Namwala" if district == 602

*Province dummies
tabulate province, g(province_)

*joinby NAME_2 using zambia.dta, unmatched(both) _merge(merge)
*joinby HHID using new_geocodes.dta, unmatched(both) _merge(merge1)
*joinby HHID using cost_index.dta, unmatched(master) _merge(merge2) 
*joinby NAME_2 using aezones_1.dta, unmatched(master) _merge(merge_az)

*collapse (mean) lat_corrected lon_corrected, by(province district camp village)


/*
drop if year == 2017
spmap using "zambia_coord.dta", id(HHID)                 /// 
        point(xcoord(lon_corrected)               /// 
        ycoord(lat_corrected)  fcolor(black)) /// 
        polygon(data("zambia_coord.dta"))
*/

replace qharvested = 0 if HHID != . & qharvested == .
replace qtop_1 = 4005 if qtop_1 == 400500
*replace extreme values on yield

*collapse (mean) yield, by(NAME_2)

*save observed_yield.dta, replace

*covert maize sales values and divide by quantity
/*
replace rct_sale_kwacha = "." if rct_sale_kwacha == "Not yet paid" 
destring rct_sale_kwacha, gen(sales)

sort year district
bysort year district: asgen maize_price = sales/rct_sale_kgs, weight(rct_sale_kgs) by(year district)
*/
replace plot_1 = "0.25" if plot_1 == "..25"
replace plot_1 = "0.25" if plot_1 == "0 .25"
destring plot_1, replace

sum plot_1 plot_2 plot_3 plot_4 plot_5 cultivown_land farmland title_land rentfrom_land rentto_land
replace qseed_1 = "80" if qseed_1 == "80kg"
replace qharv_1 = "17500" if qharv_1 == "17,500"
destring qseed_1 qharv_1, replace
replace qharv_4 = 0 if qharv_4 < 0

forvalues i = 1/5 {
	replace plot_`i' = 0 if plot_`i' == 99 | plot_`i' == 999 | plot_`i' < 0
	replace qharv_`i' = 0 if qharv_`i' == 99 | qharv_`i' == 999 | qharv_`i' < 0
	replace qseed_`i' = 0 if qseed_`i' == 99 | qseed_`i' == 999 | qseed_`i' < 0
	replace qbasal_`i' = 0 if qbasal_`i' == 99 | qbasal_`i' == 999 | qbasal_`i' < 0
	replace qtop_`i' = 0 if qtop_`i' == 99 | qtop_`i' == 999 | qtop_`i' < 0
	
	}
*correcting extreme values using total farmland/cultiveown_land
replace plot_1 = plot_1/10 if plot_1 >= 9
replace plot_2 = plot_2/100 if plot_2 >= 100
replace plot_2 = plot_2/10 if plot_2 >= 10
replace plot_3 = plot_3/100 if plot_3 >= 100
replace plot_3 = plot_3/10 if plot_3 >= 10
replace plot_4 = plot_4/10 if plot_4 >= 10
replace plot_5 = plot_5/10 if plot_5 >= 10

sum cultivown_land farmland title_land rentfrom_land rentto_land
replace farmland = farmland/100 if farmland >= 100 
replace cultivown_land = cultivown_land/100 if cultivown_land >= 100 
replace title_land = title_land/100 if title_land >= 100 


	
sum qseed_1 qseed_2 qseed_3 qseed_4 qseed_5 qharv_1 qharv_2 qharv_3 qharv_4 qharv_5
sum cultivown_land farmland title_land rentfrom_land rentto_land
sum recycl_1 recycl_2 recycl_3 recycl_4 recycl_5


gen plot = .

forvalues i = 1/5 {
	replace plot = `i' if plot_`i' != . & HHID != .
}

*analysis previous to reshape

foreach var in qharv_1 qharv_2 qharv_3 qharv_4 qharv_5 {
	sum `var', detail
	scalar `var'p99 = r(p99)
	replace `var' = `var'/10 if `var' >= scalar(`var'p99)
	}
/*
hist qharv_1 
hist qharv_2 
hist qharv_3 
hist qharv_4 
hist qharv_5 	
*/	

sum qbasal_1 qbasal_2 qbasal_3 qbasal_4 qbasal_5
sum qtop_1 qtop_2 qtop_3 qtop_4 qtop_5

foreach var in qbasal_1 qbasal_2 qtop_1 qtop_2 {
	sum `var', detail
	scalar `var'p99 = r(p99)
	replace `var' = `var'/10 if `var' >= scalar(`var'p99)
}

sum qseed_1 qseed_2 qseed_3 qseed_4 qseed_5

forvalues i = 1/5 {
	gen yield_`i' = qharv_`i'/plot_`i'
	replace yield_`i' = 0 if plot_`i' != . & qharv_`i' == .
	}

sum yield_1 yield_2 yield_3 yield_4 yield_5
sum qbasal_1 qbasal_2 qbasal_3 qbasal_4 qbasal_5
sum qtop_1 qtop_2 qtop_3 qtop_4 qtop_5
sum qseed_1 qseed_2 qseed_3 qseed_4 qseed_5
sum qharv_1 qharv_2 qharv_3 qharv_4 qharv_5

*replace village and camp names to merge the village survey
*camps
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
replace camp = "Kashitu" if camp == "Doesn't know" & village == "Kulaubone"
replace camp = "Kashitu" if camp == "Doesn't know" & village == " Kulaubone"
replace camp = "Mabanda" if camp == "Doesn't know" & village == "Sichilima"
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
replace camp = "Mawanda" if camp == "None" & village == "CHIMUKWAMBA"
replace camp = "Minga" if camp == "None" & village == "KUNDA"
replace camp = "Minga" if camp == "None" & village == "KALUMBWA"
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
replace camp = "Mabanda" if camp == "Xxx" & village == "Mukwakwa"
replace camp = "Mumbi B" if camp == "Xxx"
replace camp = "Mumbi B" if camp == "Xxx"
replace camp = "Mumbi B" if camp == "Xxxx"
replace camp = "Minga" if camp == "Ziyai"


*tab camp year: use it to check camp by year to make sure they are not messed up

gen camp1 = camp if year == 2016

sort HHID year

by HHID: replace camp1 = camp1[_n-1] if year > 2016

tab camp1 year

*joinby camp year using agrodealers_village.dta, unmatched(master) _merge(merge_village)
*joinby camp using village_survey_2016.dta, unmatched(master) _merge(merge_village)

/*
tab year
replace agrodealers = 0 if agrodealers == . 
*/


*Cleaning main variables 
*Income, HH size and HH head data, title land, total land cultivated, n of plots, transportation (vehicle)
*off-farm income, small businesses
*use of credit
*climate shocks
*village characteristics

replace NAME_2 = "Chinsali" if NAME_2 == "Mungwi"
gen district_lat = 0 
gen district_lon = 0
replace district_lat = 	-16.8066705	if NAME_2 == "Choma"
replace district_lat = 	-12.2901697	if NAME_2 == "Lundazi"
replace district_lat = 	-13.5123502	if NAME_2 == "MPongwe"
replace district_lat = 	-13.2599031	if NAME_2 == "Masaiti"
replace district_lat = 	-8.8481575	if NAME_2 == "Mbala"
replace district_lat = 	-13.6222944	if NAME_2 == "Mkushi"
replace district_lat = 	-13.2628297	if NAME_2 == "Mufumbwe"
replace district_lat = 	-14.984502	if NAME_2 == "Mumbwa"
replace district_lat = 	-10.1784068	if NAME_2 == "Mungwi"
replace district_lat = 	-15.7538028	if NAME_2 == "Namwala"
replace district_lat = 	-14.248657	if NAME_2 == "Petauke"
replace district_lat = 	-12.1690303	if NAME_2 == "Solwezi"
replace district_lon = 	26.939806	if NAME_2 == "Choma"
replace district_lon = 	33.1618021	if NAME_2 == "Lundazi"
replace district_lon = 	28.14767	if NAME_2 == "MPongwe"
replace district_lon = 	28.3850676	if NAME_2 == "Masaiti"
replace district_lon = 	31.3228789	if NAME_2 == "Mbala"
replace district_lon = 	29.3561759	if NAME_2 == "Mkushi"
replace district_lon = 	25.5516459	if NAME_2 == "Mufumbwe"
replace district_lon = 	27.0439194	if NAME_2 == "Mumbwa"
replace district_lon = 	31.3394879	if NAME_2 == "Mungwi"
replace district_lon = 	26.4252089	if NAME_2 == "Namwala"
replace district_lon = 	31.2953701	if NAME_2 == "Petauke"
replace district_lon = 	26.3574447	if NAME_2 == "Solwezi"
replace district_lat = 	-10.5464089	if NAME_2 == "Chinsali"
replace district_lon = 	31.9877645	if NAME_2 == "Chinsali"

*replace extra camps
replace camp1 = "Kiasa" if camp1 == "Chisefu" & NAME_2 == "Solwezi"
replace camp1 = "Chisefu" if camp1 == "Chasefu" & NAME_2 == "Lundazi"
replace camp1 = "Kiasa" if (camp1 == "Kakaindu" | camp1 == "Kalengwa" | camp1 == "Kikonge" | camp1 == "Munyambala" | camp1 == "Kaindu" ) & NAME_2 == "Solwezi"
replace camp1 = "Moobola" if camp1 == "Moboola"
replace camp1 = "Kiasa" if camp1 == "Kisasa"
replace camp1 = "Manyama" if camp1 == "Kaindu" & NAME_2 == "Solwezi"
replace camp1 = "Kaka" if camp1 == "Kakaindu" & NAME_2 == "Mbala"
replace camp1 = "Kalwanyembe" if camp1 == "Kaindu" & NAME_2 == "Mumbwa"
replace camp1 = "Popota" if camp1 == "Gamela"
replace camp1 = "Mukumpu" if camp1 == "Munkumpu"
replace camp1 = "Nkula" if camp1 == "Mulakupikwa"
replace camp1 = "Nkula" if camp1 == "Mucheleka"
replace camp1 = "Nkula" if camp1 == "Nalubanda" & NAME_2 == "Chinsali"
replace camp1 = "Nondo" if camp1 == "Senga"
replace camp1 = "Mabanda" if camp1 == "Mawanda"
replace camp1 = "Nyampande" if camp1 == "Kakwiya"
replace camp1 = "Minga"  if camp1 == "Nyampande"
replace camp1 = "Chikomeni"  if camp1 == "Mukaya"

replace camp1 = "Kalweo"  if camp1 == "Katuba"
replace camp1 = "Kalweo"  if camp1 == "Mipundu"
replace NAME_2 = "MPongwe" if camp1 == "Kalweo"

*HHID and lat and long corrections
*Chinsali
*replace new_latitude = -9.82527	if new_latitude == -8.82527 & HHID == 40213002
replace NAME_2 = "Mbala" if NAME_2 == "Chinsali" & HHID == 40213002
*Solwezi
replace new_latitude = -12.469963	if new_latitude == -13.469963  & HHID == 50211003
replace new_latitude = -12.055964	if new_latitude == -13.055964 & HHID == 50210005
*Mpongwe
replace new_latitude = -13.8293	if new_latitude == -13.5293 & HHID == 20106078 & new_longitude == 28.64627
replace new_latitude = -13.83015	if new_latitude == -13.23015 & HHID == 20106075 & new_longitude == 28.6692
*Lundazi
replace NAME_2 = "Petauke" if NAME_2 == "Lundazi" & HHID == 30107001
*Mkushi
replace NAME_2 = "Mumbwa" if NAME_2 == "Mkushi" & HHID == 10132001
*Namwala
replace new_latitude = -16.034851	if HHID == 60202008 & new_latitude != .
replace NAME_2 = "Choma" if HHID == 60215002 | HHID == 60215003 & new_latitude != .
replace NAME_2 = "Namwala" if camp1 == "Macha"

encode camp1, gen(camp2)


*change income label

*label variable income "aggregate income"

forvalues  i = 1/3 {
	replace scenario_`i' = 0 if scenario_`i' == .
	}

replace switch_bags = "3" if switch_bags == "3 on drought yield " 
replace switch_bags = "4" if switch_bags == "4bags" 
replace switch_bags = "5" if switch_bags == "5 during drought" 
replace switch_bags = "5" if switch_bags == "5bags" 
replace switch_bags = "7" if switch_bags == "7 during drought " 
replace switch_bags = "." if switch_bags == "999" 
replace switch_bags = "." if switch_bags == "Can only chose if the number of yields increased on drought yield " 
replace switch_bags = "." if switch_bags == "Cant say " 
replace switch_bags = "." if switch_bags == "Canât decide" 
replace switch_bags = "." if switch_bags == "Donât know" 
replace switch_bags = "." if switch_bags == "More bags no matter the rains " 
replace switch_bags = "." if switch_bags == "Nil" 	
replace switch_bags = "." if switch_bags == "Nil " 	
replace switch_bags = "." if switch_bags == "No idea " 	
replace switch_bags = "." if switch_bags == "No number" 	
replace switch_bags = "." if switch_bags == "Non" 	
replace switch_bags = "." if switch_bags == "Unless adding on drought yield "
replace switch_bags = "." if switch_bags == "."
destring switch_bags, replace

replace switch_bags = 140 if switch_bags == 0
replace switch_bags = switch_bags+8 if switch_bags <=7 & switch_bags != .

gen switch_yield = switch_bags*50 if switch_bags != .


foreach var in recycl_1 recycl_2 recycl_3 recycl_4 recycl_5 {
	replace `var' = 0 if `var' == .
	}
	
	
global incomeT income_piecework income_salary income_smallbusiness ///
income_charcoal income_gardening income_forestproduct income_livestock ///
income_remittance income_other income_nonmaizecrop income_cabbage income_carrots ///
income_cassava income_combeans income_cotton income_cowpeas income_groundnuts ///
income_irishpots income_leafygreens income_millet income_okra income_onions ///
income_orchard income_peppers income_pigeonpea income_popcorn income_pumpkin ///
income_rice income_sorghum income_soyabeans income_sunflower income_sweetpot ///
income_tobacco income_tomatoes income_othercrop2 income_none
	
foreach var in $incomeT  {
	replace `var' = 0 if `var' == .
	}
	
* income variable
gen income = (income_piecework +income_salary +income_smallbusiness ///
+income_charcoal +income_gardening +income_forestproduct +income_livestock ///
+income_remittance +income_other +income_nonmaizecrop +income_cabbage +income_carrots ///
 +income_cassava +income_combeans +income_cotton +income_cowpeas +income_groundnuts ///
 +income_irishpots +income_leafygreens +income_millet +income_okra +income_onions ///
 +income_orchard +income_peppers +income_pigeonpea +income_popcorn +income_pumpkin ///
 +income_rice +income_sorghum +income_soyabeans +income_sunflower +income_sweetpot ///
 +income_tobacco +income_tomatoes +income_othercrop2 +income_none)
	
	

* recylce variable
gen use_recycled = (recycl_1 + recycl_2 + recycl_3 + recycl_4 + recycl_5)/5 if plot == 5
replace use_recycled = (recycl_1 + recycl_2 + recycl_3 + recycl_4 + recycl_5)/4 if plot == 4
replace use_recycled = (recycl_1 + recycl_2 + recycl_3 + recycl_4 + recycl_5)/3 if plot == 3
replace use_recycled = (recycl_1 + recycl_2 + recycl_3 + recycl_4 + recycl_5)/2 if plot == 2
replace use_recycled = (recycl_1 + recycl_2 + recycl_3 + recycl_4 + recycl_5)/1 if plot == 1

* adding rainfall data for seasonal_rainfall

joinby HHID year using rainfall_HHID.dta, _merge(merge_rain) unmatched(master)


*diversification
sum cabbage carrots cassava combeans cotton cowpeas groundnuts ipotato greens   ///
millet okra onions orchard peppers pea rice sorghum soybean sunflower  ///
spotato tobacco tomatoes othercrop
replace combeans = 0 if combeans == .
replace onions = 0 if onions == .
replace cotton = 0 if cotton == .

*crop16_text crop17_text nonmaize_current_other
rename nonmaize_current crop19
rename nonmaize_current_other crop19_text

split crop16, parse(,) generate(crop16_) destring 
split crop17, parse(,) generate(crop17_) destring 
split crop19, parse(,) generate(crop19_) destring


foreach var in cabbage carrots cassava combeans cotton cowpeas groundnuts ipotato greens   ///
millet okra onions orchard peppers pea rice sorghum soybean sunflower  ///
spotato tobacco tomatoes othercrop {
	replace `var' = . if year != 2018
	}
	
sum cabbage carrots cassava combeans cotton cowpeas groundnuts ipotato greens   ///
millet okra onions orchard peppers pea rice sorghum soybean sunflower  ///
spotato tobacco tomatoes othercrop


rename cabbage crop18_1
rename carrots crop18_2
rename cassava crop18_3
rename combeans crop18_4
rename cotton crop18_5
rename cowpeas crop18_6
rename groundnuts crop18_7
rename ipotato crop18_8
rename greens crop18_9
rename millet crop18_10
rename okra crop18_11
rename onions crop18_12
rename orchard crop18_13
rename peppers crop18_14
rename pea crop18_15
rename rice crop18_16
rename sorghum crop18_17
rename soybean crop18_18
rename sunflower crop18_19
rename spotato crop18_20
rename tobacco crop18_21
rename tomatoes crop18_22
rename othercrop crop18_23

forvalues i = 1/10 {
	replace crop16_`i' = 0 if crop16_`i' == . & year == 2016
	replace crop16_`i' = 1 if crop16_`i' > 0 & year == 2016
	}

forvalues i = 1/8 {
	replace crop17_`i' = 0 if crop17_`i' == . & year == 2017
	replace crop17_`i' = 1 if crop17_`i' > 0 & year == 2017
	}	

forvalues i = 1/7 {
	replace crop19_`i' = 0 if crop19_`i' == . & year == 2019
	replace crop19_`i' = 1 if crop19_`i' > 0 & year == 2019
	}

gen n_crops = 0
replace n_crops = crop16_1 + crop16_2 + crop16_3 + crop16_4 + crop16_5 + crop16_6 + crop16_7 + crop16_8 + crop16_9 + crop16_10 if year == 2016
replace n_crops = crop17_1 + crop17_2 + crop17_3 + crop17_4 + crop17_5 + crop17_6 + crop17_7 + crop17_8 if year == 2017
replace n_crops = crop19_1 + crop19_2 + crop19_3 + crop19_4 + crop19_5 + crop19_6 + crop19_7  if year == 2019
replace n_crops = crop18_1 + crop18_2 + crop18_3 + crop18_4 + crop18_5 + crop18_6 + crop18_7 + crop18_8 + crop18_9 + crop18_10 + ///
crop18_11 + crop18_12 + crop18_13 + crop18_14 + crop18_15 + crop18_16 + crop18_17 + crop18_18 + crop18_19 + crop18_20 + ///
crop18_21 + crop18_22 + crop18_23 if year == 2018

gen total_crops = 0
replace total_crops = 22 if year == 2016
replace total_crops = 17 if year == 2017
replace total_crops = 22 if year == 2018
replace total_crops = 20 if year == 2019

gen hhi = ((n_crops/total_crops)*100)^2



sum n_crops hhi

replace use_recycled = 0 if plot == .

*** RISK ***

*gen values for variety A in all scenarios	
gen avg_a1 = 6*50
gen low_a1 = 5*50
gen high_a1 = 7*50
*gen values for variety B in all scenarios
gen avg_b1 = 4*50
gen low_b1 = 1*50
gen high_b1 = 14*50
gen avg_b2 = 5*50
gen low_b2 = 1*50
gen high_b2 = 14*50
gen avg_b3 = 6*50
gen low_b3 = 1*50
gen high_b3 = 14*50
gen avg_b4 = 8*50
gen low_b4 = 1*50
gen high_b4 = 14*50

*gen the coefficient for each farmer
gen avg_s = 0 if year == 2019
*replace avg_s = (avg_a1*0.5 + low_a1*0.1 + high_a1*0.1) if scenario_1 == 0 & scenario_2 == 0 & scenario_3 == 0 & scenario_4 == 0 
replace avg_s = (avg_b1*0.5 + low_b1*0.1 + high_b1*0.1) if scenario_1 == 1 & scenario_2 == 0 & scenario_3 == 0 & scenario_4 == 0 & year == 2019
replace avg_s = (avg_b2*0.5 + low_b2*0.1 + high_b2*0.1) if scenario_1 == 0 & scenario_2 == 1 & scenario_3 == 1 & scenario_4 == 1 & year == 2019
replace avg_s = (avg_b3*0.5 + low_b3*0.1 + high_b3*0.1) if scenario_1 == 0 & scenario_2 == 0 & scenario_3 == 1 & scenario_4 == 1 & year == 2019
replace avg_s = (avg_b4*0.5 + low_b4*0.1 + high_b4*0.1) if scenario_1 == 0 & scenario_2 == 0 & scenario_3 == 0 & scenario_4 == 1 & year == 2019
replace avg_s = switch_yield if scenario_1 == 0 & scenario_2 == 0 & scenario_3 == 0 & scenario_4 == 0  & year == 2019

*this follow Binswanger
gen s_n = avg_s/536
*transform into the hyperbolic sine (approx log)
ssc install ihstrans
ihstrans s_n



* regression

* original - reg ihs_s_n hh_head_age hh_head_edu hh_head_sex hh_num income farmland use_recycled hhi seasonal_rainfall ///
* d2 d3 d4 d5 d6 d7 d8 d9 d10 d11 d12, vce(cluster camp2)

* district dummies
tabulate district, generate(dum)

foreach var in hh_head_age hh_head_edu hh_head_sex hh_num district {
	bysort HHID: replace `var' = `var'[_n-1] if year >= 2017
	}

foreach var in ihs_s_n hh_head_age hh_head_edu hh_head_sex hh_num income farmland hhi use_recycled seasonal_rainfall ///
dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10 dum11 dum12 {
	replace `var' = 0 if `var' == .
	}
	
reg ihs_s_n hh_head_age hh_head_edu hh_head_sex hh_num income farmland hhi use_recycled seasonal_rainfall ///
dum2 dum3 dum4 dum5 dum6 dum7 dum8 dum9 dum10 dum11 dum12, vce(cluster camp2)

*predict coefficient
*** THIS PREDICTED VALUE IS INDIVIDUAL LEVEL RISK AVERSION!!! ***
predict s_n_hat, xb

*tables
tabstat s_n_hat if s_n != ., by(NAME_2) col(stat) stat(n mean sd)
tabstat s_n if s_n != ., by(NAME_2) col(stat) stat(n mean sd)

*predicted risk aversion coefficient by camp
bysort camp2: egen mean_s_n_hat = mean(s_n_hat)
*unadjusted risk aversion coefficient by camp
bysort camp2: egen mean_s_n = mean(s_n)

save HICPS_RISK.dta, replace 

*outreg2 using risk_aversion, word excel replace

***************************************************************************************************************************************************************************************

** Mutation and transformation for analysis

***************************************************************************************************************************************************************************************









