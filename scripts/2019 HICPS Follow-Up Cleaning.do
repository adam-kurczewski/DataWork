clear
set more off

*** Set appropriate directory pathway for your machine ***
cd "C:\Users\kurczew2\Box\Research\HICPS"

use "2019 HICPS Follow-Up_raw.dta", clear

label define yesnoL 1 "Yes" 0 "No" 

capture program drop yesno 
program define yesno 
	replace `1'=0 if `1'==2
	label values `1' yesnoL
end 

*********************************************************************
/* Section 1: Introduction */
*********************************************************************

replace q110=101 if q110==1
replace q110=102 if q110==2

replace q111=201 if q111==1
replace q111=202 if q111==2

replace q112=301 if q112==1
replace q112=302 if q112==2

replace q113=401 if q113==1
**Chinsali not in HICPS 16/17
replace q113=403 if q113==2

replace q114=501 if q114==1
replace q114=502 if q114==2

replace q115=601 if q115==1
replace q115=602 if q115==2

gen new_district=. 
foreach i in q110 q111 q112 q113 q114 q115{
	replace new_district=`i' if new_district==.
	drop `i'
	}

rename 	q13	new_hh
yesno new_hh

rename 	q15	at_house 
yesno at_house 

rename 	q16	new_lat

rename 	q17	new_long

rename 	q18	move_hh1
yesno move_hh1

rename 	q19	new_province

rename 	q116	same_respondent
yesno same_respondent 

rename respondent_name name_19
rename phone phone_number
 
rename 	q119	ZESCO
replace ZESCO=0 if ZESCO==4
yesno ZESCO

label variable	enumerator	"enumerator "
label variable	new_hh	"Newly added household "
label variable	HHID	"Household identification number "
label variable	move_hh1	"Has household moved since 2016"
label variable	at_house 	"At respondents household "
label variable	new_lat	"Moved household latitude "
label variable	new_long	"Moved Household longitude "
label variable	new_province	"Moved household province "
label variable	same_respondent 	"Same respondent from last year "
label variable	name_19	"Name of respondent "
label variable	phone_number	"Current phone number "
label variable	ZESCO	"Household connected to ZESCO"


*********************************************************************
/* Section 2: Demographics */
*********************************************************************


rename 	q21 	hh_num 
rename 	q221_1_1 	hh_mem_Munder5
rename 	q221_2_1 	hh_mem_M5to9
rename 	q221_3_1 	hh_mem_M10to17
rename 	q221_4_1 	hh_mem_M18to59
rename 	q221_5_1 	hh_mem_M60
rename 	q222_1_1 	hh_mem_Funder5
rename 	q222_2_1 	hh_mem_F5to9
rename 	q222_3_1 	hh_mem_F10to17
rename 	q222_4_1 	hh_mem_F18to59
rename	q222_5_1	hh_mem_F60
rename	q23	new_hh_mem1
rename	q241_1_1 	new_mem_Munder5
rename	q241_2_1 	new_mem_M5to9
rename	q241_3_1 	new_mem_M10to17
rename	q241_4_1 	new_mem_M18to59
rename	q241_5_1 	new_mem_M60
rename	q242_1_1 	new_mem_Funder5
rename	q242_2_1 	new_mem_F5to9
rename	q242_3_1 	new_mem_F10to17
rename	q242_4_1 	new_mem_F18to59
rename	q242_5_1	new_mem_F60

*distance to places
rename q251_1_1 tarmac_dist
rename q251_2_1 public_trans_dist
rename q251_3_1 village_mkt_dist
rename q251_4_1 water_dist
rename q251_5_1 firewood_dist
rename q251_6_1 prim_maize_dist
rename q251_7_1 agrodealer_dist
rename q26 comments_dist


/*
rename	q261_1 	perm_relate_1
rename	q261_2 	perm_relate_2
rename	q261_3 	perm_relate_3
rename	q261_4 	perm_relate_4
rename	q261_5 	perm_relate_5
rename	q262_1	perm_sex_1
rename	q262_2	perm_sex_2
rename	q262_3	perm_sex_3
rename	q262_4	perm_sex_4
rename	q262_5	perm_sex_5
rename	q263_1	perm_birth_1
rename	q263_2	perm_birth_2
rename	q263_3	perm_birth_3
rename	q263_4	perm_birth_4
rename	q263_5	perm_birth_5
rename	q264_1	perm_reason_1
rename	q264_2	perm_reason_2
rename	q264_3	perm_reason_3
rename	q264_4	perm_reason_4
rename	q264_5	perm_reason_5
rename	q265_1_1 	perm_district_1
rename	q265_2_1 	perm_district_2
rename	q265_3_1 	perm_district_3
rename	q265_4_1 	perm_district_4
rename	q265_5_1	perm_district_5
rename	q266_1	perm_area_1
rename	q266_2	perm_area_2
rename	q266_3	perm_area_3
rename	q266_4	perm_area_4
rename	q266_5	perm_area_5
rename	q267_1	perm_remit1
rename	q267_2	perm_remit2
rename	q267_3	perm_remit3
rename	q267_4	perm_remit4
rename	q267_5	perm_remit5
rename	q268_1_1 	perm_amountremit1
rename	q268_2_1 	perm_amountremit2
rename	q268_3_1 	perm_amountremit3
rename	q268_4_1 	perm_amountremit4
rename	q268_5_1	perm_amountremit5

*fix coded values 
replace new_hh_mem1=new_hh_mem1-1
yesno perm_left

*fix coded values of perm left table 
label define sex 1 "Male" 0 "Female"
foreach i of num 1/5{
	replace perm_sex_`i'=0 if perm_sex_`i'==2
	label values perm_sex_`i' sex
	}

foreach i of num 1/5{
	replace perm_birth_`i'=perm_birth_`i'+1917
	}

foreach i of num 1/5{ 
	replace perm_area_`i'=3 if perm_area_`i'==1
	replace perm_area_`i'=1 if perm_area_`i'==2
	}

foreach i of num 1/5{
	yesno perm_remit`i'
	}
	
label define HHrelation 1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter"  5 "Adopted son/Daughter" 6 "Grandchild" 7 "Father/Mother" 8 "Brother/Sister" 9 "Half-brother/Half-sister" 10 "Nephew/Niece of head (related)" 11 "Nephew/Niece of head (unrelated)" 12 "Son-in-law/Daughter-in-law" 13 "Brother-in-law/Sister-in-law" 14 "Father-in-law/Mother-in-law" 15 "Other family relative" 16 "Other person not related" 
 
label define reason_leaving 1 "Death" 2 "Marriage" 3 "Divorce" 4 "School" 5 "Employment" 6 "Transferred" 7 "Other" 

label define rural_urban 1 "Rural" 3 "Urban" 

foreach i of num 1/5{ 
	label values perm_relate_`i' HHrelation 
	label values perm_reason_`i' reason_leaving
	label values perm_area_`i' rural_urban 
	}

*/
label variable	hh_num 	"Number of people in household "
label variable	hh_mem_Munder5	"Number of hh members male under 5 "
label variable	hh_mem_M5to9	"Number of hh members male 5 to 9"
label variable	hh_mem_M10to17	"Number of hh members male 10 to 17"
label variable	hh_mem_M18to59	"Number of hh members male 18 to 59"
label variable	hh_mem_M60	"Number of hh members male 60+"
label variable	hh_mem_Funder5	"Number of hh members female under 5 "
label variable	hh_mem_F5to9	"Number of hh members female 5 to 9"
label variable	hh_mem_F10to17	"Number of hh members female 10 to 17"
label variable	hh_mem_F18to59	"Number of hh members female 18 to 59"
label variable	hh_mem_F60	"Number of hh members female 60+"
label variable	new_hh_mem1	"New members joined household since last survey period"
label variable	new_mem_Munder5	"Number of new hh members male under 5 "
label variable	new_mem_M5to9	"Number of new hh members male 5 to 9"
label variable	new_mem_M10to17	"Number of new hh members male 10 to 17"
label variable	new_mem_M18to59	"Number of new hh members male 18 to 59"
label variable	new_mem_M60	"Number of new hh members male 60+"
label variable	new_mem_Funder5	"Number of new hh members female under 5 "
label variable	new_mem_F5to9	"Number of new hh members female 5 to 9"
label variable	new_mem_F10to17	"Number of new hh members female 10 to 17"
label variable	new_mem_F18to59	"Number of new hh members female 18 to 59"
label variable	new_mem_F60	"Number of new hh members female 60+"
label variable tarmac_dist "Distance to tarmac road - walking minutes"
label variable public_trans_dist "Distance to public transportation - walking minutes"
label variable village_mkt_dist "Distance to village market - walking minutes"
label variable water_dist "Distance to water collection location - walking minutes"
label variable firewood_dist "Distance to the last place of firewood collection - walking minutes"
label variable prim_maize_dist "Distance to primary maize field - walking minutes"
label variable agrodealer_dist "Distance to primary agricultural dealer - walkign minutes"
label variable comments_dist "Comments for distance section"

*destring
destring hh_num hh_mem_Munder5 hh_mem_M5to9 hh_mem_M10to17 hh_mem_M18to59 hh_mem_M60 ///
hh_mem_Funder5 hh_mem_F5to9 hh_mem_F18to59 hh_mem_F60 new_hh_mem1 new_mem_Munder5 new_mem_M5to9 ///
new_mem_M10to17 new_mem_M18to59 new_mem_M60 new_mem_Funder5 new_mem_F5to9 new_mem_F10to17 ///
new_mem_F18to59 new_mem_F60 tarmac_dist public_trans_dist village_mkt_dist water_dist ///
firewood_dist prim_maize_dist agrodealer_dist comments_dist, replace


*********************************************************************
/* Section 3: Remittances and Migration */
*********************************************************************

replace q31=2 if q31==3
yesno q31
rename q31 mem_left
label variable mem_left "Has anyone left since June 2018"
label value mem_left yesnoL

rename q32 children_left
label variable children_left "Number of children under the age of 16 who left since June 2018"

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
/* Section 9: Finances */
*********************************************************************
label define five 5 "5+"

capture program drop numbers 
program define numbers 
	replace `1'=0 if `1'==7
	replace `1'=0 if `1'==6
	label values `1' five
end 



rename 	q92	asset_phone 
rename 	q93	tv 
rename 	q94	radio 
rename 	q95	bike 
rename 	q96	motorcycle 
rename 	q97	water_pump 
rename 	q98	plough 
rename 	q99	sprayers 
rename 	q910	ox_carts 
rename 	q911	vehicle 
replace vehicle=0 if vehicle==5 
label define four 4 "4+"
label value vehicle four 

foreach i in asset_phone tv radio bike motorcycle water_pump plough sprayers ox_carts {
	numbers `i'
	}
	

rename 	q912	iron_sheets 
replace iron_sheets=1 if iron_sheets==23
replace iron_sheets=0 if iron_sheets==24 
label value iron_sheets yesnoL

rename 	q913	solar 
replace solar=0 if solar==6 
replace solar=3 if solar==12
rename q914 solar_purpose
rename q914_7_text solar_text
rename q915 solar_knowledge
replace solar_knowledge = 0 if solar_knowledge == 2
replace solar_knowledge = 1 if solar_knowledge == 3
replace solar_knowledge = 2 if solar_knowledge == 6

rename q916_1 solar_month
replace solar_month = "January" if solar_month == "January  " | solar_month == "January " |  solar_month == "January   " | solar_month == " January"  | solar_month == " January " | solar_month == "1"
replace solar_month = "February" if solar_month == "February  " | solar_month == "February " |  solar_month == "February   " | solar_month == " February"  | solar_month == " February " | solar_month == "2"
replace solar_month = "March" if solar_month == "March  " | solar_month == "March " |  solar_month == "March   " | solar_month == " March"  | solar_month == " March " | solar_month == "3"
replace solar_month = "April" if solar_month == "April  " | solar_month == "April " |  solar_month == "April   " | solar_month == " April"  | solar_month == " April " | solar_month == "4"
replace solar_month = "May" if solar_month == "May  " | solar_month == "May " |  solar_month == "May   " | solar_month == " May"  | solar_month == " May " | solar_month == "5"
replace solar_month = "June" if solar_month == "June  " | solar_month == "June " |  solar_month == "June   " | solar_month == " June"  | solar_month == " June " | solar_month == "june" | solar_month == "6"
replace solar_month = "July" if solar_month == "July  " | solar_month == "July " |  solar_month == "July   " | solar_month == " July"  | solar_month == " July " | solar_month == "Juky" | solar_month == "7"
replace solar_month = "August" if solar_month == "August  " | solar_month == "August " |  solar_month == "August   " | solar_month == " August"  | solar_month == " August "  | solar_month == "8"
replace solar_month = "September" if solar_month == "September  " | solar_month == "September " |  solar_month == "September   " | solar_month == " September"  | solar_month == " September " | solar_month == "9"
replace solar_month = "October" if solar_month == "October  " | solar_month == "October " |  solar_month == "October   " | solar_month == " October"  | solar_month == " October " | solar_month == "10"
replace solar_month = "November" if solar_month == "November  " | solar_month == "November " |  solar_month == "November   " | solar_month == " November"  | solar_month == " November " | solar_month == "11"
replace solar_month = "December" if solar_month == "December  " | solar_month == "December " |  solar_month == "December   " | solar_month == " December"  | solar_month == " December " | solar_month == "12"
rename q916_2 solar_year
rename q917 solar_where
label define solar 1"Bought it myself (full payment)" 2 "Pre-financed through rural bank" 3 "Financing through a local savings group" /// 
4 "Rent for regular payments" 5 "Sponsored through project" 6 "Other"
label values solar_where solar
rename q917_6_text solar_where_text
rename q918 solar_fail
rename q918_6_text solar_fail_text
rename q919 solar_expansion
replace solar_expansion = 0 if solar_expansion == 3

