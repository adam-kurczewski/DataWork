


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
