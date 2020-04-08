*********************************************************************
/* Section 3: Remittances and Migration */
*********************************************************************

replace q31=2 if q31==3
yesno q31
rename q31 mem_left
label variable mem_left "Has anyone left since June 2018"
label value mem_left yesnoL

rename q32 children_left
label variable num_children_left "Number of children under the age of 16 who left since June 2018"

rename q331_1 child1_relate 
rename q331_2 child2_relate
rename q331_3 child3_relate
rename q331_4 child4_relate
rename q331_5 child5_relate

rename q332_1 child1_gender
rename q332_2 child2_gender
rename q332_3 child3_gender
rename q332_4 child4_gender
rename q332_5 child5_gender

rename q333_1 child1_birthyear
rename q333_2 child2_birthyear
rename q333_3 child3_birthyear
rename q333_4 child4_birthyear
rename q333_5 child5_birthyear

rename q334_1 child1_reason
rename q334_2 child2_reason
rename q334_3 child3_reason
rename q334_4 child4_reason
rename q334_5 child5_reason

foreach i of num 1/5{
	label variable child`i'_relate "Relationship to household head"
	label variable child`i'_gender "Gender"
	label variable child`i'_birthyear "Birth year"
	label variable child`i'_reason "Reason for leaving household"
	}

rename q34 mem_remain
label variable mem_remain "How many individuals 16 years or older remain in the household"
replace mem_remain = 0 if mem_remain == 1
replace mem_remain = 1 if mem_remain == 2
replace mem_remain = 2 if mem_remain == 3
replace mem_remain = 3 if mem_remain == 4
replace mem_remain = 4 if mem_remain == 5
replace mem_remain = 5 if mem_remain == 6

* some variables that were "rostered" in 2018 are single varible column in 2019
* example: mig1_occ in 2019 is a single column were 2018 was a dummy variable for each occupation

* migrant 1

rename q41 mig1_name
rename q42 mig1_sex
rename q43 mig1_birthyear
rename q44 mig1_edu
rename q45 mig1_sends_remittances
rename q46_1 mig1_noncash
rename q46_2 mig1_money
rename q47 mig1_occ
rename q47_11_text mig1_occ_text
rename q48 mig1_explain
rename q48_8_text mig1_explain_text
rename q49 mig1_oa
rename q49_11_text mig1_oa_text
rename q410 mig1_hasphone
rename q411 mig1_phone
rename q412 mig1_reason 
rename q412_5_text mig1_reason_text
rename q413 mig1_destdistrict
rename q414 mig1_dest_urban_rural
rename q415 mig1_permanent
rename q416 mig1_year_left
rename q417 mig1_duration
rename q418 mig1_season 

label variable mig1_name "Migrant 1 name "
label variable mig1_sex "Sex of migrant 1 "
label variable mig1_birthyear "Birthyear of migrant 1 "
label variable mig1_edu "Educational attainment of migrant 1 "
label variable mig1_sends_remittances "Migrant 1 sends remittances "
label variable mig1_noncash "Non-cash remittances value migrant 1 "
label variable mig1_money "Remittances value migrant 1 "
label variable mig1_occ "Occupation before migrating mig1 "
label variable mig1_occ_text "Occupation before migrating mig1 - other text"
label variable mig1_explain "Reason for leaving the household "
label variable mig1_explain_text "Reason for leaving the household - other text "
label variable mig1_oa "Occupation while migrating mig1 "
label variable mig1_oa_text "Occupation while migrating mig1 - other text "
label variable mig1_hasphone "Migrant has a mobile phone "
label variable mig1_phone "Migrant 1 phone number "
label variable mig1_reason "Decision to leave migrant 1 "
label variable mig1_reason_text "Decision to leave migrant 1 - other text "
label variable mig1_destdistrict "Migrant 1 destination district"
label variable mig1_dest_urban_rural "Migrant 1 destination rural or urban"
label variable mig1_permanent	"Migrant 1 Temp or Perm left "
label variable mig1_year_left "Year migrant 1 left household"
label variable mig1_duration	"Legnth of migration of migrant 1 "
label variable mig1_season "Season migrant 1 was absent from the household"

* migrant 2

rename q51 mig2_name
rename q52 mig2_sex
rename q53 mig2_birthyear
rename q54 mig2_edu
rename q55 mig2_sends_remittances
rename q56_1 mig2_noncash
rename q56_2 mig2_money
rename q57 mig2_occ
rename q57_11_text mig2_occ_text
rename q58 mig2_explain
rename q58_8_text mig2_explain_text
rename q59 mig2_oa
rename q59_11_text mig2_oa_text
rename q510 mig2_hasphone
rename q511 mig2_phone
rename q512 mig2_reason 
rename q512_5_text mig2_reason_text
rename q513 mig2_destdistrict
rename q514 mig2_dest_urban_rural
rename q515 mig2_permanent
rename q516 mig2_year_left
rename q517 mig2_duration
rename q518 mig2_season 

label variable mig2_name "Migrant 2 name "
label variable mig2_sex "Sex of migrant 2 "
label variable mig2_birthyear "Birthyear of migrant 2 "
label variable mig2_edu "Educational attainment of migrant 2 "
label variable mig2_sends_remittances "Migrant 2 sends remittances "
label variable mig2_noncash "Non-cash remittances value migrant 2 "
label variable mig2_money "Remittances value migrant 2 "
label variable mig2_occ "Occupation before migrating mig2 "
label variable mig2_occ_text "Occupation before migrating mig2 - other text"
label variable mig2_explain "Reason for leaving the household "
label variable mig2_explain_text "Reason for leaving the household - other text "
label variable mig2_oa "Occupation while migrating mig2 "
label variable mig2_oa_text "Occupation while migrating mig2 - other text "
label variable mig2_hasphone "Migrant has a mobile phone "
label variable mig2_phone "Migrant 2 phone number "
label variable mig2_reason "Decision to leave migrant 2 "
label variable mig2_reason_text "Decision to leave migrant 2 - other text "
label variable mig2_destdistrict "Migrant 2 destination district"
label variable mig2_dest_urban_rural "Migrant 2 destination rural or urban"
label variable mig2_permanent	"Migrant 2 Temp or Perm left "
label variable mig2_year_left "Year migrant 2 left household"
label variable 	mig2_duration	"Legnth of migration of migrant 2 "
label variable mig2_season "Season migrant 2 was absent from the household"