*livestock
rename 	q920_1_1 female_cattle_number 
rename 	q920_2_1 goat_sheep_number 
rename 	q920_3_1 poultry_number 
rename 	q920_4_1 pigs_number
rename 	q920_5_1 oxen_number
rename 	q920_6_1 breeding_bull_number

*income
rename 	q921_1	income_piecework 
rename 	q921_2	income_salary 
rename 	q921_9	income_smallbusiness 
rename 	q921_10	income_charcoal 
rename 	q921_12	income_gardening 
rename 	q921_13	income_forestproduct 
rename 	q921_17	income_nonmaizecrop
rename 	q921_6	income_livestock 
rename 	q921_8	income_remittance 
rename 	q921_16	income_other 
rename 	q922	piecework_members 
replace piecework_members=0 if piecework_members==6 
replace piecework_members=piecework_members-6 if piecework_members!=0
rename 	q923	piecework_type
rename q923_10_text piecework_text
rename 	q924	bank_account 
yesno bank_account
rename 	q925	mobile_bank_account 
yesno mobile_bank_account
rename 	q926	formal_loan 
yesno formal_loan
rename 	q927_1	borrow500 
yesno borrow500
rename 	q927_2	borrow2500 
yesno borrow2500
rename 	q927_3	borrow10000 
yesno borrow10000
rename 	q928	phone_transfer 
replace phone_transfer=1 if phone_transfer==23
replace phone_transfer=0 if phone_transfer==24

rename 	q929	food_budget_7day 
rename 	q930	talktime_budget_7day 
rename 	q931_2	veterinary_cost_month 
rename 	q931_3	clothing_cost_month 
rename 	q931_4	transportation_cost_month 
rename 	q931_5	alcohol_cost_month 
rename 	q931_6	firewood_cost_month 
rename 	q931_7	charcoal_cost_month 
rename 	q931_8	other_cost_month
rename 	q932	school_fees
rename 	q933	medical_exp
rename 	q934	sell_nonmaize19
yesno sell_nonmaize
rename q935 sell_crop
rename q935_24_text sell_nonmaize_txt

*non-maize - hectares
rename 	q9361_1_1	hec_cabbage 
rename 	q9361_2_1	hec_carrots
rename 	q9361_3_1	hec_cassava
rename 	q9361_4_1	hec_combeans
rename 	q9361_5_1	hec_cotton 
rename 	q9361_6_1	hec_cowpeas
rename 	q9361_7_1	hec_groundnuts
rename 	q9361_8_1	hec_irishpots
rename 	q9361_9_1	hec_leafygreens
rename 	q9361_10_1	hec_millet
rename 	q9361_11_1	hec_okra
rename 	q9361_12_1	hec_onions
rename 	q9361_13_1	hec_orchard
rename 	q9361_14_1	hec_peppers
rename 	q9361_15_1	hec_pigeonpea
rename 	q9361_16_1	hec_popcorn
rename 	q9361_17_1	hec_pumpkin
rename 	q9361_18_1	hec_rice
rename 	q9361_19_1	hec_sorghum
rename 	q9361_20_1	hec_soyabeans
rename 	q9361_21_1	hec_sunflower
rename 	q9361_22_1	hec_sweetpot
rename 	q9361_23_1	hec_tobacco
rename 	q9361_24_1	hec_tomatoes
rename 	q9361_25_text	hec_other
rename 	q9361_25_1	hec_other2
rename 	q9361_26_1	hec_none
*non-maize - squared meters
rename 	q9362_1_1	sqm_cabbage 
rename 	q9362_2_1	sqm_carrots
rename 	q9362_3_1	sqm_cassava
rename 	q9362_4_1	sqm_combeans
rename 	q9362_5_1	sqm_cotton 
rename 	q9362_6_1	sqm_cowpeas
rename 	q9362_7_1	sqm_groundnuts
rename 	q9362_8_1	sqm_irishpots
rename 	q9362_9_1	sqm_leafygreens
rename 	q9362_10_1	sqm_millet
rename 	q9362_11_1	sqm_okra
rename 	q9362_12_1	sqm_onions
rename 	q9362_13_1	sqm_orchard
rename 	q9362_14_1	sqm_peppers
rename 	q9362_15_1	sqm_pigeonpea
rename 	q9362_16_1	sqm_popcorn
rename 	q9362_17_1	sqm_pumpkin
rename 	q9362_18_1	sqm_rice
rename 	q9362_19_1	sqm_sorghum
rename 	q9362_20_1	sqm_soyabeans
rename 	q9362_21_1	sqm_sunflower
rename 	q9362_22_1	sqm_sweetpot
rename 	q9362_23_1	sqm_tobacco
rename 	q9362_24_1	sqm_tomatoes
rename 	q9362_25_text	sqm_other
rename 	q9362_25_1	sqm_other2
rename 	q9362_26_1	sqm_none
*non-maize income
rename 	q9363_1_1	income_cabbage 
rename 	q9363_2_1	income_carrots
rename 	q9363_3_1	income_cassava
rename 	q9363_4_1	income_combeans
rename 	q9363_5_1	income_cotton 
rename 	q9363_6_1	income_cowpeas
rename 	q9363_7_1	income_groundnuts
rename 	q9363_8_1	income_irishpots
rename 	q9363_9_1	income_leafygreens
rename 	q9363_10_1	income_millet
rename 	q9363_11_1	income_okra
rename 	q9363_12_1	income_onions
rename 	q9363_13_1	income_orchard
rename 	q9363_14_1	income_peppers
rename 	q9363_15_1	income_pigeonpea
rename 	q9363_16_1	income_popcorn
rename 	q9363_17_1	income_pumpkin
rename 	q9363_18_1	income_rice
rename 	q9363_19_1	income_sorghum
rename 	q9363_20_1	income_soyabeans
rename 	q9363_21_1	income_sunflower
rename 	q9363_22_1	income_sweetpot
rename 	q9363_23_1	income_tobacco
rename 	q9363_24_1	income_tomatoes
rename 	q9363_25_text	income_othercrop
rename 	q9363_25_1	income_othercrop2
rename 	q9363_26_1	income_none

tab income_remittance
replace income_piecework = "10080" if income_piecework == "10,080"
replace income_salary = "10800" if income_salary == "10,800"
replace income_smallbusiness = "19200" if income_smallbusiness == "19,200"
replace income_charcoal = "0" if income_charcoal == "P"
replace income_charcoal = "0" if income_charcoal == "p"
replace income_gardening = "15500" if income_gardening == "15,500"
replace income_nonmaizecrop = "22000" if income_nonmaizecrop == "22,000"

destring income_piecework income_salary income_smallbusiness income_charcoal ///
income_gardening income_forestproduct income_nonmaizecrop income_remittance income_other, replace

label variable	asset_phone 	"Number of mobile phones"
label variable	tv 	"Number of  TVs"
label variable	radio 	"Number of radios"
label variable	bike 	"Bicycles"
label variable	motorcycle 	"Number of motorcycles"
label variable	water_pump 	"Number of water pumps"
label variable	plough 	"Number of ploughs"
label variable	sprayers 	"Number of sprayers"
label variable	ox_carts 	"Number of ox carts"
label variable	vehicle 	"Number of vehicles"
label variable	iron_sheets 	"House has iron sheets"
label variable	solar 	"Number of solar panels"

label variable solar_purpose "What is the purpose of the solar system right now"
label variable solar_text "What is the purpose of the solar system right now - other"
label variable solar_knowledge "How would you rate your (or anyone in the household's) technical knowledge "
label variable solar_month "What month and year did you purchase this solar system - month"
label variable solar_year "What month and year did you purchase this solar system - year"
label variable solar_where "Where/ How did you get this solar system"
label variable solar_where_text "Where/ How did you get this solar system - other"
label variable solar_fail "Did a part of the system fail? If so which part?"
label variable solar_fail_text "Did a part of the system fail? If so which part? - other"
label variable solar_expansion "Do you plan to expand the solar system in the future?"

label variable	female_cattle_number 	"Number of female cattle "
label variable	goat_sheep_number 	"Number of goat/sheep"
label variable	poultry_number 	"Number of poultry"
label variable	pigs_number	"Number of pigs"
label variable	oxen_number 	"Number of oxen"
label variable	breeding_bull_number 	"Number of Breeding bull"

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
label variable	piecework_members 	"Number of household members doing piecework"
label variable	piecework_type 	"Piecework type"
label variable	piecework_text 	"Piecework type - Other"

label variable	bank_account 	"Anyone have a bank account"
label variable	mobile_bank_account 	"Anyone have a mobile bank account"
label variable	formal_loan 	"Anyone taken out a formal loan"
label variable	borrow500 	"Be able to borrow 500 K"
label variable	borrow2500 	"Be able to borrow 2,500 K"
label variable	borrow10000 	"Be able to borrow 10,000 K "
label variable	phone_transfer 	"Anyone transferred money from mobile phone"

label variable	food_budget_7day 	"7 day household food budget"
label variable	talktime_budget_7day 	"7 day talk time budget"
label variable	veterinary_cost_month 	"Last months veterinary expenses"
label variable	clothing_cost_month 	"Last months clothing expenses"
label variable	transportation_cost_month 	"Last months transportation expenses"
label variable	alcohol_cost_month 	"Last months alcohol expenses"
label variable	firewood_cost_month 	"Last months firewood expenses"
label variable	charcoal_cost_month 	"Last months charcoal expenses"
label variable	other_cost_month	"Last months other significant expenses"
label variable	school_fees	"12 month school fees"
label variable	medical_exp	"12 month medical expenses"
label variable sell_nonmaize19 "Did you sell non-maize crop from 18/19 harvest"
label variable	sell_crop	"Which non-maize crops from 18/19 harvest did you sell"
label variable sell_nonmaize_txt "Which non-maize crops from 18/19 harvest did you sell - Other"
	
label variable	hec_cabbage 	"Total amount of land (ha) for cabbage"
label variable	hec_carrots	"Total amount of land (ha) for carrots"
label variable	hec_cassava	"Total amount of land (ha) for cassava"
label variable	hec_combeans	"Total amount of land (ha) for common beans"
label variable	hec_cotton 	"Total amount of land (ha) for cotton"
label variable	hec_cowpeas	"Total amount of land (ha) for cowpeas"
label variable	hec_groundnuts	"Total amount of land (ha) for groundnuts"
label variable	hec_irishpots	"Total amount of land (ha) for irish potatoes"
label variable	hec_leafygreens	"Total amount of land (ha) for leafy greens"
label variable	hec_millet	"Total amount of land (ha) for millet"
label variable	hec_okra	"Total amount of land (ha) for okra"
label variable	hec_onions	"Total amount of land (ha) for onions"
label variable	hec_orchard	"Total amount of land (ha) for orchard"
label variable	hec_peppers	"Total amount of land (ha) for peppers"
label variable	hec_pigeonpea	"Total amount of land (ha) for pigeon pea"
label variable	hec_popcorn	"Total amount of land (ha) for popcorn "
label variable	hec_pumpkin	"Total amount of land (ha) for pumpkin"
label variable	hec_rice	"Total amount of land (ha) for rice"
label variable	hec_sorghum	"Total amount of land (ha) for sorghum"
label variable	hec_soyabeans	"Total amount of land (ha) for soyabeans"
label variable	hec_sunflower	"Total amount of land (ha) for sunflowers"
label variable	hec_sweetpot	"Total amount of land (ha) for sweet potatoes"
label variable	hec_tobacco	"Total amount of land (ha) for tobacco"
label variable	hec_tomatoes	"Total amount of land (ha) for tomatoes"
label variable	hec_other	"Total amount of land (ha) for other crop"
label variable	hec_other2	"Total amount of land (ha) for other crop"
label variable	hec_none	"Nothing else planted "

