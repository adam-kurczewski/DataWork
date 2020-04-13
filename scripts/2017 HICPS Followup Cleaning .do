/*
Notes: 	
a. A total of 12 households were invalid; they occured before the survey start date. 
b. HHIDs that are unable to be matched are assigned a HHID of .
*/ 
clear 

cd "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2017 HICPS" 

import delimited using "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2017 HICPS\HICPS Zambia 2017 Follow-Up Raw Data.csv", varnames(1) clear


**programs to help clean 

label define yesnoL 1 "Yes" 0 "No" 

capture program drop yesno 
program define yesno 
	replace `1'=0 if `1'==2
	label values `1' yesnoL
end 

***************************************************************************
//Section 0: Clean HHIDS
***************************************************************************

//NOTE: Any responses with a start/end date before 6/5 are not legitimate data.
//NOTE: 12 invalid obs dropped 
split enddate,parse(" ")
gen survey_date = date(enddate1,"MD20Y")
drop enddate1 enddate2
*gen DVadmission1 = date(startdate, "DM20Y")
format survey_date %td
order survey_date,after(enddate)
drop if survey_date < date("5jun2017","DM20Y")


//1.1 Is this a new household? If yes, use the other survey entitled 
//"HICPS Zambia 2017 New Respondent."
//NOTE: drop if new_hh==yes Drop 23 obs 
rename v19 new_hh 
yesno new_hh 


//1.2 Enter HH ID:
rename v20 HHID

//1.4a Name of respondent: 
rename v34 name_respondent

***check for duplicates 
sort HHID
quietly by HHID:  gen dup = cond(_N==1,0,_n) 
***ONLY 877 UNIQUE OBS 


replace HHID = 60100008 if name_respondent == "Cecil Munsaka"
replace HHID = 50111001 if name_respondent == "Handwane Alfred"
replace HHID = 40229001 if name_respondent == "Kabungo Nfupa"
replace HHID = 40229011 if name_respondent == "Agness kangwa"
replace HHID = 60100014 if name_respondent == "Shadreck Munsaka"


***used Excel to fix duplicate obs by matching 2017 respondent name and/or number to 2016
gen corrected_HHID=0
replace HHID=10117013	if name_respondent=="Bertha Kapenya"
replace corrected_HHID=1 if HHID==10117013

replace HHID=10201013	if name_respondent=="Lita Mulekwa"
replace corrected_HHID=1 if HHID==10201013

replace HHID=10208006	if name_respondent=="Ireen Nsangwapo"
replace corrected_HHID=1 if HHID==10208006

replace HHID=10208007	if name_respondent=="Steward Mushina"
replace corrected_HHID=1 if HHID==10208007

replace HHID=20106033	if name_respondent=="Kano Kakungu"
replace corrected_HHID=1 if HHID==20106033

replace HHID=20106035	if name_respondent=="Maceleta Kapeya"
replace corrected_HHID=1 if HHID==20106035

replace HHID=20106037	if name_respondent=="Killion Kankomba"
replace corrected_HHID=1 if HHID==20106037

replace HHID=20106046	if name_respondent=="Martin Chinsankila"
replace corrected_HHID=1 if HHID==20106046

replace HHID=20106049	if name_respondent=="Lawson Mulaisho"
replace corrected_HHID=1 if HHID==20106049

replace HHID=20206022	if name_respondent=="James Shanfuti"
replace corrected_HHID=1 if HHID==20206022

replace HHID=20206035	if name_respondent=="Hartson Chitonge"
replace corrected_HHID=1 if HHID==20206035

replace HHID=30103001	if name_respondent=="Winford Ndhlovu"
replace corrected_HHID=1 if HHID==30103001

replace HHID=30103003	if name_respondent=="Tryness Muhoni"
replace corrected_HHID=1 if HHID==30103003

replace HHID=30107001	if name_respondent=="Mary Zulu"
replace corrected_HHID=1 if HHID==30107001

replace HHID=30107003	if name_respondent=="Fani Banda"
replace corrected_HHID=1 if HHID==30107003

replace HHID=30107008	if name_respondent=="Beatrice Nkhoma"
replace corrected_HHID=1 if HHID==30107008

replace HHID=30107011	if name_respondent=="Ireen Banda"
replace corrected_HHID=1 if HHID==30107011

replace HHID=30133002	if name_respondent=="Ephraim Lowole"
replace corrected_HHID=1 if HHID==30133002

replace HHID=30133006	if name_respondent=="Stainley Zimba"
replace corrected_HHID=1 if HHID==30133006

replace HHID=30133012	if name_respondent=="Maureen Mwanza"
replace corrected_HHID=1 if HHID==30133012

replace HHID=30221004	if name_respondent=="Bernadette Daka"
replace corrected_HHID=1 if HHID==30221004

replace HHID=40109011	if name_respondent=="Keleby Simfukwe"
replace corrected_HHID=1 if HHID==40109011

replace HHID=40109012	if name_respondent=="Getrude Chipeta"
replace corrected_HHID=1 if HHID==40109012

replace HHID=40109014	if name_respondent=="Naomi Nambule"
replace corrected_HHID=1 if HHID==40109014

replace HHID=40113014	if name_respondent=="Wesley Simuyemba"
replace corrected_HHID=1 if HHID==40113014

replace HHID=40139003	if name_respondent=="Jimmson Simwinga"
replace corrected_HHID=1 if HHID==40139003

replace HHID=40139017	if name_respondent=="Harriet Naulapwa"
replace corrected_HHID=1 if HHID==40139017

replace HHID=40223009	if name_respondent=="Agness Musale"
replace corrected_HHID=1 if HHID==40223009

replace HHID=40223012	if name_respondent=="Silvia Nkole"
replace corrected_HHID=1 if HHID==40223012

replace HHID=40235011	if name_respondent=="Mirriam Kangwa"
replace corrected_HHID=1 if HHID==40235011

replace HHID=40235019	if name_respondent=="Lewis Mukuka"
replace corrected_HHID=1 if HHID==40235019

replace HHID=50100021	if name_respondent=="Lyson Mulando"
replace corrected_HHID=1 if HHID==50100021

replace HHID=50211001	if name_respondent=="Godfrey Temba"
replace corrected_HHID=1 if HHID==50211001

replace HHID=50211003	if name_respondent=="Kayelu Yona"
replace corrected_HHID=1 if HHID==50211003

replace HHID=50216013	if name_respondent=="Ruth Chiteta"
replace corrected_HHID=1 if HHID==50216013

replace HHID=50216019	if name_respondent=="Ngomi Malayi"
replace corrected_HHID=1 if HHID==50216019

replace HHID=60100003	if name_respondent=="Gracious Simwinga"
replace corrected_HHID=1 if HHID==60100003

replace HHID=60100009	if name_respondent=="Emmanuel Choonga"
replace corrected_HHID=1 if HHID==60100009

replace HHID=60100061	if name_respondent=="Alick Mapasula"
replace corrected_HHID=1 if HHID==60100061

replace HHID=60115013	if name_respondent=="Fredrick Simalonga"
replace corrected_HHID=1 if HHID==60115013

replace HHID=60115014	if name_respondent=="Faith Mulongo"
replace corrected_HHID=1 if HHID==60115014

replace HHID=60126012	if name_respondent=="Ronald Sikayola"
replace corrected_HHID=1 if HHID==60126012

replace HHID=60126034	if name_respondent=="George Nyambe"
replace corrected_HHID=1 if HHID==60126034

replace HHID=60126038	if name_respondent=="Gabriel katembo"
replace corrected_HHID=1 if HHID==60126038

replace HHID=60130007	if name_respondent=="Benita Moono"
replace corrected_HHID=1 if HHID==60130007

replace HHID=60130022	if name_respondent=="Belita Munsaka"
replace corrected_HHID=1 if HHID==60130022

replace HHID=60204020	if name_respondent=="Skeeter Mweene"
replace corrected_HHID=1 if HHID==60204020

replace HHID=60204024	if name_respondent=="Linety Muhila"
replace corrected_HHID=1 if HHID==60204024

replace HHID=60222001	if name_respondent=="Enias Moono"
replace corrected_HHID=1 if HHID==60222001

replace HHID=60222019	if name_respondent=="Elijah Muganda"
replace corrected_HHID=1 if HHID==60222019

replace HHID=40229001	if name_respondent=="Kabungo Nfupa"
replace corrected_HHID=1 if HHID==40229001

replace HHID=40229011	if name_respondent=="Agness Kangwa"
replace corrected_HHID=1 if HHID==40229011

replace HHID=30224008	if name_respondent=="Elizabeth Daka"
replace corrected_HHID=1 if HHID==30224008

replace HHID=40109017	if name_respondent=="Susan Nakatunga"
replace corrected_HHID=1 if HHID==40109017

replace HHID=40137022	if name_respondent=="Gilant Salimu"
replace corrected_HHID=1 if HHID==40137022

replace HHID=40139011	if name_respondent=="Shadreck Mwenya"
replace corrected_HHID=1 if HHID==40139011

replace HHID=40139014	if name_respondent=="Jane Chiyanga"
replace corrected_HHID=1 if HHID==40139014

replace HHID=60112024	if name_respondent=="Manager Hakoonta "
replace corrected_HHID=1 if HHID==60112024

replace HHID=40109008	if name_respondent=="Wedson Singoma"
replace corrected_HHID=1 if HHID==40109008

replace HHID=50111001	if name_respondent=="Handwane Alfred"
replace corrected_HHID=1 if HHID==50111001

replace HHID=10136002	if name_respondent=="Rudies Nachula"
replace corrected_HHID=1 if HHID==10136002

replace HHID=40223006	if name_respondent=="Charles Chilufya"
replace corrected_HHID=1 if HHID==40223006

replace HHID=60100014	if name_respondent=="Shedrick Munsaka"
replace corrected_HHID=1 if HHID==60100014

replace HHID=60100008	if name_respondent=="Cecil Munsaka"
replace corrected_HHID=1 if HHID==60100008

replace HHID=40235011	if name_respondent=="Mirriam Kangwa "
replace corrected_HHID=1 if HHID==40235011


****respondent has 11 obs all obs are the same drop all but first occurance 
drop if HHID==20206063 & dup>1

****respondent has 11 obs all obs are the same drop all but first occurance 
drop if HHID==30107016 & dup>1

****respondent has 12 obs all obs are the same drop all but first occurance 
drop if HHID==20106057 & dup>1

****respondent has 2 obs all obs are the same drop all but first occurance 
drop if HHID==20206010 & dup>1

****Same respondent interveiwed by dominic and nelly has different responses 
****take first occurance
drop if HHID==60222007 & startdate=="6/11/17 14:13"

****respondent has 3 obs all obs are the same drop all but first occurance 
drop if HHID==50206008 & dup>1

****respondent has 3 obs all obs are the same drop all but first occurance 
drop if HHID==50216018 & dup>1

****respondent has 2 obs all obs are the same drop all but first occurance 
drop if HHID==50216013 & dup>1

***check for duplicates 
sort HHID
quietly by HHID:  gen dup1 = cond(_N==1,0,_n) 

gen notcorrectedHHID=0

***replaces 9 HHIDs with .
replace HHID=999999992 if HHID==99999999
replace notcorrectedHHID=1 if HHID==999999992

replace HHID=9960222007 if HHID==60222007  & dup==1 
replace notcorrectedHHID=1 if HHID==9960222007

replace HHID=9950100021 if name_respondent=="Yosia Njikunka"
replace notcorrectedHHID=1 if HHID==9950100021

replace HHID=9940113014 if name_respondent=="Jackline Muchindo "
replace notcorrectedHHID=1 if HHID==9940113014

replace HHID=9910201013 if HHID==10201013
replace notcorrectedHHID=1 if HHID==9910201013


***unable to match these following HHIDs
replace HHID=99302017 if HHID==302017
replace notcorrectedHHID=1 if HHID==99302017

replace HHID=99999991 if HHID==9999999 
replace notcorrectedHHID=1 if HHID==99999991

replace HHID=9911018001 if HHID==11018001
replace notcorrectedHHID=1 if HHID==9911018001

replace HHID= 9911111111 if HHID==11111111  
replace notcorrectedHHID=1 if HHID==9911111111

replace HHID= 9920106916  if HHID==20106916 
replace notcorrectedHHID=1 if HHID==9920106916

replace HHID= 99601109014 if HHID==601109014
replace notcorrectedHHID=1 if HHID==99601109014



*** cannot match  second occurance 
replace HHID=9940113014 if HHID==40113014	& startdate=="6/30/17 12:54"
replace notcorrectedHHID=1 if HHID==9940113014


drop dup dup1
sort HHID
quietly by HHID:  gen dup = cond(_N==1,0,_n) 
drop dup

********************************************************************************
//Section 1: Introduction Block 
********************************************************************************
//1.0 Enumerator
rename v18 enumerator_17 
label define enumerator 1 "Maurice" 2 "Enoch" 3 "Dominic" 4 "Protensia" 5 "Nelly" 6 "Allan" 7 "Noah" 8 "Elijah" 9 "Christabel" 10 "Nashon" 11 "Nana" 12 "Milton"   
label value enumerator_17 enumerator 

//1.3 Has the household moved since we visited in June-July 2016?
//NOTE: 42 HH have moved 
rename v21 move_hh1
yesno move_hh1


//1.3a Enter Latitude:  (should between -18.xxxxxxx to -8.xxxxxxxxx) 
rename v22 latitude

//1.3b Enter Longitude: (should be 22.xxxxxxxx to 33.xxxxxxxx)
rename v23 longitude 

//1.3c Province:
rename v24 province 
label define province 1 "Central" 2 "Copperbelt" 3 "Eastern" 4 "Northern" /*
*/ 5 "Northwestern" 6 "Southern" 
label values province province 


//Districts
foreach i of numlist 25/30{
	rename v`i' new_dist_`i'
	tab new_dist_`i'
	}

//1.3c.1 New_district:
replace new_dist_25= 101 if new_dist_25==1
replace new_dist_25= 102 if new_dist_25==2

//1.3c.2 New_district:
replace new_dist_26= 202 if new_dist_26==2
replace new_dist_26= 201 if new_dist_26==1

//1.3c.3 New_district:
replace new_dist_27=301 if new_dist_27==1 
replace new_dist_27=302 if new_dist_27==2

//1.3c.4 New_district:
***Chinsali new new_dist? 
replace new_dist_28=403 if new_dist_28==2
replace new_dist_28=402 if new_dist_28==1

//1.3c.5 New_district:
replace new_dist_29=501 if new_dist_29==1
replace new_dist_29=502 if new_dist_29==2

//1.3c.6 New_district:
replace new_dist_30=601 if new_dist_30==1
replace new_dist_30=602 if new_dist_30==2


	
* generate new new_district variable and put it next to new_province
gen district= .
label variable district "New district"
order district, after(province)

replace district= new_dist_25 if province==1
replace district= new_dist_26 if province==2
replace district= new_dist_27 if province==3
replace district= new_dist_28 if province==4
replace district= new_dist_29 if province==5
replace district= new_dist_30 if province==6

label define district 101 "Mkushi" /*
*/102 "Mumbwa"/* 
*/201 "Mpongwe"/* 
*/202 "Masaiti"/* 
*/301 "Lundazi"/* 
*/302 "Petauke"/* 
*/401 "Mbala"/* 
*/402 "Mungwi"/*
*/403 "Chinsali" /*
*/501 "Mufumbwe"/* 
*/502 "Solwezi"/* 
*/601 "Choma"/* 
*/602 "Namwala"

label value district district

**drop old district  variables
foreach i of num 25/30{
	drop new_dist_`i'
	}