* migrant 3

rename q61 mig3_name
rename q62 mig3_sex
rename q63 mig3_birthyear
rename q64 mig3_edu
rename q65 mig3_sends_remittances
rename q66_1 mig3_noncash
rename q66_2 mig3_money
rename q67 mig3_occ
rename q67_11_text mig3_occ_text
rename q68 mig3_explain
rename q68_8_text mig3_explain_text
rename q69 mig3_oa
rename q69_11_text mig3_oa_text
rename q610 mig3_hasphone
rename q611 mig3_phone
rename q612 mig3_reason 
rename q612_5_text mig3_reason_text
rename q613 mig3_destdistrict
rename q614 mig3_dest_urban_rural
rename q615 mig3_permanent
rename q616 mig3_year_left
rename q617 mig3_duration
rename q618 mig3_season 

label variable mig3_name "Migrant 3 name "
label variable mig3_sex "Sex of migrant 3 "
label variable mig3_birthyear "Birthyear of migrant 3 "
label variable mig3_edu "Educational attainment of migrant 3 "
label variable mig3_sends_remittances "Migrant 3 sends remittances "
label variable mig3_noncash "Non-cash remittances value migrant 3 "
label variable mig3_money "Remittances value migrant 3 "
label variable mig3_occ "Occupation before migrating mig3"
label variable mig3_occ_text "Occupation before migrating mig3 - other text"
label variable mig3_explain "Reason for leaving the household "
label variable mig3_explain_text "Reason for leaving the household - other text "
label variable mig3_oa "Occupation while migrating mig3 "
label variable mig3_oa_text "Occupation while migrating mig3 - other text "
label variable mig3_hasphone "Migrant has a mobile phone "
label variable mig3_phone "Migrant 3 phone number "
label variable mig3_reason "Decision to leave migrant 3 "
label variable mig3_reason_text "Decision to leave migrant 3 - other text "
label variable mig3_destdistrict "Migrant 3 destination district"
label variable mig3_dest_urban_rural "Migrant 3 destination rural or urban"
label variable mig3_permanent	"Migrant 3 Temp or Perm left "
label variable mig3_year_left "Year migrant 3 left household"
label variable mig3_duration	"Legnth of migration of migrant 3 "
label variable mig3_season "Season migrant 3 was absent from the household"

* migrant 4

rename q71 mig4_name
rename q72 mig4_sex
rename q73 mig4_birthyear
rename q74 mig4_edu
rename q75 mig4_sends_remittances
rename q76_1 mig4_noncash
rename q76_2 mig4_money
rename q77 mig4_occ
rename q77_11_text mig4_occ_text
rename q78 mig4_explain
rename q78_8_text mig4_explain_text
rename q79 mig4_oa
rename q79_11_text mig4_oa_text
rename q710 mig4_hasphone
rename q711 mig4_phone
rename q712 mig4_reason 
rename q712_5_text mig4_reason_text
rename q713 mig4_destdistrict
rename q714 mig4_dest_urban_rural
rename q715 mig4_permanent
rename q716 mig4_year_left
rename q717 mig4_duration
rename q718 mig4_season 

label variable mig4_name "Migrant 4 name "
label variable mig4_sex "Sex of migrant 4 "
label variable mig4_birthyear "Birthyear of migrant 4 "
label variable mig4_edu "Educational attainment of migrant 4 "
label variable mig4_sends_remittances "Migrant 4 sends remittances "
label variable mig4_noncash "Non-cash remittances value migrant 4 "
label variable mig4_money "Remittances value migrant 4 "
label variable mig4_occ "Occupation before migrating mig4"
label variable mig4_occ_text "Occupation before migrating mig4 - other text"
label variable mig4_explain "Reason for leaving the household "
label variable mig4_explain_text "Reason for leaving the household - other text "
label variable mig4_oa "Occupation while migrating mig4 "
label variable mig4_oa_text "Occupation while migrating mig4 - other text "
label variable mig4_hasphone "Migrant has a mobile phone "
label variable mig4_phone "Migrant 4 phone number "
label variable mig4_reason "Decision to leave migrant 4 "
label variable mig4_reason_text "Decision to leave migrant 4 - other text "
label variable mig4_destdistrict "Migrant 4 destination district"
label variable mig4_dest_urban_rural "Migrant 4 destination rural or urban"
label variable mig4_permanent	"Migrant 4 Temp or Perm left "
label variable mig4_year_left "Year migrant 4 left household"
label variable mig4_duration	"Legnth of migration of migrant 4 "
label variable mig4_season "Season migrant 4 was absent from the household"

* migrant 5

rename q81 mig5_name
rename q82 mig5_sex
rename q83 mig5_birthyear
rename q84 mig5_edu
rename q85 mig5_sends_remittances
rename q86_1 mig5_noncash
rename q86_2 mig5_money
rename q87 mig5_occ
rename q87_11_text mig5_occ_text
rename q88 mig5_explain
rename q88_8_text mig5_explain_text
rename q89 mig5_oa
rename q89_11_text mig5_oa_text
rename q810 mig5_hasphone
rename q811 mig5_phone
rename q812 mig5_reason 
rename q812_5_text mig5_reason_text
rename q813 mig5_destdistrict
rename q814 mig5_dest_urban_rural
rename q815 mig5_permanent
rename q816 mig5_year_left
rename q817 mig5_duration
rename q818 mig5_season 