label variable	sqm_cabbage 	"Total amount of land (sqm) for cabbage"
label variable	sqm_carrots	"Total amount of land (sqm) for carrots"
label variable	sqm_cassava	"Total amount of land (sqm) for cassava"
label variable	sqm_combeans	"Total amount of land (sqm) for common beans"
label variable	sqm_cotton 	"Total amount of land (sqm) for cotton"
label variable	sqm_cowpeas	"Total amount of land (sqm) for cowpeas"
label variable	sqm_groundnuts	"Total amount of land (sqm) for groundnuts"
label variable	sqm_irishpots	"Total amount of land (sqm) for irish potatoes"
label variable	sqm_leafygreens	"Total amount of land (sqm) for leafy greens"
label variable	sqm_millet	"Total amount of land (sqm) for millet"
label variable	sqm_okra	"Total amount of land (sqm) for okra"
label variable	sqm_onions	"Total amount of land (sqm) for onions"
label variable	sqm_orchard	"Total amount of land (sqm) for orchard"
label variable	sqm_peppers	"Total amount of land (sqm) for peppers"
label variable	sqm_pigeonpea	"Total amount of land (sqm) for pigeon pea"
label variable	sqm_popcorn	"Total amount of land (sqm) for popcorn "
label variable	sqm_pumpkin	"Total amount of land (sqm) for pumpkin"
label variable	sqm_rice	"Total amount of land (sqm) for rice"
label variable	sqm_sorghum	"Total amount of land (sqm) for sorghum"
label variable	sqm_soyabeans	"Total amount of land (sqm) for soyabeans"
label variable	sqm_sunflower	"Total amount of land (sqm) for sunflowers"
label variable	sqm_sweetpot	"Total amount of land (sqm) for sweet potatoes"
label variable	sqm_tobacco	"Total amount of land (sqm) for tobacco"
label variable	sqm_tomatoes	"Total amount of land (sqm) for tomatoes"
label variable	sqm_other	"Total amount of land (sqm) for other crop"
label variable	sqm_other2	"Total amount of land (sqm) for other crop"
label variable	sqm_none	"Nothing else planted "

label variable	income_cabbage 	"Total income collected from cabbage"
label variable	income_carrots	"Total income collected from carrots"
label variable	income_cassava	"Total income collected from cassava"
label variable	income_combeans	"Total income collected from common beans"
label variable	income_cotton 	"Total income collected from cotton"
label variable	income_cowpeas	"Total income collected from cowpeas"
label variable	income_groundnuts	"Total income collected from groundnuts"
label variable	income_irishpots	"Total income collected from irish potatoes"
label variable	income_leafygreens	"Total income collected from leafy greens"
label variable	income_millet	"Total income collected from millet"
label variable	income_okra	"Total income collected from okra"
label variable	income_onions	"Total income collected from onions"
label variable	income_orchard	"Total income collected from orchard"
label variable	income_peppers	"Total income collected from peppers"
label variable	income_pigeonpea	"Total income collected from pigeon pea"
label variable	income_popcorn	"Total income collected from popcorn "
label variable	income_pumpkin	"Total income collected from pumpkin"
label variable	income_rice	"Total income collected from rice"
label variable	income_sorghum	"Total income collected from sorghum"
label variable	income_soyabeans	"Total income collected from soyabeans"
label variable	income_sunflower	"Total income collected from sunflowers"
label variable	income_sweetpot	"Total income collected from sweet potatoes"
label variable	income_tobacco	"Total income collected from tobacco"
label variable	income_tomatoes	"Total income collected from tomatoes"
label variable	income_othercrop	"Total income collected from other crop"
label variable	income_othercrop2	"Total income collected from other crop"
label variable	income_none	"Nothing else planted "

*********************************************************************
/* Section 10: Dietary Diversity and Expenses */
*********************************************************************	

rename 	q102	cook_person
yesno cook_person 

rename 	q103	enough_food
yesno enough_food 

rename 	q104	maize_consu_harvest

*eat
rename q1051_1 eat_maize_days
rename q1051_2 eat_rice_days
rename q1051_3 eat_sorghum_days
rename q1051_4 eat_millet_days
rename q1051_5 eat_wheat_bread_days
rename q1051_6 eat_irish_potato_days
rename q1051_7 eat_carrot_days
rename q1051_8 eat_leafy_veg_days
rename q1051_9 eat_other_vegetable_days
rename q1051_10 eat_fruit_days
rename q1051_11 eat_other_fruit_days
rename q1051_12 eat_chicken_days
rename q1051_13 eat_beef_days
rename q1051_14 eat_goat_days
rename q1051_15 eat_pork_days
rename q1051_16 eat_other_meat_days
rename q1051_17 eat_insect_days
rename q1051_18 eat_egg_days
rename q1051_19 eat_fish_days
rename q1051_20 eat_beans_days
rename q1051_21 eat_milk_days
rename q1051_22 eat_alcohol_days
rename q1051_23 eat_oil_days
rename q1051_24 eat_sweets_days
rename q1051_25 eat_spice_beverage_days


***recode values 
foreach i in eat_maize_days eat_rice_days eat_sorghum_days eat_millet_days eat_wheat_bread_days eat_irish_potato_days ///
eat_carrot_days eat_leafy_veg_days eat_other_vegetable_days eat_fruit_days eat_other_fruit_days eat_chicken_days ///
eat_beef_days eat_goat_days eat_pork_days eat_other_meat_days eat_insect_days eat_egg_days eat_fish_days eat_beans_days ///
eat_milk_days eat_alcohol_days eat_oil_days eat_sweets_days eat_spice_beverage_days {
	replace `i'=`i'-1
	}
	
*Main source	
rename q1052_1 source_maize
rename q1052_2 source_rice
rename q1052_3 source_sorghum
rename q1052_4 source_millet
rename q1052_5 source_wheat_bread
rename q1052_6 source_irish_potato
rename q1052_7 source_carrot
rename q1052_8 source_leafy_veg
rename q1052_9 source_other_vegetable
rename q1052_10 source_fruit
rename q1052_11 source_other_fruit
rename q1052_12 source_chicken
rename q1052_13 source_beef
rename q1052_14 source_goat
rename q1052_15 source_pork
rename q1052_16 source_other_meat
rename q1052_17 source_insect
rename q1052_18 source_egg
rename q1052_19 source_fish
rename q1052_20 source_beans
rename q1052_21 source_milk
rename q1052_22 source_alcohol
rename q1052_23 source_oil
rename q1052_24 source_sweets
rename q1052_25 source_spice_beverage

*secondary source
rename q1053_1 Ssource_maize
rename q1053_2 Ssource_rice
rename q1053_3 Ssource_sorghum
rename q1053_4 Ssource_millet
rename q1053_5 Ssource_wheat_bread
rename q1053_6 Ssource_irish_potato
rename q1053_7 Ssource_carrot
rename q1053_8 Ssource_leafy_veg
rename q1053_9 Ssource_other_vegetable
rename q1053_10 Ssource_fruit
rename q1053_11 Ssource_other_fruit
rename q1053_12 Ssource_chicken
rename q1053_13 Ssource_beef
rename q1053_14 Ssource_goat
rename q1053_15 Ssource_pork
rename q1053_16 Ssource_other_meat
rename q1053_17 Ssource_insect
rename q1053_18 Ssource_egg
rename q1053_19 Ssource_fish
rename q1053_20 Ssource_beans
rename q1053_21 Ssource_milk
rename q1053_22 Ssource_alcohol
rename q1053_23 Ssource_oil
rename q1053_24 Ssource_sweets
rename q1053_25 Ssource_spice_beverage

label define source 1 "Own production" 2 "Village market" 3 "Town market" 4 "Roadside market" 5 "Passing trader" 6 "Own production" 7 "Relative/Neighbor" 8 "Collected on common land" 

foreach i in source_maize source_rice source_sorghum source_millet source_wheat_bread source_irish_potato ///
source_carrot source_leafy_veg source_other_vegetable source_fruit source_other_fruit source_chicken ///
source_beef source_goat source_pork source_other_meat source_insect source_egg source_fish source_beans ///
source_milk source_alcohol source_oil source_sweets source_spice_beverage ///
Ssource_maize Ssource_rice Ssource_sorghum Ssource_millet Ssource_wheat_bread Ssource_irish_potato ///
Ssource_carrot Ssource_leafy_veg Ssource_other_vegetable Ssource_fruit Ssource_other_fruit Ssource_chicken ///
Ssource_beef Ssource_goat Ssource_pork Ssource_other_meat Ssource_insect Ssource_egg Ssource_fish Ssource_beans ///
Ssource_milk Ssource_alcohol Ssource_oil Ssource_sweets Ssource_spice_beverage {
	label value `i' source
	}


rename 	q106	mkts_visited
replace mkts_visited=mkts_visited-1
label define plus5 5 "5+"
label value mkts_visited plus5

rename 	q107	mkts_type
label define mrkt 1 "Village market" 2 "Neighboring village market" 3 "Town market" 4 "Roadside market" 5 "Other" 
label value mkts_type mrkt

rename 	q107_5_text	mkts_type_other
rename 	q108	mkts_trans
label define trans 1 "Walk" 2 "Bike" 3 "Own car" 4 "Own motorbike" 5 "Taxi" 7 "Bus" 6 "Other" 
label value mkts_trans trans 
rename 	q108_6_text	mkts_trans_other 

rename 	q109_1	days_less_prefer
rename 	q109_2	days_borrow_food
rename 	q109_6	days_limit
rename 	q109_8	days_restrict
rename 	q109_13	days_reduce
rename 	q1010	sharing 
replace sharing=0 if sharing==4 
yesno sharing 

rename 	q1011_1_1	food_supplied
rename 	q1011_1_2	food_received
rename 	q1011_5_1	maize_supplied
rename 	q1011_5_2	maize_received
rename 	q1011_2_1	nonfood_supplied
rename 	q1011_2_2	nonfood_received
rename 	q1011_3_1	livestock_supplied
rename 	q1011_3_2	livestock_received
rename 	q1011_4_1	labor_supplied
rename 	q1011_4_2	labor_received 

label variable 	cook_person	"Person who is in charge of cooking answered these questions"
label variable 	enough_food	"In 7 days were there times there was not enough food in the house"
label variable 	maize_consu_harvest	"Amount in kgs of household maize consumption"
foreach food in maize rice sorghum millet wheat_bread irish_potato carrot leafy_veg other_vegetable fruit other_fruit chicken beef goat pork other_meat ///
insect egg fish beans milk alcohol oil sweets spice_beverage {
*eat
label variable eat_`food'_days "Number of days consumed `food'"
*Main source	
label variable source_`food' "Main source of `food'"
*secondary source
label variable Ssource_`food' "Secondary source of `food'"
}
label variable 	mkts_visited	"In a month number of different markets visited"
label variable 	mkts_type	"Type of market purchased food from"
label variable 	mkts_type_other	"Type of market purchased food from (other)"
label variable 	mkts_trans	"Mode of transportation to get to/from market"
label variable 	mkts_trans_other 	"Mode of transportation to get to/from market (other)"
label variable 	days_less_prefer	"Number of days rely on less prefered food"
label variable 	days_borrow_food	"Number of days borrowed food"
label variable 	days_limit	"Number of days limit portion size"
label variable 	days_restrict	"Number of days restrict food of adults"
label variable 	days_reduce	"Number of days reduced meals"
label variable 	sharing 	"Did household share food maize livestock etc."
label variable 	food_supplied	"Supplied food "
label variable 	food_received	"Received food"
label variable 	maize_supplied	"Supplied maize"
label variable 	maize_received	"Received maize"
label variable 	nonfood_supplied	"Supplied nonfood"
label variable 	nonfood_received	"Received nonfood"
label variable 	livestock_supplied	"Supplied livestock"
label variable 	livestock_received	"Received livestock"
label variable 	labor_supplied	"Supplied labor"
label variable 	labor_received 	"Received labor"


*********************************************************************
/* Section 18: Army Worms and Invasive Species*/
*********************************************************************
*Q18.1 
*What type of invasive species? 
rename q181 invasive_type
label var invasive_type "Type of invasive species"
rename q181_6_text invasive_other
label var invasive_other "Type of invasive species - text"

*18.2 week, month and year of armyworm invasion
rename q182_1 army_week
label var army_week "Week when the HH saw the armyworm"
destring army_week, replace 


rename q182_4 army_mnth
label var army_mnth "Month when the HH saw the armyworms"

replace army_mnth="." if army_mnth=="0" 
replace army_mnth="." if army_mnth=="13" 
replace army_mnth="1" if army_mnth=="January " | army_mnth=="January" | army_mnth=="Jan"
replace army_mnth="2" if army_mnth=="Fe" | army_mnth=="February " | army_mnth=="February"
replace army_mnth="3" if army_mnth=="March" | army_mnth=="March " 
replace army_mnth="11" if army_mnth=="November " | army_mnth=="November  " | army_mnth==" November "
replace army_mnth="12" if army_mnth=="December"  | army_mnth=="December "  
destring army_mnth, replace 

rename q182_5 army_year
label var army_year "Year when the HH saw the armyworms"

replace army_year = "2019" if army_year == "209"
replace army_year = "2019" if army_year == "3019"
replace army_year = "2018" if army_year == "December"
destring army_year, replace 

*18.3 Armyworm in which crop
rename q183 AW_crop
rename q183_8_text AW_crop_other
label var AW_crop "Crop affected by armyworm"
label var AW_crop_other "Crop affected by armyworm - other"