//1.3d Camp name Village name 
rename v31 camp
rename v32 village

//1.4 Is this the same respondent from our in-person visit last year?
rename v33 same_respondent
yesno same_respondent 

//1.4a Name of respondent: renamed in Section 0 

//Q391 1.4b What is the current mobile phone number for this household? 
rename q391 phone_number


//1.5 Is this household connected to ZESCO?
rename  v36 ZESCO
replace ZESCO=0 if ZESCO==4
yesno ZESCO

//1.6 How many people live in the household?
rename v37 hh_num

label var	enumerator	"enumerator "
label var	new_hh	"Newly added household "
label var	HHID	"Household identification number "
label var	move_hh1	"Has household moved since 2016"
label var	latitude	"Moved household latitude "
label var	longitude	"Moved Household longitude "
label var	province	"Moved household province "
label var	district	"Moved household district "
label var	camp	"Moved household camp"
label var	village 	"Moved household village "
label var	same_respondent 	"Same respondent from last year "
label var	name_respondent	"Name of respondent "
label var	phone_number	"Current phone number "
label var	ZESCO	"Household connected to ZESCO"
label var	hh_num	"Number of people in household "

***************************************************
* Section 2: Demographics v38-v86
***************************************************
//2.1 Have any new members joined the household since we visited in 
//June-July 2016?
rename v38 new_hh_mem1
replace new_hh_mem1=0 if new_hh_mem1==3
yesno new_hh_mem1


//2.1a How many people in the following categories joined the household 
//since June/July 2016?
*0-14
rename v39 new_mem_0_14 

*15-64 
rename v40 new_mem_15_64 

*65+
rename v41 new_mem_64_old 


//Demographic variables on new hh members
*relationship to head 
//2.1b Complete the following information for each new member of the household: 

*Relationship to Household Head
rename v42 new_relate_1
rename v47 new_relate_2
rename v52 new_relate_3
rename v57 new_relate_4
rename v62 new_relate_5

foreach  i of numlist 1/5 {
label define new_relate_`i'  1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter" /*
*/  5 "Adopted son/Daughter" 6 "Grandchild" /*
*/7 "Father/Mother" /*
*/8 "Brother/Sister" /*
*/9 "Half-brother/Half-sister" /*
*/10 "Nephew/Niece of head (related)" /*
*/11 "Nephew/Niece of head (unrelated)" /*
*/12 "Son-in-law/Daughter-in-law" /*
*/13 "Brother-in-law/Sister-in-law" /*
*/14 "Father-in-law/Mother-in-law" /*
*/15 "Other family relative" /*
*/16 "Other person not related" 
label values new_relate_`i' new_relate_`i'
}
	
	
*Gender
rename v43 new_sex_1
rename v48 new_sex_2
rename v53 new_sex_3
rename v58 new_sex_4
rename v63 new_sex_5

replace new_sex_1="0" if new_sex_1=="F"
replace new_sex_1="0" if new_sex_1==" F"
replace new_sex_1="1" if new_sex_1=="M"
replace new_sex_1="1" if new_sex_1=="M "

replace new_sex_2="0" if new_sex_2=="F"
replace new_sex_2="1" if new_sex_2=="M"

replace new_sex_3="0" if new_sex_3=="F"
replace new_sex_3="1" if new_sex_3=="M"

replace new_sex_4="0" if new_sex_4=="F"
replace new_sex_4="1" if new_sex_4=="M"

replace new_sex_5="0" if new_sex_5=="F"
replace new_sex_5="1" if new_sex_5=="M"

label define new_sex 0 "Female" 1 "Male"


foreach i of num 1/5{
	destring new_sex_`i', replace
	label values new_sex_`i' new_sex
	}

*Year of birth 
rename v44 new_birth_1
rename v49 new_birth_2
rename v54 new_birth_3
rename v59 new_birth_4
rename v64 new_birth_5


*Educational attainment 
rename v45 new_educ_1
rename v50 new_educ_2
rename v55 new_educ_3
rename v60 new_educ_4
rename v65 new_educ_5

label define new_educ  1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown" 

foreach  i of numlist 1/5 {
label values new_educ_`i'  new_educ  
}
****Lived here since birth 
***has several answers Y N No Yes 1-->99 typo
*generate for loop
rename v46 vv1
rename v51 vv2
rename v56 vv3
rename v61 vv4
rename v66 vv5

label define vv 1 "Yes" 0 "No"

foreach i of num 1/5{
	replace vv`i'="0" if vv`i'=="N"
	replace vv`i'="0" if vv`i'=="No"
	replace vv`i'="0" if vv`i'==" N"
	replace vv`i'="0" if vv`i'=="N "
	replace vv`i'="99" if vv`i'=="1"
	replace vv`i'="1" if vv`i'=="Y"
	replace vv`i'="1" if vv`i'=="Yes"
	destring vv`i', replace
	
	label values vv`i' vv
	rename vv`i' new_here_`i'
}


//2.2 Has anyone permanently left the household since June-July 2016?
rename v67 perm_left
yesno perm_left 


//2.2a If permanently, complete demographic sheet to identify household member:

***relation to hh head 
***perm_relate_1 contains string respondents name? 
rename v68 perm_relate_1 
replace perm_relate_1="." if perm_relate_1=="Enifa malilwa"
destring perm_relate_1, replace 
rename v74 perm_relate_2
rename v80 perm_relate_3 

label define relate 1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter" /*
*/  5 "Adopted son/Daughter" 6 "Grandchild" /*
*/7 "Father/Mother" /*
*/8 "Brother/Sister" /*
*/9 "Half-brother/Half-sister" /*
*/10 "Nephew/Niece of head (related)" /*
*/11 "Nephew/Niece of head (unrelated)" /*
*/12 "Son-in-law/Daughter-in-law" /*
*/13 "Brother-in-law/Sister-in-law" /*
*/14 "Father-in-law/Mother-in-law" /*
*/15 "Other family relative" /*
*/16 "Other person not related" 99 "Enifa malilwa"

foreach  i of numlist 1/3 {
label values perm_relate_`i' relate
}

foreach i of num 1/3{
	tab perm_relate_`i' 
	}
***gender of permantly left 
rename v69 perm_sex_1
rename v75 perm_sex_2
rename v81 perm_sex_3

label define perm_sex 0 "Female" 1 "Male" 
foreach i of num 1/3{
	replace perm_sex_`i'="0" if perm_sex_`i'=="F"
	replace perm_sex_`i'="1" if perm_sex_`i'=="M"
	destring perm_sex_`i', replace 
	label value perm_sex_`i' perm_sex 
	}


	

***year of birth of permantly left 
rename v70 perm_birth_1
rename v76 perm_birth_2
rename v82 perm_birth_3



***reason of permantly left leaving ***needs value recoding cant find value codes 
rename v71 perm_reason_1
rename v77 perm_reason_2
rename v83 perm_reason_3


***district permantly left went ***needs value recoding cant find value codes
rename v72 perm_district_1
rename v78 perm_district_2
rename v84 perm_district_3


***urban or rural district ****not sure what 0 denotes in 1 and 2 
rename v73 perm_area_1
rename v79 perm_area_2
rename v85 perm_area_3

foreach i of num 1/3{	
	replace perm_area_`i'="1" if perm_area_`i'=="Rural "
	replace perm_area_`i'="1" if perm_area_`i'=="R"
	
	replace perm_area_`i'="2" if perm_area_`i'=="Town"
	replace perm_area_`i'="2" if perm_area_`i'=="T"

	replace perm_area_`i'="3" if perm_area_`i'=="U " 
	replace perm_area_`i'="3" if perm_area_`i'=="U" 
	replace perm_area_`i'="3" if perm_area_`i'=="Urban " 
	destring perm_area_`i', replace
	}

label define perm_area 1 "Rural" 2 "Town" 3  "Urban" 

foreach i of num 1/3{
	label value perm_area_`i' perm_area 
	}
	
rename v86 perm_remit
replace perm_remit="0" if perm_remit=="No"
replace perm_remit="0" if perm_remit=="No "
destring perm_remit, replace 

label var	new_hh_mem1	"New members joined household since 2016"
label var	new_mem_0_14	"New members Age 0-14"
label var	new_mem_15_64	"New members Age 15-64"
label var	new_mem_64_old	"New members Age 64+"
label var	new_relate_1	"Relationship to HH new person 1"
label var	new_relate_2	"Relationship to HH new person 2"
label var	new_relate_3	"Relationship to HH new person 3"
label var	new_relate_4	"Relationship to HH new person 4"
label var	new_relate_5 	"Relationship to HH new person 5"
label var	new_sex_1	"Gender of new person 1 "
label var	new_sex_2	"Gender of new person 2"
label var	new_sex_3	"Gender of new person 3"
label var	new_sex_4	"Gender of new person 4"
label var	new_sex_5	"Gender of new person 5"
label var	new_birth_1 	"Year of birth new person 1"
label var	new_birth_2	"Year of birth new person 2"
label var	new_birth_3	"Year of birth new person 3"
label var	new_birth_4	"Year of birth new person 4"
label var	new_birth_5	"Year of birth new person 5"
label var	new_educ_1	"Educational attainment new person 1"
label var	new_educ_2	"Educational attainment new person 2"
label var	new_educ_3	"Educational attainment new person 3"
label var	new_educ_4	"Educational attainment new person 4"
label var	new_educ_5	"Educational attainment new person 5"
label var	new_here_1	"Lived here since birth new person 1 "
label var	new_here_2	"Lived here since birth new person 2"
label var	new_here_3	"Lived here since birth new person 3"
label var	new_here_4	"Lived here since birth new person 4"
label var	new_here_5	"Lived here since birth new person 5"
label var	perm_left	"Members permanently left the household "
label var	perm_relate_1	"Relation to HH permantly left member 1"
label var	perm_relate_2	"Relation to HH permantly left member 2"
label var	perm_relate_3	"Relation to HH permantly left member 3"
label var	perm_sex_1	"Gender of permanently left person 1 "
label var	perm_sex_2	"Gender of permanently left person 2"
label var	perm_sex_3	"Gender of permanently left person 3"
label var	perm_birth_1	"Year of birth of permantently left person 1"
label var	perm_birth_2	"Year of birth of permantently left person 2"
label var	perm_birth_3	"Year of birth of permantently left person 3"
label var	perm_reason_1	"Reason for leaving of permanently left person 1 "
label var	perm_reason_2	"Reason for leaving of permanently left person 2"
label var	perm_reason_3	"Reason for leaving of permanently left person 3"
label var	perm_district_1	"District name of place permantely left person 1 "
label var	perm_district_2	"District name of place permantely left person 2"
label var	perm_district_3	"District name of place permantely left person 3"
label var	perm_area_1	"Urban or Rural location of Permantly left person 1"
label var	perm_area_2	"Urban or Rural location of Permantly left person 2"
label var	perm_area_3	"Urban or Rural location of Permantly left person 3"
label var	perm_remit	"Permantly left persons send remittances "

********************************************************************************
* Section 3: Labor migration questions: v87-v138
********************************************************************************

// 3.1, 3.2.0 existance of migrant 

rename v87 mig1_exist
rename v113 mig2_exist 
foreach i of num 1/2{
	replace mig`i'_exist=0 if mig`i'_exist==4
	yesno mig`i'_exist
}

//3.1.1, 3.2.1 relationship to household head 
rename v88 mig1_relate
rename v114 mig2_relate

foreach i of num 1/2{ 
label values  mig`i'_relate relate
}


//3.1.2, 3.2.2 sex of migrant 
rename v89 mig1_sex
rename v115 mig2_sex

label define sex 0 "Female" 1 "Male" 
foreach i of num 1/2{
	replace mig`i'_sex=0 if mig`i'_sex==2 
	label value mig`i'_sex sex 
}


//3.1.3, 3.2.3 year of birth-migrant ***migrant1 born in 1886
rename v90 mig1_birth 
rename v116 mig2_birth

//3.1.3, 3.2.3 Educational attainment 
rename v91 mig1_edu
rename v117 mig2_edu

label define mig_edu 1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown"


foreach i of num 1/2{
 label values mig`i'_edu mig_edu
}

//3.1.5, 3.2.5 Occupation before leaving household-migrant 
rename v92 mig1_occ
rename v118 mig2_occ

rename v93 mig1_occ_other  
rename v119 mig2_occ_other 



label define mig_occ 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other"/*
*/10 "Clinic officer"/*
*/11 "She was not working"

foreach i of num 1/2{ 
label values mig`i'_occ mig_occ
}

//3.1.6, 3.2.6 Reason to leave household 
rename v94 mig1_reason
rename v120 mig2_reason 

/*cannot lable unparsed variables because it is a string 
label define mig_reasons /*
		*/ 1 "Household food insecurity" /*
		*/ 2 "Low household economic resources" /*
		*/ 3 "Higher wages elsewhere" /*
		*/ 4 "Increasing concerns about climatic variability and future crop yields at home" /*
		*/ 5 "Declining environmental conditions at home" /*
		*/ 6 "Lack of household-level demand for labour" /*
		*/ 7 "Lack of regional demand for labour" /*
		*/ 8 "Knew someone who worked in or helped the individual find work in the destination area" /*
		*/ 10 "Prestige associated with moving to the destination area" /*
		*/ 11 "Prestige associated with working in a different type of occupation" /*
		*/ 12 "Better educational opportunities in the destination area" /*
		*/ 13 "Desire to support household by sending money home" /*
		*/ 14 "Desire to permanently leave the household"  /*
		*/ 15 "Other"
foreach i of num 1/2{
	label values mig`i'_reason mig_reasons
	}