label variable mig5_name "Migrant 5 name "
label variable mig5_sex "Sex of migrant 5 "
label variable mig5_birthyear "Birthyear of migrant 5 "
label variable mig5_edu "Educational attainment of migrant 5 "
label variable mig5_sends_remittances "Migrant 5 sends remittances "
label variable mig5_noncash "Non-cash remittances value migrant 5 "
label variable mig5_money "Remittances value migrant 5 "
label variable mig5_occ "Occupation before migrating mig5"
label variable mig5_occ_text "Occupation before migrating mig5 - other text"
label variable mig5_explain "Reason for leaving the household "
label variable mig5_explain_text "Reason for leaving the household - other text "
label variable mig5_oa "Occupation while migrating mig5 "
label variable mig5_oa_text "Occupation while migrating mig5 - other text "
label variable mig5_hasphone "Migrant has a mobile phone "
label variable mig5_phone "Migrant 5 phone number "
label variable mig5_reason "Decision to leave migrant 5 "
label variable mig5_reason_text "Decision to leave migrant 5 - other text "
label variable mig5_destdistrict "Migrant 5 destination district"
label variable mig5_dest_urban_rural "Migrant 5 destination rural or urban"
label variable mig5_permanent	"Migrant 5 Temp or Perm left "
label variable mig5_year_left "Year migrant 5 left household"
label variable mig5_duration	"Legnth of migration of migrant 5 "
label variable mig5_season "Season migrant 5 was absent from the household"

*further labelling and necessary recodings
label define gender 1 "Male" 0 "Female"

label define edu  1 "None" 2 "Some Primary" 3 "Completed Primary" 4 "Some Secondary" 5 "Completed Secondary" 6 "Some Post-Secondary" 7 "Completed Post-Secondary" 8 "Unknown" 	

label define perm 1 "Permanently" 2 "Temporarily" 3 "Respondent does not know" 

label define reason 1 "Household food insecurity" 2 "Work opp/ higher wages elsewhere" 3 "Lack of demand for labor within household's village" 6 "Crop failure/ bad harvest"  7 "Unsure" 4 "Other" 

label define location 2 "Urban" 3 "Rural" 4 "Unsure" 

foreach i of num 1/5{
	replace mig`i'_sex=0 if mig`i'_sex==2
	label value mig`i'_sex gender 
	label value  mig`i'_edu edu
	label value mig`i'_permanent perm
	}
	
	
*********************************************************************
/* Section 24: Weather and Climate Information*/
*********************************************************************

rename q242 forecast_use
label variable forecast_use "Did you use forecasts in the last growing season?"
label define forecast 1 "Yes" 2 "No" 3 "I dont know"
label value forecast_use forecast

rename q243 forecast_aware
label variable forecast_aware "Are you aware of weather forecasts?"
label value forecast_aware forecast 

* 244 equivalent of 174 in 2018 - but 2019 is not rostered

rename q244 no_weekly_reason
label variable no_weekly_reason "Why did you not use weather forecasts in previous growing season?"
label define no_reason 1 "I used my own observations" 2 "No one can predict the weather / god's plan" 3 "I followed the activities of other community members and leaders" ///
4 "I didnt make decisions based on this information" 5 "The information is not accurate" 6 "The information came too late" 7 "I never received the information" ///
8 "The information was not specific to my town/home/area" 9 "I did not understand the technical nature of the information" 10 "other" 11 "I dont know"

rename q245 primary_forecast_application
label variable primary_forecast_application "What are the main ways you used weather forecasts during the last growing season?"

rename q246 forecast_accuracy
label variable forecast_accuracy "How accurate do you think forecasts are?"
label define accuracy 1 "Always accurate" 2 "Mostly accurate" 3 "Sometimes accurate" 4 "Not very accurate" 5 "I do not know"
label value forecast_accuracy accuracy 

rename q247 forecast_10year_importance
label variable forecast_10year_importance "How important are weather forecasts compared to 10 years ago for farm decisions?"
label define importance 1 "More important" 2 "Less important" 3 "About the same" 4 "I dont know"
label value forecast_10year_importance importance

rename q248 forecast_importance_reason
label variable forecast_importance_reason "Why are forecasts more/less/same important than 10 years ago for farm decisions?"

rename q249 forecast_accuracy_climate
label variable forecast_accuracy_climate "How has climate change affected the accuracy of forecasts?"

rename q2410 forecast_accuracy_change
label variable forecast_accuracy_change "How is forecast accuracy changing compared to 10 years ago?"
label define accuracy_change 1 "They are becoming more accurate" 2 "They are becoming less accurate" 3 "There is no change in accuracy" 4 "I do not know"
label value forecast_accuracy_change accuracy_change

rename q2411 predict_rains
label variable predict_rains "How does your ability to predict the growing season rains compare to 10 years ago?"
label define predict 1 "More difficult now compared to 10 years ago" 2 "Easier now compared to 10 years ago" 3 "About the same" 4 "I do not know/cannot predit"
label value predict_rains predict

rename q2412 predict_rains_reason
rename q2412_5_text predict_rains_reason_text
label variable predict_rains_reason "Why is your ability to predict growing season rains different now?"

rename q2413 predict_season_rains
label variable predict_season_rains "Ability to predict rains during the entire growing season compared to 10 years ago"
label value predict_season_rains predict

rename q2414 predict_season_rains_reason
label variable predict_season_rains_reason "Why is your ability to predict rains during the entire growing season different?"

rename q2415 climate_changed
label variable climate_changed "Have you noticed the weather/climate changed over the past 10 years?"
label value climate_changed forecast

rename q2416 observed_climate_changes
label variable observed_climate_changes "What changes have you observed in the weather/climate - 10 years?"

rename q2417 climate_affects_forecast
label variable climate_affects_forecast "Do climate changes affect forecast accuracy?"
label value climate_affects_forecast forecast


* 2418 equivalent to 178 in 2018

rename	q2418_1	chall_prev_year1
rename	q2418_2	chall_prev_year2
rename	q2418_3	chall_prev_year3
rename	q2418_4	chall_prev_year4
rename	q2418_5	chall_prev_year5
rename	q2418_6	chall_prev_year6
rename	q2418_7	chall_prev_year7
rename	q2418_8	chall_prev_year8
rename	q2418_9	chall_prev_year9
rename	q2418_10	chall_prev_year10
rename	q2418_11	chall_prev_year11
rename	q2418_12	chall_prev_year12
rename	q2418_12_text	chall_prev_year12_text
rename	q2418_13	chall_prev_year13
rename	q2418_13_text	chall_prev_year13_text
rename	q2418_14	chall_prev_year14
rename	q2418_14_text	chall_prev_year14_text

label define challenge 1 "Biggest challenge" 2 "Second biggest" 3 "Third biggest" 

foreach i of num 1/14{
	label value chall_prev_year`i' challenge
	}