*18.4 Stage of the crop
rename q184 AW_stage
label var AW_stage "Stage of the crop affected by armyworm"

*18.5 Intensity of damage
rename q185 army_aff
label var army_aff "The intensity of damage by armyworms"
recode army_aff 4=1
recode army_aff 5=2
recode army_aff 6=3
recode army_aff 7=4
recode army_aff 8=5
label define army_aff 1 "0 to 10%" 2 "10-25%" 3 "25-50%" 4 "50-75%" 5 "75-100%"

*18.6 Treatment
rename q186 AW_treatment
rename q186_5_text AW_treatment_other
label var AW_treatment "Armyworm treatment"
label var AW_treatment_other "Armyworm treatment - other"

*18.7 Type of pesticide
rename q187 AW_pesticide_type
rename q187_8_text AW_pesticide_other
label var AW_pesticide_type "Type of pesticide used"
label var AW_pesticide_other "Type of pesticide used - other"


*18.8 Where did you get the pesticide
rename q188 where_pesticide 
rename q188_9_text where_pesticide_other
label var where_pesticide "Where did you buy the pesticide"
label var where_pesticide_other "Where did you buy the pesticide - other"

*18.9 How much did you spend?
rename q189 kwacha_pesticide 
label var kwacha_pesticide "How much did you spend on pesticide?"

*18.10 Where did you apply pesticide the first time you sprayed
rename q1810 first_pest_application
label var first_pest_application "Where did you apply the first time you sprayed"

*18.11 how many times
rename q1811 spray_times
label var spray_times "How many times did you spray"
**recode values to make sense 
recode spray_times 1=0 
recode spray_times 11=1
recode spray_times 4=2
recode spray_times 3=10 
recode spray_times 5=3 
recode spray_times 6=4 
recode spray_times 7=5 
recode spray_times 8=6 
recode spray_times 9=7 
recode spray_times 10=8 
recode spray_times 2=9 
label define ten 10 "10+"
label values spray_times ten 

*18.12 Date of the first pesticide application
rename q1812_1 pesticide_week
rename q1812_4 pesticide_month
rename q1812_5 pesticide_year
label var pesticide_week "Date of the first pesticide application - week"
label var pesticide_month "Date of the first pesticide application - month"
label var pesticide_year "Date of the first pesticide application - year"
replace pesticide_week = "." if pesticide_week == "Ae"
replace pesticide_month = "12" if pesticide_month == "December" | pesticide_month == "December "
replace pesticide_month = "1" if pesticide_month == "January" | pesticide_month == "January "
replace pesticide_month = "2" if pesticide_month == "February" | pesticide_month == "February "
replace pesticide_month = "3" if pesticide_month == "March" | pesticide_month == "March "
destring pesticide_week pesticide_month pesticide_year, replace

*18.13 equipment
rename q1813 wear_equipment_pest
rename q1813_7_text wear_equipment_other
label var wear_equipment_pest "Was any of the following protective equipment worn when spraying pesticides?"
label var wear_equipment_other "Was any of the following protective equipment worn when spraying pesticides? - other"

*18.14 Effectiveness
rename q1814 pesticide_effective
label var pesticide_effective "How effective were the pesticides in eradicating Fall Armyworms from your fields?"

*18.15 reason for not using pesticides
rename q1815 reason_nopest 
rename q1815_8_text reason_nopest_other 
label var reason_nopest "Why did you not use pesticide to treat for Fall Armyworms?"
label var reason_nopest_other "Why did you not use pesticide to treat for Fall Armyworms? - other"

*18.16 armyworm present season 17/18
rename q1816 AW_previous 
label var AW_previous "Were Fall Armyworms present in your fields during the 2017/18 growing season?"
replace AW_previous = 0 if AW_previous == 3
yesno AW_previous

*18.17 damage comparison
rename q1817 damage_comp 
label var damage_comp "how much damage did the Fall Armyworm cause to your fields this year?"

*18.18 ability controlling armyworm
rename q1818 AW_ability 
label var AW_ability "how well were you able to control the damage of Fall Armyworms this year?"

*18.20 armyworm next season 19/20
rename q1820 AW_next_season 
label var AW_next_season "Do you think your farm will be affected by Fall Armyworms in the 2019-2020 growing season?"

*18.21 armyworm impact level
rename q1821 impact_next_season 
label var impact_next_season "How impactful do you think the Fall Armyworm outbreak will be in the coming growing season (2019-2020)?"

*18.22 Practices next season to mitigate armyworm
rename q1822 AW_next_practices
rename q1822_7_text AW_next_practices_other 
label var AW_next_practices "To mitigate the impact of the Fall Armyworm in the coming growing season (2019-2020) do you plan to do any of the following"
label var AW_next_practices_other "To mitigate the impact of the Fall Armyworm in the coming growing season (2019-2020) do you plan to do any of the following - other"

*18.24 Sunflower plant knowledge
rename q1824 sunflower_knowledge
yesno sunflower_knowledge
label var sunflower_knowledge "Are you familiar with the wild sunflower plant?"

*18.25 Sunflower present in your field
rename q1825 sunflower_present 
label var sunflower_present "Is the wild sunflower plant present in any of your agricultural fields?"

*18.26 Have you seen the sunflower in the area
rename q1826 sunflower_area 
label var sunflower_area "Have you seen the wild sunflower plant in other farmer's fields or in this general area?"

*18.28 Training armyworm 
rename q1828 no_of_trainings
label var no_of_trainings "In the last 12 months how many times has you HH member attended training by the govt extension officers"

*18.29 Training from seed companies
rename q1829 seed_companies
label var seed_companies "How many times has any HH member attended training by seed companies?"

*18.30 In the last 12 month, how beneficial was advice, training, or information about Fall Armyworms to your farming practices? 
rename q1830  training_gov
label define training 1 "Substantial benefit" 2 "Some benefit" 3 "No benefit" 5 "No advice, training info given" 
label value training_gov training 
label var training_gov "In the last 12 month, how beneficial was advice, training, or information about Fall Armyworms to your farming practices?"
 
 

*********************************************************************
/* Section 11: Land*/
*********************************************************************


rename v446 farmland
rename v447 title_land
rename v448 cultivown_land
rename v449 fallow_land
rename v450 fallow_reason
rename q116_6_text fallow_reason_text
rename v452 rentfrom_land
rename v453 rentto_land

*label vars
label var farmland "Total area of farm land"
label var title_land "Area of land titled by state" 
label var cultivown_land "Total area of cultivated land" 
label var fallow_land "Total area of fallowed land"
label var fallow_reason "Fallowed land reasons"
label var fallow_reason_text "Fallowed land reason - Text"
label var rentfrom_land "Area of land rented FROM somone" 
label var rentto_land "Area of land rented TO someone"



*********************************************************************
/* Section 12: Maize Plantings Starter */
*********************************************************************
                  

rename q122 grewmaize
rename q123 able_preferred_date
rename q124 not_able_reason
rename q124_4_text not_able_reason_text
rename q125 shift_planting
rename q126 plantnum
rename v460 cult_1
rename v461 plnt_1
rename v462 fert_1
rename v463 weed_1
rename v464 harv_1
rename q128 armyworm_present