*/ 


// 3.1.7, 3.2.7 Occupation while living somewhere else 
rename v96 mig1_occ_away
rename v122 mig2_occ_away 

label define mig_occ_away 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other"
foreach i of num 1/2{ 
label values mig`i'_occ_away mig_occ_away
}

//"other" specified in text data in variable "mig1_occ_away_other" 
rename v97 mig1_occ_away_other 
rename v123 mig2_occ_away_other

// 3.1.8, 3.2.8 Year in which individual first began to support this household 
// while living elsewhere:
rename v98 mig1_year
rename v124 mig2_year

// 3.1.9, 3.2.9 Number of weeks the individual spent away from the household 
// in the last 12 months?
rename v99 mig1_weeks_away
rename v125 mig2_weeks_away

// 3.1.10, 3.2.10 Approximately how much money did this individual give to the 
// household in the last 12 months? (in Kwacha)
rename v100 mig1_money
rename v126 mig2_money

// 3.1.11, 3.2.11 What is the approximate value (in kwacha) of the non-cash 
// remittances you received from this individual in the last 12 months?
rename v101 mig1_noncash
rename v127 mig2_noncash

// 3.1.12, 3.2.12  Migrant ledt the household permanently or temporarily?
rename v102 mig1_permanent
rename v128 mig2_permanent

label define mig_permanent 1 "Permanently" 2 "Temporarily"

foreach i of num 1/2{
	label values mig`i'_permanent mig_permanent
	}

// 3.1.13 Where did the person move to 
rename v103 mig1_district
rename v129 mig2_district 

rename  v104 mig1_town 
rename  v130 mig2_town 

// 3.1.14, 3.2.14 How long is this person expected to be gone	
rename v105 mig1_duration 
rename v131 mig2_duration 

label define mig_duration 1 "Less than a season" 2 "Full season" /*
*/ 3 "Less than a year" 4 "More than a year" 5 "Forever"

foreach i of num 1/2{ 
	label values mig`i'_duration mig_duration
	}

//3.1.14a, 3.2.14a Expected number of absences if migrant is expected to be gone 
//less than a year not sure the diff between v106 and v107
rename v106 mig1_duration_abs
rename v107 mig1_duration_days 

rename v132 mig2_duration_abs
rename v133 mig2_duration_days

//3.1.15, 3.2.15 How many people in villahe have migrated to this location 
//within the past 12 months 
rename v108 mig1_othermigs
rename v134 mig2_othermigs


//3.1.16, 3.2.16 Did anyone in the destination area aid migrant in obtaining
//employment
rename v109 mig1_aid 
rename v135 mig2_aid

/*cannot lable unparsed variables because it is a string 

label define mig_aid 1 "Friend" 2 "Family member" 3 "NGO" 4 /*
	*/ "Previous Employer" 5 "Other" 

foreach i of num 1/2{
	label values mig`i'_aid mig_aid
	}
*/ 

rename v110 mig1_aidother
rename v136 mig2_aidother

//3.1.17, 3.2.17 Was employment obtained before arrival at destination
rename v111 mig1_employ 
rename v137 mig2_employ 
foreach i of num 1/2{
	yesno mig`i'_employ 
	}
	
//3.1.19, 3.2.19 Was this person listed in the demo section 
rename v112 mig1_listed 
rename v138 mig2_listed 
foreach i of num 1/2{ 
	yesno mig`i'_listed
	}

rename v95 mig1_reasonother 
rename v121 mig2_reasonother 

foreach i of num 1/2{ 
	tab mig`i'_listed
	}
	
label variable 	mig1_exist	"Existence of migrant 1 "
label variable 	mig1_relate	"Relationship of migrant 1 to HH"
label variable 	mig1_sex	"Sex of migrant 1"
label variable 	mig1_birth	"Year of birth of migrant 1"
label variable 	mig1_edu	"Educational attainment of migrant 1"
label variable 	mig1_occ	"Occupation before migrating of migrant 1 "
label variable 	mig1_reason	"Decision to leave migrant 1 unparsed"
label variable 	mig1_reasonother	"Other reasons for leaving the household text entry "
label variable 	mig1_occ_away 	"Occupation while migrating migrant 1"
label variable 	mig1_occ_away_other	"Occupation while migrating migrant 1 (other text entry "
label variable 	mig1_year	"Year in which remittances sent migrant 1 "
label variable 	mig1_weeks_away	"Number of weeks away migrant 1 "
label variable 	mig1_money	"Remittances value migrant 1 "
label variable 	mig1_noncash	"Non-cash remittances value migrant 1 "
label variable 	mig1_permanent	"Migrant 1 Temp or Perm left "
label variable 	mig1_district	"Migrant 1 moved to district"
label variable 	mig1_town	"Migrant 1 moved to town"
label variable 	mig1_duration	"Legnth of migration of migrant 1 "
label variable 	mig1_duration_abs	"Expected number of days abs migrant 1 "
label variable 	mig1_duration_days	"Expected duration of abs migrant 1 "
label variable 	mig1_othermigs	"Number of people migrated to location of migrant 1 "
label variable 	mig1_aid	"1 Aid in obtaining employment migrant 1 "
label variable 	mig1_aidother	"Aid in obtaining employment migrant 1 (other)"
label variable 	mig1_employ	"Employment obtained pre mig migrant 1 "
label variable 	mig1_listed	"Listed in demographic section migrant 1 "
label variable 	mig2_exist	"Existence of migrant 2 "
label variable 	mig2_relate	"Relationship of migrant 2 to HH"
label variable 	mig2_sex	"Sex of migrant 2"
label variable 	mig2_birth	"Year of birth of migrant 2"
label variable 	mig2_edu	"Educational attainment of migrant 2"
label variable 	mig2_occ	"Occupation before migrating of migrant 2 "
label variable 	mig2_reason	"Decision to leave migrant 2 unparsed"
label variable 	mig2_reasonother	"Other reasons for leaving the household text entry "
label variable 	mig2_occ_away 	"Occupation while migrating migrant 2"
label variable 	mig2_occ_away_other	"Occupation while migrating migrant 2 (other text entry "
label variable 	mig2_year	"Year in which remittances sent migrant 2 "
label variable 	mig2_weeks_away	"Number of weeks away migrant 2 "
label variable 	mig2_money	"Remittances value migrant 2 "
label variable 	mig2_noncash	"Non-cash remittances value migrant 2 "
label variable 	mig2_permanent	"Migrant 2 Temp or Perm left "
label variable 	mig2_district	"Migrant 2 moved to district"
label variable 	mig2_town	"Migrant 2 moved to town"
label variable 	mig2_duration	"Legnth of migration of migrant 2 "
label variable 	mig2_duration_abs	"Expected number of days abs migrant 2 "
label variable 	mig2_duration_days	"Expected duration of abs migrant 2 "
label variable 	mig2_othermigs	"Number of people migrated to location of migrant 2 "
label variable 	mig2_aid	"Aid in obtaining employment migrant 2 "
label variable 	mig2_aidother	"Aid in obtaining employment migrant 2 (other)"
label variable mig2_employ	"Employment obtained pre mig migrant 2 "
label variable mig2_listed	"Listed in demographic section migrant 2 "
		
********************************************************************************
* Section 4: Assets/ Finances v139-v195 q392 q393
********************************************************************************
//4.1 How many phones does hh have 
rename v139 asset_phone 
replace asset_phone=0 if asset_phone==7
label define five 5 "5+"
label value asset_phone five 

//4.1b Has this chnaged since June-July 2016 survey 
rename v140 asset_phone_change
label define change 1 "-3 or more" 2 "-2" 3 "-1" 4 "0 (no change)" 6 "+1" 7 "+2" 8 "+3 or more" 
label values asset_phone_change change 

//4.2 How many TVs does hh have 
rename v141 tv 
replace tv=0 if tv==7 
label value tv five 

//4.2b Has this chnaged since June-July 2016 survey
rename v142 tv_change
label value tv_change change 

//4.3 How many radios does hh have
rename v143 radio 
replace radio=0 if radio==6 
label value radio five 

//4.3b Has this changed since June=-July 2016 survey 
rename v144 radio_change
label value radio_change change 

//4.4 How many bikes does hh have 
rename v145 bike  
replace bike=0 if bike==6
label value bike five 

//4.4b Has this changed since June=-July 2016 survey 
rename v146 bike_change
label value bike_change change 

//4.5 How many motorcycles does hh have 
rename v147 motorcycle
replace motorcycle=0 if motorcycle==6 
label value motorcycle five 

//4.5b Has this changed since June=-July 2016 survey  
rename v148 motorcycle_change
label value motorcycle_change change

//4.6 How many water pumps does hh have 
rename v149 water_pump 
replace water_pump=0 if water_pump==6 
label value water_pump five 

//4.6b Has this changed since June=-July 2016 survey  
rename v150 water_pump_change
label value water_pump_change change 

//4.7 How many ploughs does hh have 
rename v151 plough 
replace plough=0 if plough==6
label value plough five 

//4.7b Has this changed since June=-July 2016 survey  
rename v152 plough_change
label value plough_change change 

//4.8 How many sprayers does hh have 
rename v153 sprayers 
replace sprayers=0 if sprayers==6
label value sprayers five 

//4.8b Has this changed since June=-July 2016 survey  
rename v154 sprayers_change
label value sprayers_change change 

//4.9 How many ox carts does hh have 
rename v155 ox_carts 
replace ox_carts=0 if ox_carts==6
label value ox_carts five

//4.9b Has this changed since June=-July 2016 survey  
rename v156 ox_carts_change
label value ox_carts_change change 

//4.10 How many vehicles does hh have 
rename v157 vehicle
replace vehicle=0 if vehicle==5 
label define four 4 "+4" 
label value vehicle four 

//4.10b Has this changed since June=-July 2016 survey  
rename v158 vehicle_change
label value vehicle_change change 

//4.11 How many iron sheets does hh have 
rename v159 iron_sheets 
replace iron_sheets=0 if iron_sheets==24
replace iron_sheets=1 if iron_sheets==23
yesno iron_sheets 

//4.11b Has this changed since June=-July 2016 survey  
rename v160 iron_sheets_change
yesno iron_sheets_change

//4.12 How many solar panels does hh have 
rename v161 solar 
replace solar=0 if solar==6 
replace solar=3 if solar==12 

//4.12b Has this changed since June=-July 2016 survey  
rename v162 solar_change
label value solar_change change 

//4.13.1 Does your household have oxen?
***enumerator typos replace with 99  
	
rename v163 oxen
**coded 1 and 2 response change to missing 
replace oxen="." if oxen=="1,2" 
destring oxen, replace 

rename v164 breeding_bull
replace breeding_bull="." if breeding_bull=="1,2" 
destring breeding_bull, replace 

rename v165 donkey

yesno oxen 
yesno breeding_bull
yesno donkey 

//4.13.2 How many of the following livestock does your household currently own?
rename v166 female_cattle_number
rename v167 goat_sheep_number
rename v168 poultry_number
rename v169 pigs_number

//4.15 Approximately how much income (in Kwacha) did your household receive from 
//the following activities in the past 12 months?
replace v176="15210" if v176=="15 210"
destring v176, replace

rename v170 income_piecework
rename v171 income_salary
rename v172 income_smallbusiness
rename v173 income_charcoal
rename v174 income_gardening
rename v175 income_forestproduct
rename v176 income_livestock
rename v177 income_remittance
rename v178 income_other

//4.16 How many members of your household did piecework (for cash or food) in 
//the last 12 months? typo 840
rename v179 piecework_members

//4.17 What kinds of piecework did household members do?
rename v180 piecework_kind

//4.18 4.18 Does anyone in this household have a bank account?
rename v181 bank_account
yesno bank_account

//4.19 Has anyone in the household taken out any formal (from a bank) monetary 
//loans in the past 12 months?
rename v182 formal_loan
yesno formal_loan 

//4.20 If you needed to borrow the following amounts, would you be able to 
//(either formal or informal)? 500 2500 10000 yes/no
rename v183 borrow500 
rename v184 borrow2500
rename v185 borrow10000
yesno borrow500
yesno borrow2500
yesno borrow10000

//4.21 Has any member of your household received or transferred money using 
//their mobile phone?
rename v186 phone_transfer
replace phone_transfer=0 if phone_transfer==24
replace phone_transfer=1 if phone_transfer==23 
yesno phone_transfer

//4.23 How much money did your household spend on food in the last 7 days? 
rename v187 food_budget_7day

//4.24 How much money did your household spend on talktime in the last 7 days? 
rename v188 talktime_budget_7day

//4.24 How much money did your household spend on the following in the last 
//month? (in Kwacha)
**replace with numeric value 
replace v195="85" if v195=="85 for pesticides"
destring v195, replace

rename v189 veterinary_cost_month 
rename v190 clothing_cost_month
rename v191 transportation_cost_month
rename v192 alcohol_cost_month
rename v193 firewood_cost_month
rename v194 charcoal_cost_month
**to match 2016 data 
*tostring charcoal_cost_month, replace 
rename v195 other_cost_month

//Q392 4.25 How much did your household spend on school fees in the 
//last 12 months (Kwacha)
replace q392="6430" if q392=="6 430"
replace q392="30000" if q392=="30 000"
destring q392, replace

rename q392 school_fees

//Q393 4.26 How much did your household spend on medical expenses in the last 
//12 months (Kwacha)
rename q393 medical_exp 

label variable 	asset_phone	"Number of mobile phones "
label variable 	asset_phone_change	"Number of mobile phone changes since 2016"
label variable 	tv	"Number of  TVs"
label variable 	tv_change	"Number of TV changes since 2016 "
label variable 	radio	"Number of radios"
label variable 	radio_change	"Number of radio changes since 2016"
label variable 	bike	"Bicycles "
label variable 	bike_change	"Number of bicycle changes since 2016"
label variable 	motorcycle	"Number of motorcycles"
label variable 	motorcycle_change	"Number of motorcycle changes since 2016"
label variable 	water_pump	"Number of water pumps "
label variable 	water_pump_change	"Number of water pump changes since 2016 "
label variable 	plough	"Number of ploughs"
label variable 	plough_change	"Number of plough changes since 2016 "
label variable 	sprayers	"Number of sprayers "
label variable 	sprayers_change	"Number of sprayer changes since 2016"
label variable 	ox_carts	"Number of ox carts "
label variable 	ox_carts_change	"Number of ox cart changes since 2016"
label variable 	vehicle	"Number of vehicles"
label variable 	vehicle_change	"Number of vehicles changes since 2016"
label variable 	iron_sheets	"House has iron sheets"
label variable 	iron_sheets_change	"Have the iron sheets changed since 2016"
label variable 	solar	"Number of solar panels "
label variable 	solar_change	"Number of solar panel changes since 2016 "
label variable 	oxen	"Own oxen "
label variable 	breeding_bull	"Own Breeding bull "
label variable 	donkey	"Own donkey "
label variable 	female_cattle_number	"Number of female cattle "
label variable 	goat_sheep_number	"Number of goat/sheep"
label variable 	poultry_number	"Number of poultry"
label variable 	pigs_number	"Number of pigs"
label variable 	income_piecework	"Income from piece work "
label variable 	income_salary	"Income from Salary/Wage"
label variable 	income_smallbusiness	"Income from Small business"
label variable 	income_charcoal	"Income from charcoal selling "
label variable 	income_gardening	"Income from gardening or horticulture"
label variable 	income_forestproduct	"Income from sale of forrest products"
label variable 	income_livestock	"Income from livestock sales "
label variable 	income_remittance	"Income from non-migration remittances "
label variable 	income_other	"Income from other sources "
label variable 	piecework_members	"Number of household members doing piecework  "
label variable 	piecework_kind	"Kinds of piecework "
label variable 	bank_account	"Anyone have a bank account "
label variable 	formal_loan	"Anyone taken out a formal loan "
label variable 	borrow500	"Be able to borrow 500 K"
label variable 	borrow2500	"Be able to borrow 2,500 K"
label variable 	borrow10000	"Be able to borrow 10,000 K "
label variable 	phone_transfer	"Anyone transferred money from mobile phone "
label variable 	food_budget_7day	"7 day household food budget "
label variable 	talktime_budget_7day	"7 day talk time budget "
label variable 	veterinary_cost	"Last months veterinary expenses "
label variable 	clothing_cost	"Last months clothing expenses "
label variable 	transportation_cost	"Last months transportation expenses "
label variable 	alcohol_cost	"Last months alcohol expenses "
label variable 	firewood_cost	"Last months firewood expenses "
label variable 	charcoal_cost	"Last months charcoal expenses "
label variable 	other_cost	"Last months other significant expenses "
label variable 	school_fees	"12 month school fees "
label variable 	medical_exp	"12 month medical expenses "
********************************************************************************
* Section 5: Dietary Diversity and Expenses v198-v276
* Completely diff food security table in 2016 figure out how to merge properly
********************************************************************************


//5 Was this person (in charge of cooking and feeding family) available to 
//answer the questions in this section? 
rename v198 cook_person
yesno cook_person 

//5.1 In the past 7 days, have there been times when you did not have enough 
//food for the household?
rename v199 enough_food
yesno enough_food

//5.2 In the period right after harvest how many kgs of maize does your 
//household consume in one month?
rename v200 maize_consu_harvest

/////Dietary Diversity Table/////
***replace all strings with numeric**** 
replace v202="." if v202=="0 1"
replace v202="." if v202=="N"

replace v203="0" if v203=="N"
replace v203="0" if v203=="N "
replace v203="0" if v203==" N"
replace v203="0" if v203=="No"
replace v203="1" if v203=="Y"
replace v203="1" if v203=="y"
***typos in v203 
replace v203="." if v203=="30"
replace v203="." if v203=="M"

replace v207="0" if v207=="N"
replace v207="0" if v207==" N"
replace v207="1" if v207=="Y"

replace v211="0" if v211=="N"
replace v211="0" if v211=="N "
replace v211="0" if v211==" N"
replace v211="0" if v211=="No"
replace v211="1" if v211=="Y"
replace v211="1" if v211=="Yes"

***typos in v211
replace v211="." if v211=="7"
replace v211="." if v211=="P"

***typo v212 
replace v212="." if v212==" "

replace v215="0" if v215=="N"
replace v215="0" if v215=="N "
replace v215="0" if v215==" N"
replace v215="0" if v215=="No"
replace v215="1" if v215=="Y"
***typo v215
replace v215="." if v215=="P"

replace v219="0" if v219=="N"
replace v219="0" if v219=="N "
replace v219="0" if v219==" N"
replace v219="1" if v219=="Y"
***typo v219
replace v219="." if v219=="P"

replace v223="0" if v223=="N"
replace v223="0" if v223==" N"
replace v223="1" if v223=="Y"

replace v224="0" if v224=="0p" 

replace v227="0" if v227=="N"
replace v227="0" if v227=="No"
replace v227="0" if v227==" N"
replace v227="1" if v227=="Y"

***typo v230
replace v230="." if v227=="03"

replace v231="0" if v231=="N"
replace v231="0" if v231=="N "
replace v231="0" if v231==" N"
replace v231="0" if v231=="No"
replace v231="1" if v231=="Y"
replace v231="1" if v231=="Yes"
***typo v231
replace v231="." if v231=="25"

replace v235="0" if v235=="N"
replace v235="1" if v235=="Y"
***typo v235
replace v235="." if v235=="2"

replace v239="0" if v239=="N"
replace v239="0" if v239=="N "
replace v239="0" if v239==" N"
replace v239="0" if v239=="No"
replace v239="1" if v239=="Y"
replace v239="1" if v239=="Yes"

replace v243="0" if v243=="N"
replace v243="1" if v243=="Y"
replace v243="1" if v243=="Yes"

***remain string there is a value N that I cannot convert into a 0
replace v247="0" if v247=="No"
replace v247="0" if v247==" N"
replace v247="0" if v247=="N "
replace v247="0" if v247=="N"
replace v247="1" if v247=="Y"
replace v247="1" if v247=="Yes"

replace v251="0" if v251=="N"
replace v251="0" if v251=="N "
replace v251="0" if v251=="No"
replace v251="0" if v251==" N"
replace v251="1" if v251=="Y"

replace v255="0" if v255=="N"
replace v255="0" if v255==" N"
replace v255="0" if v255=="N "
replace v255="0" if v255=="No"
replace v255="1" if v255=="Y"
replace v255="1" if v255=="Yes"

***typo v257
replace v257="." if v257=="å¡"

replace v259="0" if v259=="N"
replace v259="1" if v259=="Y"
replace v259="1" if v259=="Y "
replace v259="." if v259=="U"

replace v263="0" if v263=="N"
replace v263="1" if v263=="Y"
replace v263="1" if v263=="Yes"

foreach i of num 201/264{
	destring v`i',replace 
	}