label var	chall_prev_year1	"The three biggest challenges from farming - Inadequate finances"
label var	chall_prev_year2	"The three biggest challenges from farming - Changes in sale prices for crops and livestock"
label var	chall_prev_year3	"The three biggest challenges from farming - Labor shortage"
label var	chall_prev_year4	"The three biggest challenges from farming - Pests and diseases"
label var	chall_prev_year5	"The three biggest challenges from farming - Unfavorable weather and climate conditions"
label var	chall_prev_year6	"The three biggest challenges from farming - Few extension visits"
label var	chall_prev_year7	"The three biggest challenges from farming - Land shortage"
label var	chall_prev_year8	"The three biggest challenges from farming - Poor seed performance"
label var	chall_prev_year9	"The three biggest challenges from farming - Access to seed varieties"
label var	chall_prev_year10	"The three biggest challenges from farming - Irrigation shortages"
label var	chall_prev_year11	"The three biggest challenges from farming - Soil fertility"
label var	chall_prev_year12	"The three biggest challenges from farming - Other_a"
label var	chall_prev_year12_text	"The three biggest challenges from farming - Text"
label var	chall_prev_year13	"The three biggest challenges from farming - Other_b"
label var	chall_prev_year13_text	"The three biggest challenges from farming - Text"
label var	chall_prev_year14	"The three biggest challenges from farming - Other_c"
label var	chall_prev_year14_text	"The three biggest challenges from farming - Text"

rename q2419 climate_change_knowledge
label variable climate_change_knowledge "How much do you know about climate change?"
label define knowledge 1 "A great deal" 2 "A fair amount" 3 "Only a little" 4 "Not at all" 5 "Does not know" 6 "Refuses to answer"
label value climate_change_knowledge knowledge

rename q2420 climate_change_worry
label variable climate_change_worry "How much do you worry about climate change?"
label value climate_change_worry knowledge

rename q2421 climate_change_threat
label variable climate_change_threat "How serious of a threat is climate change to your family?"
label define threat 1 "Very serious" 2 "Fairly serious" 3 "Not serious" 4 "Does not know" 5 "Refuse to answer"
label value climate_change_threat threat

rename q2422 climate_change_effects
label variable climate_change_effects "When do you think the effects of climate change will begin?"
label define effects 1 "Already begun" 2 "Within a few years" 3 "Within your lifetime" 4 "Not within your lifetime, but will happen in the future" ///
5 "Will never happen" 6 "Does not know" 7 "Refuse to answer"
label value climate_change_effects effects

rename q2423 climate_change_foodconsump
label variable climate_change_foodconsump "Will climate change threaten food consumption in your life?"
label define cc_food 1 "Yes" 2 "No" 3 "Does not know" 4 "Maybe"
label value climate_change_foodconsump cc_food 


*********************************************************************
/* Section 25: Charcoal and Firewood*/
*********************************************************************

rename q252 Charc
label var Charc "Did you produce charcoal for sale in July 2018"
label define Charc 1 "yes" 0 "no"
label value Charc Charc
 
rename q253 qcharc
rename q253_7_text qcharc_text
label var qcharc "What bag size of charcoal do you typically sell?"
label var qcharc_text "What bag size of charcoal do you typically sell? - other text"
label define qcharc 4 "5kg" 5 "25kg" 6 "50kg" 7 "Other"
label value qcharc qcharc

rename q254 price_charc
label var price_charc "How much do you charge for the bag of charcoal?"

*Q255 (Q197 - 2018)
rename q2551_1_1 srev_cha_june_18
lab var srev_cha_june_18 "Money made from charcoal sales in june 2018"
rename q2551_2_1 srev_cha_july_18
lab var srev_cha_july_18 "Money made from charcoal sales in july 2018"
rename q2551_3_1 srev_cha_aug_18
lab var srev_cha_aug_18 "Money made from charcoal sales in august 2018"
rename q2551_4_1 srev_cha_sept_18
lab var srev_cha_sept_18 "Money made from charcoal sales in september 2018"
rename q2551_5_1 srev_cha_oct_18
lab var srev_cha_oct_18 "Money made from charcoal sales in october 2018"
rename q2551_6_1 srev_cha_nov_18
lab var srev_cha_nov_18 "Money made from charcoal sales in november 2018"
rename q2551_7_1 srev_cha_dec_18
lab var srev_cha_dec_18 "Money made from charcoal sales in december 2018"
rename q2551_8_1 srev_cha_jan_19
lab var srev_cha_jan_19 "Money made from charcoal sales in january 2019"
rename q2551_9_1 srev_cha_feb_19
lab var srev_cha_feb_19 "Money made from charcoal sales in february 2019"
rename q2551_10_1 srev_cha_marc_19
lab var srev_cha_marc_19 "Money made from charcoal sales in march 2019"
rename q2551_11_1 srev_cha_april_19
lab var srev_cha_april_19 "Money made from charcoal sales in april 2019"
rename q2551_12_1 srev_cha_may_19
lab var srev_cha_may_19 "Money made from charcoal sales in may 2019"
rename q2551_13_1 srev_cha_june_19
lab var srev_cha_june_19 "Money made from charcoal sales in june 2019"
rename q2551_14_1 srev_cha_july_19
lab var srev_cha_july_19 "Money made from charcoal sales in july 2019"


 rename q2552_1_1 pqchar_june_18
