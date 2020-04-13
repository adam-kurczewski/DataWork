/// This file append HICPS Follow-up ///
clear all
set more off

cd "C:\Users\kurczew2\Box\Research\HICPS\Data"

use "2016 HICPS.dta", clear

*gen year = 2016
*tostring status phone_number, replace
append using "2017 HICPS Followup.dta", force

replace year = 2017 if year == .


append using "2018 HICPS Follow-up.dta", force

replace year = 2018 if year == .

drop if HHID == .

label variable	income_piecework 	"Income from piece work"
label variable	income_salary 	"Income from Salary/Wage"
label variable	income_smallbusiness 	"Income from Small business"
label variable	income_charcoal 	"Income from charcoal selling "
label variable	income_gardening 	"Income from gardening or horticulture"
label variable	income_forestproduct 	"Income from sale of forest products"
label variable	income_nonmaizecrop	"Income from sale of non-maize crops"
label variable	income_livestock 	"Income from livestock sales"
label variable	income_remittance 	"Income from non-migration remittances"
label variable	income_other 	"Income from other sources"

sum plot_1 plot_2 plot_3 plot_4 plot_5
sum qseed_1 qseed_2 qseed_3 qseed_4 qseed_5 qharv_1 qharv_2 qharv_3 qharv_4 qharv_5

append using "2019 HICPS Follow-up.dta", force

replace year = 2019 if year == .

drop if HHID == .

duplicates report HHID
duplicates tag HHID, gen(duplicates)
tab duplicates
drop if duplicates == 0 | duplicates == 1 | duplicates == 2 | duplicates == 4 

duplicates tag HHID year, gen(dup1)
tab dup1
drop if dup1 == 3
drop dup1 duplicates

sort HHID year

xtset HHID year

save HICPS_all.dta, replace