// Number of days consumed 
rename v201 eat_cereal_days
rename v205 eat_cassava_days
rename v209 eat_carrot_days
rename v213 eat_vegetable_days
rename v217 eat_other_vegetable_days
rename v221 eat_fruit_days
rename v225 eat_other_fruit_days
rename v229 eat_meat_days
rename v233 eat_insect_days
rename v237 eat_egg_days
rename v241 eat_fish_days
rename v245 eat_pulses_days
rename v249 eat_milk_days
rename v253 eat_oil_days
rename v257 eat_sweets_days
destring eat_sweets_days, replace force
rename v261 eat_spice_beverage_days

//Source of food
rename v202 source_cereal
rename v206 source_cassava
rename v210 source_carrot
rename v214 source_vegetable
rename v218 source_other_vegetable
rename v222 source_fruit
rename v226 source_other_fruit
rename v230 source_meat
replace source_meat="3" if source_meat=="O3"
destring source_meat, replace 
rename v234 source_insect
rename v238 source_egg
rename v242 source_fish
rename v246 source_pulses
rename v250 source_milk
rename v254 source_oil
rename v258 source_sweets
rename v262 source_spice_beverage

//Purchased yes or no
rename v203 purchased_cereal
rename v207 purchased_cassava
rename v211 purchased_carrot
rename v215 purchased_vegetable
rename v219 purchased_other_vegetable
rename v223 purchased_fruit
rename v227 purchased_other_fruit
rename v231 purchased_meat
rename v235 purchased_insect
rename v239 purchased_egg
rename v243 purchased_fish
rename v247 purchased_pulses

*typo 
replace purchased_pulses= "0" if startdate=="6/29/17 10:23"
destring purchased_pulses, replace 

rename v251 purchased_milk
rename v255 purchased_oil
rename v259 purchased_sweets
rename v263 purchased_spice_beverage