lab var pqchar_june_18 "quantity(kgs) of charcoal produced in june 2018"
rename q2552_2_1 pqchar_july_18
lab var pqchar_july_18 "quantity (kgs) of charcoal produced in july 2018"
rename q2552_3_1 pqchar_aug_18
lab var pqchar_aug_18 "quantity (kgs) of charcoal produced in july 2018"
rename q2552_4_1 pqchar_sept_18
lab var pqchar_sept_18 "quantity (kgs) of charcoal produced in september 2018"
rename q2552_5_1 pqchar_oct_18
lab var pqchar_oct_18 "quantity (kgs) of charcoal produced in october 2018"
rename q2552_6_1 pqchar_nov_18
lab var pqchar_nov_18 "quantity (kgs) of charcoal produced in november 2018"
rename q2552_7_1 pqchar_dec_18
lab var pqchar_dec_18 "quantity (kgs) of charcoal produced in december 2018"
rename q2552_8_1 pqchar_jan_19
lab var pqchar_jan_19 "quantity (kgs) of charcoal produced in january 2019"
rename q2552_9_1 pqchar_feb_19
lab var pqchar_feb_19 "quantity (kgs) of charcoal produced in february 2019"
rename q2552_10_1 pqchar_mar_19
lab var pqchar_mar_19 "quantity (kgs) of charcoal produced in march 2019"
rename q2552_11_1 pqchar_april_19
lab var pqchar_april_19 "quantity (kgs) of charcoal produced in april 2019"
rename q2552_12_1 pqchar_may_19
lab var pqchar_may_19 "quantity (kgs) of charcoal produced in may 2019"
rename q2552_13_1 pqchar_june_19
lab var pqchar_june_19 "quantity (kgs) of charcoal produced in june 2019"
rename q2552_14_1 pqchar_july_19
lab var pqchar_july_19 "quantity (kgs) of charcoal produced in july 2019"


 rename q2553_1_1 sqchar_june_18
lab var sqchar_june_18 "quantity (kgs) of charcoal sold june 2018"
rename q2553_2_1 sqchar_july_18
lab var sqchar_july_18 "quantity (kgs) of charcoal sold july 2018"
rename q2553_3_1 sqchar_aug_18
lab var sqchar_aug_18 "quantity (kgs) of charcoal sold july 2018"
rename q2553_4_1 sqchar_sept_18
lab var sqchar_sept_18 "quantity (kgs) of charcoal sold september 2018"
rename q2553_5_1 sqchar_oct_18
lab var sqchar_oct_18 "quantity (kgs) of charcoal sold october 2018"
rename q2553_6_1 sqchar_nov_18
lab var sqchar_nov_18 "quantity (kgs) of charcoal sold november 2018"
rename q2553_7_1 sqchar_dec_18
lab var sqchar_dec_18 "quantity (kgs) of charcoal sold december 2018"
rename q2553_8_1 sqchar_jan_19
lab var sqchar_jan_19 "quantity (kgs) of charcoal sold january 2019"
rename q2553_9_1 sqchar_feb_19
lab var sqchar_feb_19 "quantity (kgs) of charcoal sold february 2019"
rename q2553_10_1 sqchar_mar_19
lab var sqchar_mar_19 "quantity (kgs) of charcoal sold march 2019"
rename q2553_11_1 sqchar_april_19
lab var sqchar_april_19 "quantity (kgs) of charcoal sold april 2019"
rename q2553_12_1 sqchar_may_19
lab var sqchar_may_19 "quantity (kgs) of charcoal sold may 2019"
rename q2553_13_1 sqchar_june_19
lab var sqchar_june_19 "quantity (kgs) of charcoal sold june 2019"
rename q2553_14_1 sqchar_july_19
lab var sqchar_july_19 "quantity (kgs) of charcoal sold july 2019"

rename q256 Charc_rev
label var Charc_rev "Total revene from charcoal sales"


rename q257_1 char_transport_cost
label var char_transport_cost " transport costs incured to the charcoal business in the past 12 months "
rename q257_2 char_hired_labor_cost
label var char_hired_labor_cost "hired labor costs incured to the charcoal business in the past 12 months "
rename q257_3 char_other_costs
label var char_other_costs "other costs incured to the charcoal business in the past 12 months "

rename q258 dist_cut_changed
label var dist_cut_changed "Do you travel further to cut trees for charcoal now compared to 5 years ago?"
recode dist_cut_changed 5=1
recode dist_cut_changed 6=0
yesno dist_cut_changed

rename q259 qchar_kiln
label var qchar_kiln "How much charcoal did you produce from the last kiln?"

rename q2510 fire_sale
label var fire_sale "Did collect the firewood for sale at any time since July 2018?"
recode fire_sale 4=0
yesno fire_sale 

rename q2511 firewood_bundle
label var firewood_bundle "What is the typical firewood bundle you sell?"
label define firesize 4 "Small" 5 "Medium" 6 "Large"

rename q2512 price_firewood
label var price_firewood "How much do you charge for the bundle of firewood?"

*Q2513 (1922 - 2018)
rename	q25131_1_1	Fwsales_June18
rename	q25131_2_1	Fwsales_July18
rename	q25131_3_1	Fwsales_Aug18
rename	q25131_4_1	Fwsales_Sept18
rename	q25131_5_1	Fwsales_Oct18
rename	q25131_6_1	Fwsales_Nov18
rename	q25131_7_1	Fwsales_Dec18
rename	q25131_8_1	Fwsales_Jan19
rename	q25131_9_1	Fwsales_Feb19
rename	q25131_10_1	Fwsales_Mar19
rename	q25131_11_1	Fwsales_Apr19
rename	q25131_12_1	Fwsales_May19
rename	q25131_13_1	Fwsales_June19
rename	q25131_14_1	Fwsales_July19
rename	q25132_1_1	Fwbundlescol_June18
rename	q25132_2_1	Fwbundlescol_July18
rename	q25132_3_1	Fwbundlescol_Aug18
rename	q25132_4_1	Fwbundlescol_Sept18
rename	q25132_5_1	Fwbundlescol_Oct18
rename	q25132_6_1	Fwbundlescol_Nov18
rename	q25132_7_1	Fwbundlescol_Dec18
rename	q25132_8_1	Fwbundlescol_Jan19
rename	q25132_9_1	Fwbundlescol_Feb19
rename	q25132_10_1	Fwbundlescol_Mar19
rename	q25132_11_1	Fwbundlescol_Apr19
rename	q25132_12_1	Fwbundlescol_May19
rename	q25132_13_1	Fwbundlescol_June19
rename	q25132_14_1	Fwbundlescol_July19
rename	q25133_1_1	Fwbundlessale_June18
rename	q25133_2_1	Fwbundlessale_July18
rename	q25133_3_1	Fwbundlessale_Aug18
rename	q25133_4_1	Fwbundlessale_Sept18
rename	q25133_5_1	Fwbundlessale_Oct18
rename	q25133_6_1	Fwbundlessale_Nov18
rename	q25133_7_1	Fwbundlessale_Dec18
rename	q25133_8_1	Fwbundlessale_Jan19
rename	q25133_9_1	Fwbundlessale_Feb19
rename	q25133_10_1	Fwbundlessale_Mar19
rename	q25133_11_1	Fwbundlessale_Apr19
rename	q25133_12_1	Fwbundlessale_May19
rename	q25133_13_1	Fwbundlessale_June19
rename	q25133_14_1	Fwbundlessale_July19

