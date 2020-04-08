/// This file is for analysis ///
clear all
set more off

cd "C:\Users\nicol\Desktop\UIUC\Baylis\Zambia new\Gowthami"

use HICPS_all.dta, clear

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
*replace plot_1 = "0.25" if plot_1 == "..25"
*replace plot_1 = "0.25" if plot_1 == "0 .25"
destring plot_1, replace

sum plot_1 plot_2 plot_3 plot_4 plot_5 cultivown_land farmland title_land rentfrom_land rentto_land

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

*replace qseed_1 = "80" if qseed_1 == "80kg"
*replace qharv_1 = "17500" if qharv_1 == "17,500"
destring qseed_1 qharv_1, replace
replace qharv_4 = 0 if qharv_4 < 0
	
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

*save hicps_part1.dta, replace

exit