foreach i in purchased_cereal purchased_cassava purchased_carrot purchased_vegetable purchased_other_vegetable purchased_fruit purchased_other_fruit purchased_meat purchased_insect purchased_insect purchased_egg purchased_fish purchased_pulses purchased_milk purchased_oil purchased_sweets purchased_spice_beverage{
	yesno `i' 
	}


//Approximate value if from own production/collection
rename v204 value_cereal
rename v208 value_cassava
rename v212 value_carrot
rename v216 value_vegetable
rename v220 value_other_vegetable
rename v224 value_fruit
rename v228 value_other_fruit
rename v232 value_meat
rename v236 value_insect
rename v240 value_egg
rename v244 value_fish
rename v248 value_pulses
rename v252 value_milk
rename v256 value_oil
rename v260 value_sweets
rename v264 value_spice_beverage

//5.4 How many different markets did you visit within the last month? 
rename  v265 mkts_visited
*recode values 
replace mkts_visited=mkts_visited-1 
label value mkts_visited five 

//5.5a From which type of market have you purchased most of your food in the last 7 days?
rename v266 mkts_type
label define mkts_type 1 "Village market" 2 "Neighboring village market" 3 "Town market" /*
*/ 4 "Roadside market" 5 "Other" 
label values mkts_type mkts_type

** rename other text entries 
rename v267 mkts_type_other 


//5.5b How many minutes does it take to walk to this market?
rename v268 mkts_mins

//5.5c Is this market on a tarmac road?
rename v269 mkts_tarmac
yesno mkts_tarmac

//5.5d What mode of transportation do you use to get to/from this market?
rename v270 mkts_trans 
label define mkts_trans 1 "walk" 2 "bike" 3 "own car" 4 "own motorbike" 5 "taxi" /*
*/ 6 "other" 7 "bus" 
label values mkts_trans mkts_trans

**rename other text entry 
rename v271 mkts_trans_other 

//5.6 In the last 7 days, how many times has your household had to 
rename v272 days_less_prefer
rename v273 days_borrow_food
rename v274 days_limit
rename v275 days_restrict 
rename v276 days_reduce 

label variable 	cook_person	"Person who is in charge of cooking answered these questions "
label variable 	enough_food	"In 7 days were there times there was not enough food in the house "
label variable 	maize_consu_harvest	"Amount in kgs of household maize consumption"
label variable 	eat_cereal_days	"Number of days consumed cereals "
label variable 	eat_cassava_days	"Number of days consumed cassava"
label variable 	eat_carrot_days	"Number of days consumed carrots"
label variable 	eat_vegetable_days	"Number of days consumed dark green leafy vegetables"
label variable 	eat_other_vegetable_days	"Number of days consumed other vegetables"
label variable 	eat_fruit_days	"Number of days consumed vitamin A fruits"
label variable 	eat_other_fruit_days	"Number of days consumed other fruits"
label variable 	eat_meat_days	"Number of days consumed meat"
label variable 	eat_insect_days	"Number of days consumed insects"
label variable 	eat_egg_days	"Number of days consumed eggs"
label variable 	eat_fish_days	"Number of days consumed fish"
label variable 	eat_pulses_days	"Number of days consumed pulses"
label variable 	eat_milk_days	"Number of days consumed milk"
label variable 	eat_oil_days	"Number of days consumed oil"
label variable 	eat_sweets_days	"Number of days consumed sweets"
label variable 	eat_spice_beverage_days	"Number of days consumed beverages and spices"
label variable 	source_cereal	"Source of cereal"
label variable 	source_cassava	"Source of cassava "
label variable 	source_carrot	"Source of carrots "
label variable 	source_vegetable	"Source of dark leafy green vegetables"
label variable 	source_other_vegetable	"Source of other vegetables"
label variable 	source_fruit	"Source of vitamin A fruit "
label variable 	source_other_fruit	"Source of other fruit"
label variable 	source_meat	"Source of meat"
label variable 	source_insect	"Source of insects "
label variable 	source_egg	"Source of eggs"
label variable 	source_fish	"Source of fish"
label variable 	source_pulses	"Source of pulses"
label variable 	source_milk	"Source of milk"
label variable 	source_oil	"Source of oil"
label variable 	source_sweets	"Source of sweets "
label variable 	source_spice_beverage	"Source of spices and beverages "
label variable 	purchased_cereal	"Binary purchase cereal "
label variable 	purchased_cassava	"Binary purchase cassava "
label variable 	purchased_carrot	"Binary purchase carrots"
label variable 	purchased_vegetable	"Binary purchase dark leefy green vegetables"
label variable 	purchased_other_vegetable	"Binary purchase other vegetables"
label variable 	purchased_fruit	"Binary purchase vitamin A fruit "
label variable 	purchased_other_fruit	"Binary purchase other fruit "
label variable 	purchased_meat	"Binary purchase meat"
label variable 	purchased_insect	"Binary purchase insects "
label variable 	purchased_egg	"Binary purchase eggs "
label variable 	purchased_fish	"Binary purchase fish "
label variable 	purchased_pulses	"Binary purchase pulses "
label variable 	purchased_milk	"Binary purchase milk"
label variable 	purchased_oil	"Binary purchase oil"
label variable 	purchased_sweets	"Binary purchase sweets"
label variable 	purchased_spice_beverage	"Binary purchase spices and beverages "
label variable 	value_cereal	"Value from own production of cereals "
label variable 	value_cassava	"Value from own production of cassava"
label variable 	value_carrot	"Value from own production of carrots"
label variable 	value_vegetable	"Value from own production of dark leefy green vegetables"
label variable 	value_other_vegetable	"Value from own production of other vegetables"
label variable 	value_fruit	"Value from own production of vitamin A fruit "
label variable 	value_other_fruit	"Value from own production of other fruit"
label variable 	value_meat	"Value from own production of meat"
label variable 	value_insect	"Value from own production of insects"
label variable 	value_egg	"Value from own production of eggs"
label variable 	value_fish	"Value from own production of fish"
label variable 	value_pulses	"Value from own production of pulses"
label variable 	value_milk	"Value from own production of milk"
label variable 	value_oil	"Value from own production of oil"
label variable 	value_sweets	"Value from own production of sweets"
label variable 	value_spice_beverage	"Value from own production of spices and beverages "
label variable 	mkts_visited	"In a month number of different markets visited"
label variable 	mkts_type	"Type of market purchased food from "
label variable 	mkts_type_other	"Type of market purchased food from (other) "
label variable 	mkts_mins	"Walking distace in minutes to market "
label variable 	mkts_tarmac	"Market located on tarmac road "
label variable 	mkts_trans	"Mode of transportation to get to/from market "
label variable 	mkts_trans_other 	"Mode of transportation to get to/from market (other)"
label variable 	days_less_prefer	"Number of days rely on less prefered food"
label variable 	days_borrow_food	"Number of days borrowed food "
label variable 	days_limit	"Number of days limit portion size "
label variable 	days_restrict	"Number of days restrict food of adults "
label variable 	days_reduce	"Number of days reduced meals "

********************************************************************************
* Section 6: Land surveys v279-v284
* start of Armand cleaning 2016**
********************************************************************************
//6.1 What is the total area of your farmland for the 2016-2017 growing season?
rename v277 farmland 

//Q394 6.2 How much land do you have that is titled by the state?
rename q394 title_land
replace title_land="." if title_land=="P" 
destring title_land, replace 

//6.3 What is the total amount of land that you cultivated in the 2016-2017 
//growing season (excluding rented land)?
rename v279 cultivown_land

//6.4 How much arable land did you have under fallow during the 2016-2017 
//growing season?
rename v280 fallow_land 

//6.4a What is your reason for fallowing your fields during the last 
//growing season?
rename v281 fallow_reasons

**rename other text entry answers 
rename v282 fallow_reasons_other
 
//6.4b How much land did you rent FROM SOMEONE ELSE in the 2016-2017 
//growing season (including borrowing land)?
rename v283 rentfrom_land 
 
//6.5 How much land did you rent TO SOMEONE ELSE in the 2016-2017 
//growing season (including letting someone borrow land from the household)?
rename v284 rentto_land 

label variable	farmland	"Total area of farm land "
label variable	title_land	"Area of land titled by state "
label variable	cultivown_land	"Total area of cultivated land "
label variable	fallow_land	"Total area of fallowed land "
label variable	fallow_reasons 	"Fallowed land reasons"
label variable	fallow_reasons_other 	"Fallowed land reasons other"
label variable	rentfrom_land	"Area of land rented FROM somone "
label variable	rentto_land	"Area of land rented TO someone "


*label define fallow_reasons 1 "Labor shortage" 2 "Seed shortage" 3 "Fertilizer shortage" 4 "Soil fertility problems" 5 "Delayed rainfall" 6 "Other" 
*label values fallow_reasons fallow_reasons
*could not label since there are multiple responses

********************************************************************************
* Section 7: Maize Plantings Starter 

********************************************************************************
           
rename v285 grewmaize
yesno grewmaize 

rename v286 plantnum
label value plantnum five 





********************************************************************************

********************************************************************************
* Section 8 Maize planting 1-5  

********************************************************************************

***************Labeling

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
	12 "3rd week of January", replace 


label define seed_company ///
	1 "SeedCo" ///
	2 "MRI"  ///
	3 "Pioneer" ///
	4 "Pannar" ///
	5 "Zamseed" ///
	6 "Dekalb" ///
	7 "Kamano" ///
	8 "Klein Karoo" ///
	10 "Other Hybrid" ///
	11 "Local Maize" ///
	13 "Unknown local" ///
	14 "Golden Valley" ///
	15 "Progene", replace 

label define seed_co_var ///
	1 "SC 303" ///
	2 "SC 403" ///
	3 "SC 411" ///
	4 "SC 506" ///
	5 "SC 513" ///
	6 "SC 525" ///
	7 "SC 602" ///
	8 "SC 608" ///
	9 "SC 621" ///
	10 "SC 627" ///
	11 "SC 633" ///
	12 "SC 637" ///
	13 "SC 647" ///
	14 "SC 701" ///
	15 "SC 709" ///
	16 "SC 719" ///
	17 "SC 727" ///
	18 "Other SeedCo", replace


label define mri_var ///
	1	"MRI 514"	///
	2	"MRI 594"	///
	3	"MRI 614"	///
	4	"MRI 624"	///
	5	"MRI 634"	///
	6	"MRI 654"	///
	7	"MRI 694"	///
	8	"MRI 704"	///
	9	"MRI 714"	///
	10	"MRI 455"	///
	11	"SY 5944"	///
	12	"MRI 644"	///
	13	"MRI 724"	///
	14	"MRI 734"	///
	15	"MRI 744"	///
	16	"MRI 651"	///
	17	"MRI 711"	///
	18	"Other MRI"	///

	
label define pioneer_var ///
	1 "PHB 30G19" ///
	2 "PHB 3253" ///
	3 "P3812W" ///
	4 "P2859W" ///
	5 "P3506W" ///
	6 "PHB 30B50" ///
	7 "Other Pioneer", replace
		
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
	13 "PAN 413" ///
	14 "PAN 691" ///
	15 "PAN 4M-23" ///
	16 "PAN 7M-81" ///
	17 "PAN 7M-83" , replace
	
		
label define zamseed_var ///
	1 "ZMS 402" ///
	2 "ZMS 502" ///
	3 "ZMS 510" ///
	4 "ZMS 528" ///
	5 "ZMS 606" ///
	6 "ZMS 607Y" ///
	7 "ZMS 616" ///
	8 "ZMS 620" ///
	9 "ZMS 623" ///
	10 "ZMS 638" ///
	11 "ZMS 717" ///
	12 "ZMS 702" ///
	13 "ZMS 720" ///
	14 "ZMS 721" ///
	15 "Other Zamseed" ///
	16 "ZMS 402" ///
	17 "ZMS 652", replace
	
label define dekalb_var ///
	1 "DKC80-21" ///
	2 "DKC80-33" ///
	3 "DKC80-73" ///
	4 "DKC90-53" ///
	5 "DKC90-89" ///
	6 "DKC777" ///
	7 "Other Dekalb", replace








*Question "8.1.1 When did you perform this planting?"
rename v287 date_1 
*Question "8.1.2 What are the reasons you planted at this time? "
rename v288 reason_1

label define reason ///
1 "I always plant at that time of year" ///
2 "I could tell the rains were going to come soon" ///
3 "The rains had already started" ///
4 "I decided because of information I got from a weather forecast on TV or radio" ///
5 "Other reasons" ///
6 "I decided because of weather forecast information I got directly from the Met department" ///
7 "I was in a project that required a specific planting date" ///
9 "I was working with a group and the group determined the planting time for my field" ///
11 "Adequate soil moisture" ///




rename v289 reason_txt_1
** Question 8.x.3 and 8.x.4 found at end of section 8
rename v290 company_1 
rename v291 seed_co_1
rename v292 mri_1
rename v293 pioneer_1
rename v294 pannar_1
rename v295 zamseed_1
rename v296 dekalb_1
*Question "8.1.5 Was this recycled seed?"
rename v297 recycl_1
*Question "8.1.6 Was there a second seed variety mixed in for this planting?"
rename v298 second_1
*Question "8.1.7 Was this a replanting?"
rename v299 replnt_1

*Question "8.1.8 Were these traditional FISP or e-voucher seeds?"
rename v300 fseed_1
label define fseed 1 "Traditional FISP" 2 "FISP e-voucher"  3 "Neither" 

*Question "8.1.9 What was the total quantity of seed that you planted (in Kg)?"
rename v301 qseed_1
*Question "8.1.10 What was the size of the plot (ha)?"
rename v302 plot_1
*Question "8.1.11 What was the harvest in Kg FOR THIS PLANTING?"
rename v303 qharv_1
*Question "8.1.12 Is there unharvested maize from this planting remaining in the field?"
rename v304 unharv_1

*Question "8.1.13 Did you harvest any green maize for this planting?"
rename v305 grn_1
yesno grn_1 

rename v306 qgrn_1
replace qgrn_1="5" if qgrn_1=="5°"
destring qgrn_1, replace 

*Question "8.1.14 What types of fertilizer were used for this planting?"
rename v307 ferts_1

*Question "8.1.15 How much basal dressing fertilizer was applied to this planting (kgs)?"
rename v308 qbasal_1
*Question "8.1.16 How much top dressing fertilizer was applied to this planting (kgs)?"
rename v309 qtop_1
*Question "8.1.17 Did you intercrop this planting?"
rename v310 inter_1


*Question "8.1.18 Did you use labor from outside the household to assist you with this planting (even volunteered labor)?"
rename v311 cult_1
rename v312 plnt_1
rename v313 fert_1
rename v314 weed_1
rename v315 harv_1


	
	
/// coding conventions and questions follow same order for plantings 2 through 5

/// maize planting 2
rename v316 date_2	
rename v317 reason_2
rename v318 reason_txt_2

rename v319 company_2
rename v320 seed_co_2
rename v321 mri_2
rename v322 pioneer_2
rename v323 pannar_2
rename v324 zamseed_2
rename v325 dekalb_2


rename v326 recycl_2
rename v327 second_2
rename v328 replnt_2
rename v329 fseed_2
rename v330 qseed_2
rename v331 plot_2
rename v332 qharv_2
rename v333 unharv_2
rename v334 grn_2
replace grn_2=0 if grn_2==9 
yesno grn_2

rename v335 qgrn_2
rename v336 ferts_2
rename v337 qbasal_2
rename v338 qtop_2
rename v339 inter_2
rename v340 cult_2
tostring cult_2, replace 
rename v341 plnt_2
rename v342 fert_2
rename v343 weed_2
rename v344 harv_2

/// maize planting 3
rename v345 date_3
rename v346 reason_3
rename v347 reason_txt_3
rename v348 company_3
rename v349 seed_co_3
rename v350 mri_3
rename v351 pioneer_3
rename v352 pannar_3
rename v353 zamseed_3


rename v354 dekalb_3
rename v355 recycl_3
rename v356 second_3
rename v357 replnt_3
rename v358 fseed_3
rename v359 qseed_3
rename v360 plot_3
rename v361 qharv_3
rename v362 unharv_3
rename v363 grn_3
yesno grn_3

rename v364 qgrn_3
rename v365 ferts_3


rename v366 qbasal_3
rename v367 qtop_3
rename v368 inter_3
rename v369 cult_3
rename v370 plnt_3
rename v371 fert_3
rename v372 weed_3
rename v373 harv_3

/// maize planting 4
rename v374 date_4
rename v375 reason_4
rename v376 reason_txt_4
rename v377 company_4
rename v378 seed_co_4
rename v379 mri_4
rename v380 pioneer_4
rename v381 pannar_4
rename v382 zamseed_4
rename v383 dekalb_4

rename v384 recycl_4
rename v385 second_4
rename v386 replnt_4
rename v387 fseed_4
rename v388 qseed_4
rename v389 plot_4
rename v390 qharv_4
rename v391 unharv_4
rename v392 grn_4
yesno grn_4
rename v393 qgrn_4
rename v394 ferts_4


rename v395 qbasal_4
rename v396 qtop_4
rename v397 inter_4
rename v398 cult_4
rename v399 plnt_4
rename v400 fert_4
rename v401 weed_4
rename v402 harv_4

/// maize planting 5
rename v403 date_5
rename v404 reason_5
rename v405 reason_txt_5
rename v406 company_5
rename v407 seed_co_5
rename v408 mri_5
rename v409 pioneer_5
rename v410 pannar_5
rename v411 zamseed_5
rename v412 dekalb_5

rename v413 recycl_5
rename v414 second_5
rename v415 replnt_5
rename v416 fseed_5
rename v417 qseed_5
rename v418 plot_5
rename v419 qharv_5
rename v420 unharv_5
rename v421 grn_5
yesno grn_5 

rename v422 qgrn_5

rename v423 ferts_5
rename v424 qbasal_5
rename v425 qtop_5
rename v426 inter_5
rename v427 cult_5
rename v428 plnt_5
rename v429 fert_5
rename v430 weed_5
rename v431 harv_5




foreach i of num 1/5{
	*label values reason_`i' reason
	label values date_`i' dates	
	label values company_`i' company 
	label values seed_co_`i' seedco
	label values mri_`i' mri
	label values pioneer_`i' pioneer
	label values pannar_`i' pannar 
	label values zamseed_`i' zamseed
	label values dekalb_`i' dekalb
	label values fseed_`i' fseed
	yesno recycl_`i'
	replace second_`i'=0 if second_`i'==74
	yesno second_`i'
	yesno replnt_`i'
}