label var 	Fwsales_June18	"Money made from firewood sales duringJune18"
label var 	Fwsales_July18	"Money made from firewood sales during July18"
label var 	Fwsales_Aug18	"Money made from firewood sales during Aug18"
label var 	Fwsales_Sept18	"Money made from firewood sales during Sept18"
label var 	Fwsales_Oct18	"Money made from firewood sales during Oct18"
label var 	Fwsales_Nov18	"Money made from firewood sales during Nov18"
label var 	Fwsales_Dec18	"Money made from firewood sales during Dec18"
label var 	Fwsales_Jan19	"Money made from firewood sales during Jan19"
label var 	Fwsales_Feb19	"Money made from firewood sales during Feb19"
label var 	Fwsales_Mar19	"Money made from firewood sales during Mar19"
label var 	Fwsales_Apr19	"Money made from firewood sales during Apr19"
label var 	Fwsales_May19	"Money made from firewood sales during May19"
label var 	Fwsales_June19	"Money made from firewood sales during June19"
label var 	Fwsales_July19	"Money made from firewood sales during July19"
label var 	Fwbundlescol_June18	"Number of bundles of firewood collected for sale during June18"
label var 	Fwbundlescol_July18	"Number of bundles of firewood collected for sale during  July18"
label var 	Fwbundlescol_Aug18 "Number of bundles of firewood collected for sale during  Aug18"
label var 	Fwbundlescol_Sept18	"Number of bundles of firewood collected for sale during  Sept18"
label var 	Fwbundlescol_Oct18 "Number of bundles of firewood collected for sale during  Oct18"
label var 	Fwbundlescol_Nov18	"Number of bundles of firewood collected for sale during  Nov18"
label var 	Fwbundlescol_Dec18	"Number of bundles of firewood collected for sale during  Dec18"
label var 	Fwbundlescol_Jan19	"Number of bundles of firewood collected for sale during  Jan19"
label var 	Fwbundlescol_Feb19	"Number of bundles of firewood collected for sale during  Feb19"
label var 	Fwbundlescol_Mar19	"Number of bundles of firewood collected for sale during  Mar19"
label var 	Fwbundlescol_Apr19	"Number of bundles of firewood collected for sale during  Apr19"
label var 	Fwbundlescol_May19	"Number of bundles of firewood collected for sale during  May19"
label var 	Fwbundlescol_June19	"Number of bundles of firewood collected for sale during  June19"
label var 	Fwbundlescol_July19	"Number of bundles of firewood collected for sale during  July19"
label var 	Fwbundlessale_June18	"Number of bundles of firewood sold during June18"
label var 	Fwbundlessale_July18	"Number of bundles of firewood sold during  July18"
label var 	Fwbundlessale_Aug18	"Number of bundles of firewood sold during  Aug18"
label var 	Fwbundlessale_Sept18	"Number of bundles of firewood sold during  Sept18"
label var 	Fwbundlessale_Oct18	"Number of bundles of firewood sold during  Oct18"
label var 	Fwbundlessale_Nov18	"Number of bundles of firewood sold during  Nov18"
label var 	Fwbundlessale_Dec18	"Number of bundles of firewood sold during  Dec18"
label var 	Fwbundlessale_Jan19	"Number of bundles of firewood sold during  Jan19"
label var 	Fwbundlessale_Feb19	"Number of bundles of firewood sold during  Feb19"
label var 	Fwbundlessale_Mar19	"Number of bundles of firewood sold during  Mar19"
label var 	Fwbundlessale_Apr19	"Number of bundles of firewood sold during  Apr19"
label var 	Fwbundlessale_May19	"Number of bundles of firewood sold during  May19"
label var 	Fwbundlessale_June19	"Number of bundles of firewood sold during  June19"
label var 	Fwbundlessale_July19	"Number of bundles of firewood sold during  July19"

rename q2514 firewood_rev
label var firewood_rev "Total revene from firewood sales"

rename q2515_1 fire_transport_cost
label var fire_transport_cost " transport costs incured to the firewood business in the past 12 months "
rename q2515_2 fire_hired_labor_cost
label var fire_hired_labor_cost " hired labor incured to the firewood business in the past 12 months "
rename q2515_3 fire_other_costs
label var fire_other_costs " other costs incured to the firewood business in the past 12 months "

rename q2516 firewood_dist_changed
label var firewood_dist_changed"Do you travel further to cut trees for firewood now compared to 5 years ago?"
recode firewood_dist_changed 4=1
recode firewood_dist_changed 5=0
yesno firewood_dist_changed

rename q2517 charc_resell
label var charc_resell "Did you buy charcoal for resale?"
recode charc_resel 5=0
yesno charc_resell

rename q2518 dist_resale
label var dist_resale "How far is the location where you purchase charcoal for resale?"