foreach i in cult_1 plnt_1 fert_1 weed_1 harv_1 armyworm_present {
	yesno `i' 
	}
	
label var	cult_1	"Planting 1: Outside labor cultivating"
label var	plnt_1	"Planting 1: Outside labor planting "
label var	fert_1	"Planting 1: Outside labor fertilizing "
label var	weed_1	"Planting 1: Outside labor weeding "
label var	harv_1	"Planting 1: Outside labor harvesting "


*label vars
label var plantnum "Number of plantings"
label var grewmaize "HH grew maize"
label var able_preferred_date "Able to plant on preferred date - Y/N"
label var not_able_reason "Reasons for not planting on preferred dates un-parsed"
label var not_able_reason_text "Reason for not planting on preferred dates - Text"
label var shift_planting "Weeks planting has to be moved" 
label var armyworm_present "Were Fall armyworms present within any of your plantings during this agricultural year 2018/19?"

*merge variables from dif columns to one and label values
label define yesno 1 "Yes" 0 "No"

foreach var in grewmaize able_preferred_date {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	

label define planting_shift 1 "Move later by one week" 2 "Move later by two weeks" 3 "Move later by three weeks" 4 "Move later by four weeks" ///
5 "Move later by five weeks" 6 "Move earlier by one weeks" 7 "Move earlier by two weeks" 8 "Move earlier by three weeks" 
label values shift_planting planting_shift

*********************************************************************
/* Section 13: Maize Plantings 1 */
*********************************************************************

*rename
rename q132 date_1
rename q133 reason_1
rename q133_5_text reason_txt_1
rename q134 company_1
rename q135 seed_co_1
rename q136 mri_1
rename q137 pioneer_1
rename q138 pannar_1
rename q139 zamseed_1
rename q1310 dekalb_1
rename q1311_4 seed_week_1 
rename q1311_5 seed_month_1
rename q1311_6 seed_year_1
rename q1312 seed_acq_1
rename q1312_8_text seed_acq_txt_1
rename q1313 recycl_1
rename q1314 second_1
rename q1315 replnt_1
rename q1316 fseed_1
rename q1317 qseed_1
rename q1318 plot_1
rename q1319 qharv_1
rename q1320 army_1
rename q1321 qharv_army_1
rename q1322 grn_1
rename q1322_1_text grn_txt_1
rename q1323 ferts_1
rename q1323_5_text ferts_txt_1
rename q1324 qbasal_1
rename q1325 qtop_1
rename q1326 inter_1
rename q1327 inter_crop_1
rename q1327_24_text inter_crop_txt_1

*change values to match previous year options
replace company_1 = 10 if company_1 == 13
replace company_1 = 11 if company_1 == 9
replace company_1 = 13 if company_1 == 15
replace mri_1 = 18 if mri_1 == 19
replace pannar_1 = 10 if pannar_1 == 16	
replace zamseed_1 = 2 if zamseed_1 == 16
replace zamseed_1 = 11 if zamseed_1 == 17	

*label vars
label var date_1 "Planting 1: Date of planting"
label var reason_1 "Planting 1: Reasons for planting on that date 1"
label var reason_txt_1 "Planting 1: Reasons for planting on that date - Text"
label var company_1 "Planting 1: Seed company "
label var seed_co_1 "Planting 1: Seedco variety"
label var mri_1 "Planting 1: MRI variety"
label var pioneer_1 "Planting 1: Pioneer variety"
label var pannar_1 "Planting 1: Pannar variety"
label var zamseed_1 "Planting 1: Zamseed variety"
label var dekalb_1 "Planting 1: Dekalb variety"
label var recycl_1 "Planting 1: Used Recycled seed"
label var second_1 "Planting 1: Second seed variety"
label var replnt_1 "Planting 1: Was this a replanting"
label var fseed_1 "Planting 1:  FISP or E-voucher seeds"
label var qseed_1 "Planting 1: Kgs of seeds planted"
label var plot_1 "Planting 1: Size of plot in ha"
label var qharv_1 "Planting 1: Harvest in kgs"
label var grn_1 "Planting 1: kgs of harvested green maize "
label var grn_txt_1 "Planting 1: kgs of harvested green maize - Text"
label var ferts_1 "Planting 1: Types of fertilizer " 
label var qbasal_1 "Planting 1: Kgs of basal dressing"
label var qtop_1 "Planting 1: kgs of top dressing fertilizer"
label var inter_1 "Planting 1: Intercrop"

*Label values
label define dates ///
	1 "4th week of October" ///
	2 "1st week of November" ///
	3 "2nd week of November"  ///
	4 "3rd week of November"  ///
	5 "4th week of November"  ///
	6 "1st week of December"  ///
	7 "2nd week of December"  ///
	8 "3rd week of December"  ///
	9 "4th week of December"  ///
	10 "1st week of January"  ///
	11 "2nd week of January"  ///
	12 "3rd week of January" 

label values date_1 dates

*Seed companies and variety labels
label define seed_company ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other hybrid" ///
	11 "Local maize" ///
	13 "Unknown local"

label values company_1 seed_company

label define seed_co_var ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo"


	
label define mri_var ///
	10 "MRI 455" ///
	1 "MRI 514" ///
	2 "MRI 594" ///
	11 "SY 5944" ///
	3 "MRI 614" ///
	4 "MRI 624" ///
	5 "MRI 634" ///
	12 "MRI 644" ///
	6 "MRI 654" ///
	7 "MRI 694" ///
	8 "MRI 704" ///
	9 "MRI 714" ///
	13 "MRI 724" ///
	14 "MRI 734" ///
	15 "MRI 744" ///
	16 "MRI 651" ///
	17 "MRI 711" ///
	18 "Other MRI"
	

label define pioneer_var ///
		1 "PHB 30G19" ///
		2 "PHB 3253" ///
		3 "P3812W" ///
		4 "P2859W" ///
		5 "P3506W" ///
		6 "PHB 30B50" ///
		7 "Other Pioneer"


		
label define pannar_var ///
	1 "PAN 4M-21" ///
	2 "PAN 6227" ///
	3 "PAN 12" ///
	4 "PAN 14" ///
	5 "PAN 53" ///
	6 "PAN 61" ///
	7 "PAN 6777" ///
	8 "PAN 6P-110" ///
	9 "PAN 7M-89" ///
	10 "PAN 8M-91" ///
	11 "PAN 8M-93" ///
	12 "Other Pannar" ///
	13 "PAN 413"
	

label define zamseed_var ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	12 "ZMS 702" ///
	11 "ZMS 717" ///
	13 "ZMS 720" ///
	6 "ZMS 607Y" ///
	15 "Other Zamseed"

label define dekalb_var ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb"
	
	
label values seed_co_1 seed_co_var
label values mri_1 mri_var
label values pioneer_1 pioneer_var
label values pannar_1 pannar_var
label values zamseed_1 zamseed_var
label values dekalb_1 dekalb_var

label define fisp_val 1 "Traditional FISP" 2 "FISP e-voucher" 3 "Neither"

foreach var in recycl_1 replnt_1 inter_1 {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
foreach var in second_1 {
	replace `var' = 0 if `var' == 74
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	


foreach var in fseed_1 {
	replace `var' = 0 if `var' == 1
	replace `var' = 1 if `var' == 2
	replace `var' = 2 if `var' == 3
	label values `var' fisp_val
	}	
	
foreach var in grn_1 {
	replace `var' = 0 if `var' == 9
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	

label var seed_week_1 "Planting 1: When was this seed acquired? - week"
label var seed_month_1 "Planting 1: When was this seed acquired? - month"
label var seed_year_1 "Planting 1: When was this seed acquired? - year"
label var seed_acq_1 "Planting 1: Where was it acquired?"
label var seed_acq_txt_1 "Planting 1: Where was it acquired? - other"
label var army_1 "Planting 1: Were fall army worms present in this planting?"
yesno army_1
label var qharv_army_1 "Planting 1: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be" 
label var ferts_txt_1 "Planting 1: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be - other"
label var inter_crop_1 "Planting 1: With what crop did you intercrop?"
label var inter_crop_txt_1 "Planting 1: With what crop did you intercrop? - other"

foreach var in date_1 company_1 seed_co_1 mri_1 pioneer_1 pannar_1 zamseed_1 dekalb_1 {
	tab `var'
	}


	
*********************************************************************
/* Section 14: Maize Plantings 2 */
*********************************************************************
*rename
rename q142 date_2
rename q143 reason_2
rename q143_5_text reason_txt_2
rename q144 company_2
rename q145 seed_co_2
rename q146 mri_2
rename q147 pioneer_2
rename q148 pannar_2
rename q149 zamseed_2
rename q1410 dekalb_2
rename q1411_4 seed_week_2 
rename q1411_5 seed_month_2
rename q1411_6 seed_year_2
rename q1412 seed_acq_2
rename q1412_8_text seed_acq_txt_2
rename q1413 recycl_2
rename q1414 second_2
rename q1415 replnt_2
rename q1416 fseed_2
rename q1417 qseed_2
rename q1418 plot_2
rename q1419 qharv_2
rename q1420 army_2
rename q1421 qharv_army_2
rename q1422 grn_2
rename q1422_1_text grn_txt_2
rename q1423 ferts_2
rename q1423_5_text ferts_txt_2
rename q1424 qbasal_2
rename q1425 qtop_2
rename q1426 inter_2
rename q1427 inter_crop_2
rename q1427_24_text inter_crop_txt_2

*change values to match previous year options
replace company_2 = 10 if company_2 == 13
replace company_2 = 11 if company_2 == 9
replace company_2 = 13 if company_2 == 15
replace mri_2 = 18 if mri_2 == 19
replace pannar_2 = 10 if pannar_2 == 16	
replace zamseed_2 = 2 if zamseed_2 == 16
replace zamseed_2 = 11 if zamseed_2 == 17	
replace pannar_2 = 11 if pannar_2 == 17  

*label vars
label var date_2 "Planting 2: Date of planting"
label var reason_2 "Planting 2: Reasons for planting on that date 1"
label var reason_txt_2 "Planting 2: Reasons for planting on that date - Text"
label var company_2 "Planting 2: Seed company "
label var seed_co_2 "Planting 2: Seedco variety"
label var mri_2 "Planting 2: MRI variety"
label var pioneer_2 "Planting 2: Pioneer variety"
label var pannar_2 "Planting 2: Pannar variety"
label var zamseed_2 "Planting 2: Zamseed variety"
label var dekalb_2 "Planting 2: Dekalb variety"
label var recycl_2 "Planting 2: Used Recycled seed"
label var second_2 "Planting 2: Second seed variety"
label var replnt_2 "Planting 2: Was this a replanting"
label var fseed_2 "Planting 2:  FISP or E-voucher seeds"
label var qseed_2 "Planting 2: Kgs of seeds planted"
label var plot_2 "Planting 2: Size of plot in ha"
label var qharv_2 "Planting 2: Harvest in kgs"
label var grn_2 "Planting 2: kgs of harvested green maize "
label var grn_txt_2 "Planting 2: kgs of harvested green maize - Text"
label var ferts_2 "Planting 2: Types of fertilizer " 
label var qbasal_2 "Planting 2: Kgs of basal dressing"
label var qtop_2 "Planting 2: kgs of top dressing fertilizer"
label var inter_2 "Planting 2: Intercrop"

*Label values
label define dates_2 ///
	1 "4th week of October" ///
	2 "1st week of November" ///
	3 "2nd week of November"  ///
	4 "3rd week of November"  ///
	5 "4th week of November"  ///
	6 "1st week of December"  ///
	7 "2nd week of December"  ///
	8 "3rd week of December"  ///
	9 "4th week of December"  ///
	10 "1st week of January"  ///
	11 "2nd week of January"  ///
	12 "3rd week of January" 

label values date_2 dates_2

*Seed companies and variety labels
label define seed_company_2 ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other hybrid" ///
	11 "Local maize" ///
	13 "Unknown local"

label values company_2 seed_company_2

label define seed_co_var_2 ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo"

label define mri_var_2 ///
	10 "MRI 455" ///
	1 "MRI 514" ///
	2 "MRI 594" ///
	11 "SY 5944" ///
	3 "MRI 614" ///
	4 "MRI 624" ///
	5 "MRI 634" ///
	12 "MRI 644" ///
	6 "MRI 654" ///
	7 "MRI 694" ///
	8 "MRI 704" ///
	9 "MRI 714" ///
	13 "MRI 724" ///
	14 "MRI 734" ///
	15 "MRI 744" ///
	16 "MRI 651" ///
	17 "MRI 711" ///
	18 "Other MRI"

label define pioneer_var_2 ///
		1 "PHB 30G19" ///
		2 "PHB 3253" ///
		3 "P3812W" ///
		4 "P2859W" ///
		5 "P3506W" ///
		6 "PHB 30B50" ///
		7 "Other Pioneer"

label define pannar_var_2 ///
	1 "PAN 4M-21" ///
	2 "PAN 6227" ///
	3 "PAN 12" ///
	4 "PAN 14" ///
	5 "PAN 53" ///
	6 "PAN 61" ///
	7 "PAN 6777" ///
	8 "PAN 6P-110" ///
	9 "PAN 7M-89" ///
	10 "PAN 8M-91" ///
	11 "PAN 8M-93" ///
	12 "Other Pannar" ///
	13 "PAN 413"

label define zamseed_var_2 ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	12 "ZMS 702" ///
	11 "ZMS 717" ///
	13 "ZMS 720" ///
	6 "ZMS 607Y" ///
	15 "Other Zamseed"

label define dekalb_var_2 ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb"
	
	
label values seed_co_2 seed_co_var_2
label values mri_2 mri_var_2
label values pioneer_2 pioneer_var_2
label values pannar_2 pannar_var_2
label values zamseed_2 zamseed_var_2
label values dekalb_2 dekalb_var_2


label define fisp_val_2 1 "Traditional FISP" 2 "FISP e-voucher" 3 "Neither"

foreach var in recycl_2 replnt_2 inter_2 {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
foreach var in second_2 {
	replace `var' = 0 if `var' == 74
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	


foreach var in fseed_2 {
	replace `var' = 0 if `var' == 1
	replace `var' = 1 if `var' == 2
	replace `var' = 2 if `var' == 3
	label values `var' fisp_val_2
	}	
	
foreach var in grn_2 {
	replace `var' = 0 if `var' == 9
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	

label var seed_week_2 "Planting 2: When was this seed acquired? - week"
label var seed_month_2 "Planting 2: When was this seed acquired? - month"
label var seed_year_2 "Planting 2: When was this seed acquired? - year"
label var seed_acq_2 "Planting 2: Where was it acquired?"
label var seed_acq_txt_2 "Planting 2: Where was it acquired? - other"
label var army_2 "Planting 2: Were fall army worms present in this planting?"
yesno army_2
label var qharv_army_2 "Planting 2: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be" 
label var ferts_txt_2 "Planting 2: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be - other"
label var inter_crop_2 "Planting 2: With what crop did you intercrop?"
label var inter_crop_txt_2 "Planting 2: With what crop did you intercrop? - other"	



foreach var in date_2 company_2 seed_co_2 mri_2 pioneer_2 pannar_2 zamseed_2 dekalb_2 {
	tab `var'
	}

*********************************************************************
/* Section 15: Maize Plantings 3 */
*********************************************************************
*rename
rename q152 date_3
rename q153 reason_3
rename q153_5_text reason_txt_3
rename q154 company_3
rename q155 seed_co_3
rename q156 mri_3
rename q157 pioneer_3
rename q158 pannar_3
rename q159 zamseed_3
rename q1510 dekalb_3
rename q1511_4 seed_week_3 
rename q1511_5 seed_month_3
rename q1511_6 seed_year_3
rename q1512 seed_acq_3
rename q1512_8_text seed_acq_txt_3
rename q1513 recycl_3
rename q1514 second_3
rename q1515 replnt_3
rename q1516 fseed_3
rename q1517 qseed_3
rename q1518 plot_3
rename q1519 qharv_3
rename q1520 army_3
rename q1521 qharv_army_3
rename q1522 grn_3
rename q1522_1_text grn_txt_3
rename q1523 ferts_3
rename q1523_5_text ferts_txt_3
rename q1524 qbasal_3
rename q1525 qtop_3
rename q1526 inter_3
rename q1527 inter_crop_3
rename q1527_24_text inter_crop_txt_3

*change values to match previous year options
replace company_3 = 10 if company_3 == 13
replace company_3 = 11 if company_3 == 9
replace company_3 = 13 if company_3 == 15
replace mri_3 = 18 if mri_3 == 19
replace pannar_3 = 10 if pannar_3 == 16	
replace zamseed_3 = 2 if zamseed_3 == 16
replace zamseed_3 = 11 if zamseed_3 == 17	
replace pannar_3 = 11 if pannar_3 == 17  

*label vars
label var date_3 "Planting 3: Date of planting"
label var reason_3 "Planting 3: Reasons for planting on that date 1"
label var reason_txt_3 "Planting 3: Reasons for planting on that date - Text"
label var company_3 "Planting 3: Seed company "
label var seed_co_3 "Planting 3: Seedco variety"
label var mri_3 "Planting 3: MRI variety"
label var pioneer_3 "Planting 3: Pioneer variety"
label var pannar_3 "Planting 3: Pannar variety"
label var zamseed_3 "Planting 3: Zamseed variety"
label var dekalb_3 "Planting 3: Dekalb variety"
label var recycl_3 "Planting 3: Used Recycled seed"
label var second_3 "Planting 3: Second seed variety"
label var replnt_3 "Planting 3: Was this a replanting"
label var fseed_3 "Planting 3:  FISP or E-voucher seeds"
label var qseed_3 "Planting 3: Kgs of seeds planted"
label var plot_3 "Planting 3: Size of plot in ha"
label var qharv_3 "Planting 3: Harvest in kgs"
label var grn_3 "Planting 3: kgs of harvested green maize "
label var grn_txt_3 "Planting 3: kgs of harvested green maize - Text"
label var ferts_3 "Planting 3: Types of fertilizer " 
label var qbasal_3 "Planting 3: Kgs of basal dressing"
label var qtop_3 "Planting 3: kgs of top dressing fertilizer"
label var inter_3 "Planting 3: Intercrop"

*Label values
label define dates_3 ///
	1 "4th week of October" ///
	2 "1st week of November" ///
	3 "2nd week of November"  ///
	4 "3rd week of November"  ///
	5 "4th week of November"  ///
	6 "1st week of December"  ///
	7 "2nd week of December"  ///
	8 "3rd week of December"  ///
	9 "4th week of December"  ///
	10 "1st week of January"  ///
	11 "2nd week of January"  ///
	12 "3rd week of January" 

label values date_3 dates_3


*Seed companies and variety labels
label define seed_company_3 ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other hybrid" ///
	11 "Local maize" ///
	13 "Unknown local"

label values company_3 seed_company_3

label define seed_co_var_3 ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo"

label define mri_var_3 ///
	10 "MRI 455" ///
	1 "MRI 514" ///
	2 "MRI 594" ///
	11 "SY 5944" ///
	3 "MRI 614" ///
	4 "MRI 624" ///
	5 "MRI 634" ///
	12 "MRI 644" ///
	6 "MRI 654" ///
	7 "MRI 694" ///
	8 "MRI 704" ///
	9 "MRI 714" ///
	13 "MRI 724" ///
	14 "MRI 734" ///
	15 "MRI 744" ///
	16 "MRI 651" ///
	17 "MRI 711" ///
	18 "Other MRI"

label define pioneer_var_3 ///
		1 "PHB 30G19" ///
		2 "PHB 3253" ///
		3 "P3812W" ///
		4 "P2859W" ///
		5 "P3506W" ///
		6 "PHB 30B50" ///
		7 "Other Pioneer"

label define pannar_var_3 ///
	1 "PAN 4M-21" ///
	2 "PAN 6227" ///
	3 "PAN 12" ///
	4 "PAN 14" ///
	5 "PAN 53" ///
	6 "PAN 61" ///
	7 "PAN 6777" ///
	8 "PAN 6P-110" ///
	9 "PAN 7M-89" ///
	10 "PAN 8M-91" ///
	11 "PAN 8M-93" ///
	12 "Other Pannar" ///
	13 "PAN 413"

label define zamseed_var_3 ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	12 "ZMS 702" ///
	11 "ZMS 717" ///
	13 "ZMS 720" ///
	6 "ZMS 607Y" ///
	15 "Other Zamseed"

label define dekalb_var_3 ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb"
	
	
label values seed_co_3 seed_co_var_3
label values mri_3 mri_var_3
label values pioneer_3 pioneer_var_3
label values pannar_3 pannar_var_3
label values zamseed_3 zamseed_var_3
label values dekalb_3 dekalb_var_3


label define fisp_val_3 1 "Traditional FISP" 2 "FISP e-voucher" 3 "Neither"

foreach var in recycl_3 replnt_3 inter_3 {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
foreach var in second_3 {
	replace `var' = 0 if `var' == 74
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	


foreach var in fseed_3 {
	replace `var' = 0 if `var' == 1
	replace `var' = 1 if `var' == 2
	replace `var' = 2 if `var' == 3
	label values `var' fisp_val_3
	}	
	
foreach var in grn_3 {
	replace `var' = 0 if `var' == 9
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	

label var seed_week_3 "Planting 3: When was this seed acquired? - week"
label var seed_month_3 "Planting 3: When was this seed acquired? - month"
label var seed_year_3 "Planting 3: When was this seed acquired? - year"
label var seed_acq_3 "Planting 3: Where was it acquired?"
label var seed_acq_txt_3 "Planting 3: Where was it acquired? - other"
label var army_3 "Planting 3: Were fall army worms present in this planting?"
yesno army_3
label var qharv_army_3 "Planting 3: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be" 
label var ferts_txt_3 "Planting 3: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be - other"
label var inter_crop_3 "Planting 3: With what crop did you intercrop?"
label var inter_crop_txt_3 "Planting 3: With what crop did you intercrop? - other"	
	
foreach var in date_3 company_3 seed_co_3 mri_3 pioneer_3 pannar_3 zamseed_3 dekalb_3 {
	tab `var'
	}	

*********************************************************************
/* Section 16: Maize Plantings 4 */
*********************************************************************
*rename
rename q162 date_4
rename q163 reason_4
rename q163_5_text reason_txt_4
rename q164 company_4
rename q165 seed_co_4
rename q166 mri_4
rename q167 pioneer_4
rename q168 pannar_4
rename q169 zamseed_4
rename q1610 dekalb_4
rename q1611_4 seed_week_4 
rename q1611_5 seed_month_4
rename q1611_6 seed_year_4
rename q1612 seed_acq_4
rename q1612_8_text seed_acq_txt_4
rename q1613 recycl_4
rename q1614 second_4
rename q1615 replnt_4
rename q1616 fseed_4
rename q1617 qseed_4
rename q1618 plot_4
rename q1619 qharv_4
rename q1620 army_4
rename q1621 qharv_army_4
rename q1622 grn_4
rename q1622_1_text grn_txt_4
rename q1623 ferts_4
rename q1623_5_text ferts_txt_4
rename q1624 qbasal_4
rename q1625 qtop_4
rename q1626 inter_4
rename q1627 inter_crop_4
rename q1627_24_text inter_crop_txt_4


*change values to match previous year options
replace company_4 = 10 if company_4 == 13
replace company_4 = 11 if company_4 == 9
replace company_4 = 13 if company_4 == 15
replace mri_4 = 18 if mri_4 == 19
replace pannar_4 = 10 if pannar_4 == 16	
replace zamseed_4 = 2 if zamseed_4 == 16
replace zamseed_4 = 11 if zamseed_4 == 17	
replace pannar_4 = 11 if pannar_4 == 17  

*label vars
label var date_4 "Planting 4: Date of planting"
label var reason_4 "Planting 4: Reasons for planting on that date 1"
label var reason_txt_4 "Planting 4: Reasons for planting on that date - Text"
label var company_4 "Planting 4: Seed company "
label var seed_co_4 "Planting 4: Seedco variety"
label var mri_4 "Planting 4: MRI variety"
label var pioneer_4 "Planting 4: Pioneer variety"
label var pannar_4 "Planting 4: Pannar variety"
label var zamseed_4 "Planting 4: Zamseed variety"
label var dekalb_4 "Planting 4: Dekalb variety"
label var recycl_4 "Planting 4: Used Recycled seed"
label var second_4 "Planting 4: Second seed variety"
label var replnt_4 "Planting 4: Was this a replanting"
label var fseed_4 "Planting 4:  FISP or E-voucher seeds"
label var qseed_4 "Planting 4: Kgs of seeds planted"
label var plot_4 "Planting 4: Size of plot in ha"
label var qharv_4 "Planting 4: Harvest in kgs"
label var grn_4 "Planting 4: kgs of harvested green maize "
label var grn_txt_4 "Planting 4: kgs of harvested green maize - Text"
label var ferts_4 "Planting 4: Types of fertilizer " 
label var qbasal_4 "Planting 4: Kgs of basal dressing"
label var qtop_4 "Planting 4: kgs of top dressing fertilizer"
label var inter_4 "Planting 4: Intercrop"

*Label values
label define dates_4 ///
	1 "4th week of October" ///
	2 "1st week of November" ///
	3 "2nd week of November"  ///
	4 "3rd week of November"  ///
	5 "4th week of November"  ///
	6 "1st week of December"  ///
	7 "2nd week of December"  ///
	8 "3rd week of December"  ///
	9 "4th week of December"  ///
	10 "1st week of January"  ///
	11 "2nd week of January"  ///
	12 "3rd week of January" 

label values date_4 dates_4

*Seed companies and variety labels
label define seed_company_4 ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other hybrid" ///
	11 "Local maize" ///
	13 "Unknown local"

label values company_4 seed_company_4

label define seed_co_var_4 ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo"

label define mri_var_4 ///
	10 "MRI 455" ///
	1 "MRI 514" ///
	2 "MRI 594" ///
	11 "SY 5944" ///
	3 "MRI 614" ///
	4 "MRI 624" ///
	5 "MRI 634" ///
	12 "MRI 644" ///
	6 "MRI 654" ///
	7 "MRI 694" ///
	8 "MRI 704" ///
	9 "MRI 714" ///
	13 "MRI 724" ///
	14 "MRI 734" ///
	15 "MRI 744" ///
	16 "MRI 651" ///
	17 "MRI 711" ///
	18 "Other MRI"

label define pioneer_var_4 ///
		1 "PHB 30G19" ///
		2 "PHB 3253" ///
		3 "P3812W" ///
		4 "P2859W" ///
		5 "P3506W" ///
		6 "PHB 30B50" ///
		7 "Other Pioneer"

label define pannar_var_4 ///
	1 "PAN 4M-21" ///
	2 "PAN 6227" ///
	3 "PAN 12" ///
	4 "PAN 14" ///
	5 "PAN 53" ///
	6 "PAN 61" ///
	7 "PAN 6777" ///
	8 "PAN 6P-110" ///
	9 "PAN 7M-89" ///
	10 "PAN 8M-91" ///
	11 "PAN 8M-93" ///
	12 "Other Pannar" ///
	13 "PAN 413"

label define zamseed_var_4 ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	12 "ZMS 702" ///
	11 "ZMS 717" ///
	13 "ZMS 720" ///
	6 "ZMS 607Y" ///
	15 "Other Zamseed"

label define dekalb_var_4 ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb"
	
	
label values seed_co_4 seed_co_var_4
label values mri_4 mri_var_4
label values pioneer_4 pioneer_var_4
label values pannar_4 pannar_var_4
label values zamseed_4 zamseed_var_4
label values dekalb_4 dekalb_var_4


label define fisp_val_4 1 "Traditional FISP" 2 "FISP e-voucher" 3 "Neither"

foreach var in recycl_4 replnt_4 inter_4 {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
foreach var in second_4 {
	replace `var' = 0 if `var' == 74
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	


foreach var in fseed_4 {
	replace `var' = 0 if `var' == 1
	replace `var' = 1 if `var' == 2
	replace `var' = 2 if `var' == 3
	label values `var' fisp_val_4
	}	
	
foreach var in grn_4 {
	replace `var' = 0 if `var' == 9
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	

label var seed_week_4 "Planting 4: When was this seed acquired? - week"
label var seed_month_4 "Planting 4: When was this seed acquired? - month"
label var seed_year_4 "Planting 4: When was this seed acquired? - year"
label var seed_acq_4 "Planting 4: Where was it acquired?"
label var seed_acq_txt_4 "Planting 4: Where was it acquired? - other"
label var army_4 "Planting 4: Were fall army worms present in this planting?"
yesno army_4
label var qharv_army_4 "Planting 4: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be" 
label var ferts_txt_4 "Planting 4: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be - other"
label var inter_crop_4 "Planting 4: With what crop did you intercrop?"
label var inter_crop_txt_4 "Planting 4: With what crop did you intercrop? - other"	
	
	
foreach var in date_4 company_4 seed_co_4 mri_4 pioneer_4 pannar_4 zamseed_4 dekalb_4 {
	tab `var'
	}		
	
*********************************************************************
/* Section 17: Maize Plantings 5 */
*********************************************************************
*rename
rename q172 date_5
rename q173 reason_5
rename q173_5_text reason_txt_5
rename q174 company_5
rename q175 seed_co_5
rename q176 mri_5
rename q177 pioneer_5
rename q178 pannar_5
rename q179 zamseed_5
rename q1710 dekalb_5
rename q1711_4 seed_week_5 
rename q1711_5 seed_month_5
rename q1711_6 seed_year_5
rename q1712 seed_acq_5
rename q1712_8_text seed_acq_txt_5
rename q1713 recycl_5
rename q1714 second_5
rename q1715 replnt_5
rename q1716 fseed_5
rename q1717 qseed_5
rename q1718 plot_5
rename q1719 qharv_5
rename q1720 army_5
rename q1721 qharv_army_5
rename q1722 grn_5
rename q1722_1_text grn_txt_5
rename q1723 ferts_5
rename q1723_5_text ferts_txt_5
rename q1724 qbasal_5
rename q1725 qtop_5
rename q1726 inter_5
rename q1727 inter_crop_5
rename q1727_24_text inter_crop_txt_5

*change values to match previous year options
replace company_5 = 10 if company_5 == 13
replace company_5 = 11 if company_5 == 9
replace company_5 = 13 if company_5 == 15
replace mri_5 = 18 if mri_5 == 19
replace pannar_5 = 10 if pannar_5 == 16	
replace zamseed_5 = 2 if zamseed_5 == 16
replace zamseed_5 = 11 if zamseed_5 == 17	
replace pannar_5 = 11 if pannar_5 == 17  


*label vars
label var date_5 "Planting 5: Date of planting"
label var reason_5 "Planting 5: Reasons for planting on that date 1"
label var reason_txt_5 "Planting 5: Reasons for planting on that date - Text"
label var company_5 "Planting 5: Seed company "
label var seed_co_5 "Planting 5: Seedco variety"
label var mri_5 "Planting 5: MRI variety"
label var pioneer_5 "Planting 5: Pioneer variety"
label var pannar_5 "Planting 5: Pannar variety"
label var zamseed_5 "Planting 5: Zamseed variety"
label var dekalb_5 "Planting 5: Dekalb variety"
label var recycl_5 "Planting 5: Used Recycled seed"
label var second_5 "Planting 5: Second seed variety"
label var replnt_5 "Planting 5: Was this a replanting"
label var fseed_5 "Planting 5:  FISP or E-voucher seeds"
label var qseed_5 "Planting 5: Kgs of seeds planted"
label var plot_5 "Planting 5: Size of plot in ha"
label var qharv_5 "Planting 5: Harvest in kgs"
label var grn_5 "Planting 5: kgs of harvested green maize "
label var grn_txt_5 "Planting 5: kgs of harvested green maize - Text"
label var ferts_5 "Planting 5: Types of fertilizer " 
label var qbasal_5 "Planting 5: Kgs of basal dressing"
label var qtop_5 "Planting 5: kgs of top dressing fertilizer"
label var inter_5 "Planting 5: Intercrop"

*Label values
label define dates_5 ///
	1 "4th week of October" ///
	2 "1st week of November" ///
	3 "2nd week of November"  ///
	4 "3rd week of November"  ///
	5 "4th week of November"  ///
	6 "1st week of December"  ///
	7 "2nd week of December"  ///
	8 "3rd week of December"  ///
	9 "4th week of December"  ///
	10 "1st week of January"  ///
	11 "2nd week of January"  ///
	12 "3rd week of January" 

label values date_5 dates_5

*Seed companies and variety labels
label define seed_company_5 ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other hybrid" ///
	11 "Local maize" ///
	13 "Unknown local"

label values company_5 seed_company_5

label define seed_co_var_5 ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo"

label define mri_var_5 ///
	10 "MRI 455" ///
	1 "MRI 514" ///
	2 "MRI 594" ///
	11 "SY 5944" ///
	3 "MRI 614" ///
	4 "MRI 624" ///
	5 "MRI 634" ///
	12 "MRI 644" ///
	6 "MRI 654" ///
	7 "MRI 694" ///
	8 "MRI 704" ///
	9 "MRI 714" ///
	13 "MRI 724" ///
	14 "MRI 734" ///
	15 "MRI 744" ///
	16 "MRI 651" ///
	17 "MRI 711" ///
	18 "Other MRI"

label define pioneer_var_5 ///
		1 "PHB 30G19" ///
		2 "PHB 3253" ///
		3 "P3812W" ///
		4 "P2859W" ///
		5 "P3506W" ///
		6 "PHB 30B50" ///
		7 "Other Pioneer"

label define pannar_var_5 ///
	1 "PAN 4M-21" ///
	2 "PAN 6227" ///
	3 "PAN 12" ///
	4 "PAN 14" ///
	5 "PAN 53" ///
	6 "PAN 61" ///
	7 "PAN 6777" ///
	8 "PAN 6P-110" ///
	9 "PAN 7M-89" ///
	10 "PAN 8M-91" ///
	11 "PAN 8M-93" ///
	12 "Other Pannar" ///
	13 "PAN 413"

label define zamseed_var_5 ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	12 "ZMS 702" ///
	11 "ZMS 717" ///
	13 "ZMS 720" ///
	6 "ZMS 607Y" ///
	15 "Other Zamseed"

label define dekalb_var_5 ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb"
	
	
label values seed_co_5 seed_co_var_5
label values mri_5 mri_var_5
label values pioneer_5 pioneer_var_5
label values pannar_5 pannar_var_5
label values zamseed_5 zamseed_var_5
label values dekalb_5 dekalb_var_5


label define fisp_val_5 1 "Traditional FISP" 2 "FISP e-voucher" 3 "Neither"

foreach var in recycl_5 replnt_5 inter_5 {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
foreach var in second_5 {
	replace `var' = 0 if `var' == 74
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	


foreach var in fseed_5 {
	replace `var' = 0 if `var' == 1
	replace `var' = 1 if `var' == 2
	replace `var' = 2 if `var' == 3
	label values `var' fisp_val_5
	}	
	
foreach var in grn_5 {
	replace `var' = 0 if `var' == 9
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}	

label var seed_week_5 "Planting 5: When was this seed acquired? - week"
label var seed_month_5 "Planting 5: When was this seed acquired? - month"
label var seed_year_5 "Planting 5: When was this seed acquired? - year"
label var seed_acq_5 "Planting 5: Where was it acquired?"
label var seed_acq_txt_5 "Planting 5: Where was it acquired? - other"
label var army_5 "Planting 5: Were fall army worms present in this planting?"
yesno army_5
label var qharv_army_5 "Planting 5: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be" 
label var ferts_txt_5 "Planting 5: your harvest for this planting was ___, if Fall armyworms had NOT been present what would your harvest be - other"
label var inter_crop_5 "Planting 5: With what crop did you intercrop?"
label var inter_crop_txt_5 "Planting 5: With what crop did you intercrop? - other"	
	
	
foreach var in date_5 company_5 seed_co_5 mri_5 pioneer_5 pannar_5 zamseed_5 dekalb_5 {
	tab `var'
	}		
	
*********************************************************************
/* Section 19: Maize storage and sales*/
*********************************************************************

*rename
rename q191 storage
rename q191_1_text kgs_stor
rename q192_1 mz_fin_wk
rename q192_2 mz_fin_mth
rename q192_3 mz_fin_yr
rename q193 qharvested
rename q194 sold_kgs_current
rename q195 sold_who_current
rename q196 rct_sale_kgs
rename q197 rct_sale_kwacha
rename q198 plan_sell
rename q199 buy_maize
rename q1910 buy_maize_kgs
rename q1911 buy_maize_kwacha
rename q1912 buy_maize_who
rename q1913 buy_maize_who_1
rename q1913_5_text buy_maize_who_txt_1
rename q1914 buy_meal
rename q1915 sold_who
rename q1916 kgs_sold
rename q1917 kgs_soldfra
rename q1918 fra_month_sold
rename q1919 fra_month_paid
rename q1920 fra_dist


*label var
label var storage "Maize storage from previous season - Y/N"
label var kgs_stor "Kgs of maize storage from previous season"
label var mz_fin_wk "week maize from the 2016-2017 harvest finished or all sold - Week (1, 2, 3, 4)"
label var mz_fin_mth "Month maize from the 2016-2017 harvest finished or all sold - Month"
label var mz_fin_yr "Year maize from the 2016-2017 harvest finished or all sold - Year"
label var qharvested "Kgs of total maize harvested from the previous season"
label var sold_kgs_current "Maize sold for cash from last harvest not including bartering - Y/N"
label var sold_who_current "Maize sold from last harvest to Briefcase buyers (unparsed)"
label var rct_sale_kwacha "Kwacha received from maize sold in the MOST RECENT SALE from last harvest"
label var rct_sale_kgs "Kgs of maize sold in the MOST RECENT SALE from last harvest"
label var plan_sell "Kilograms of maize, available now, from the last harvest that are planned to be sold in the future"
label var buy_maize "Maize purchased in the last 3 months - Y/N"
label var buy_maize_kgs "Kgs of maize purchased in the last 3 months"
label var buy_maize_kwacha "Maize purchased in the last 3 months in Kwacha (including any milling cost)"
label var buy_maize_who "From where is the maize purchased (grain) on the last purchase"
label var buy_maize_who_txt_1 "From where is the maize purchased (grain) on the last purchase - Other"
label var buy_meal  "Bought mealie meal in the last 3 months - Y/N"
label var sold_who "Buyers/Barter maize from the previous harvest"
label var kgs_sold "Kgs of maize sold from the previous harvest"
label var kgs_soldfra "Kgs of maize sold from the previous harvest to FRA"
label var fra_month_sold "Month of sales from the previous-harvest maize to FRA"
label var fra_month_paid "Month of payment from the previous-harvest maize sales to FRA"
label var fra_dist "Distance to the FRA depot where previous-harvest maize sales has been done (walking time in minutes)"

*Label values
label define buy_who 1 "Market" 2 "Another farmer" 3 "Miller" 4 "Other", replace
label define sell_who 1 "Briefcase buyers (in village)" 2 "FRA" 3 "Private buyers in town" 4 "Individuals" 5 "Bartering partner" 6 "I did not sell maize", replace

*change dummies
foreach var in storage sold_kgs_current buy_maize buy_meal {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}

foreach var in sold_kgs_current {
	replace `var' = 0 if `var' == 6
	replace `var' = 1 if `var' == 5
	label values `var' yesno
	}

tab mz_fin_mth

replace mz_fin_mth = "." if mz_fin_mth == "0"
replace mz_fin_mth = "1" if mz_fin_mth == "January" | mz_fin_mth == "January "
replace mz_fin_mth = "2" if mz_fin_mth == "February" | mz_fin_mth == "February " | mz_fin_mth == "February y"
replace mz_fin_mth = "3" if mz_fin_mth == "March" | mz_fin_mth == "March " | mz_fin_mth == " March" | mz_fin_mth == " March "   
replace mz_fin_mth = "4" if mz_fin_mth == "April" | mz_fin_mth == "April " | mz_fin_mth == "Aprl"
replace mz_fin_mth = "5" if mz_fin_mth == "May" |  mz_fin_mth == "May " | mz_fin_mth == " May"
replace mz_fin_mth = "6" if mz_fin_mth == "June" | mz_fin_mth == "June " | mz_fin_mth == "june"
replace mz_fin_mth = "7" if mz_fin_mth == "July" | mz_fin_mth == "July "
replace mz_fin_mth = "8" if mz_fin_mth == "August" | mz_fin_mth == "August "
replace mz_fin_mth = "9" if mz_fin_mth == "September "
replace mz_fin_mth = "10" if mz_fin_mth == "October " | mz_fin_mth == "Ictober"
replace mz_fin_mth = "11" if mz_fin_mth == "November "
replace mz_fin_mth = "12" if mz_fin_mth == "December" | mz_fin_mth == "December " | mz_fin_mth == "December  "
 
destring mz_fin_wk mz_fin_mth, replace

label define months 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label define weeks 0 "Week 0" 1 "Week 1" 2 "Week 2" 3 "Week 3" 4 "Week 4" 5 "Week 5" 

label values mz_fin_wk weeks
label values mz_fin_mth months

*********************************************************************
/* Section 20: Cooperatives and FISP */
*********************************************************************
rename q201 coop
rename q202 coop_fee
rename q203 renewal_fee
rename q204 fisp
rename q205 vouchdate
rename q206 vouchdate_delivered
yesno coop 
recode fisp 3=0
label define fisp 1 "Yes, conventional FISP" 2 "Yes, E-Voucher FISP" 0 "No"

label define vouchdate 	1	"1st week October 2018"		///
6	"2nd week October 2018"		///
7	"3rd week October 2018"		///
8	"4th week October 2018"		///
2	"1st week November 2018"		///
9	"2nd week November 2018"		///
10	"3rd week November 2018"		///
11	"4th week November 2018"		///
3	"1st week December 2018"		///
12	"2nd week December 2018"		///
13	"3rd week December 2018"		///
14	"4th week December 2018"		///
4	"1st week January  2019"		///
15	"2nd week January  2019"		///
16	"3rd week January  2019"		///
17	"4th week January  2019"		///
5	"1st week February  2019"		///
19	"Was never activated "	
label value vouchdate vouchdate 


label define delivered 19	"1st week October 2018"		///
1	"2nd week October 2018"		///
6	"3rd week October 2018"		///
7	"4th week October 2018"		///
8	"1st week November 2018"		///
2	"2nd week November 2018"		///
9	"3rd week November 2018"		///
10	"4th week November 2018"		///
11	"1st week December 2018"		///
3	"2nd week December 2018"		///
12	"3rd week December 2018"		///
13	"4th week December 2018"		///
14	"1st week January  2019"		///
4	"2nd week January  2019"		///
15	"3rd week January  2019"		///
16	"4th week January  2019"		///
17	"1st week February  2019"		///
20	"After 1st week of February 2019 "		///
19	"Before first week of October 2018"		

rename v700 vfert
rename v701 vmaizeseed
rename v702 votherseed
rename v703 vequip
rename v704 vchem
rename v705 vhealth
rename v706 vgoods
rename v707 qvfert
rename v708 qvmaizeseed
rename v709 qvotherseed
rename v710 qvequip
rename v711 qvchem
rename v712 qvhealth
rename v713 qvgoods
rename v714 efert
rename v715 emaizeseed
rename v716 eotherseed
rename v717 eequip
rename v718 echem
rename v719 ehealth
rename v720 egoods


label var	coop	"yesno coop member (1=yes)"
label var coop_fee "How much does it cost to join this cooperative or other group?"
label var renewal_fee "What is the annual renewal fee to be a member of this cooperative?"
label var	fisp	"Participate in FISP this ag season"
label var	vouchdate	"when was evouch first used / activated"
label var	vouchdate_delivered	"when was evouch first delivered"


label var vfert "FISP E-Voucher credit spent in fertilizer" 
label var vmaizeseed "FISP E-Voucher credit spent in maize seed" 
label var votherseed "FISP E-Voucher credit spent in other seed" 
label var vequip "FISP E-Voucher credit spent in equipment" 
label var vchem "FISP E-Voucher credit spent in chemicals" 
label var vhealth "FISP E-Voucher credit spent in immunization/vaccination" 
label var vgoods "FISP E-Voucher credit spent in non-ag goods" 
label var qvfert "Fertilizer Bags FISP E-Voucher credit" 
label var qvmaizeseed "Kgs of maize seeds FISP E-Voucher credit" 
label var qvotherseed "Kgs of other seeds FISP E-Voucher credit" 
label var qvequip  "Quantity of equipment FISP E-Voucher credit"
label var qvchem "Liters of chemicals FISP E-Voucher credit" 
label var qvhealth "Liters of immunization/vaccination FISP E-Voucher credit" 
drop qvgoods 
label var efert "Fertilizer bought with E-Voucher - Y/N"
label var emaizeseed "Maize seed bought with E-Voucher - Y/N"
label var eotherseed "Other seed bought with E-Voucher - Y/N"
label var eequip "Fertilizer bought with E-Voucher - Y/N"
label var echem "Chemicals bought with E-Voucher - Y/N"
label var ehealth "immunization/vaccination bought with E-Voucher - Y/N"
label var egoods "Non-ag goods bought with E-Voucher - Y/N"

foreach var in efert emaizeseed eotherseed eequip echem ehealth egoods {
replace  `var' = 0 if `var' == 3
yesno `var'
tab `var'
}

*********************************************************************
/* Section 21: Non-maize crops */
*********************************************************************

rename q211 nonmaize_current
rename q211_24_text nonmaize_current_other
rename q212 nonmaize_next
rename q212_24_text nonmaize_next_other

label var nonmaize_current "What crops did you grow in the 2018-2019 season?"
label var nonmaize_current_other "What crops did you grow in the 2018-2019 season? - other"
label var nonmaize_next "Which of the following crops do you expect to grow in the next season (2019/20)?"
label var nonmaize_next_other "Which of the following crops do you expect to grow in the next season (2019/20)? - other"

*********************************************************************
/* Section 22: Risk Aversion */
*********************************************************************

rename q222 scenario_1
rename q223 scenario_2
rename q224 scenario_3
rename q225 scenario_4
rename q226_5 switch_bags
rename q226_6 switch_comments
rename q227 comments_varA
rename q228 comments_varB
rename q229 comments_general

label var scenario_1 "What variety would you like to plant in your fields during the next season? - Risk Lover"
label var scenario_2 "What variety would you like to plant in your fields during the next season? - Risk Neutral"
label var scenario_3 "What variety would you like to plant in your fields during the next season? - Risk Averse 1"
label var scenario_4 "What variety would you like to plant in your fields during the next season? - Risk Averse 2"
label var switch_bags "How much yield would you need to get in average yield to switch to Variety B? In bags of 50 kg per 0.1 hectares"
label var switch_comments "How much yield would you need to get in average yield to switch to Variety B? Reason"
label var comments_varA "comments if the respondent had any reason for systematically choosing variety A for all the scenarios"
label var comments_varB "comments if the respondent had any reason for systematically choosing variety B for all the scenarios"
label var comments_general "notes that help understanding the arguments to switch from Variety A to Variety B"


*********************************************************************
/* Section 23: Perceptions of Rainfall*/
*********************************************************************
rename q231 rainfall_19
label var rainfall_19 "How would you characterize the rainfall from the 2018-2019 growing season?"
label define rainfall 1 "Severe drought" 2 "Moderate drought" 3 "Average" 4 "Above Average" 5 "Too much"
label value rainfall_19 rainfall

rename q232 rainfall_harvest
label var rainfall_harvest "if the rainfall had been average what would your total maize harvest have been?"

rename q233 rainfall_events
label var rainfall_events "Did you experience any of the following in the 2018-2019 growing season?"
*label define events 1 "Late rain arrival" 2 "Dry spells (extended periods without rain" 3 "Low total seasonal accumulation of rainfall" /// 
*4 "Periods of extremely warm temperature" 5 "Too much soil moisture (including flooding)" 6 "Other"
*label value rainfall_events events

rename q233_6_text rainfall_events_other
label var rainfall_events_other "Did you experience any of the following in the 2018-2019 growing season? other"

rename q234 latearrival
label var	latearrival	"How many weeks late did rains arrive? " 

rename q235 daysnorain
label var	daysnorain	"During growing season how days in a row is harmful to maize" 

rename q236 daysdrought
label var	daysdrought	"How many days without rain is a drought? " 

rename q237 drought_seasons
label var	drought_season	"Seasons maize was affected by drought" 
*label define seasons_effected 1 "2018-2019" 2 "2017-2018" 3 "2016-2017" 4 "2015-2016"
*label value drought_seasons seasons_effected

rename q238 droughtint
label var	droughtint	"Dry spell intensity " 
*how long did the longest dry spell last in 2018-19 growing season

rename q239 droughtfreq
label var droughtfreq "How often would you say that you experience a drought year?"
label define droughtfreq 1 "Every year" 2 "Every other year" 3 "Once every 3 years" 4 "Once every 4 years" 5 "Once every 5 years" 6 "Once every 6 years" 7 "Once every 7 years" 8 "Once every 8 years" 9 "Once every 9 years" 10 "Once every 10 years or less frequently" 11 "I have never experienced a drought" 
label value droughtfreq droughtfreq

rename q2310 rains
label var	rains	"Predictions of rains next season " 
label define rains 1 "Wetter than a typical year" 2 "About the same as a typical year" 3 "Drier than a typical year" 4 "I dont know/ can't predict" 
label value rains rains 

rename q2311 forecast_rain
label var forecast_rain "Do you think the rains from the upcoming 2019/2020 growing season will be more..."
label define forecast_rain 1 "Very confident" 2 "Moderate confidence" 3 "Not very confident" 4 "I don't know" 
label value forecast_rain forecast_rain

rename q2312 rains_reasons
label var rains_reasons "Why do you think the rain during the growing season will be this way?"

rename q2312_8_text rains_reasons_other
label var rains_reasons_other "Why do you think the rain during the growing season will be this way? - other"

rename q2313 seedp_next
label var seedp_next "For the upcoming growing season what type/s of seeds, will you plant? If known fill in the variety"

rename q2313_1_text early_next
label var early_next "Type of early maturity seed"

rename q2313_2_text medium_next
label var medium_next "Type of medium maturity seed"

rename q2313_3_text late_next
label var late_next "Type of late maturity seed"

rename q2314 prepared
label var	prepared	"How likely is HH to be prepared for drought" 
label define prepared 1 "Very likely" 2 "Somewhat likely" 3 "Not likely" 4 "I dont know" 
label values prepared prepared

rename q2315 activities_drought
label var	activities_drought	"Activities that can be preformed now in prep for drought - Y/N" 
* 1 - Yes; 2 - No; 3 - I dont know

rename q2316 act_drought
label var	act_drought	"Activities that can be preformed now in prep for drought" 

rename q2316_11_text act_drought_other
label var	act_drought_other	"Activities that can be preformed now in prep for drought - other" 

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

*********************************************************************
/* Section 26: Aspirations and Future Making */
*********************************************************************
rename q262_1 importance_occup
rename q262_2 importance_educ
rename q262_3 importance_respect
rename q262_4 importance_land
rename q262_5 importance_livestock
rename q262_6 importance_assets

label var importance_occup "Occupation importance in determining the social status of the most reputable individuals in your village"
label var importance_educ "Education importance in determining the social status of the most reputable individuals in your village"
label var importance_respect "Respect importance in determining the social status of the most reputable individuals in your village"
label var importance_land "Land importance in determining the social status of the most reputable individuals in your village"
label var importance_livestock "Livestock importance in determining the social status of the most reputable individuals in your village"
label var importance_asset "Assets importance in determining the social status of the most reputable individuals in your village"

* Land Aspirations
rename q263_1 rank_land
label var rank_land "Where would you rank your household on this scale of land ownership?"

rename q264_3 rank_land_10
label var rank_land_10 "Where on this scale of land ownership would you expect your household to be in 10 years?"

rename q265 change_exp_land
replace change_exp_land = 0 if change_exp_land == 4
yesno change_exp_land
label var change_exp_land "Has land expectation changed in the last 3 years?"

rename q266 exp_how_land
label var exp_how_land "How land expectation changed?"

rename q267 people_livestock
replace people_livestock = 0 if people_livestock == 2
yesno people_livestock
label var people_livestock "Do a lot of people in your village have livestock?"

* Livestock Aspirations
rename q268_1 rank_livestock
label var rank_livestock "Where would you rank your household on this scale of livestock ownership?"

rename q269_3 rank_livestock_10
label var rank_livestock_10 "Where on this scale of livestock ownership would you expect your household to be in 10 years?"

rename q2610 change_exp_livestock
replace change_exp_livestock = 0 if change_exp_livestock == 4
yesno change_exp_livestock
label var change_exp_livestock "Has livestock expectation changed in the last 3 years? "

rename q2611 exp_how_livestock
label var exp_how_livestock "How livestock expectation changed?"

* Asset Aspirations
rename q2612_1 rank_asset
label var rank_asset "Where would you rank your household on this scale of asset ownership?"

rename q2613_3 rank_asset_10
label var rank_asset_10 "Where on this scale of asset ownership would you expect your household to be in 10 years?"

rename q2614 change_exp_asset
replace change_exp_asset = 0 if change_exp_asset == 4
yesno change_exp_asset
label var change_exp_asset "Has asset expectation changed in the last 1 year?"

rename q2615 exp_how_asset
label var exp_how_asset "How asset expectation changed?"

rename q2616 comments_expectations
label var comments_expectations "If the individual is confused about what defines asset ownership,add note about their comments in the space provided"

rename q2617 primary_role_child
label var primary_role_child "Who of the following played a primary role in raising you as a child?"

rename q2618 educ_mother
label var educ_mother "educational attainment of your mother."

rename q2619 educ_father
label var educ_father "educational attainment of your father."

rename q2620 educ_guardian1
label var educ_guardian1 "Please indicate the educational attainment of guardian 1"

rename q2621 educ_guardian2
label var educ_guardian2 "Please indicate the educational attainment of guardian 2"

rename q2622 educ_son
label var educ_son "If you just had another son born, please indicate the level of educational attainment you hope they would achieve"

rename q2623 job_son
label var job_son "What occupation do you wish your son would have?"

rename q2623_8_text job_son_other
label var job_son_other "What occupation do you wish your son would have? other"

rename q2624 educ_daughter
label var educ_daughter "If you just had a baby daughter, please indicate the level of educational attainment you hope she achieves"

rename q2625 job_daughter
label var job_daughter "What occupation do you wish your daughter would have?"

rename q2625_8_text job_daughter_other
label var job_daughter_other "What occupation do you wish your daughter would have? other"

rename q2626_1 c_unem
rename q2626_2 c_health
rename q2626_3 c_food
rename q2626_4 c_weather
rename q2626_5 c_degradation
rename q2626_6 c_land_loss
rename q2626_7 c_land_conflict
rename q2626_8 c_social_insta

label var c_unem "How worried are you that unemployment may affect your household?"
label var c_health "How worried are you that health may affect your household?"
label var c_food "How worried are you that food insecurity may affect your household?"
label var c_weather "How worried are you that weather may affect your household?"
label var c_degradation "How worried are you that land degradation may affect your household?"
label var c_land_loss "How worried are you that land loss may affect your household?"
label var c_land_conflict "How worried are you that land conflict may affect your household?"
label var c_social_insta "How worried are you that social instability may affect your household?"

rename q2627_1 c_unem_3
rename q2627_2 c_health_3
rename q2627_3 c_food_3
rename q2627_4 c_weather_3
rename q2627_5 c_degradation_3
rename q2627_6 c_land_loss_3
rename q2627_7 c_land_conflict_3
rename q2627_8 c_social_insta_3

label var c_unem_3 "Are you more or less worried about unemployment now, than you were 3 years ago?"
label var c_health_3 "Are you more or less worried about health now, than you were 3 years ago?"
label var c_food_3 "Are you more or less worried about food insecurity now, than you were 3 years ago?"
label var c_weather_3 "Are you more or less worried about weather now, than you were 3 years ago?"
label var c_degradation_3 "Are you more or less worried about soil degradation now, than you were 3 years ago?"
label var c_land_loss_3 "Are you more or less worried about land loss now, than you were 3 years ago?"
label var c_land_conflict_3 "Are you more or less worried about land conflict now, than you were 3 years ago?"
label var c_social_insta_3 "Are you more or less worried about social instability now, than you were 3 years ago?"


*********************************************************************
/* Section 27: Administrative */
*********************************************************************

label var province "Province"
label var camp "Camp Name"
label var village "Village Name"

rename q274 sms_partic
label var sms_partic "20.4 Did you particpate in the SMS program?"
recode sms_partic 5=1
recode sms_partic 6=0
yesno sms_partic

rename q276 sms_name 
rename q277 sms_num
label var sms_name "trained individual's name"
label var sms_num "individual's phone number"
label var enumerator "comments on survey"
drop dup

forvalues i = 1/5 {
destring date_`i' recycl_`i' second_`i' replnt_`i' qseed_`i' plot_`i' qharv_`i'  qbasal_`i' qtop_`i', replace 
}

cd "C:\Users\kurczew2\Box\Research\HICPS"

*replace rct_sale_kwacha = "." if rct_sale_kwacha == "Not yet paid" 
*destring rct_sale_kwacha, replace



save "2019 HICPS Follow-up", replace  