destring cult_2, replace
foreach i of num 1/5{ 
	yesno cult_`i' 
	yesno plnt_`i'
	yesno fert_`i'
	yesno inter_`i' 
	yesno unharv_`i'
	}


label variable 	grewmaize	"HH grew maize"
label variable 	plantnum	"Number of plantings"
label variable 	date_1	"Planting 1: Date of planting "
label variable 	reason_1	"Planting 1: Reasons for planting on that date (unparsed)"
label variable 	reason_txt_1	"Planting 1: Reasons for planting on that date (other)"
label variable 	company_1	"Planting 1: Seed company "
label variable 	seed_co_1	"Planting 1: Seedco variety "
label variable 	mri_1	"Planting 1: MRI variety "
label variable 	pioneer_1	"Planting 1: Pioneer variety "
label variable 	pannar_1	"Planting 1: Pannar variety "
label variable 	zamseed_1	"Planting 1: Zamseed variety"
label variable 	dekalb_1	"Planting 1: Dekalb variety "
label variable 	recycl_1	"Planting 1: Used Recycled seed"
label variable 	second_1	"Planting 1: Second seed variety "
label variable 	replnt_1	"Planting 1: Was this a replanting "
label variable 	fseed_1	"Planting 1: Use of FISP or E-voucher seeds"
label variable 	qseed_1	"Planting 1: Kgs of seeds planted "
label variable 	plot_1	"Planting 1: Size of plot in ha "
label variable 	qharv_1	"Planting 1: Harvest in kgs"
label variable 	unharv_1	"Planting 1: Unharvested maize remaining "
label variable 	grn_1	"Planting 1: Harvested green maize "
label variable 	qgrn_1	"Planting 1: kgs  of harvested green maize "
label variable 	ferts_1	"Planting 1: Types of fertilizer unparsed"
label variable 	qbasal_1	"Planting 1: Kgs of basal dressing "
label variable 	qtop_1	"Planting 1: kgs of top dressing fertilizer "
label variable 	inter_1	"Planting 1: Intercrop "
label variable 	cult_1	"Planting 1: Outside labor cultivating"
label variable 	plnt_1	"Planting 1: Outside labor planting "
label variable 	fert_1	"Planting 1: Outside labor fertilizing "
label variable 	weed_1	"Planting 1: Outside labor weeding "
label variable 	harv_1	"Planting 1: Outside labor harvesting "
label variable 	date_2	"Planting 2: Date of planting "
label variable 	reason_2	"Planting 2: Reasons for planting on that date unparsed "
label variable 	reason_txt_2	"Planting 2: Reasons for planting on that date (other)"
label variable 	company_2	"Planting 2: Seed company "
label variable 	seed_co_2	"Planting 2: Seedco variety "
label variable 	mri_2	"Planting 2: MRI variety "
label variable 	pioneer_2	"Planting 2: Pioneer variety "
label variable 	pannar_2	"Planting 2: Pannar variety "
label variable 	zamseed_2	"Planting 2: Zamseed variety"
label variable 	dekalb_2	"Planting 2: Dekalb variety "
label variable 	recycl_2	"Planting 2: Used Recycled seed"
label variable 	second_2	"Planting 2: Second seed variety "
label variable 	replnt_2	"Planting 2: Was this a replanting "
label variable 	fseed_2	"Planting 2: Use of FISP or E-voucher seeds"
label variable 	qseed_2	"Planting 2: Kgs of seeds planted "
label variable 	plot_2	"Planting 2: Size of plot in ha "
label variable 	qharv_2	"Planting 2: Harvest in kgs"
label variable 	unharv_2	"Planting 2: Unharvested maize remaining "
label variable 	grn_2	"Planting 2: Harvested green maize "
label variable 	qgrn_2	"Planting 2: kgs  of harvested green maize "
label variable 	ferts_2	"Planting 2: Types of fertilizer (unparsed)"
label variable 	qtop_2	"Planting 2: kgs of top dressing fertilizer "
label variable 	inter_2	"Planting 2: Intercrop "
label variable 	cult_2	"Planting 2: Outside labor cultivating"
label variable 	plnt_2	"Planting 2: Outside labor planting "
label variable 	fert_2	"Planting 2: Outside labor fertilizing "
label variable 	weed_2	"Planting 2: Outside labor weeding "
label variable 	harv_2	"Planting 2: Outside labor harvesting "
label variable 	date_3	"Planting 3: Date of planting "
label variable 	reason_3	"Planting 3: Reasons for planting on that date (unparsed)"
label variable 	reason_txt_3	"Planting 3: Reasons for planting on that date (other)"
label variable 	company_3	"Planting 3: Seed company "
label variable 	seed_co_3	"Planting 3: Seedco variety "
label variable 	mri_3	"Planting 3: MRI variety "
label variable 	pioneer_3	"Planting 3: Pioneer variety "
label variable 	pannar_3	"Planting 3: Pannar variety "
label variable 	zamseed_3	"Planting 3: Zamseed variety"
label variable 	dekalb_3	"Planting 3: Dekalb variety "
label variable 	recycl_3	"Planting 3: Used Recycled seed"
label variable 	second_3	"Planting 3: Second seed variety "
label variable 	replnt_3	"Planting 3: Was this a replanting "
label variable 	fseed_3	"Planting 3: Use of FISP or E-voucher seeds"
label variable 	qseed_3	"Planting 3: Kgs of seeds planted "
label variable 	plot_3	"Planting 3: Size of plot in ha "
label variable 	qharv_3	"Planting 3: Harvest in kgs"
label variable 	unharv_3	"Planting 3: Unharvested maize remaining "
label variable 	grn_3	"Planting 3: Harvested green maize "
label variable 	qgrn_3	"Planting 3: kgs  of harvested green maize "
label variable 	ferts_3	"Planting 3: Types of fertilizer (unparsed) "
label variable 	qbasal_3	"Planting 3: Kgs of basal dressing "
label variable 	qtop_3	"Planting 3: kgs of top dressing fertilizer "
label variable 	inter_3	"Planting 3: Intercrop "
label variable 	cult_3	"Planting 3: Outside labor cultivating"
label variable 	plnt_3	"Planting 3: Outside labor planting "
label variable 	fert_3	"Planting 3: Outside labor fertilizing "
label variable 	weed_3	"Planting 3: Outside labor weeding "
label variable 	harv_3	"Planting 3: Outside labor harvesting "
label variable 	date_4	"Planting 4: Date of planting "
label variable 	reason_4	"Planting 4: Reasons for planting on that date (unparsed)"
label variable 	reason_txt_4	"Planting 4: Reasons for planting on that date (other)"
label variable 	company_4	"Planting 4: Seed company "
label variable 	seed_co_4	"Planting 4: Seedco variety "
label variable 	mri_4	"Planting 4: MRI variety "
label variable 	pioneer_4	"Planting 4: Pioneer variety "
label variable 	pannar_4	"Planting 4: Pannar variety "
label variable 	zamseed_4	"Planting 4: Zamseed variety"
label variable 	dekalb_4	"Planting 4: Dekalb variety "
label variable 	recycl_4	"Planting 4: Used Recycled seed"
label variable 	second_4	"Planting 4: Second seed variety "
label variable 	replnt_4	"Planting 4: Was this a replanting "
label variable 	fseed_4	"Planting 4: Use of FISP or E-voucher seeds"
label variable 	qseed_4	"Planting 4: Kgs of seeds planted "
label variable 	plot_4	"Planting 4: Size of plot in ha "
label variable 	qharv_4	"Planting 4: Harvest in kgs"
label variable 	unharv_4	"Planting 4: Unharvested maize remaining "
label variable 	grn_4	"Planting 4: Harvested green maize "
label variable 	qgrn_4	"Planting 4: kgs  of harvested green maize "
label variable 	ferts_4	"Planting 4: Types of fertilizer "
label variable 	qbasal_4	"Planting 4: Kgs of basal dressing "
label variable 	qtop_4	"Planting 4: kgs of top dressing fertilizer "
label variable 	inter_4	"Planting 4: Intercrop "
label variable 	cult_4	"Planting 4: Outside labor cultivating"
label variable 	plnt_4	"Planting 4: Outside labor planting "
label variable 	fert_4	"Planting 4: Outside labor fertilizing "
label variable 	weed_4	"Planting 4: Outside labor weeding "
label variable 	harv_4	"Planting 4: Outside labor harvesting "
label variable 	date_5	"Planting 5: Date of planting "
label variable 	reason_5	"Planting 5: Reasons for planting on that date (unparsed)"
label variable 	reason_txt_5	"Planting 5: Reasons for planting on that date (other)"
label variable 	company_5	"Planting 5: Seed company "
label variable 	seed_co_5	"Planting 5: Seedco variety "
label variable 	mri_5	"Planting 5: MRI variety "
label variable 	pioneer_5	"Planting 5: Pioneer variety "
label variable 	pannar_5	"Planting 5: Pannar variety "
label variable 	zamseed_5	"Planting 5: Zamseed variety"
label variable 	dekalb_5	"Planting 5: Dekalb variety "
label variable 	recycl_5	"Planting 5: Used Recycled seed"
label variable 	second_5	"Planting 5: Second seed variety "
label variable 	replnt_5	"Planting 5: Was this a replanting "
label variable 	fseed_5	"Planting 5: Use of FISP or E-voucher seeds"
label variable 	qseed_5	"Planting 5: Kgs of seeds planted "
label variable 	plot_5	"Planting 5: Size of plot in ha "
label variable 	qharv_5	"Planting 5: Harvest in kgs"
label variable 	unharv_5	"Planting 5: Unharvested maize remaining "
label variable 	grn_5	"Planting 5: Harvested green maize "
label variable 	qgrn_5	"Planting 5: kgs  of harvested green maize "
label variable 	ferts_5	"Planting 5: Types of fertilizer (unparsed)"
label variable 	qbasal_5	"Planting 5: Kgs of basal dressing "
label variable 	qtop_5	"Planting 5: kgs of top dressing fertilizer "
label variable 	inter_5	"Planting 5: Intercrop "
label variable 	cult_5	"Planting 5: Outside labor cultivating"
label variable 	plnt_5	"Planting 5: Outside labor planting "
label variable 	fert_5	"Planting 5: Outside labor fertilizing "
label variable 	weed_5	"Planting 5: Outside labor weeding "
label variable 	harv_5	"Planting 5: Outside labor harvesting "

		
********* rename section 9 ************* complete - Jordan 12/12/17

***Question "9.1 How many kgs of maize from the 2015/2016 season do you have in storage now?"
rename v432 storage

***Question "9.2 What week/month was your maize from the 2015/2016 harvest finished or all sold?"
rename v433 mz_fin_wk
replace mz_fin_wk="." if mz_fin_wk=="December" 
destring mz_fin_wk, replace 
rename v434 mz_fin_mth
replace mz_fin_mth="4" if mz_fin_mth=="April"
replace mz_fin_mth="4" if mz_fin_mth=="April "
replace mz_fin_mth="8" if mz_fin_mth=="August"
replace mz_fin_mth="8" if mz_fin_mth=="August "
replace mz_fin_mth="12" if mz_fin_mth=="December"
replace mz_fin_mth="12" if mz_fin_mth=="December "
replace mz_fin_mth="2" if mz_fin_mth=="Feb"
replace mz_fin_mth="2" if mz_fin_mth=="February"
replace mz_fin_mth="2" if mz_fin_mth=="February "
replace mz_fin_mth="1" if mz_fin_mth=="January"
replace mz_fin_mth="1" if mz_fin_mth=="January "
replace mz_fin_mth="7" if mz_fin_mth=="July"
replace mz_fin_mth="7" if mz_fin_mth=="July "
replace mz_fin_mth="6" if mz_fin_mth=="June"
replace mz_fin_mth="6" if mz_fin_mth=="June "
replace mz_fin_mth="2" if mz_fin_mth=="March"
replace mz_fin_mth="2" if mz_fin_mth=="March "
replace mz_fin_mth="5" if mz_fin_mth=="May"
replace mz_fin_mth="5" if mz_fin_mth=="May "
replace mz_fin_mth="5" if mz_fin_mth==" May"
replace mz_fin_mth="5" if mz_fin_mth==" May  "
replace mz_fin_mth="5" if mz_fin_mth==" May "
replace mz_fin_mth="11" if mz_fin_mth=="November"
replace mz_fin_mth="11" if mz_fin_mth=="November "
replace mz_fin_mth="10" if mz_fin_mth=="October"
replace mz_fin_mth="10" if mz_fin_mth=="October "
replace mz_fin_mth="9" if mz_fin_mth=="September"
replace mz_fin_mth="9" if mz_fin_mth=="September "
replace mz_fin_mth="9" if mz_fin_mth=="September"
replace mz_fin_mth="12" if mz_fin_mth=="Dec"
destring mz_fin_mth, replace 


rename v435 mz_fin_yr

***Question "9.3 How much total maize have you harvested from the 2016/2017 harvest?"
rename v436 qharvested

***Question "9.4 Do you have any unharvested maize still in your fields?"
rename v437 nonharv

//label var nonharv "HH has unharvested maize in their field in 2015: 0-Yes 1-No"
replace nonharv=1 if nonharv==28
replace nonharv=0 if nonharv==29
label define nonharv 0 "No" 1 "Yes", replace
label values nonharv nonharv
*sum nonharv

***Question "9.5 How much additional maize do you expect to harvest from your remaining 2016/2017 maize crops?"
rename v438 qleft

***Question "9.6 Was your current maize crop infested with army worms in the 2016/2017 season?"
rename v439 army
replace army=0 if army==2 
label define army 0 "No" 1 "Yes", replace
label values army army

***Question "9.7 How many times did you spray any of your maize fields with pesticide to kill army worms?"
rename v440 spray
label var spray "9.7 How many times did you spray any of your maize fields with pesticide to kill army worms?"

***Question "9.8 Why didn't you spray?"
rename v441 nospray

label define nospray 1 "1_could not afford pesticide" 2 "2_did not have time to spray" 3"3_pesticide not available" ///
4"4_other", replace
label values nospray nospray
rename v442 no_spray_txt
***Question "9.9 When did you first notice the army worms?"
rename v443 army_wk 
destring army_wk, replace 
rename v444 army_mth
replace army_mth="12" if army_mth=="Dec" 
replace army_mth="12" if army_mth=="December" 
replace army_mth="2" if army_mth=="Feb" 
replace army_mth="2" if army_mth=="February" 
replace army_mth="1" if army_mth=="Jan" 
replace army_mth="1" if army_mth=="January" 
replace army_mth="3" if army_mth=="March" 
replace army_mth="11" if army_mth=="November" 
destring army_mth, replace 



rename v445 army_yr

replace army_yr="2017" if army_yr=="2 017" 
replace army_yr="." if army_yr=="201" 
replace army_yr="2017" if army_yr=="2917" 
replace army_yr="." if army_yr=="January" 
destring army_yr, replace


***Question "9.10 How much of your maize crop was affected when you first noticed the army worms?"
rename v446 army_aff

label define army_aff 1"1_little bit" 2"2_most" 3"3_all", replace
label values army_aff army_aff

***Question "9.11 How many total kilograms of maize do you have in storage now?"
rename v447 kgs_stor_now

***Question "9.12 How many months do you think the maize that you currently have in storage will last?"

rename v448 stor_last
***Question "9.13 Have you sold any maize for cash from your 2016/2017 harvest yet?"
rename v449 sold_kgs_current
replace sold_kgs_current=1 if sold_kgs_current==5
replace sold_kgs_current=0 if sold_kgs_current==6
yesno sold_kgs_current

***Question "9.14 To whom have you sold maize from your 2016/2017 harvest?"
rename v450 sold_who_current

***Question "9.15 How many kilograms of maize did you sell in your most recent sale from your 2016/2017 harvest?"
rename v451 rct_sale_kgs

***Question "9.16 How much did you receive for this sale (K)?"
rename v452 rct_sale_kwacha

***Question "9.17 How many KGs of maize from your 2016-2017 harvest have you bartered?"
rename v453 bartered

***Question "9.18 How many KGs of maize from your 2016/2017 harvest do you plan to sell in the future?
rename v454 plan_sell

***Question "9.19 Did you give away maize from your 2016-2017 harvest to anyone?"
rename v455 give_maize
replace give_maize=1 if give_maize==5
replace give_maize=0 if give_maize==6
yesno give_maize

***Question "9.20 How many KGs of maize did you give away?"
rename v456 give_maize_kgs

***Question "9.21 Did someone give you or your HH maize in the last 3 months?"
rename v457 rcv_maize
yesno rcv_maize

***Question "9.22 How many KGs of maize did you receive in the last 3 months?"
rename v458 rcv_maize_kgs

***Question "9.23 Did you buy any maize in the last 3 months?"
rename v459 buy_maize
yesno buy_maize

***Question "9.24 How many KGs of maize (grain) did you buy in the last 3 months?"
rename v460 buy_maize_kgs

***Question "9.25 How much did you pay for your last maize (grain) purchase (including milling cost in K)?"
rename v461 buy_maize_price

***Question "9.26 From where did you purchase this maize (grain) from your last purchase?"
rename v462 buy_maize_loc
label define buymaize 4 "Market" 3 "Amother farmer" 2 "Mill" 5 "Other" 
label val buy_maize_loc  buymaize
***Question "9.27 Did you buy any mealie meal in the last 3 months?"
rename v463 buy_meal
yesno buy_meal 
***Question "9.28 To which of the following types of buyers did you sell or barter maize from your 2015-2016 harvest?"
rename v464 sold_who_prev


***Question "9.29 How many kgs of maize did you sell from your 2015-2016 harvest?"
rename v465 kgs_sold

***Question "9.30 How many KGs of maize from the 2015-2016 growing season did you sell to FRA?"
rename v466 kgs_soldfra

***Question "9.31 What month did you sell to FRA?"
rename v467 fra_month_sold
label define monthsold 1 "April 2016" 2 "May 2016" 3 "June 2016" 4 "July 2016" 5 "August 2016" 6 "September 2016" 7 "October 2016" 8 "November 2016"  9 "December 2016" 10 "January 2017" 11 "February 2017" 12 "March 2017" 13 "April 2017" 14 "May 2017" 
label val  fra_month_sold monthsold 


***Question "9.32 What month were you paid from your sale to FRA?"
rename v468 fra_month_paid
label define monthpaid 1 "April 2016" 2 "May 2016" 13 "June 2016" 14 "July 2016" 15 "August 2016" 16 "September 2016" 25 "October 2016" 17 "November 2016"  18 "December 2016" 19 "January 2017" 20 "February 2017" 21 "March 2017" 22 "April 2017" 23 "May 2017" 
label val  fra_month_paid monthpaid

***Question "9.33 How far away was the FRA depot that you sold to (walking time in minutes)?"
rename v469 fra_dist

***Question "9.34 How many kgs of your maize storage were lost (to pest of mold)?"
rename v470 maize_stor_lost

********* rename section 10 *************   complete - Jordan 12/31/17
//relabeling Question "10.1 What crops did you grow in the 2016-2017 season (select all that apply)"
rename v471 crop17
rename v472 crop17_text
label var crop17 "Crops grown in 2016"

* Labeling crops
label define staples  ///
	1 "Local Maize" ///
	2 "Early maturing maize hybrid" ///
	3 "Medium maturing maize hybrid" ///
	38 "Late maturing maize hybrid" ///
	4 "Sorghum" ///
	5 "Rice" ///
	6 "Millet" ///
	7 "Sunflower" ///
	8 "Groundnuts" ///
	9 "Soyabeans" ///
	10 "Cotton" ///
	11 "Irish Potato" ///
	17 "Sweet Potato" ///
	25 "Tomatoes" ///
	26 "Onions" ///
	16 "Peppers" ///
	39 "Okra" ///
	20 "Leafy Greens" ///
	19 "Carrots" ///
	13 "Cabbage" ///
	12 "Tobacco" ///
	14 "Common Beans" ///
	15 "Cowpeas" ///
	18 "Cassava" ///
	21 "Pigeon Pea" ///
	23 "Orchard" ///
	24 "Other" ///
	65 "No other crops were planted", replace

*label value crop17 staples
*multiple responses unparsed in crop17

//relabeling Question "10.2 From October 2016 until now, what was the most important crop that you planted other than maize?"
rename v473 impcrop17_1
rename v474 impcrop17_text1

***relabeling Question "10.3 what was the total area planted in this crop?"
rename v475 area_crop_1

***relabeling Question "10.4 Did you sell most of your production from this crop?"
rename v476 sold_most_1
yesno sold_most_1

***relabeling Question "10.5 Where did you purchase/acquire your seed for this planting?"
rename v477 purchased_from_1
label define seed1 1 "Neighbor" 2 "Agro-dealer" 3 "Local market" 8 "Town market (District town or other town)"  4 "NGO" 5 "Seed representative" 6 "Given to respondent"  7 "Recycled own seed" 
label val purchased_from_1 seed1


***relabeling Question "10.6 Was this seed purchased using FISP e-voucher?"
rename v478 evoucher_seed_1 
replace evoucher_seed_1=1 if evoucher_seed_1==4
replace evoucher_seed_1=0 if evoucher_seed_1==5
yesno evoucher_seed_1


***relabeling Question "10.7 From Oct. 2016 until now, what was the second most important crop that you planted other than maize?"
rename v479 impcrop17_2
rename v480 impcrop17_text2
rename v481 area_crop_2
rename v482 sold_most_2
yesno sold_most_2
rename v483 purchased_from_2
label val purchased_from_2 seed1

rename v484 evoucher_seed_2
replace evoucher_seed_2=1 if evoucher_seed_2==4 
replace evoucher_seed_2=0 if evoucher_seed_2==5
yesno evoucher_seed_2

***relabeling Question "10.12 From Oct. 2016 until now, what was the third most important crop that you planted other than maize?"
rename v485 impcrop17_3
rename v486 impcrop17_text3
rename v487 area_crop_3
rename v488 sold_most_3
yesno sold_most_3

rename v489 purchased_from_3
label val purchased_from_3 seed1
rename v490 evoucher_seed_3
replace evoucher_seed_3=1 if evoucher_seed_3 == 4
replace evoucher_seed_3=0 if evoucher_seed_3 == 5

//relabeling Question "10.17 Which of the following crops do you expect to grow in the 2017/18 season?"
rename v491 NS_crop


* NS_crop is a string (Must change it to numerics to recode the values)

label define staples  ///
	1 "Local Maize" ///
	2 "Early maturing maize hybrid" ///
	3 "Medium maturing maize hybrid" ///
	38 "Late maturing maize hybrid" ///
	4 "Sorghum" ///
	5 "Rice" ///
	6 "Millet" ///
	7 "Sunflower" ///
	8 "Groundnuts" ///
	9 "Soyabeans" ///
	10 "Cotton" ///
	11 "Irish Potato" ///
	17 "Sweet Potato" ///
	25 "Tomatoes" ///
	26 "Onions" ///
	16 "Peppers" ///
	39 "Okra" ///
	20 "Leafy Greens" ///
	19 "Carrots" ///
	13 "Cabbage" ///
	12 "Tobacco" ///
	14 "Common Beans" ///
	15 "Cowpeas" ///
	18 "Cassava" ///
	21 "Pigeon Pea" ///
	23 "Orchard" ///
	24 "Other" ///
	65 "No other crops were planted", replace

*label value NS_crop staples

 
rename v492 NS_crop_other

//relabeling Question "10.18 In total, how many agro-dealers did you purchase seed from during the 2016-2017 growing season?"
rename v493 dealernum


********* rename section 11 *************  complete - Jordan 12/21/17
***relabeling Question "11.1 To the best of your memory, when did the rains begin in the 2016-2017 season?"
rename v494 rainstart16
label define rainstart16 1 "1_2nd week October" /*
*/ 2 "2_3rd week October" /*
*/ 3 "3_4th week October" /*
*/ 4 "4_1st week November" /*
*/ 5 "5_2nd week November" /*
*/ 6 "6_3rd week November" /*
*/ 7 "7_4th week November" /*
*/ 8 "8_1st week December" /*
*/ 9 "9_2nd week December" /*
*/ 10 "10_3rd week December" /*
*/ 11 "11_4th week December" /*
*/ 12 "12_1st week January" /*
*/ 13 "13_2nd week January", replace
label values rainstart16 rainstart16
*tab rainstart16, sort

***relabeling Question "11.2 To the best of your memory, when did the rains begin in the 2015-2016 season?"
rename v495 rainstart15
label define rainstart15 1 "1_2nd week October" /*
*/ 2 "2_3rd week October" /*
*/ 3 "3_4th week October" /*
*/ 4 "4_1st week November" /*
*/ 5 "5_2nd week November" /*
*/ 6 "6_3rd week November" /*
*/ 7 "7_4th week November" /*
*/ 8 "8_1st week December" /*
*/ 9 "9_2nd week December" /*
*/ 10 "10_3rd week December" /*
*/ 11 "11_4th week December" /*
*/ 12 "12_1st week January" /*
*/ 13 "13_2nd week January", replace
label values rainstart15 rainstart15
*tab rainstart15, sort

***relabeling Question "11.3 To the best of your memory, when did the rains begin in the 2014-2015 season?"
rename v496 rainstart14
label define rainstart14 1 "1_2nd week October" /*
*/ 2 "2_3rd week October" /*
*/ 3 "3_4th week October" /*
*/ 4 "4_1st week November" /*
*/ 5 "5_2nd week November" /*
*/ 6 "6_3rd week November" /*
*/ 7 "7_4th week November" /*
*/ 8 "8_1st week December" /*
*/ 9 "9_2nd week December" /*
*/ 10 "10_3rd week December" /*
*/ 11 "11_4th week December" /*
*/ 12 "12_1st week January" /*
*/ 13 "13_2nd week January", replace
label values rainstart14 rainstart14
*tab rainstart14, sort

***relabeling Question "11.4 To the best of your memory, when did the rains begin in the 2013-2014 season?"
rename v497 rainstart13
label define rainstart13 1 "1_2nd week October" /*
*/ 2 "2_3rd week October" /*
*/ 3 "3_4th week October" /*
*/ 4 "4_1st week November" /*
*/ 5 "5_2nd week November" /*
*/ 6 "6_3rd week November" /*
*/ 7 "7_4th week November" /*
*/ 8 "8_1st week December" /*
*/ 9 "9_2nd week December" /*
*/ 10 "10_3rd week December" /*
*/ 11 "11_4th week December" /*
*/ 12 "12_1st week January" /*
*/ 13 "13_2nd week January", replace
label values rainstart13 rainstart13
*tab rainstart13, sort

***relabeling Question "11.5 To the best of your memory, when did the rains begin about 10 years ago?"
rename v498 rainstart06
label define rainstart06 1 "1_2nd week October" /*
*/ 2 "2_3rd week October" /*
*/ 3 "3_4th week October" /*
*/ 4 "4_1st week November" /*
*/ 5 "5_2nd week November" /*
*/ 6 "6_3rd week November" /*
*/ 7 "7_4th week November" /*
*/ 8 "8_1st week December" /*
*/ 9 "9_2nd week December" /*
*/ 10 "10_3rd week December" /*
*/ 11 "11_4th week December" /*
*/ 12 "12_1st week January" /*
*/ 13 "13_2nd week January", replace
label values rainstart06 rainstart06
*tab rainstart06, sort

***relabeling Question "11.6 How would you characterize the rainfall from the 2016-2017 growing season?"
*"rainint" as in "rain intensity"
rename v499 rainint
la var rainint "how intense was the rainfall during this season"
destring rainint,replace
label define rainint 1 "1_Severe drought" /*
*/ 2 "2_Moderate drought" /*
*/ 4 "4_Average" /*
*/ 5 "5_Above average" /*
*/ 6 "6_Too much", replace
label values rainint rainint
*tab rainint16, sort

***relabeling Question "11.7 How often would you say that you experience a drought year?"
rename v500 droughtfreq
la var droughtfreq "how often droughts occur"
label define droughtfreq 1 "1_Every year" /*
*/ 2 "2_Every other year" /*
*/ 3 "3_Once every 3 years" /*
*/ 4 "4_Once every 4 years" /*
*/ 5 "5_Once every 5 years" /*
*/ 6 "6_Once every 6 years" /*
*/ 7 "7_Once every 7 years" /*
*/ 8 "8_Once every 8 years" /*
*/ 9 "9_Once every 9 years" /*
*/ 10 "10_Once every 10 years or less frequently", replace
label values droughtfreq droughtfreq
*tab droughtfreq

***relabeling Question "11.8 How long did the longest dry spell last in the 2016-2017 growing season? (in days)"
*"droughtint" as in "drought intensity"
rename v501 droughtint
la var droughtint "longest dryspell in 16/17"

***relabeling Question "11.9 How did this dry spell impact your harvest?"
*"droughtimp" as in "drought impact"
rename v502 droughtimp
la var droughtimp "how did dryspell impact farm"
label define droughtimp 1 "None" 2 "Somewhat" 3 "Significantly" 
label values droughtimp droughtimp

***relabeling Question "11.10 Did flooding affect your harvests in the 2016-2017 growing season?"
rename v503 floodaff
la var floodaff "did flood affect maize in 16/17"
label define flood 0 "No" 1"Yes"
yesno floodaff 

***relabeling Question "11.11 How did the floods impact your harvest?"
*"floodimp" as in "flood impact"
rename v504 floodimp
la var floodimp "how did flood impact harvest"
label define floodimp 1 "None" /*
*/ 2 "Somewhat" /*
*/ 3 "Significantly", replace
label values floodimp floodimp
*tab floodimp16, sort

***relabeling Question "11.12 Do you think the rain in the 2017-2018 growing season will be the same, more, or less, than the 2016-2017 growing season?"
rename v505 rains
la var rains "expectation of next season rains"
label define rains 1 "Less" /*
*/ 2 "More" /*
*/ 3 "The same", replace
label values rains rains

********* rename section 12 ************* 
*Question "12.1: the variable for agricultural cooperative membership in 2016"  
rename v506 coop
la var coop "coop member (1=yes)"
label define yesno 1 "1_yes" 0 "0_no" 
label values coop yesno  

*Question "12.2: How much is the membership share to be a member of this cooperative? (In Kwacha)"
rename v507 coopshare
la var coopshare "coop membership share"

*Question "12.3: What is the annual renewal fee to be a member of this cooperative? (In Kwacha)"
rename v508 cooprenew
la var cooprenew "coop annual renewal fee"

*Question "12.4: Have you previously been in another cooperative?"
rename v509 coop_prev
la var coop_prev "previously in other coop"
label values coop_prev yesno

*Question "12.5: Why did you leave the previous cooperative?"
rename v510 left_why
la var left_why "why R left prev. coop"
label define left_why 1"1_previous coop too expensive" 2"2_members wanted to split" ///
3"3_respondent expelled" 4"4_coop stopped working" 5"5_lost faith in leaders" ///
6"6_other"
label values left_why left_why  
rename v511 left_why_txt

*Question "12.6: What appeal did members consider to split to form their own cooperative?"
rename v512 mems_left_appeal
la var mems_left_appeal "why coop split"
label define mems_left_appeal 1"1_new coop less expensive" ///
2"2_new coop has greater fisp benefits" ///
3"3_mems wanted to expand business" 4"4_other" 
label values mems_left_appeal mems_left_appeal  
rename v513 mems_left_appeal_txt

*Question "12.7: Why did you join the current cooperative?"
rename v514 join_why
la var join_why "why R joined current coop"
label define join_why 1"1_closest coop to hh" 2"2_family mems also mems" ///
3"3_camp off encouraged joining" 4"4_low mem fee" 5"5_only coop in area" ///
6"6_other"
label values join_why join_why  
rename v515 join_why_txt

*Question "12.8: What is the official purpose/funciton of this agricultural cooperative?"
rename v516 off_funct
la var off_funct "official coop purpose"
label define off_funct 1"1_fisp" 2"2_dairy" 3"3_livestock" 4"4_trade" ///
5"5_village savings loan" 6"6_other"
label values off_funct off_funct  
rename v517 off_funct_txt

*Question "12.9: What is your reason for joining this agricultural cooperative?"
rename v518 r_reas
la var r_reas "purpose R joined coop"
label values r_reas off_funct
rename v519 r_reas_txt

* Question "12.10 What benefits/advantages do you get from the cooperative?"
rename v520 coop_bens 
la var coop_bens "benefits of coop membership"
rename v521 oth_bens_txt
la var oth_bens_txt "benefits of coop membership (text)"

* Question "12.11 How are the cooperative's fees (membership shares and renewal fees) used by the cooperative?"
rename v522 fees_used
la var fees_used "how coop fees used"
label define fees_used 1"1_facilitate transport" 2"2_funeral expenses" ///
3"3_respondent doesn't know" 4"4_other"
label values fees_used fees_used  
rename v523 fees_used_txt

*Question "12.12: What is the cooperative leader's gender?"
rename v524 lead_gender
label define malefem 1"1_male" 0"0_female"
label values lead_gender malefem

*Question "12.13: How long has that person been the coop's leader?"
rename v525 lead_yrs
la var lead_yrs "how long has leader been in position"
label define lead_yrs 1"1_1 year" 2"2_2 years" ///
3"3_3 years" 4"4_4 years" 5"5_5+ years"
label values lead_yrs lead_yrs 

*Question "12.14: Is the R related to the coop leader?"
rename v526 lead_relate
la var lead_relate "R related to leader (1=yes)"
label values lead_relate yesno

*Question "12.15: What is the R's relationship to the leader?"
rename v527 relate_lead
la var relate_lead "R's relation to leader"
label define relate_lead 1"1_1 respondent is leader/spouse of leader" ///
2"2_son/daughter" ///
3"3_niece/nephew" 4"4_brother/sister" 5"5_other"
label values relate_lead relate_lead 
rename v528 relat_lead_txt

*Question "12.16: About how many members are in the coop?"
rename v529 coop_mems
label define coop_mems 1"1_10-14" 2"2_15-19" 3"3_20-24" ///
4"4_25-29" 5"5_30-34" 6"6_35+"
label values coop_mems coop_mems
la var coop_mems "About how many members are in the coop"

*Question "12.17: Why is this HH not a member of an ag coop?"
rename v530 not_coop
la var not_coop "why R not coop member"
rename v531 not_coop_txt

*Question "12.18: Did you participate in FISP during the 2016-2017 agricultural season?"
rename v532 fisp_evouch
la var fisp "particpated in FISP in 16/17"
label define fisp16 1"1_conventional fisp" 2"2_evoucher fisp" 3"3_no"
label values fisp_evouch fisp16

*Question "12.20: When was your FISP e-voucher card first used during the 2016-2017 ag season?"
rename v533 fispused
la var fispused "when was evouch first used / activated"
label define fispused 1"1_1st wk oct 2016" 2"2_2nd wk oct 2016" 3"3_3rd wk oct 2016" ///
4"4_4th wk oct 2016" 5"5_1st wk nov 2016" 6"6_2nd wk nov 2016" 7"7_3rd wk nov 2016" ///
8"8_4th wk nov 2016" 9"9_1st wk dec 2016" 10"10_2nd wk dec 2016" ///
11"11_3rd wk dec 2016" 12"12_4th wk dec 2016" 13"13_1st wk jan 2017" ///
14"14_2nd wk jan 2017" 15"15_3rd wk jan 2017" 16"16_4th wk jan 2017" ///
17"17_1st wk feb 2017"
label values fispused fispused

*Question "12.21: When was your conventional FISP package delivered during the 2016-2017 ag season?"
rename v534 fisp_dlvr
la var fisp_dlvr "conventional fisp delivered in 16/17"
label values fisp_dlvr card_use

*Q411 "How did you redeem the money on your e-voucher card?"
rename q411 how_redeem
la var how_redeem "how R redeemed evoucher"
label define redeem 1"1_coop leadership redeemed" 2"2_resp swiped at local" ///
3"3_resp swiped in town" 4"4_other"
label values how_redeem redeem 

rename q411_4_text how_redeem_txt

*Question "12.22: How much of your FISP e-voucher credit did you spend in the following categories?"
rename v537 vfert
la var vfert "evouch used on fertilizer (kwacha)"
rename v538 vfert_bags
la var vfert_bags "evouch used on fertilizer (#bags)"
rename v539 vmaizeseed
la var vmaizeseed "evouch used on maize seed"
*should have no values attached to them based on question these should be blank
drop v540 v542 v544 v546 v548 v550
rename v541 votherseed
la var votherseed "evouch used on other seed"
rename v543 vequip
la var vequip "evouch used on implements"
rename v545 vchem
la var vchem "evouch used on chemicals"
rename v547 vhealth
la var vhealth "evouch used on immunizations"
rename v549 vgoods
la var vgoods "evouch used on non-ag goods"


********* rename section 13 ************* 
*Question "13.1a"
rename v551 agext_info
la var agext_info "HH received ag extension service (1=yes)"
*Question "13.1 Which of the following groups have you received farming / ag info from?"
****rename these variables
rename v552 gov_ext
la var gov_ext "info from government extension"
rename v553 priv_ext
la var priv_ext "info from private extension"
rename v554 ngo_info
la var ngo_info "info from NGO"
rename v555 lead_frmr
la var lead_frmr "info from lead farmer"
rename v556 oth_frmr
la var oth_frmr "info from other farmer"
rename v557 med_info
la var med_info "info from media source"

*Question "13.2"
rename v558 info_effect
la var info_effect "the effect of the extension info"
label define info_effect 1"1_not effective" 2"2_somewhat effective" ///
3"3_very effective" 
label values info_effect info_effect 

*Question "13.3"
rename v559 phys_visit
la var phys_visit "farm physically visited (1=yes)"
yesno phys_visit

*Question "13.4"
rename v560 visit_times
la var visit_times "number of times visited"
label define visit_times 1"1_1 to 3 times" 2"2_4 to 6 times" ///
3"3_6 to 9 times" 4"4_10+ times"
label values visit_times visit_times 

*Question "13.5 Which agents visited the farm?"
rename v561 agts
la var agts "which agents visited farm"
rename v562 agts_txt
la var agts_txt "which agents visited farm (text)"

*Question "13.6 What area(s) of education/farm improvement/betterment was discussed?"
rename v563 farm_imp
la var farm_imp "areas of farming discussed"
rename v564 farm_imp_txt
la var farm_imp_txt "areas of farming discussed (text)"

* Question "13.7"
rename v565 topics
la var topics "topics R wants more info on"

********* rename section 14 ************* complete - Jordan 12/21/17
*Question "14.0: is someone at this HH being trained to participate in the weekly SMS survey?"
rename v566 trained_sms
replace trained_sms=1 if trained_sms==5
replace trained_sms=0 if trained_sms==6
yesno trained_sms
la var trained_sms "someone form HH trained in SMS (1=yes)"

*Question "14.2"
rename v567 sms_name
la var sms_name "trained individual's name"
*Question "14.3"
rename v568 sms_num
la var sms_num "individual's phone number"
*Question "14.4"
rename v569 survey_comments
la var survey_comments "enumerator comments on survey"

rename name_respondent name 
********************************************************************************
						******Variable labeling*****
********************************************************************************
label var 	storage	"Storage remaining from last harvest "
label var 	mz_fin_wk	"Week storage ran out"
label var 	mz_fin_mth	"Month storage ran out "
label var 	mz_fin_yr	"Year storage ran out "
label var 	qharvested	"Total quantity  maize harvested this season"
label var 	nonharv	"Is there unharvested maize in field"
label var 	qleft	"How much maize is remaining"
label var 	army	"Fall armyworms present this season"
label var 	spray	"Number of times sprayed pesticide "
label var 	nospray	"Reason not to spray "
label var 	no_spray_txt	"Reason not to spray (other text entry)"
label var 	army_wk	"Week noticing Fall armyworms"
label var 	army_mth	"Month noticing Fall armywomrs"
label var 	army_yr	"Year noticing Fall armyworms"
label var 	army_aff	"Amount of maize crop affected by FAW"
label var 	kgs_stor_now	"Kgs in storage now"
label var 	stor_last	"Months storage will last "
label var 	sold_kgs_current	"Sold maize for cash this season"
label var 	sold_who_current	"Who did yous sell maze to for cash "
label var 	rct_sale_kgs	"How many kgs of maize sold "
label var 	rct_sale_kwacha	"Amount of kwacha received for sold maize"
label var 	bartered	"Kgs of bartered maize "
label var 	plan_sell	"Kgs of maize plan to sell in future "
label var 	give_maize	"Did you give away any maize "
label var 	give_maize_kgs	"Kgs of maize given away "
label var 	rcv_maize	"Receive maize from anyone "
label var 	rcv_maize_kgs	"Kgs of received maize "
label var 	buy_maize	"Buy maize "
label var 	buy_maize_kgs	"Kgs of purhcased mazie "
label var 	buy_maize_price	"Amount of kwacha paid for purchased maize"
label var 	buy_maize_loc	"Place/person of purchase maize "
label var 	buy_meal	"Purchased mealie meal "
label var 	sold_who_prev	"Place/person of sale or barter maize "
label var 	kgs_sold	"Kgs of pmaize sold from prev harvest "
label var 	kgs_soldfra	"kgs of maize sold to FRA from prev harvest "
label var 	fra_month_sold	"Month sold to FRA"
label var 	fra_month_paid	"Month paid from FRA "
label var 	fra_dist	"Distance to FRA "
label var 	maize_stor_lost	"kgs of maize storage lost "
label var 	crop17	"Crops grown this season"
label var 	crop17_text	"Crops grown this season (text) "
label var 	impcrop17_1	"Most important crop planted "
label var 	impcrop17_text1	"Most important crop 1 planted (text) "
label var 	area_crop_1	"Hectares of important crop 1 planted "
label var 	sold_most_1	"Sell most of important crop 1 "
label var 	purchased_from_1	"Location/person of where most important crop 1 was purchased"
label var 	evoucher_seed_1	"Was most important crop 1 seed purchsed with FISP "
label var 	impcrop17_2	"Most important crop 2 planted "
label var 	impcrop17_text2	"Most important crop 2 planted (text) "
label var 	area_crop_2	"Hectares of important crop 2 planted "
label var 	sold_most_2	"Sell most of important crop 2 "
label var 	purchased_from_2	"Location/person of where most important crop 2 was purchased"
label var 	evoucher_seed_2	"Was most important crop 2 seed purchsed with FISP "
label var 	impcrop17_3	"Most important crop 3 planted "
label var 	impcrop17_text3	"Most important crop 3 planted (text) "
label var 	area_crop_3 "Hectares of important crop 3 planted "
label var 	sold_most_3	"Sell most of important crop 3 "
label var 	purchased_from_3	"Location/person of where most important crop 3 was purchased"
label var 	evoucher_seed_3	"Was most important crop 3 seed purchsed with FISP "
label var 	NS_crop	"Crops for next season "
label var 	NS_crop_other	"Crops for next season (text) "
label var 	dealernum	"Number of agro-dealers seed was purchased from this season "
label var 	rainstart16	"When did the rains begin in the 2016/17 season "
label var 	rainstart15	"When did the rains begin in the 2015/16 season "
label var 	rainstart14	"When did the rains begin in the 2014/15 season "
label var 	rainstart13	"When did the rains begin in the 2013/14 season "
label var 	rainstart06	"When did the rains begin 10 years ago"
label var  mig1_occ_other "Occupation while migrating migrant 1 text"
label var mig2_occ_other "Occupation while migrating migrant 2 text"
label var left_why_txt "why R left prev. coop text"
label var mems_left_appeal_txt "why coop split text"
label var join_why_txt "why R joined current coop text"
label var off_funct_txt  "official coop purpose text" 
label var r_reas_txt "purpose R joined coop text"
label var fees_used_txt "how coop fees used text"
label var lead_gender "cooperative leader's gender"
label var relat_lead_txt "R's relationship to the leader text"
label var coop_mems  "Number of members in the coop"
label var not_coop_txt "why R not coop member text" 
label var how_redeem_txt "how R redeemed evoucher"


****drop created variables
drop enddate3 enddate4 enddate5 enddate6 enddate7 enddate8 enddate9 enddate10 enddate11 enddate12 enddate13 enddate14

save "2017 HICPS Followup", replace 


////////////////////////////////////END///////////////////////////////////