*Q2519 (1934 - 2018)
rename q25191_1_1 qchar_june_18
lab var qchar_june_18 "quantity of charcoal bought for resale june 2018"
rename q25191_2_1 qchar_july_18
lab var qchar_july_18 "quantity of charcoal bought for resale july 2018"
rename q25191_3_1 qchar_aug_18
lab var qchar_aug_18 "quantity of charcoal bought for resale august 2018"
rename q25191_4_1 qchar_sept_18
lab var qchar_sept_18 "quantity of charcoal bought for resale september 2018"
rename q25191_5_1 qchar_oct_18
lab var qchar_oct_18 "quantity of charcoal bought for resale october 2018"
rename q25191_6_1 qchar_nov_18
lab var qchar_nov_18 "quantity of charcoal bought for resale november 2018"
rename q25191_7_1 qchar_dec_18
lab var qchar_dec_18 "quantity of charcoal bought for resale december 2018"
rename q25191_8_1 qchar_jan_19
lab var qchar_jan_19 "quantity of charcoal bought for resale january 2019"
rename q25191_9_1 qchar_feb_19
lab var qchar_feb_19 "quantity of charcoal bought for resale february 2019"
rename q25191_10_1 qchar_mar_19
lab var qchar_mar_19 "quantity of charcoal bought for resale march 2019"
rename q25191_11_1 qchar_april_19
lab var qchar_april_19 "quantity of charcoal bought for resale april 2019"
rename q25191_12_1 qchar_may_19
lab var qchar_may_19 "quantity of charcoal bought for resale may 2019"
rename q25191_13_1 qchar_june_19
lab var qchar_june_19 "quantity of charcoal bought for resale august 2019"
rename q25191_14_1 qchar_july_19
lab var qchar_july_19 "quantity of charcoal bought for resale august 2019"

rename q25192_1_1 cst_cha_june_18
lab var cst_cha_june_18 "cost of charcoal bought for resale june 2018"
rename q25192_2_1 cst_cha_july_18
lab var cst_cha_july_18 "cost of charcoal bought for resale july 2018"
rename q25192_3_1 cst_cha_aug_18
lab var cst_cha_aug_18 "cost of charcoal bought for resale august 2018"
rename q25192_4_1 cst_cha_sept_18
lab var cst_cha_sept_18 "cost of charcoal bought for resale september 2018"
rename q25192_5_1 cst_cha_oct_18
lab var cst_cha_oct_18 "cost of charcoal bought for resale october 2018"
rename q25192_6_1 cst_cha_nov_18
lab var cst_cha_nov_18 "cost of charcoal bought for resale november 2018"
rename q25192_7_1 cst_cha_dec_18
lab var cst_cha_dec_18 "cost of charcoal bought for resale december 2018"
rename q25192_8_1 cst_cha_jan_19
lab var cst_cha_jan_19 "cost of charcoal bought for resale january 2019"
rename q25192_9_1 cst_cha_feb_19
lab var cst_cha_feb_19 "cost of charcoal bought for resale february 2019"
rename q25192_10_1 cst_cha_marc_19
lab var cst_cha_marc_19 "cost of charcoal bought for resale march 2019"
rename q25192_11_1 cst_cha_april_19
lab var cst_cha_april_19 "cost of charcoal bought for resale april 2019"
rename q25192_12_1 cst_cha_may_19
lab var cst_cha_may_19 "cost of charcoal bought for resale may 2019"
rename q25192_13_1 cst_cha_june_19
lab var cst_cha_june_19 "cost of charcoal bought for resale june 2019"
rename q25192_14_1 cst_cha_july_19
lab var cst_cha_july_19 "cost of charcoal bought for resale july 2019"

rename q25193_1_1 rev_cha_june_18
lab var rev_cha_june_18 "revenue charcoal bought for resale june 2018"
rename q25193_2_1 rev_cha_july_18
lab var rev_cha_july_18 "revenue charcoal bought for resale july 2018"
rename q25193_3_1 rev_cha_aug_18
lab var rev_cha_aug_18 "revenue charcoal bought for resale august 2018"
rename q25193_4_1 rev_cha_sept_18
lab var rev_cha_sept_18 "revenue charcoal bought for resale september 2018"
rename q25193_5_1 rev_cha_oct_18
lab var rev_cha_oct_18 "revenue charcoal bought for resale october 2018"
rename q25193_6_1 rev_cha_nov_18
lab var rev_cha_nov_18 "revenue charcoal bought for resale november 2018"
rename q25193_7_1 rev_cha_dec_18
lab var rev_cha_dec_18 "revenue charcoal bought for resale december 2018"
rename q25193_8_1 rev_cha_jan_19
lab var rev_cha_jan_19 "revenue charcoal bought for resale january 2019"
rename q25193_9_1 rev_cha_feb_19
lab var rev_cha_feb_19 "revenue charcoal bought for resale february 2019"
rename q25193_10_1 rev_cha_marc_19
lab var rev_cha_marc_19 "revenue charcoal bought for resale march 2019"
rename q25193_11_1 rev_cha_april_19
lab var rev_cha_april_19 "revenue charcoal bought for resale april 2019"
rename q25193_12_1 rev_cha_may_19
lab var rev_cha_may_19 "revenue charcoal bought for resale may 2019"
rename q25193_13_1 rev_cha_june_19
lab var rev_cha_june_19 "revenue charcoal bought for resale june 2019"
rename q25193_14_1 rev_cha_july_19
lab var rev_cha_july_19 "revenue charcoal bought for resale july 2019"


rename q2520_1 rchar_char_cost
label var rchar_char_cost " charcoal cost associated to the resell of charcoal"
rename q2520_2 rchar_transport_cost
label var rchar_transport_cost " transport cost associated to the resell of charcoal"
rename q2520_3 rchar_hired_labor_cost
label var rchar_hired_labor_cost " hired labor cost associated to the resell of charcoal"
rename q2520_5 rchar_other_costs
label var rchar_other_costs " other cost associated to the resell of charcoal"

rename q2521 resale_firewood
label var resale_firewood "Do you resell of firewood?"
recode resale_firewood 5=0
yesno resale_firewood

rename q2522 dist_fire_resal
label var dist_fire_resal "Distance from point of purchase to point of resale"


*Q2523 (1939 - 2018) 
rename 	q25231_1_1	FW_PresaleJun18
rename 	q25231_2_1	FW_PresaleJul18
rename 	q25231_3_1	FW_PresaleAug18
rename 	q25231_4_1	FW_PresaleSept18
rename 	q25231_5_1	FW_PresaleOct18
rename 	q25231_6_1	FW_PresaleNov18
rename 	q25231_7_1	FW_PresaleDec18
rename 	q25231_8_1	FW_PresaleJan19
rename 	q25231_9_1	FW_PresaleFeb19
rename 	q25231_10_1	FW_PresaleMar19
rename 	q25231_11_1	FW_PresaleApr19
rename 	q25231_12_1	FW_PresaleMay19
rename 	q25231_13_1	FW_PresaleJun19
rename 	q25231_14_1	FW_PresaleJul19
rename 	q25232_1_1	FW_payresaleJun18
rename 	q25232_2_1	FW_payresaleJul18
rename 	q25232_3_1	FW_payresaleAug18
rename 	q25232_4_1	FW_payresaleSept18
rename 	q25232_5_1	FW_payresaleOct18
rename 	q25232_6_1	FW_payresaleNov18
rename 	q25232_7_1	FW_payresaleDec18
rename 	q25232_8_1	FW_payresaleJan19
rename 	q25232_9_1	FW_payresaleFeb19
rename 	q25232_10_1	FW_payresaleMar19
rename 	q25232_11_1	FW_payresaleApr19
rename 	q25232_12_1	FW_payresaleMay19
rename 	q25232_13_1	FW_payresaleJun19
rename 	q25232_14_1	FW_payresaleJul19
rename 	q25233_1_1	FW_RresaleJun18
rename 	q25233_2_1	FW_RresaleJul18
rename 	q25233_3_1	FW_RresaleAug18
rename 	q25233_4_1	FW_RresaleSept18
rename 	q25233_5_1	FW_RresaleOct18
rename 	q25233_6_1	FW_RresaleNov18
rename 	q25233_7_1	FW_RresaleDec18
rename 	q25233_8_1	FW_RresaleJan19
rename 	q25233_9_1	FW_RresaleFeb19
rename 	q25233_10_1	FW_RresaleMar19
rename 	q25233_11_1	FW_RresaleApr19
rename 	q25233_12_1	FW_RresaleMay19
rename 	q25233_13_1	FW_RresaleJun19
rename 	q25233_14_1	FW_RresaleJul19

label var	FW_PresaleJun18	"How much firewood did you purchase for resale in Jun18"
label var	FW_PresaleJul18	"How much firewood did you purchase for resale in Jul18"
label var	FW_PresaleAug18	"How much firewood did you purchase for resale in Aug18"
label var	FW_PresaleSept18 "How much firewood did you purchase for resale in Sept18"
label var	FW_PresaleOct18	"How much firewood did you purchase for resale in Oct18"
label var	FW_PresaleNov18	"How much firewood did you purchase for resale in Nov18"
label var	FW_PresaleDec18	"How much firewood did you purchase for resale in Dec18"
label var	FW_PresaleJan19	"How much firewood did you purchase for resale in Jan19"
label var	FW_PresaleFeb19	"How much firewood did you purchase for resale in Feb19"
label var	FW_PresaleMar19	"How much firewood did you purchase for resale in Mar19"
label var	FW_PresaleApr19	"How much firewood did you purchase for resale in Apr19"
label var	FW_PresaleMay19	"How much firewood did you purchase for resale in May19"
label var	FW_PresaleJun19	"How much firewood did you purchase for resale in Jun19"
label var	FW_PresaleJul19	"How much firewood did you purchase for resale in Jul19"
label var	FW_payresaleJun18	"How much did you pay for the firewood for resale in Jun18"
label var	FW_payresaleJul18	"How much did you pay for the firewood for resale in Jul18"
label var	FW_payresaleAug18	"How much did you pay for the firewood for resale in Aug18"
label var	FW_payresaleSept18	"How much did you pay for the firewood for resale in Sept18"
label var	FW_payresaleOct18	"How much did you pay for the firewood for resale in Oct18"
label var	FW_payresaleNov18	"How much did you pay for the firewood for resale in Nov18"
label var	FW_payresaleDec18	"How much did you pay for the firewood for resale in Dec18"
label var	FW_payresaleJan19	"How much did you pay for the firewood for resale in Jan19"
label var	FW_payresaleFeb19	"How much did you pay for the firewood for resale in Feb19"
label var	FW_payresaleMar19	"How much did you pay for the firewood for resale in Mar19"
label var	FW_payresaleApr19	"How much did you pay for the firewood for resale in Apr19"
label var	FW_payresaleMay19	"How much did you pay for the firewood for resale in May19"
label var	FW_payresaleJun19	"How much did you pay for the firewood for resale in Jun19"
label var	FW_payresaleJul19	"How much did you pay for the firewood for resale in Jul19"
label var	FW_RresaleJun18	"How much money did you make from firewood resale in Jun18"
label var	FW_RresaleJul18	"How much money did you make from firewood resale in Jul18"
label var	FW_RresaleAug18	"How much money did you make from firewood resale in Aug18"
label var	FW_RresaleSept18	"How much money did you make from firewood resale in Sept18"
label var	FW_RresaleOct18	"How much money did you make from firewood resale in Oct18"
label var	FW_RresaleNov18	"How much money did you make from firewood resale in Nov18"
label var	FW_RresaleDec18	"How much money did you make from firewood resale in Dec18"
label var	FW_RresaleJan19	"How much money did you make from firewood resale in Jan19"
label var	FW_RresaleFeb19	"How much money did you make from firewood resale in Feb19"
label var	FW_RresaleMar19	"How much money did you make from firewood resale in Mar19"
label var	FW_RresaleApr19	"How much money did you make from firewood resale in Apr19"
label var	FW_RresaleMay19	"How much money did you make from firewood resale in May19"
label var	FW_RresaleJun19	"How much money did you make from firewood resale in Jun19"
label var	FW_RresaleJul19	"How much money did you make from firewood resale in Jul19"

rename q2524_1 FW_RS_firewood
label var FW_RS_firewood "Cash costs incurred for the firewood of firewood resale"
rename q2524_2 FW_RS_trans
label var FW_RS_trans "Cash costs incurred for transportation of firewood resale" 
rename q2524_3 FW_RS_labor
label var FW_RS_labor "Cash costs incurred for labor of firewood resale" 
rename q2524_5 FW_RS_other 
label var FW_RS_other "Cash costs incurred for other misc. of firewood resale"
