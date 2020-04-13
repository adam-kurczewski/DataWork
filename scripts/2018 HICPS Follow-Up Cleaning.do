clear

cd "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2018 HICPS" 

import delimited using "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2018 HICPS\HICPS 2018 Follow-up Raw Numeric_without comments .csv", clear

label define yesnoL 1 "Yes" 0 "No" 

capture program drop yesno 
program define yesno 
	replace `1'=0 if `1'==2
	label values `1' yesnoL
end 

*********************************************************************
/* Section 0: Clean HHIDs */
*********************************************************************
rename 	q14	HHID
rename 	q118 phone_number
rename 	q117 name_respondent
rename 	q12	enumerator_18

gen corrected_HHID=0

sort HHID
quietly by HHID:  gen dup = cond(_N==1,0,_n) 

gen dup1=1 if dup>0
replace dup1=0 if missing(dup1) 

**drop duplicates 
drop if HHID==10134005 & dup==2
drop if HHID==10208014 & dup==2
drop if HHID==30103011 & dup==2
drop if HHID==30207007 & dup==2
drop if HHID==30220012 & dup==2
drop if HHID==40137005 & dup==2 
drop if HHID==40223013 & dup==2
drop if HHID==40235017 & dup==2
drop if HHID==173020700 & dup==2
drop if HHID==1740209001 & dup==2

*delete blank obs 
drop if missing(HHID)

*two respondents from the same housheold were interviewed take first occurance 
drop if phone_number=="975580840" & startdate=="8/10/18 12:02"

replace HHID=	10117009 	 if HHID==	10117005	& name_respondent ==	"Reuben Chabaila"
replace corrected_HHID=1 if HHID==	10117009 
replace HHID=	10201022	 if HHID==	10201017	& name_respondent==	"Martha Kenan Moyo"
replace corrected_HHID=1 if HHID==10201022
replace HHID=	10232005	 if HHID==	10232004	& name_respondent==	"Davison shakafwa"
replace corrected_HHID=1 if HHID==10232005
replace HHID=	20106075	 if HHID==	20106074	& name_respondent==	"Loveness Chendela"
replace corrected_HHID=1 if HHID==20106075
replace HHID=	30107018	 if HHID==	30107017	& name_respondent==	"Rodah Mwale "
replace corrected_HHID=1 if HHID==30107018
replace HHID=	30220010	 if HHID==	30220006	& name_respondent==	"Alice Tembo"
replace corrected_HHID=1 if HHID==30220010
replace HHID=	30220014	 if HHID==	30220009	& name_respondent==	"Edson Tembo"
replace corrected_HHID=1 if HHID==30220014
replace HHID=	40139006	 if HHID==	40139003	& name_respondent==	"Bright sipanje"
replace corrected_HHID=1 if HHID==40139006
replace HHID=	50216007	 if HHID==	50216006	& name_respondent==	"Lines mangani"
replace corrected_HHID=1 if HHID==50216007
replace HHID=	60115008	 if HHID==	60115013	& name_respondent==	"Given Moono"
replace corrected_HHID=1 if HHID==60115008
replace HHID=	60222003	 if HHID==	60222009	& name_respondent==	"Raymond Moono"
replace corrected_HHID=1 if HHID==60222003
replace HHID=	1760126003	 if HHID==	60126001	& name_respondent==	"Kemanord chigunta"
replace corrected_HHID=1 if HHID==1760126003
replace HHID=	1730238021	if HHID==	173023800	& name_respondent==	"AlIda   Lungu"
replace corrected_HHID=1 if HHID==1730238021
replace HHID=	1730238019	if HHID==	173023801	& name_respondent==	"Joyce Mwanza"
replace corrected_HHID=1 if HHID==1730238019
replace HHID=	1740213004	if HHID==	1740213001	& name_respondent==	"Jane Muchindo"
replace corrected_HHID=1 if HHID==1740213004
replace HHID=	1730238024	if HHID==	173023800	& name_respondent==	"Anastasia Mumba"
replace corrected_HHID=1 if HHID==1730238024
replace HHID=	1730238012	if HHID==	173023800	& name_respondent==	"Ruth Lungu"
replace corrected_HHID=1 if HHID==1730238012
replace HHID=	1730238009	if HHID==	173023801	& name_respondent==	"Isaac Chirwa"
replace corrected_HHID=1 if HHID==1730238009
			
sort HHID
quietly by HHID:  gen dup2 = cond(_N==1,0,_n) 

replace HHID=	10228007	if startdate==	"7/20/18 10:56"
replace corrected_HHID=1 if HHID==10228007
replace HHID=	1730238005	if startdate==	"7/18/18 10:12"
replace corrected_HHID=1 if HHID==1730238005
replace HHID= 	40229020	if HHID==	4022
replace corrected_HHID=1 if HHID==40229020
replace HHID= 	50206001	if HHID==	5020601
replace corrected_HHID=1 if HHID==50206001
replace HHID= 	60100004	if HHID==	6010004
replace corrected_HHID=1 if HHID==60100004
replace HHID= 	60100049	if HHID==	601000
replace corrected_HHID=1 if HHID==60100049
replace HHID= 	60126006	if HHID==	6012006
replace corrected_HHID=1 if HHID==60126006
replace HHID= 	60130001	if HHID==	6013001
replace corrected_HHID=1 if HHID==60130001
replace HHID= 	60130017	if HHID==	6130017
replace corrected_HHID=1 if HHID==60130017
replace HHID= 	60140021	if HHID==	601400
replace corrected_HHID=1 if HHID==60140021

sort HHID
quietly by HHID:  gen dup3 = cond(_N==1,0,_n) 

replace HHID=	10134003	if name_respondent==	"Catherine Mwansa "
replace corrected_HHID=1 if HHID==10134003

replace HHID=	1730133003	if name_respondent==	"Patson Nkhata"
replace corrected_HHID=1 if HHID==1730133003

replace HHID= 1730133001 if name_respondent=="Nathan Msimuko "
replace corrected_HHID=1 if HHID==1730133001


replace HHID=	1730238003	if name_respondent==	"James Zulu"
replace corrected_HHID=1 if HHID==1730238003

replace HHID= 1730133002 if name_respondent=="Judith Nyirongo"
replace corrected_HHID=1 if HHID==1730133002

replace HHID=9930127016 if name_respondent=="Beatrice Phiri"
gen notcorrectedHHID=0
replace notcorrectedHHID=1 if HHID==9930127016

replace HHID=9940139022 if name_respondent=="Gladys Nanzumwa"
replace notcorrectedHHID=1 if HHID==9940139022

replace HHID=9940235020 if name_respondent=="Mercy Kangwa"
replace notcorrectedHHID=1 if HHID==9940235020

replace HHID=9950206002 if name_respondent=="Juliet Nzala"
replace notcorrectedHHID=1 if HHID==9950206002

replace HHID=9960202001 if name_respondent=="Muule kanguya"
replace notcorrectedHHID=1 if HHID==9960202001

replace HHID=9910117009 if name_respondent=="Chabaila Enny"
replace notcorrectedHHID=1 if HHID==9910117009 

sort HHID
quietly by HHID:  gen dup4 = cond(_N==1,0,_n) 

replace HHID=60122006 if phone_number=="973101883 "
replace corrected_HHID=1 if HHID==60122006

replace HHID=50100015 if name_respondent=="Kabesha Sulako"
replace corrected_HHID=1 if HHID==50100015

replace HHID=1720106012 if name_respondent=="Agness Kalyamba"
replace corrected_HHID=1 if HHID==1720106012

replace HHID=20106029 if name_respondent=="Charity kawisha"
replace corrected_HHID=1 if HHID==20106029

replace HHID=60204016 if name_respondent=="Gloria mwanga"
replace corrected_HHID=1 if HHID==60204016

replace HHID=50216005 if name_respondent=="Regina Mushapa"
replace corrected_HHID=1 if HHID==50216005

replace HHID=50141018 if name_respondent=="Godfrey mamfwela"
replace corrected_HHID=1 if HHID==50141018

replace HHID=60119014 if name_respondent=="Comrade Hamasisa"
replace corrected_HHID=1 if HHID==60119014

replace HHID=1720106009 if name_respondent=="Shelly Kampape" 
replace corrected_HHID=1 if HHID==1720106009

replace HHID=	40113010	if HHID==	401130010
replace HHID=	40113013	if HHID==	401130013
replace HHID=	50100011	if HHID==	501000011
replace HHID=	60112006	if HHID==	60122006
replace HHID=	60112025	if HHID==	6011202025
replace HHID=	60119014	if HHID==	60129014
replace HHID=	1720106016	if HHID==	1720104009
replace HHID=	1730133002	if HHID==	173013300
replace HHID=	1730207003	if HHID==	173020700
replace HHID=	1730238004	if HHID==	173023802
replace HHID=	1730238018	if HHID==	173023800
replace HHID=	1750214007	if HHID==	1750124021
replace HHID=	1760100001	if HHID==	176010000
replace corrected_HHID=1 if HHID==	40113010		
replace corrected_HHID=1 if HHID==	40113013		
replace corrected_HHID=1 if HHID==	50100011		
replace corrected_HHID=1 if HHID==	60112006		
replace corrected_HHID=1 if HHID==	60112025		
replace corrected_HHID=1 if HHID==	60119014		
replace corrected_HHID=1 if HHID==	1720106016		
replace corrected_HHID=1 if HHID==	1730133002		
replace corrected_HHID=1 if HHID==	1730207003		
replace corrected_HHID=1 if HHID==	1730238004		
replace corrected_HHID=1 if HHID==	1730238018		
replace corrected_HHID=1 if HHID==	1750214007		
replace corrected_HHID=1 if HHID==	1760100001		
replace HHID=	991730802	if HHID==	1730802
replace HHID=	993013007	if HHID==	3013007
replace HHID=	993013301	if HHID==	3013301
replace HHID=	993023810	if HHID==	3023810
replace HHID=	996666666	if HHID==	6666666
replace HHID=	9910106057	if HHID==	10106057
replace HHID=	99173023801	if HHID==	173023801
replace HHID=	99174021300	if HHID==	174021300
replace HHID=	99175011104	if HHID==	175011104
replace HHID=	99401103014	if HHID==	401103014
replace HHID=	991710216001	if HHID==	1710216001
replace notcorrectedHHID=1 if HHID==	991730802		
replace notcorrectedHHID=1 if HHID==	993013007		
replace notcorrectedHHID=1 if HHID==	993013301		
replace notcorrectedHHID=1 if HHID==	993023810		
replace notcorrectedHHID=1 if HHID==	996666666		
replace notcorrectedHHID=1 if HHID==	9910106057		
replace notcorrectedHHID=1 if HHID==	99173023801		
replace notcorrectedHHID=1 if HHID==	99174021300		
replace notcorrectedHHID=1 if HHID==	99175011104		
replace notcorrectedHHID=1 if HHID==	99401103014		
replace notcorrectedHHID=1 if HHID==	991710216001		


replace HHID=	991720106016	if name_respondent==	"Ireen Kalima"
replace HHID=	991730133002	if name_respondent==	"Lestina Nyirongo"
replace HHID=	991730207001	if name_respondent==	"Rosemary Tembo"
replace HHID=	991730238022	if name_respondent==	"Oscar Zulu"
replace HHID=	99953272770		if name_respondent==	"Bestern Muleya"
replace notcorrectedHHID=1 if HHID==	991720106016		
replace notcorrectedHHID=1 if HHID==	991730133002		
replace notcorrectedHHID=1 if HHID==	991730207001		
replace notcorrectedHHID=1 if HHID==	991730238022		
replace notcorrectedHHID=1 if HHID==	99953272770
replace notcorrectedHHID=1 if HHID==173010000000 

drop dup dup1 dup2 dup3 dup4 
	

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

gen district=. 
foreach i in q110 q111 q112 q113 q114 q115{
	replace district=`i' if district==.
	drop `i'
	}

rename 	q13	new_hh
yesno new_hh

rename 	q15	move_hh1
yesno move_hh1

rename 	q16	at_house 
yesno at_house 

rename 	q17	latitude

rename 	q18	longitude

rename 	q19	province

rename 	q116	same_respondent
yesno same_respondent 
 

rename 	q119	ZESCO
replace ZESCO=0 if ZESCO==4
yesno ZESCO

label define enumerator 1 "Allan" 2 "Nashon" 3 "Noah" 4  "Maurice" 5  "Mwangala" 6 "Agness" 7 "Elijah" 8 "Enock" 9 "Marksman" 10 "Kabanshi" 11 "Emeldah" 12 "Godwin" 

label define province 1 "Central" 2 "Copperbelt" 3 "Eastern" 4 "Northern" 5 "Northwestern" 6 "Southern" 

label define district 101 "Mkushi" 102 "Mumbwa" 201 "Mpongwe"  202 "Masaiti" 301 "Lundazi" 302 "Petauke" 401 "Mbala" 402 "Mungwi" 403 "Chinsali" 501 "Mufumbwe" 502 "Solwezi" 601 "Choma" 602 "Namwala"

label values enumerator enumerator 
label values province province 
label values district district

label variable	enumerator	"enumerator "
label variable	new_hh	"Newly added household "
label variable	HHID	"Household identification number "
label variable	move_hh1	"Has household moved since 2016"
label variable	at_house 	"At respondents household "
label variable	latitude	"Moved household latitude "
label variable	longitude	"Moved Household longitude "
label variable	province	"Moved household province "
label variable	same_respondent 	"Same respondent from last year "
label variable	name_respondent	"Name of respondent "
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
rename	q25	perm_left
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
label variable	perm_left	"Members permanently left the household since last survey period"
label variable	perm_relate_1	"Relation to HH permanently left member 1"
label variable	perm_relate_2	"Relation to HH permanently left member 2"
label variable	perm_relate_3	"Relation to HH permanently left member 3"
label variable	perm_relate_4	"Relation to HH permanently left member 4"
label variable	perm_relate_5	"Relation to HH permanently left member 5"
label variable	perm_sex_1	"Gender of permanently left person 1 "
label variable	perm_sex_2	"Gender of permanently left person 2"
label variable	perm_sex_3	"Gender of permanently left person 3"
label variable	perm_sex_4	"Gender of permanently left person 4"
label variable	perm_sex_5	"Gender of permanently left person 5"
label variable	perm_birth_1	"Year of birth of permanently left person 1"
label variable	perm_birth_2	"Year of birth of permanently left person 2"
label variable	perm_birth_3	"Year of birth of permanently left person 3"
label variable	perm_birth_4	"Year of birth of permanently left person 4"
label variable	perm_birth_5	"Year of birth of permanently left person 5"
label variable	perm_reason_1	"Reason for leaving of permanently left person 1 "
label variable	perm_reason_2	"Reason for leaving of permanently left person 2"
label variable	perm_reason_3	"Reason for leaving of permanently left person 3"
label variable	perm_reason_4	"Reason for leaving of permanently left person 4"
label variable	perm_reason_5	"Reason for leaving of permanently left person 5"
label variable	perm_district_1	"District name of place permanently left person 1 "
label variable	perm_district_2	"District name of place permanently left person 2"
label variable	perm_district_3	"District name of place permanently left person 3"
label variable	perm_district_4	"District name of place permanently left person 4"
label variable	perm_district_5	"District name of place permanently left person 5"
label variable	perm_area_1	"Urban or Rural location of Permanently left person 1"
label variable	perm_area_2	"Urban or Rural location of Permanently left person 2"
label variable	perm_area_3	"Urban or Rural location of Permanently left person 3"
label variable	perm_area_4	"Urban or Rural location of Permanently left person 4"
label variable	perm_area_5	"Urban or Rural location of Permanently left person 5"
label variable	perm_remit1	"Permanently left persons send remittances 1"
label variable	perm_remit2	"Permanently left persons send remittances 2"
label variable	perm_remit3	"Permanently left persons send remittances 3"
label variable	perm_remit4	"Permanently left persons send remittances 4"
label variable	perm_remit5	"Permanently left persons send remittances 5"
label variable	perm_amountremit1	"Permanently left person amount of remittances 1"
label variable	perm_amountremit2	"Permanently left person amount of remittances 2"
label variable	perm_amountremit3	"Permanently left person amount of remittances 3"
label variable	perm_amountremit4	"Permanently left person amount of remittances 4"
label variable	perm_amountremit5	"Permanently left person amount of remittances 5"


*********************************************************************
/* Section 3: Remittances and Migration */
*********************************************************************

rename	q31	mig1_exist
yesno mig1_exist 

rename	q33	mig1_name 
rename	q34	mig1_phone 
rename	q35	mig1_currentage
rename	q36	mig1_relate
rename	q37	mig1_sex
rename	q38	mig1_edu
rename	q39_1	mig1_occ_farm
rename	q39_2	mig1_occ_comfarm
rename	q39_3	mig1_occ_indust
rename	q39_4	mig1_occ_teacher
rename	q39_5	mig1_occ_civil
rename	q39_6	mig1_occ_clerk
rename	q39_7	mig1_occ_shop
rename	q39_8	mig1_occ_piece
rename	q39_9	mig1_occ_other
rename	q39_9_text	mig1_occ_othertext
rename	q310_1	mig1_reason_foodsec
rename	q310_2	mig1_reason_wages
rename	q310_3	mig1_reason_labor
rename	q310_16	mig1_reason_crop
rename	q310_4	mig1_reason_unsure
rename	q310_5	mig1_reason_other
rename	q310_5_text	mig1_reason_othertext
rename	q311_1	mig1_occ_away_farm
rename	q311_2	mig1_occ_away_comfarm
rename	q311_3	mig1_occ_away_industrial
rename	q311_4	mig1_occ_away_teacher
rename	q311_5	mig1_occ_away_civil
rename	q311_6	mig1_occ_away_clerk 
rename	q311_7	mig1_occ_away_shop
rename	q311_8	mig1_occ_away_piece
rename	q311_9	mig1_occ_away_other
rename	q311_9_text	mig1_occ_away_othertext
rename	q312	mig1_year
rename	q313	mig1_money
rename	q314	mig1_noncash
rename	q315	mig1_permanent
rename	q316	mig1_duration
rename	q317_1	mig1_district
rename	q317_2	mig1_town
rename	q318_1	mig1_hunger
rename	q318_2	mig1_harvest
rename	q318_3	mig1_postharv
rename	q318_4	mig1_planting

rename	q319	mig2_exist
yesno mig2_exist
rename	q321	mig2_name 
rename	q322	mig2_phone 
rename	q323	mig2_currentage
rename	q324	mig2_relate
rename	q325	mig2_sex
rename	q326	mig2_edu
rename	q327_1	mig2_occ_farm
rename	q327_2	mig2_occ_comfarm
rename	q327_3	mig2_occ_indust
rename	q327_4	mig2_occ_teacher
rename	q327_5	mig2_occ_civil
rename	q327_6	mig2_occ_clerk
rename	q327_7	mig2_occ_shop
rename	q327_8	mig2_occ_piece
rename	q327_9	mig2_occ_other
rename	q327_9_text	mig2_occ_othertext
rename	q328_1	mig2_reason_foodsec
rename	q328_2	mig2_reason_wages
rename	q328_3	mig2_reason_labor
rename	q328_16	mig2_reason_crop
rename	q328_4	mig2_reason_unsure
rename	q328_5	mig2_reason_other
rename	q328_5_text	mig2_reason_othertext
rename	q329_1	mig2_occ_away_farm
rename	q329_2	mig2_occ_away_comfarm
rename	q329_3	mig2_occ_away_industrial
rename	q329_4	mig2_occ_away_teacher
rename	q329_5	mig2_occ_away_civil
rename	q329_6	mig2_occ_away_clerk 
rename	q329_7	mig2_occ_away_shop
rename	q329_8	mig2_occ_away_piece
rename	q329_9	mig2_occ_away_other
rename	q329_9_text	mig2_occ_away_othertext
rename	q330	mig2_year
rename	q331	mig2_money
rename	q332	mig2_noncash
rename	q333	mig2_permanent
rename	q334	mig2_duration
rename	q335_1	mig2_district
rename	q335_2	mig2_town
rename	q336_1	mig2_hunger
rename	q336_2	mig2_harvest
rename	q336_3	mig2_postharv
rename	q336_4	mig2_planting
rename	q337	fiveyrmig1
rename	q338	fiveyeartotalmig
rename	q339	name_mig1
rename	q340	phone_mig1
rename	q341	gender_mig1
rename	q342	age_mig1
rename	q343	relate_mig1
rename	q344	reason_mig1
rename	q344_4_text	reason_mig1_text
rename	q345	locate_mig1
rename	q346	times_mig1
rename	q347	fiveyrmig2
rename	q348	name_mig2
rename	q349	phone_mig2
rename	q350	gender_mig2
rename	q351	age_mig2
rename	q352	relate_mig2
rename	q353	reason_mig2
rename	q353_4_text	reason_mig2_text
rename	q354	locate_mig2
rename	q355	times_mig2
rename	q356	fiveyrmig3
rename	q357	name_mig3
rename	q358	phone_mig3
rename	q359	gender_mig3
rename	q360	age_mig3
rename	q361	relate_mig3
rename	q362	reason_mig3
rename	q362_4_text	reason_mig3_text
rename	q363	locate_mig3
rename	q364	times_mig3
rename	q365	fiveyrmig4
rename	q366	name_mig4
rename	q367	phone_mig4
rename	q368	gender_mig4
rename	q369	age_mig4
rename	q370	relate_mig4
rename	q371	reason_mig4
rename	q371_4_text	reason_mig4_text
rename	q372	locate_mig4
rename	q373	times_mig4
rename	q374	fiveyrmig5
rename	q375	name_mig5
rename	q376	phone_mig5
rename	q377	gender_mig5
rename	q378	age_mig5
rename	q379	relate_mig5
rename	q380	reason_mig5
rename	q380_4_text	reason_mig5_text
rename	q381	locate_mig5
rename	q382	times_mig5

 
label define gender 1 "Male" 0 "Female" 

label define edu  1 "None" 2 "Some Primary" 3 "Completed Primary" 4 "Some Secondary" 5 "Completed Secondary" 6 "Some Post-Secondary" 7 "Completed Post-Secondary" 8 "Unknown" 	

label define perm 1 "Permanently" 2 "Temporarily" 3 "Respondent does not know" 

label define reason 1 "Household food insecurity" 2 "Work opp/ higher wages elsewhere" 3 "Lack of demand for labor within household's village" 6 "Crop failure/ bad harvest"  7 "Unsure" 4 "Other" 

label define location 2 "Urban" 3 "Rural" 4 "Unsure" 

foreach i of num 1/2{
	label value mig`i'_relate HHrelation
	replace mig`i'_sex=0 if mig`i'_sex==2
	label value mig`i'_sex gender 
	label value  mig`i'_edu edu
	label value mig`i'_permanent perm
	}

foreach i of num 1/5{
	yesno fiveyrmig`i' 
	replace gender_mig`i'=0 if gender_mig`i'==2
	label value gender_mig`i' gender 
	label value relate_mig`i' HHrelation
	label value reason_mig`i' reason 
	label value locate_mig`i' location
	}
	
label variable 	mig1_exist	"Existence of migrant 1 "
label variable 	mig1_name 	"Migrant 1 name "
label variable 	mig1_phone 	"Migrant 1 phone number "
label variable 	mig1_currentage	"Migrant 1 current age "
label variable 	mig1_relate	"Relationship of migrant 1 to HH"
label variable 	mig1_sex	"Sex of migrant 1"
label variable 	mig1_edu	"Educational attainment of migrant 1"
label variable 	mig1_occ_farm	"Occupation before migrating of migrant 1 smallholder farm "
label variable 	mig1_occ_comfarm	"Occupation before migrating of migrant 1 commercial farm "
label variable 	mig1_occ_indust	"Occupation before migrating of migrant 1 industrial work "
label variable 	mig1_occ_teacher	"Occupation before migrating of migrant 1 teacher "
label variable 	mig1_occ_civil	"Occupation before migrating of migrant 1 civil servant"
label variable 	mig1_occ_clerk	"Occupation before migrating of migrant 1 clerk"
label variable 	mig1_occ_shop	"Occupation before migrating of migrant 1 shop attend."
label variable 	mig1_occ_piece	"Occupation before migrating of migrant 1 non-ag piecework"
label variable 	mig1_occ_other	"Occupation before migrating of migrant 1 other"
label variable 	mig1_occ_othertext	"Occupation before migrating of migrant 1 other text"
label variable 	mig1_reason_foodsec	"Decision to leave migrant 1: Household food insecurity"
label variable 	mig1_reason_wages	"Decision to leave migrant 1: higher wages "
label variable 	mig1_reason_labor	"Decision to leave migrant 1: lack of labor"
label variable 	mig1_reason_crop	"Decision to leave migrant 1: crop fail"
label variable 	mig1_reason_unsure	"Decision to leave migrant 1: unsure "
label variable 	mig1_reason_other	"Decision to leave migrant 1: other"
label variable 	mig1_reason_othertext	"Decision to leave migrant 1: other text"
label variable 	mig1_occ_away_farm	"Occupation while migrating mig1: Smallholder"
label variable 	mig1_occ_away_comfarm	"Occupation while migrating mig1: commercial farm"
label variable 	mig1_occ_away_industrial	"Occupation while migrating mig1: industrial work"
label variable 	mig1_occ_away_teacher	"Occupation while migrating mig1: teacher"
label variable 	mig1_occ_away_civil	"Occupation while migrating mig1: civil servant"
label variable 	mig1_occ_away_clerk 	"Occupation while migrating mig1: clerk"
label variable 	mig1_occ_away_shop	"Occupation while migrating mig1: shop attendant"
label variable 	mig1_occ_away_piece	"Occupation while migrating mig1: non ag piecework"
label variable 	mig1_occ_away_other	" Occupation while migrating mig1: other"
label variable 	mig1_occ_away_othertext	"Occupation while migrating mig1: other text"
label variable 	mig1_year	"Year in which remittances sent migrant 1 "
label variable 	mig1_money	"Remittances value migrant 1 "
label variable 	mig1_noncash	"Non-cash remittances value migrant 1 "
label variable 	mig1_permanent	"Migrant 1 Temp or Perm left "
label variable 	mig1_duration	"Legnth of migration of migrant 1 "
label variable 	mig1_district	"Migrant 1 destination district"
label variable 	mig1_town	"Migrant 1 destination rural town"
label variable 	mig1_hunger	"Migran 1 migrated over hunger season "
label variable 	mig1_harvest	"Migran 1 migrated over harvest season"
label variable 	mig1_postharv	"Migran 1 migrated over post harvest season"
label variable 	mig1_planting	"Migran 1 migrated over planting season"
label variable 	mig2_exist	"Existence of migrant 2 "
label variable 	mig2_name 	"Migrant 2 name "
label variable 	mig2_phone 	"Migrant 2 phone number "
label variable 	mig2_currentage	"Migrant 2 current age "
label variable 	mig2_relate	"Relationship of migrant 2 to HH"
label variable 	mig2_sex	"Sex of migrant 2"
label variable 	mig2_edu	"Educational attainment of migrant 2"
label variable 	mig2_occ_farm	"Occupation before migrating of migrant 2 smallholder farm "
label variable 	mig2_occ_comfarm	"Occupation before migrating of migrant 2 commercial farm "
label variable 	mig2_occ_indust	"Occupation before migrating of migrant 2 industrial work "
label variable 	mig2_occ_teacher	"Occupation before migrating of migrant 2 teacher "
label variable 	mig2_occ_civil	"Occupation before migrating of migrant 2 civil servant"
label variable 	mig2_occ_clerk	"Occupation before migrating of migrant 2 clerk"
label variable 	mig2_occ_shop	"Occupation before migrating of migrant 2 shop attend."
label variable 	mig2_occ_piece	"Occupation before migrating of migrant 2 non-ag piecework"
label variable 	mig2_occ_other	"Occupation before migrating of migrant 2 other"
label variable 	mig2_occ_othertext	"Occupation before migrating of migrant 2 other text"
label variable 	mig2_reason_foodsec	"Decision to leave migrant 2: Household food insecurity"
label variable 	mig2_reason_wages	"Decision to leave migrant 2: higher wages "
label variable 	mig2_reason_labor	"Decision to leave migrant 2: lack of labor"
label variable 	mig2_reason_crop	"Decision to leave migrant 2: crop fail"
label variable 	mig2_reason_unsure	"Decision to leave migrant 2: unsure "
label variable 	mig2_reason_other	"Decision to leave migrant 2: other"
label variable 	mig2_reason_othertext	"Decision to leave migrant 2: other text"
label variable 	mig2_occ_away_farm	"Occupation while migrating mig2: Smallholder"
label variable 	mig2_occ_away_comfarm	"Occupation while migrating mig2: commercial farm"
label variable 	mig2_occ_away_industrial	"Occupation while migrating mig2: industrial work"
label variable 	mig2_occ_away_teacher	"Occupation while migrating mig2: teacher"
label variable 	mig2_occ_away_civil	"Occupation while migrating mig2: civil servant"
label variable 	mig2_occ_away_clerk 	"Occupation while migrating mig2: clerk"
label variable 	mig2_occ_away_shop	"Occupation while migrating mig2: shop attendant"
label variable 	mig2_occ_away_piece	"Occupation while migrating mig2: non ag piecework"
label variable 	mig2_occ_away_other	" Occupation while migrating mig2: other"
label variable 	mig2_occ_away_othertext	"Occupation while migrating mig2: other text"
label variable 	mig2_year	"Year in which remittances sent migrant 2 "
label variable 	mig2_money	"Remittances value migrant 2 "
label variable 	mig2_noncash	"Non-cash remittances value migrant 2 "
label variable 	mig2_permanent	"Migrant 2 Temp or Perm left "
label variable 	mig2_duration	"Legnth of migration of migrant 2 "
label variable 	mig2_district	"Migrant 2 destination district"
label variable 	mig2_town	"Migrant 2 destination rural town"
label variable 	mig2_hunger	"Migrant 2 migrated over hunger season "
label variable 	mig2_harvest	"Migrant 2 migrated over harvest season"
label variable 	mig2_postharv	"Migrant 2 migrated over post harvest season"
label variable 	mig2_planting	"Migrant 2 migrated over planting season"
label variable 	fiveyrmig1	"Migrant 1 migrated in past 5 years "
label variable 	fiveyeartotalmig	"Total migrants in past  years "
label variable 	name_mig1	"Name of migrant 1 "
label variable 	phone_mig1	"Phone number of migrant 1 "
label variable 	gender_mig1	"Gender of migrant 1 "
label variable 	age_mig1	"Age of migrant 1 "
label variable 	relate_mig1	"Relationship of migrant 1 to HH"
label variable 	reason_mig1	"Reason for migrating migrant 1"
label variable 	reason_mig1_text	"Reason for migrating migrant 1 text "
label variable 	locate_mig1	"Location of migrant 1 "
label variable 	times_mig1	"Number of times migrant 1 migrated "
label variable 	fiveyrmig2	"Migrant 2 migrated in past 5 years "
label variable 	name_mig2	"Name of migrant 2 "
label variable 	phone_mig2	"Phone number of migrant 2 "
label variable 	gender_mig2	"Gender of migrant 2 "
label variable 	age_mig2	"Age of migrant 2 "
label variable 	relate_mig2	"Relationship of migrant 2 to HH"
label variable 	reason_mig2	"Reason for migrating migrant 2"
label variable 	reason_mig2_text	"Reason for migrating migrant 2 text "
label variable 	locate_mig2	"Location of migrant 2 "
label variable 	times_mig2	"Number of times migrant 2 migrated "
label variable 	fiveyrmig3	"Migrant 3 migrated in past 5 years "
label variable 	name_mig3	"Name of migrant 3 "
label variable 	phone_mig3	"Phone number of migrant 3 "
label variable 	gender_mig3	"Gender of migrant 3 "
label variable 	age_mig3	"Age of migrant 3 "
label variable 	relate_mig3	"Relationship of migrant 3 to HH"
label variable 	reason_mig3	"Reason for migrating migrant 3"
label variable 	reason_mig3_text	"Reason for migrating migrant 3 text "
label variable 	locate_mig3	"Location of migrant 3 "
label variable 	times_mig3	"Number of times migrant 3 migrated "
label variable 	fiveyrmig4	"Migrant 4 migrated in past 5 years "
label variable 	name_mig4	"Name of migrant 4 "
label variable 	phone_mig4	"Phone number of migrant 4 "
label variable 	gender_mig4	"Gender of migrant 4 "
label variable 	age_mig4	"Age of migrant 4 "
label variable 	relate_mig4	"Relationship of migrant 4 to HH"
label variable 	reason_mig4	"Reason for migrating migrant 4"
label variable 	reason_mig4_text	"Reason for migrating migrant 4 text "
label variable 	locate_mig4	"Location of migrant 4 "
label variable 	times_mig4	"Number of times migrant 4 migrated "
label variable 	fiveyrmig5	"Migrant 5 migrated in past 5 years "
label variable 	name_mig5	"Name of migrant 5 "
label variable 	phone_mig5	"Phone number of migrant 5 "
label variable 	gender_mig5	"Gender of migrant 5 "
label variable 	age_mig5	"Age of migrant 5 "
label variable 	relate_mig5	"Relationship of migrant 5 to HH"
label variable 	reason_mig5	"Reason for migrating migrant 5"
label variable 	reason_mig5_text	"Reason for migrating migrant 5 text "
label variable 	locate_mig5	"Location of migrant 5 "
label variable 	times_mig5	"Number of times migrant 5 migrated "

*********************************************************************
/* Section 4: Finances */
*********************************************************************
label define five 5 "5+"

capture program drop numbers 
program define numbers 
	replace `1'=0 if `1'==7
	replace `1'=0 if `1'==6
	label values `1' five
end 

rename 	q42	asset_phone 
rename 	q43	tv 
rename 	q44	radio 
rename 	q45	bike 
rename 	q46	motorcycle 
rename 	q47	water_pump 
rename 	q48	plough 
rename 	q49	sprayers 
rename 	q410	ox_carts 
rename 	q411	vehicle 
replace vehicle=0 if vehicle==5 
label define four 4 "4+"
label value vehicle four 

foreach i in asset_phone tv radio bike motorcycle water_pump plough sprayers ox_carts {
	numbers `i'
	}
	
	
rename 	q412	iron_sheets 
replace iron_sheets=1 if iron_sheets==23
replace iron_sheets=0 if iron_sheets==24 
label value iron_sheets yesnoL

rename 	q413	solar 
replace solar=0 if solar==6 
replace solar=3 if solar==12

rename 	q414_1_1	oxen_yes
rename 	q414_1_2	oxen_no
replace oxen_no=0 if oxen_no==1
gen oxen=oxen_no if oxen_no==0
replace oxen=oxen_yes if oxen_yes==1


rename 	q414_2_1	breeding_bullyes
rename 	q414_2_2	breeding_bullno
replace breeding_bullno=0 if breeding_bullno==1
gen breeding_bull=breeding_bullno if breeding_bullno==0
replace breeding_bull=breeding_bullyes if breeding_bullyes==1

rename 	q414_3_1	donkey_yes
rename 	q414_3_2	donkey_no
replace donkey_no=0 if donkey_no==1 
gen donkey=donkey_no if donkey_no==0
replace donkey=donkey_yes if donkey_yes==1

drop oxen_yes oxen_no breeding_bullyes breeding_bullno donkey_yes donkey_no

rename 	q415_1_1	female_cattle_number 
rename 	q415_2_1	goat_sheep_number 
rename 	q415_3_1	poultry_number 
rename 	q415_4_1	pigs_number

rename 	q416_1	income_piecework 
rename 	q416_2	income_salary 
rename 	q416_9	income_smallbusiness 
rename 	q416_10	income_charcoal 
rename 	q416_12	income_gardening 
rename 	q416_13	income_forestproduct 
rename 	q416_17	income_nonmaizecrop
rename 	q416_6	income_livestock 
rename 	q416_8	income_remittance 
rename 	q416_16	income_other 
rename 	q417	piecework_members 
replace piecework_members=0 if piecework_members==6 
replace piecework_members=piecework_members-6 if piecework_members!=0
rename 	q418_1	piecework_ploughing
rename 	q418_2	piecework_planting
rename 	q418_5	piecework_fert
rename 	q418_3	piecework_weed
rename 	q418_4	piecework_harvest
rename 	q418_8	piecework_shelling
rename 	q418_9	piecework_nonag
rename 	q419	bank_account 
yesno bank_account
rename 	q420	formal_loan 
yesno formal_loan
rename 	q421_1	borrow500 
yesno borrow500
rename 	q421_2	borrow2500 
yesno borrow2500
rename 	q421_3	borrow10000 
yesno borrow10000
rename 	q422	phone_transfer 
replace phone_transfer=1 if phone_transfer==23
replace phone_transfer=0 if phone_transfer==24

rename 	q423	food_budget_7day 
rename 	q424	talktime_budget_7day 
rename 	q425_2	veterinary_cost_month 
rename 	q425_3	clothing_cost_month 
rename 	q425_4	transportation_cost_month 
rename 	q425_5	alcohol_cost_month 
rename 	q425_6	firewood_cost_month 
rename 	q425_7	charcoal_cost_month 
rename 	q425_8	other_cost_month
rename 	q426	school_fees
rename 	q427	medical_exp
rename 	q428	sell_nonmaize
yesno sell_nonmaize

rename 	q429_42	sell_cabbage 
rename 	q429_16	sell_carrots
rename 	q429_18	sell_cassava
rename 	q429_14	sell_combeans
rename 	q429_10	sell_cotton 
rename 	q429_15	sell_cowpeas
rename 	q429_8	sell_groundnuts
rename 	q429_11	sell_irishpots
rename 	q429_41	sell_leafygreens
rename 	q429_6	sell_millet
rename 	q429_40	sell_okra
rename 	q429_26	sell_onions
rename 	q429_23	sell_orchard
rename 	q429_39	sell_peppers
rename 	q429_21	sell_pigeonpea
rename 	q429_67	sell_popcorn
rename 	q429_66	sell_pumpkin
rename 	q429_5	sell_rice
rename 	q429_4	sell_sorghum
rename 	q429_9	sell_soyabeans
rename 	q429_7	sell_sunflower
rename 	q429_17	sell_sweetpot
rename 	q429_12	sell_tobacco
rename 	q429_25	sell_tomatoes
rename 	q429_24	sell_other
rename 	q429_65	sell_none
rename 	q429_24_text sell_othertext


rename 	q4301_1_1	hec_cabbage 
rename 	q4301_2_1	hec_carrots
rename 	q4301_3_1	hec_cassava
rename 	q4301_4_1	hec_combeans
rename 	q4301_5_1	hec_cotton 
rename 	q4301_6_1	hec_cowpeas
rename 	q4301_7_1	hec_groundnuts
rename 	q4301_8_1	hec_irishpots
rename 	q4301_9_1	hec_leafygreens
rename 	q4301_10_1	hec_millet
rename 	q4301_11_1	hec_okra
rename 	q4301_12_1	hec_onions
rename 	q4301_13_1	hec_orchard
rename 	q4301_14_1	hec_peppers
rename 	q4301_15_1	hec_pigeonpea
rename 	q4301_16_1	hec_popcorn
rename 	q4301_17_1	hec_pumpkin
rename 	q4301_18_1	hec_rice
rename 	q4301_19_1	hec_sorghum
rename 	q4301_20_1	hec_soyabeans
rename 	q4301_21_1	hec_sunflower
rename 	q4301_22_1	hec_sweetpot
rename 	q4301_23_1	hec_tobacco
rename 	q4301_24_1	hec_tomatoes
rename 	q4301_25_text	hec_other
rename 	q4301_25_1	hec_other2
rename 	q4301_26_1	hec_none
rename 	q4302_1_1	income_cabbage 
rename 	q4302_2_1	income_carrots
rename 	q4302_3_1	income_cassava
rename 	q4302_4_1	income_combeans
rename 	q4302_5_1	income_cotton 
rename 	q4302_6_1	income_cowpeas
rename 	q4302_7_1	income_groundnuts
rename 	q4302_8_1	income_irishpots
rename 	q4302_9_1	income_leafygreens
rename 	q4302_10_1	income_millet
rename 	q4302_11_1	income_okra
rename 	q4302_12_1	income_onions
rename 	q4302_13_1	income_orchard
rename 	q4302_14_1	income_peppers
rename 	q4302_15_1	income_pigeonpea
rename 	q4302_16_1	income_popcorn
rename 	q4302_17_1	income_pumpkin
rename 	q4302_18_1	income_rice
rename 	q4302_19_1	income_sorghum
rename 	q4302_20_1	income_soyabeans
rename 	q4302_21_1	income_sunflower
rename 	q4302_22_1	income_sweetpot
rename 	q4302_23_1	income_tobacco
rename 	q4302_24_1	income_tomatoes
rename 	q4302_25_text	income_othercrop
rename 	q4302_25_1	income_othercrop2
rename 	q4302_26_1	income_none


label variable	asset_phone 	"Number of mobile phones "
label variable	tv 	"Number of  TVs"
label variable	radio 	"Number of radios"
label variable	bike 	"Bicycles "
label variable	motorcycle 	"Number of motorcycles"
label variable	water_pump 	"Number of water pumps "
label variable	plough 	"Number of ploughs"
label variable	sprayers 	"Number of sprayers "
label variable	ox_carts 	"Number of ox carts "
label variable	vehicle 	"Number of vehicles"
label variable	iron_sheets 	"House has iron sheets"
label variable	solar 	"Number of solar panels "
label variable	oxen 	"Own oxen "
label variable	breeding_bull 	"Own Breeding bull "
label variable	donkey 	"Own donkey "
label variable	female_cattle_number 	"Number of female cattle "
label variable	goat_sheep_number 	"Number of goat/sheep"
label variable	poultry_number 	"Number of poultry"
label variable	pigs_number	"Number of pigs"
label variable	income_piecework 	"Income from piece work "
label variable	income_salary 	"Income from Salary/Wage"
label variable	income_smallbusiness 	"Income from Small business"
label variable	income_charcoal 	"Income from charcoal selling "
label variable	income_gardening 	"Income from gardening or horticulture"
label variable	income_forestproduct 	"Income from sale of forest products"
label variable	income_nonmaizecrop	"Income from sale of non-maize crops"
label variable	income_livestock 	"Income from livestock sales "
label variable	income_remittance 	"Income from non-migration remittances "
label variable	income_other 	"Income from other sources "
label variable	piecework_members 	"Number of household members doing piecework  "
label variable	piecework_ploughing	"Pieceowork type ploughing "
label variable	piecework_planting	"Pieceowork type planting"
label variable	piecework_fert	"Pieceowork type apply herbicides/pesticides or fertilizer"
label variable	piecework_weed	"Pieceowork type weeding "
label variable	piecework_harvest	"Pieceowork type harvesting "
label variable	piecework_shelling	"Pieceowork type shelling "
label variable	piecework_nonag	"Pieceowork type non-aricultural "
label variable	bank_account 	"Anyone have a bank account "
label variable	formal_loan 	"Anyone taken out a formal loan "
label variable	borrow500 	"Be able to borrow 500 K"
label variable	borrow2500 	"Be able to borrow 2,500 K"
label variable	borrow10000 	"Be able to borrow 10,000 K "
label variable	phone_transfer 	"Anyone transferred money from mobile phone "
label variable	food_budget_7day 	"7 day household food budget "
label variable	talktime_budget_7day 	"7 day talk time budget "
label variable	veterinary_cost_month 	"Last months veterinary expenses "
label variable	clothing_cost_month 	"Last months clothing expenses "
label variable	transportation_cost_month 	"Last months transportation expenses "
label variable	alcohol_cost_month 	"Last months alcohol expenses "
label variable	firewood_cost_month 	"Last months firewood expenses "
label variable	charcoal_cost_month 	"Last months charcoal expenses "
label variable	other_cost_month	"Last months other significant expenses "
label variable	school_fees	"12 month school fees "
label variable	medical_exp	"12 month medical expenses "
label variable	sell_nonmaize	"Did you sell any non-maize crops from 17/18 harvest "
label variable	sell_cabbage 	"Did you sell cabbage "
label variable	sell_carrots	"Did you sell carrots"
label variable	sell_cassava	"Did you sell cassava"
label variable	sell_combeans	"Did you sell combeans"
label variable	sell_cotton 	"Did you sell cotton "
label variable	sell_cowpeas	"Did you sell cowpeas"
label variable	sell_groundnuts	"Did you sell groundnuts"
label variable	sell_irishpots	"Did you sell irishpots"
label variable	sell_leafygreens	"Did you sell leafygreens"
label variable	sell_millet	"Did you sell millet"
label variable	sell_okra	"Did you sell okra"
label variable	sell_onions	"Did you sell onions"
label variable	sell_orchard	"Did you sell orchard"
label variable	sell_peppers	"Did you sell peppers"
label variable	sell_pigeonpea	"Did you sell pigeonpea"
label variable	sell_popcorn	"Did you sell popcorn"
label variable	sell_pumpkin	"Did you sell pumpkin"
label variable	sell_rice	"Did you sell rice"
label variable	sell_sorghum	"Did you sell sorghum"
label variable	sell_soyabeans	"Did you sell soyabeans"
label variable	sell_sunflower	"Did you sell sunflower"
label variable	sell_sweetpot	"Did you sell sweetpot"
label variable	sell_tobacco	"Did you sell tobacco"
label variable	sell_tomatoes	"Did you sell tomatoes"
label variable	sell_other	"Did you sell other"
label variable	sell_none	"Did you sell none"
label variable	sell_othertext	"Did you sell othertext"
	
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
/* Section 5: Dietary Diversity and Expenses */
*********************************************************************	
rename 	q51	cook_person
yesno cook_person 

rename 	q52	enough_food
yesno enough_food 

rename 	q53	maize_consu_harvest
rename 	q541_1	eat_maize_days
rename 	q541_2	eat_cereal_days
rename 	q541_3	eat_cassava_days
rename 	q541_4	eat_carrot_days
rename 	q541_5	eat_vegetable_days
rename 	q541_6	eat_other_vegetable_days
rename 	q541_7	eat_fruit_days
rename 	q541_8	eat_other_fruit_days
rename 	q541_9	eat_meat_days
rename 	q541_10	eat_insect_days
rename 	q541_11	eat_egg_days
rename 	q541_12	eat_fish_days
rename 	q541_13	eat_pulses_days
rename 	q541_14	eat_milk_days
rename 	q541_15	eat_oil_days
rename 	q541_16	eat_sweets_days
rename 	q541_17	eat_spice_beverage_days

***recode values 
foreach i in eat_maize_days eat_cereal_days eat_cassava_days eat_carrot_days eat_vegetable_days eat_other_vegetable_days eat_fruit_days eat_other_fruit_days eat_meat_days eat_insect_days eat_egg_days eat_fish_days eat_pulses_days eat_milk_days eat_sweets_days eat_oil_days eat_spice_beverage_days{
	replace `i'=`i'-1
	}
	
rename 	q542_1	source_maize
rename 	q542_2	source_cereal
rename 	q542_3	source_cassava
rename 	q542_4	source_carrot
rename 	q542_5	source_vegetable
rename 	q542_6	source_other_vegetable
rename 	q542_7	source_fruit
rename 	q542_8	source_other_fruit
rename 	q542_9	source_meat
rename 	q542_10	source_insect
rename 	q542_11	source_egg
rename 	q542_12	source_fish
rename 	q542_13	source_pulses
rename 	q542_14	source_milk
rename 	q542_15	source_oil
rename 	q542_16	source_sweets
rename 	q542_17	source_spice_beverage
rename 	q543_1	sec_source_maize
rename 	q543_2	sec_source_cereal
rename 	q543_3	sec_source_cassava
rename 	q543_4	sec_source_carrot
rename 	q543_5	sec_source_vegetable
rename 	q543_6	sec_source_other_vegetable
rename 	q543_7	sec_source_fruit
rename 	q543_8	sec_source_other_fruit
rename 	q543_9	sec_source_meat
rename 	q543_10	sec_source_insect
rename 	q543_11	sec_source_egg
rename 	q543_12	sec_source_fish
rename 	q543_13	sec_source_pulses
rename 	q543_14	sec_source_milk
rename 	q543_15	sec_source_oil
rename 	q543_16	sec_source_sweets
rename 	q543_17	sec_source_spice_beverage

label define source 1 "Own production" 2 "Village market" 3 "Town market" 4 "Roadside market" 5 "Passing trader" 6 "Own production" 7 "Relative/Neighbor" 8 "Collected on common land" 

foreach i in source_maize source_cereal source_cassava source_carrot source_other_vegetable source_vegetable source_fruit source_other_fruit source_meat source_insect source_egg source_fish source_pulses source_milk source_oil source_sweets source_spice_beverage sec_source_maize sec_source_cereal sec_source_cassava sec_source_carrot sec_source_vegetable sec_source_other_vegetable sec_source_fruit sec_source_other_fruit sec_source_meat sec_source_insect sec_source_egg sec_source_fish sec_source_pulses sec_source_milk sec_source_oil sec_source_spice_beverage sec_source_sweets{
	label value `i' source
	}

rename 	q55	mkts_visited
replace mkts_visited=mkts_visited-1
label define plus5 5 "5+"
label value mkts_visited plus5

rename 	q56	mkts_type
label define mrkt 1 "Village market" 2 "Neighboring village market" 3 "Town market" 4 "Roadside market" 5 "Other" 
label value mkts_type mrkt

rename 	q56_5_text	mkts_type_other
rename 	q57	mkts_trans
label define trans 1 "Walk" 2 "Bike" 3 "Own car" 4 "Own motorbike" 5 "Taxi" 7 "Bus" 6 "Other" 
label value mkts_trans trans 

rename 	q57_6_text	mkts_trans_other 
rename 	q58_1	days_less_prefer
rename 	q58_2	days_borrow_food
rename 	q58_6	days_limit
rename 	q58_8	days_restrict
rename 	q58_13	days_reduce
rename 	q59	sharing 
replace sharing=0 if sharing==4 
yesno sharing 

rename 	q510_1_1	food_supplied
rename 	q510_1_2	food_received
rename 	q510_5_1	maize_supplied
rename 	q510_5_2	maize_received
rename 	q510_2_1	nonfood_supplied
rename 	q510_2_2	nonfood_received
rename 	q510_3_1	livestock_supplied
rename 	q510_3_2	livestock_received
rename 	q510_4_1	labor_supplied
rename 	q510_4_2	labor_received 

label variable 	cook_person	"Person who is in charge of cooking answered these questions "
label variable 	enough_food	"In 7 days were there times there was not enough food in the house "
label variable 	maize_consu_harvest	"Amount in kgs of household maize consumption"
label variable 	eat_maize_days	"Number of days consumed maize "
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
label variable 	source_maize	"Source of maize "
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
label variable 	sec_source_maize	"Secondary source of maize "
label variable 	sec_source_cereal	"Secondary source of cereal"
label variable 	sec_source_cassava	"Secondary source of cassava "
label variable 	sec_source_carrot	"Secondary source of carrots "
label variable 	sec_source_vegetable	"Secondary source of dark leafy green vegetables"
label variable 	sec_source_other_vegetable	"Secondary source of other vegetables"
label variable 	sec_source_fruit	"Secondary source of vitamin A fruit "
label variable 	sec_source_other_fruit	"Secondary source of other fruit"
label variable 	sec_source_meat	"Secondary source of meat"
label variable 	sec_source_insect	"Secondary source of insects "
label variable 	sec_source_egg	"Secondary source of eggs"
label variable 	sec_source_fish	"Secondary source of fish"
label variable 	sec_source_pulses	"Secondary source of pulses"
label variable 	sec_source_milk	"Secondary source of milk"
label variable 	sec_source_oil	"Secondary source of oil"
label variable 	sec_source_sweets	"Secondary source of sweets "
label variable 	sec_source_spice_beverage	"Secondary source of spices and beverages "
label variable 	mkts_visited	"In a month number of different markets visited"
label variable 	mkts_type	"Type of market purchased food from "
label variable 	mkts_type_other	"Type of market purchased food from (other) "
label variable 	mkts_trans	"Mode of transportation to get to/from market "
label variable 	mkts_trans_other 	"Mode of transportation to get to/from market (other)"
label variable 	days_less_prefer	"Number of days rely on less prefered food"
label variable 	days_borrow_food	"Number of days borrowed food "
label variable 	days_limit	"Number of days limit portion size "
label variable 	days_restrict	"Number of days restrict food of adults "
label variable 	days_reduce	"Number of days reduced meals "
label variable 	sharing 	"Did household share food maize livestock etc. "
label variable 	food_supplied	"Supplied food "
label variable 	food_received	"Received food"
label variable 	maize_supplied	"Supplied maize "
label variable 	maize_received	"Received maize"
label variable 	nonfood_supplied	"Supplied nonfood "
label variable 	nonfood_received	"Received nonfood "
label variable 	livestock_supplied	"Supplied livestock "
label variable 	livestock_received	"Received livestock "
label variable 	labor_supplied	"Supplied labor"
label variable 	labor_received 	"Received labor "

*********************************************************************
/* Section 6: Army Worms and Invasive Species*/
*********************************************************************
*Do you have household memebers that do any of the following?
*Q6.1 

rename q61_1 Scoutfield 
label var Scoutfield "Scouted own field"
rename q61_4 Scoutgrasses
label var Scoutgrasses "scouted the grass"
rename q61_5 helpotherf
label var helpotherf "Helped others scout for insects"
rename q61_2 scout_nonabove
label var scout_nonabove "Did not do any of the above"

*Q6.2
rename q62 identf_ins
recode identf_ins 2=0
label define identf_ins 1 "yes" 0 "no"
label var identf_ins "Can you identify the insect pests"
*Q6.3
rename q63_1 physically
label var physically "HH can identify insect pest by physically seeing them"
rename q63_2 damage
label var damage "HH can identify the insect pest by the damage they cause "
rename q63_4 cannot_ide
label var cannot_ide "HH can not identify the insect pest"
rename q63_3 other_idetify
label var other_idetify "other ways HH uses to identifying the insect pest"
rename q63_3_text other_ide_text
label var other_ide_text "Other ways HH identifies insect pests text entry" 

*Q6.4
rename q64_1 Neighboring_hh
label var Neighboring_hh "HH reported to neighboring HH"
rename q64_2 Coop_mem
label var Coop_mem "HH reported to Cooperative members"
rename q64_3 Camp_off
label var Camp_off "HH report to the camp officer"
rename q64_4 Ext_agent
label var Ext_agent "HH report to the extension agent"



*Q6.5 
rename q65_1 intercrop
label var intercrop "HH practiced intercroped to eliminate invasive pests"
rename q65_2 sprayed_pes
label var sprayed_pes "HH sprayed with pesticide to eliminate invasive pests"
rename q65_3 hh_items
label var hh_items "HH uses household items and/or products to invasive eliminate pests"
rename q65_4 manually
label var manually "HH manually removed invasive pests"
rename q65_5 other_sp
label var other_sp "HH used other means to eliminate invasive pests"
rename q65_5_text other_sptext 
label var other_sptext"HH other means to eliminate invasive pests text entry"

*What 
*Q6.6
rename q66_1 Locust
label var Locust "Locusts the damaged the HH crops"
rename q66_2 Stem_borer 
lab var Stem_borer "Stem borers the damaged the HH crops"
rename q66_3 Armyworms 
label var Armyworms "Armyworms the damaged the HH crops"
rename q66_4 Other 
label var  Other "Other invasive pests the damaged the HH crops"
rename q66_5 Damaged_Unsure
label var Damaged_Unsure "Other invasive damaged the HH crops"
rename q66_6 No_pests 
label var No_pests "No damage caused to the crops"
rename q66_4_text other_invasive_text 
label var other_invasive_text "Other invasive pests text entry damaged the HH crops"


*6.8
rename q68_1 army_week
label var army_week "Week when the HH saw the armyworm"
*recode values from strings to numerics 
replace army_week="." if army_week=="30"
replace army_week="." if army_week=="99"
replace army_week="." if army_week=="Week"
replace army_week="." if army_week=="Week "
replace army_week="1" if army_week=="Week 1"
replace army_week="2" if army_week=="Week 2"
replace army_week="3" if army_week=="Week 3"
replace army_week="4" if army_week=="Week 4"
replace army_week="1" if army_week=="Week1"
replace army_week="1" if army_week=="Week1 "
replace army_week="2" if army_week=="Week2"
replace army_week="2" if army_week=="Week2 "
replace army_week="3" if army_week=="Week3"
replace army_week="3" if army_week=="Week3 "
replace army_week="4" if army_week=="Week4" 
replace army_week="4" if army_week=="Week4 " 
destring army_week, replace 

rename q68_2 army_mnth
label var army_mnth "Month when the HH saw the armyworms"
replace army_mnth="3" if army_mnth=="March" 
replace army_mnth="3" if army_mnth=="March " 
replace army_mnth="11" if army_mnth=="1-Nov" 
replace army_mnth="11" if army_mnth=="November  " 
replace army_mnth="11" if army_mnth=="November " 
replace army_mnth="12" if army_mnth=="December " 
replace army_mnth="12" if army_mnth=="December" 
replace army_mnth="2" if army_mnth=="February" 
replace army_mnth="2" if army_mnth=="February " 
replace army_mnth="1" if army_mnth=="January" 
replace army_mnth="1" if army_mnth=="January " 
replace army_mnth="." if army_mnth=="Ji" 
replace army_mnth="6" if army_mnth=="June" 
replace army_mnth="3" if army_mnth==" March" 
replace army_mnth="3" if army_mnth==" March " 
destring army_mnth, replace 

rename q68_3 army_year
label var army_year "Year when the HH saw the armyworms"

*6.9
rename q69_1 AW_Maize
label var AW_Maize "HH first saw the armyworms in the Maize crop" 
rename q69_2 AW_Millet
label var AW_Millet "HH first saw the armyworms in the Millet crop" 
rename q69_3 AW_Soybeans
label var AW_Soybeans "HH first saw the armyworms in the Soybeans crop" 
rename q69_4 AW_Tomatoes
label var AW_Tomatoes "HH first saw the armyworms in the Tomatoes crop" 
rename q69_5 AW_Onions
label var AW_Onions "HH first saw the armyworms in the Onions crop" 
rename q69_6 AW_Sorghum
label var AW_Sorghum "HH first saw the armyworms in the Sorghum crop" 
rename q69_7 AW_Rape
label var AW_Rape "HH first saw the armyworms in the Rape crop" 
rename q69_8 AW_Othe_crop
label var AW_Othe_crop "HH first saw the armyworms in the Other crop" 
rename q69_6_text AW_other_crop_text
label var AW_other_crop_text "HH first saw the armyworms in the text entry crop" 


*6.10
rename q610_1 spray_pest
label var spray_pest "HH used spray method"
rename q610_2 local_rem 
label var spray_pest "HH used local remember including ash,sand and soil"
rename q610_3 botanical
label var botanical "HH used botanical insectcide"
rename q610_4 soap_hh_pr
label var soap_hh_pr "HH used soap solution or other HH insecticide"
rename q610_5 Oth_pesticide
label var Oth_pesticide "Other methodes of control"
rename q610_5_text other_methods_text 
label var other_methods_text "Other methodes text entry of control"



*Q6.11
rename q611 spray
label var spray "Did you spray with pestcides?"
recode spray 4=0
label define spray 1 "yes" 2 "Not available" 0 "no"

*Q6.12
rename q612 spray_times
label var spray_times"How many times did you spray"
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


*Q6.13
rename q613_1 Camp_Off
label var Camp_Off "HH gets the pesticides from camp officer"
rename q613_2 Vill_agro_ret
label var Vill_agro_ret "HH gets the pesticides from village agro retailer in the village"
rename q613_3 Dist_agro_ret
label var Dist_agro_ret "HH gets the pesticides from agro retailer in district market"
rename q613_4 Neigh_frien
label var Neigh_frien "HH gets the pesticides from neighbor,friend etc"
rename q613_5 home_pestic
label var home_pestic "HH gets the pesticides from used homemade pesticdes from products within household"
rename q613_6 pesticide_other
label var pesticide_other "HH gets the pesticides from used homemade pesticdes from other sources"
rename q613_6_text pesticide_other_text 
label var pesticide_other_text "HH gets the pesticide from other sources text entry"

*Q6.14
rename q614 dist_pestic
label var dist_pestic "How far is the nearest place where you can access drugs"

*Q.15
rename q615 pestcide_cost
label var pestcide_cost "How much are the pesticides for armyworms?"

*Q.16
rename q616_1 Couldnt_afford
label var Couldnt_afford "HH could not affect pesticide"
rename q616_2 didnt_time
label var didnt_time "HH did not have time to spray"
rename q616_3 pestcide_unvail
label var pestcide_unvail "Pesticide was not available"
rename q616_4 not_enough_lab
label var not_enough_lab "HH did not have enough labor to spray the entire field"
rename q616_5 didnt_believ
label var didnt_believ "HH did not believe pesticide was effective"
rename q616_6 health_conc
label var   health_conc "HH was concerned about health of member from spraying pesticides"
rename q616_7 Other_nopesticide
label var Other_nopesticide "Other reasons HH did not spray"
rename q616_6_text other_nopest_text 
label var other_nopest_text "Other reasons text entry HH did not spray"

*Q.17
rename q617_1 Daco_off
label var Daco_off "HH accessed the pesticides from the DACo's office"
rename q617_2 Local_Agri
label var Local_Agri "HH accessed the pesticides from agri retailers"
rename q617_4 Distr_Agri
label var Distr_Agri "HH accessd the pesticides from the agric retailer in town"
rename q617_5 Other_pestsource
label var Other_pestsource "HH accessed the pesticides from other sources"
rename q617_6 Not_Avail
label var Not_Avail "The pesticide was not accessible or available"
rename q617_2_text Other_pestsource_text 
label var Other_pestsource_text "HH accessed the pesticides from other source text entry"

*Q.18
rename q618_1 Didnt_rec_in
label var Didnt_rec_in "Did not receive any information"
rename q618_2 Camp_Offic
label var Camp_Offic "HH got the information from camp officers"
rename q618_3 Neigh_hh
label var  Neigh_hh "HH got the information from the neighboring household"
rename q618_4 Coop_members
label var Coop_members "HH received information from cooperative members"
rename q618_5 Ag_dealer
label var Ag_dealer "HH received information from the agro dealer"
rename q618_6 Other_source
label var Other_source "HH received information from other sources"
rename q618_7 Didnt_recinf
label var Didnt_recinf "HH did not received any information"
rename q618_5_text other_source_text 
label var other_source_text "HH received information from other sources text entry"

*Q.19
rename q619 army_aff
label var army_aff "The intensity of damage by armyworms"
recode army_aff 4=1
recode army_aff 5=2
recode army_aff 6=3
recode army_aff 7=4
recode army_aff 8=5
label define army_aff 1 "0 to 10%" 2 "10-25%" 3 "25-50%" 4 "50-75%" 5 "75-100%"
*Q.20
rename q620 army_aff_end
label var army_aff_end "The intensity of damage by armyworms by end of 2018 "
recode army_aff_end 4=1
recode army_aff_end 5=2
recode army_aff_end 6=3
recode army_aff_end 7=4
recode army_aff_end 8=5
label define army_aff_end 1 "0 to 10%" 2 "10-25%" 3 "25-50%" 4 "50-75%" 5 "75-100%"

*Q.21
rename q621_1 pln_to_use
label var pln_to_use "HH plansto use pesticides to guard against armyworms"
rename q621_2 Doing_nothng
label var Doing_nothng "HH plans to do nothing aginst invasive pests"
rename q621_3 diversify_crps
label var diversify_crps "HH plans to diversify their crosps to fight against armyworms"
rename q621_4 new_area
label var new_area "HH plans to plant in a different area next season"
rename q621_5 wait
label var wait "HH plans to wait to see the fields that will be affected"
rename q621_6 Other_seasmethod
label var Other_seasmethod "HH plans to use other methods next year aginst fall armyworms"
rename q621_6_text Other_seasmethod_text 
label var Other_seasmethod_text "HH plans to use other methods text entry next year aginst fall armyworms"


*Q.23
rename q623_1 PS_army_worm
label var PS_army_worm "HH's maize crop was infested by armyworms during the 2016/17 season"
rename q623_2 PS_stem_borer
label var PS_stem_borer "HH maize crop was infested with stem borers 2016/17 season"
rename q623_3 PS_Locust
label var PS_Locust"HH maize crop was infested with Locusts  2016/17 season"
rename q623_5 PSinvasive_Other
label var PSinvasive_Other " HH maize crop wasinfested with other pests  2016/17 season"
rename q623_5 PSinvasive_text
label var PSinvasive_text " HH maize crop was infested with other pests text entry 2016/17 season"
rename q623_6 damage_unsur
label var damage_unsur "HH was not sure what pest infested there maize crop last season 2016/17 season"
rename q623_7 no_pests
label var no_pests "HH did not experience any pest infestations during the 2016/17 season"

*Q.24
rename q624 spray_insec
label var spray_insec "Did you spray to eradicate insect pests?"
recode spray_insec 2=0
label define spray_insec 1 "yes" 0 "no"
*Q.25
rename q625 effectivenes
label var effectivenes "Was the insectcide you sprayed effective?"
recode effectivenes 2=0
label define effectivenes 1 "yes" 0 "no"
*Q.26
rename q626 perce_harv
label var perce_ "What percentage of the field was lost to insect pest damage?"
recode perce_harv 4=1
recode perce_harv 5=2
recode perce_harv 7=3
recode perce_harv 8=4
recode perce_harv 9=5
label value perce_harv army_aff_end 

*Q.28
 rename q628 no_of_visits
 label var no_of_visits "In the last month how many times have you been visited by the govt extension officers"
 label define visits 1 "0" 2 "1-3" 3 "4-6" 4 "7-9" 5 "10+" 
 label value no_of_visits visits 
 
 *Q.29
 rename q629 no_of_trainings
 label var no_of_trainings "In the last 12 months how many times has you HH member attended training by the govt extension officers"
 label value no_of_trainings visits 
 
  *Q.30
 rename q630 seed_companies
 label var seed_companies "How many times has any HH member attended training by seed companies?"
 
 *Q.31
 rename q631 traing_gov
 label var traing_gov "In the last 12 months have you received any advice, training or information from government officers? "
 
 label define training 1 "Substantial benefit" 2 "Some benefit" 3 "No benefit" 5 "No advice, training info given" 
 label value traing_gov training 
 

*********************************************************************
/* Section 7: Land*/
*********************************************************************
rename q72 farmland
rename q73 title_land
rename q74 cultivown_land
rename q75 fallow_land
rename q76_1 fallow_reason1
rename q76_2 fallow_reason2
rename q76_3 fallow_reason3
rename q76_4 fallow_reason4
rename q76_5 fallow_reason5
rename q76_6 fallow_reason6
rename q76_6_text fallow_reason_text
rename q77 rentfrom_land
rename q78 rentto_land

*label vars
label var farmland "Total area of farm land"
label var title_land "Area of land titled by state" 
label var cultivown_land "Total area of cultivated land" 
label var fallow_land "Total area of fallowed land"
label var fallow_reason1 "Fallowed land reason 1"
label var fallow_reason2 "Fallowed land reason 2"
label var fallow_reason3 "Fallowed land reason 3"
label var fallow_reason4 "Fallowed land reason 4"
label var fallow_reason5 "Fallowed land reason 5"
label var fallow_reason6 "Fallowed land reason 6"
label var fallow_reason_text "Fallowed land reason - Text"
label var rentfrom_land "Area of land rented FROM somone" 
label var rentto_land "Area of land rented TO someone"

gen fallow_reason = .
label var fallow_reason "Fallowed land reason un-parsed"

*merge variables from dif columns to one and label values
forvalues i = 1/6 {
	replace fallow_reason = `i' if fallow_reason`i' != .
	}

label define fallow_reasons 1 "Labor shortage" 2 "Seed shortage" 3 "Fertilizer shortage" 4 "Soil fertility problems" 5 "Delayed rainfall" 6 "Other" 
label values fallow_reason fallow_reasons


*********************************************************************
/* Section 8: Maize Plantings Starter */
*********************************************************************


rename q82 grewmaize
rename q83 able_preferred_date
gen not_able_reason = .
rename q84_1 not_able_reason1
rename q84_2 not_able_reason2
rename q84_3 not_able_reason3
rename q84_5 not_able_reason4
rename q84_6 not_able_reason5
rename q84_4 not_able_reason6
rename q84_4_text not_able_reason_text
rename q85 shift_planting
rename q86 plantnum
rename v579 cult_1
rename v580 plnt_1
rename v581 fert_1
rename v582 weed_1
rename v583 harv_1

foreach i in cult_1 plnt_1 fert_1 weed_1 harv_1{
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
label var not_able_reason1 "Reason for not planting on preferred dates - FISP finances did not arrive on schedule"
label var not_able_reason2 "Reason for not planting on preferred dates - Don't own oxen/plow and had to borrow"
label var not_able_reason3 "Reason for not planting on preferred dates - Was only able to hire labor on a non-preferred date"
label var not_able_reason4 "Reason for not planting on preferred dates - Late rain"
label var not_able_reason5 "Reason for not planting on preferred dates - Dry spells"
label var not_able_reason6 "Reason for not planting on preferred dates - Other"
label var not_able_reason_text "Reason for not planting on preferred dates - Text"
label var shift_planting "Weeks planting has to be moved" 

*merge variables from dif columns to one and label values
forvalues i = 1/6 {
	replace not_able_reason = `i' if not_able_reason`i' != .
	}

label define planting_problems 1 "FISP finances did not arrive on schedule" 2 "Don't own oxen/plow and had to borrow" ///
3 "Was only able to hire labor on a non-preferred date" 4 "Late rain" 6 "Dry spells" 5 "Other" 
label define yesno 1 "Yes" 0 "No"

foreach var in grewmaize able_preferred_date {
	replace `var' = 0 if `var' == 2
	replace `var' = 1 if `var' == 1
	label values `var' yesno
	}
	
label values not_able_reason planting_problems

label define planting_shift 1 "Move later by one week" 2 "Move later by two weeks" 3 "Move later by three weeks" 4 "Move later by four weeks" ///
5 "Move later by five weeks" 6 "Move earlier by one weeks" 7 "Move earlier by two weeks" 8 "Move earlier by three weeks" 
label values shift_planting planting_shift

*********************************************************************
/* Section 9: Maize Plantings 1 */
*********************************************************************

*rename
rename q92 date_1
rename q93_1 reason_11
rename q93_2 reason_12
rename q93_3 reason_13
rename q93_11 reason_14
rename q93_4 reason_15
rename q93_6 reason_16
rename q93_7 reason_17
rename q93_9 reason_18
rename q93_5 reason_19
rename q93_5_text reason_txt_1
rename q94 company_1
rename q95 seed_co_1
rename q96 mri_1
rename q97 pioneer_1
rename q98 pannar_1
rename q99 zamseed_1
rename q910 dekalb_1
rename q911 recycl_1
rename q912 second_1
rename q913 replnt_1
rename q914 fseed_1
rename q915 qseed_1
rename q916 plot_1
rename q917 qharv_1
rename q918 grn_1
rename q918_1_text grn_txt_1
rename q919_1 ferts_11
rename q919_2 ferts_12
rename q919_3 ferts_13
rename q919_4 ferts_14
rename q920 qbasal_1
rename q921 qtop_1
rename q922 inter_1


*label vars
label var date_1 "Planting 1: Date of planting"
label var reason_11 "Planting 1: Reasons for planting on that date 1"
label var reason_12 "Planting 1: Reasons for planting on that date 2"
label var reason_13 "Planting 1: Reasons for planting on that date 3"
label var reason_14 "Planting 1: Reasons for planting on that date 4"
label var reason_15 "Planting 1: Reasons for planting on that date 5"
label var reason_16 "Planting 1: Reasons for planting on that date 6"
label var reason_17 "Planting 1: Reasons for planting on that date 7"
label var reason_18 "Planting 1: Reasons for planting on that date 8"
label var reason_19 "Planting 1: Reasons for planting on that date 9"
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
label var ferts_11 "Planting 1: Types of fertilizer 1 - Chemical Basal" 
label var ferts_12 "Planting 1: Types of fertilizer 2 - Chemical Top-dressing" 
label var ferts_13 "Planting 1: Types of fertilizer 3 - Animal Manure" 
label var ferts_14 "Planting 1: Types of fertilizer 4 - No fertilizer" 
label var qbasal_1 "Planting 1: Kgs of basal dressing"
label var qtop_1 "Planting 1: kgs of top dressing fertilizer"
label var inter_1 "Planting 1: Intercrop"

*Label values combined from all data sets

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
	
label values date_1 dates	
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
	
*********************************************************************
/* Section 10: Maize Plantings 2 */
*********************************************************************

*rename
rename q102 date_2
rename q103_1 reason_21
rename q103_2 reason_22
rename q103_3 reason_23
rename q103_11 reason_24
rename q103_4 reason_25
rename q103_6 reason_26
rename q103_7 reason_27
rename q103_9 reason_28
rename q103_5 reason_29
rename q103_5_text reason_txt_2
rename q104 company_2
rename q105 seed_co_2
rename q106 mri_2
rename q107 pioneer_2
rename q108 pannar_2
rename q109 zamseed_2
rename q1010 dekalb_2
rename q1011 recycl_2
rename q1012 second_2
rename q1013 replnt_2
rename q1014 fseed_2
rename q1015 qseed_2
rename q1016 plot_2
rename q1017 qharv_2
rename q1018 grn_2
rename q1018_1_text grn_txt_2
rename q1019_1 ferts_21
rename q1019_2 ferts_22
rename q1019_3 ferts_23
rename q1019_4 ferts_24
rename q1020 qbasal_2
rename q1021 qtop_2
rename q1022 inter_2


*label vars
label var date_2 "Planting 2: Date of planting"
label var reason_21 "Planting 2: Reasons for planting on that date 1"
label var reason_22 "Planting 2: Reasons for planting on that date 2"
label var reason_23 "Planting 2: Reasons for planting on that date 3"
label var reason_24 "Planting 2: Reasons for planting on that date 4"
label var reason_25 "Planting 2: Reasons for planting on that date 5"
label var reason_26 "Planting 2: Reasons for planting on that date 6"
label var reason_27 "Planting 2: Reasons for planting on that date 7"
label var reason_28 "Planting 2: Reasons for planting on that date 8"
label var reason_29 "Planting 2: Reasons for planting on that date 9"
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
label var ferts_21 "Planting 2: Types of fertilizer 1 - Chemical Basal" 
label var ferts_22 "Planting 2: Types of fertilizer 2 - Chemical Top-dressing" 
label var ferts_23 "Planting 2: Types of fertilizer 3 - Animal Manure" 
label var ferts_24 "Planting 2: Types of fertilizer 4 - No fertilizer" 
label var qbasal_2 "Planting 2: Kgs of basal dressing"
label var qtop_2 "Planting 2: kgs of top dressing fertilizer"
label var inter_2 "Planting 2: Intercrop"


	
label values date_2 dates	
label values seed_co_2 seed_co_var
label values mri_2 mri_var
label values pioneer_2 pioneer_var
label values pannar_2 pannar_var
label values zamseed_2 zamseed_var
label values dekalb_2 dekalb_var


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

*********************************************************************
/* Section 11: Maize Plantings 3 */
*********************************************************************

rename v652 date_3
rename q113_1 reason_31
rename q113_2 reason_32
rename q113_3 reason_33
rename q113_11 reason_34
rename q113_4 reason_35
rename q113_6 reason_36
rename q113_7 reason_37
rename q113_9 reason_38
rename q113_5 reason_39
rename q113_5_text reason_txt_3
rename v663 company_3
rename v664 seed_co_3
rename v665 mri_3
rename v666 pioneer_3
rename v667 pannar_3
rename v668 zamseed_3
rename q1110 dekalb_3
rename q1111 recycl_3
rename q1112 second_3
rename q1113 replnt_3
rename q1114 fseed_3
rename q1115 qseed_3
rename q1116 plot_3
rename q1117 qharv_3
rename q1118 grn_3
rename q1118_1_text grn_txt_3
rename q1119_1 ferts_31
rename q1119_8 ferts_32
rename q1119_4 ferts_33
rename q1119_3 ferts_34
rename q1120 qbasal_3
rename q1121 qtop_3
rename q1122 inter_3


*label vars
label var date_3 "Planting 3: Date of planting"
label var reason_31 "Planting 3: Reasons for planting on that date 1"
label var reason_32 "Planting 3: Reasons for planting on that date 2"
label var reason_33 "Planting 3: Reasons for planting on that date 3"
label var reason_34 "Planting 3: Reasons for planting on that date 4"
label var reason_35 "Planting 3: Reasons for planting on that date 5"
label var reason_36 "Planting 3: Reasons for planting on that date 6"
label var reason_37 "Planting 3: Reasons for planting on that date 7"
label var reason_38 "Planting 3: Reasons for planting on that date 8"
label var reason_39 "Planting 3: Reasons for planting on that date 9"
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
label var ferts_31 "Planting 3: Types of fertilizer 1 - Chemical Basal" 
label var ferts_32 "Planting 3: Types of fertilizer 2 - Chemical Top-dressing" 
label var ferts_33 "Planting 3: Types of fertilizer 3 - Animal Manure" 
label var ferts_34 "Planting 3: Types of fertilizer 4 - No fertilizer" 
label var qbasal_3 "Planting 3: Kgs of basal dressing"
label var qtop_3 "Planting 3: kgs of top dressing fertilizer"
label var inter_3 "Planting 3: Intercrop"


	
label values date_3 dates	
label values seed_co_3 seed_co_var
label values mri_3 mri_var
label values pioneer_3 pioneer_var
label values pannar_3 pannar_var
label values zamseed_3 zamseed_var
label values dekalb_3 dekalb_var


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

*********************************************************************
/* Section 12: Maize Plantings 4 */
*********************************************************************

rename q122 date_4
rename q123_1 reason_41
rename q123_2 reason_42
rename q123_3 reason_43
rename q123_11 reason_44
rename q123_4 reason_45
rename q123_6 reason_46
rename q123_7 reason_47
rename q123_9 reason_48
rename q123_5 reason_49
rename q123_5_text reason_txt_4
rename q124 company_4
rename q125 seed_co_4
rename q126 mri_4
rename q127 pioneer_4
rename q128 pannar_4
rename q129 zamseed_4
rename q1210 dekalb_4
rename q1211 recycl_4
rename q1212 second_4
rename q1213 replnt_4
rename q1214 fseed_4
rename q1215 qseed_4
rename q1216 plot_4
rename q1217 qharv_4
rename q1218 unharv_4
*rename q1219 grn_4
rename q1218_1_text grn_4
rename q1219_1 ferts_41
rename q1219_8 ferts_42
rename q1219_3 ferts_43
rename q1219_4 ferts_44
rename q1220 qbasal_4
rename q1221 qtop_4
rename q1222 inter_4


*label vars
label var date_4 "Planting 4: Date of planting"
label var reason_41 "Planting 4: Reasons for planting on that date 1"
label var reason_42 "Planting 4: Reasons for planting on that date 2"
label var reason_43 "Planting 4: Reasons for planting on that date 3"
label var reason_44 "Planting 4: Reasons for planting on that date 4"
label var reason_45 "Planting 4: Reasons for planting on that date 5"
label var reason_46 "Planting 4: Reasons for planting on that date 6"
label var reason_47 "Planting 4: Reasons for planting on that date 7"
label var reason_48 "Planting 4: Reasons for planting on that date 8"
label var reason_49 "Planting 4: Reasons for planting on that date 9"
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
label var unharv_4 "Planting 4: Unharvested maize remaining"
label var grn_4 "Planting 4: kgs of harvested green maize "
*label var grn_txt_4 "Planting 4: kgs of harvested green maize - Text"
label var ferts_41 "Planting 4: Types of fertilizer 1 - Chemical Basal" 
label var ferts_42 "Planting 4: Types of fertilizer 2 - Chemical Top-dressing" 
label var ferts_43 "Planting 4: Types of fertilizer 3 - Animal Manure" 
label var ferts_44 "Planting 4: Types of fertilizer 4 - No fertilizer" 
label var qbasal_4 "Planting 4: Kgs of basal dressing"
label var qtop_4 "Planting 4: kgs of top dressing fertilizer"
label var inter_4 "Planting 4: Intercrop"


label values date_4 dates	
label values seed_co_4 seed_co_var
label values mri_4 mri_var
label values pioneer_4 pioneer_var
label values pannar_4 pannar_var
label values zamseed_4 zamseed_var
label values dekalb_4 dekalb_var


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

*********************************************************************
/* Section 13: Maize Plantings 5 */
*********************************************************************
rename q132 date_5
rename q133_1 reason_51
rename q133_2 reason_52
rename q133_3 reason_53
rename q133_11 reason_54
rename q133_4 reason_55
rename q133_6 reason_56
rename q133_7 reason_57
rename q133_9 reason_58
rename q133_5 reason_59
rename q133_5_text reason_txt_5
rename q134 company_5
rename q135 seed_co_5
rename q136 mri_5
rename q137 pioneer_5
rename q138 pannar_5
rename q139 zamseed_5
rename q1310 dekalb_5
rename q1311 recycl_5
rename q1312 second_5
rename q1313 replnt_5
rename q1314 fseed_5
rename q1315 qseed_5
rename q1316 plot_5
rename q1317 qharv_5
rename q1318 grn_5
rename q1318_1_text grn_txt_5
rename q1319_1 ferts_51
rename q1319_8 ferts_52
rename q1319_4 ferts_53
rename q1319_3 ferts_54
rename q1320 qbasal_5
rename q1321 qtop_5
rename q1322 inter_5


*label vars
label var date_5 "Planting 5: Date of planting"
label var reason_51 "Planting 5: Reasons for planting on that date 1"
label var reason_52 "Planting 5: Reasons for planting on that date 2"
label var reason_53 "Planting 5: Reasons for planting on that date 3"
label var reason_54 "Planting 5: Reasons for planting on that date 4"
label var reason_55 "Planting 5: Reasons for planting on that date 5"
label var reason_56 "Planting 5: Reasons for planting on that date 6"
label var reason_57 "Planting 5: Reasons for planting on that date 7"
label var reason_58 "Planting 5: Reasons for planting on that date 8"
label var reason_59 "Planting 5: Reasons for planting on that date 9"
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

*label var unharv_5 "Planting 5: Unharvested maize remaining"
label var grn_5 "Planting 5: kgs of harvested green maize "
label var grn_txt_5 "Planting 5: kgs of harvested green maize - Text"
label var ferts_51 "Planting 5: Types of fertilizer 1 - Chemical Basal" 
label var ferts_52 "Planting 5: Types of fertilizer 2 - Chemical Top-dressing" 
label var ferts_53 "Planting 5: Types of fertilizer 3 - Animal Manure" 
label var ferts_54 "Planting 5: Types of fertilizer 4 - No fertilizer" 
label var qbasal_5 "Planting 5: Kgs of basal dressing"
label var qtop_5 "Planting 5: kgs of top dressing fertilizer"
label var inter_5 "Planting 5: Intercrop"


	
label values date_5 dates	
label values seed_co_5 seed_co_var
label values mri_5 mri_var
label values pioneer_5 pioneer_var
label values pannar_5 pannar_var
label values zamseed_5 zamseed_var
label values dekalb_5 dekalb_var

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
	
*********************************************************************
/* Section 14: Maize storage and sales*/
*********************************************************************


*rename
rename q141 storage_yn
rename q142 storage
rename q143_1 mz_fin_wk
rename q143_2 mz_fin_mth
rename q143_3 mz_fin_yr
rename q1441_1_1 kgs_stor_now
rename q1442_1 reason_stor
rename q1443_1_1 maize_stor_lost
rename q1444_1 reason_stor_lost
rename q145 qharvested
rename q146 sold_kgs_current
gen sold_who_current = .
rename q147_1 sold_who_current1
rename q147_2 sold_who_current2
rename q147_3 sold_who_current3
rename q147_4 sold_who_current4
rename q148 rct_sale_kgs
rename q149 rct_sale_kwacha
rename q1410 plan_sell
rename q1411 buy_maize
rename q1412 buy_maize_kgs
rename q1413 buy_maize_price
rename q1414 buy_maize_loc
rename q1414_5_text buy_maize_loc_1
rename q1415 buy_meal
rename q1416_2 sold_1
label var sold_1 "Sold 16/17 harvested maize to FRA"
 
rename q1416_3 sold_2
label var sold_2 "Sold 16/17 harvested maize to Other" 

rename q1416_6 sold_3
label var sold_3 "Did not Sell 16/17 harvested maize " 

rename q1417_1 sold_4
label var sold_4 "Sold 16/17 harvested maize to briefcase buyers in village" 

rename q1417_2 sold_5
label var sold_5 "Sold 16/17 harvested maize to private buyers" 

rename q1417_3 sold_6
label var sold_2 "Sold 16/17 harvested maize to individuals" 

rename q1417_4 sold_7
label var sold_2 "Sold 16/17 harvested maize to bartering partner" 

gen sold_who = .
rename q1418 kgs_sold
rename q1419 kgs_soldfra
rename q1420 fra_month_sold
rename q1421 fra_month_paid
rename q1422 fra_dist


*label var
label var storage "Maize storage from previous season - Y/N"
label var kgs_stor "Kgs of maize storage from previous season"
label var mz_fin_wk "week maize from the 2016-2017 harvest finished or all sold - Week (1, 2, 3, 4)"
label var mz_fin_mth "Month maize from the 2016-2017 harvest finished or all sold - Month"
label var mz_fin_yr "Year maize from the 2016-2017 harvest finished or all sold - Year"
label var kgs_stor_now "Kgs of maize storage now"
label var reason_stor "Reason for storing maize"
label var maize_stor_lost "% of storage loss - Maize - 0 - 100"
label var reason_stor_lost "Reason for storage loss - Maize"
label var qharvested "Kgs of total maize harvested from the previous season"
label var sold_kgs_current "Maize sold for cash from last harvest not including bartering - Y/N"
label var sold_who_current "Maize sold from last harvest to Briefcase buyers (unparsed)"
label var sold_who_current1 "Maize sold from last harvest to Briefcase buyers"
label var sold_who_current2 "Maize sold from last harvest to FRA"
label var sold_who_current3 "Maize sold from last harvest to Private buyers / millers in town"
label var sold_who_current4 "Maize sold from last harvest to Individuals in the community"
label var rct_sale_kgs "Kgs of maize sold in the MOST RECENT SALE from last harvest"
label var rct_sale_kwacha "Kwacha received from maize sold in the MOST RECENT SALE from last harvest"
label var plan_sell "Kilograms of maize, available now, from the last harvest that are planned to be sold in the future"
label var buy_maize "Maize purchased in the last 3 months - Y/N"
label var buy_maize_kgs "Kgs of maize purchased in the last 3 months"
label var buy_maize_price "Maize purchased in the last 3 months in Kwacha (including any milling cost)"
label var buy_maize_loc "From where is the maize purchased (grain) on the last purchase"
label var buy_maize_loc_1 "From where is the maize purchased (grain) on the last purchase - Other"
label var buy_meal  "Bought mealie meal in the last 3 months - Y/N"
label var sold_who "Buyers/Barter maize from the previous harvest"

*label var sold_who_1 "Buyers/Barter maize from the previous harvest"
label var kgs_sold "Kgs of maize sold from the previous harvest"
label var kgs_soldfra "Kgs of maize sold from the previous harvest to FRA"
label var fra_month_sold "Month of sales from the previous-harvest maize to FRA"
label var fra_month_paid "Month of payment from the previous-harvest maize sales to FRA"
label var fra_dist "Distance to the FRA depot where previous-harvest maize sales has been done (walking time in minutes)"

*Label values
label define storage_reasons 1 "Better price" 2 "Own use" 3 "No buyers" 4 "Other"
label define storage_losses 1 "Rodents" 2 "Rotting" 3 "Insects" 4 "Other"
label define buy_who 1 "Market" 2 "Another farmer" 3 "Miller" 4 "Other"
label define sell_who 1 "Briefcase buyers (in village)" 2 "FRA" 3 "Private buyers in town" 4 "Individuals" 5 "Bartering partner" 6 "I did not sell maize"

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

forvalues i = 1/4 {
	replace sold_who_current = `i' if sold_who_current`i' == 1
	}

label values reason_stor storage_reasons
label values reason_stor_lost storage_losses

label values buy_maize_loc buy_who
	
label values sold_who sell_who


label define fra_months 1 "April 2017" 2 "May 2017" 3 "June 2017" 4 "July 2017" 5 "August 2017" 6 "September 2017" 7 "October 2017" ///
8 "November 2017" 9 "December 2017" 10 "January 2018" 11 "February 2018" 12 "March 2018" 13 "April 2018" 14 "May 2018"

label values fra_month_sold fra_months
label values fra_month_paid fra_months

replace mz_fin_wk = "99" if mz_fin_wk == "Week" 
replace mz_fin_wk = "1" if mz_fin_wk == "Week 1" 
replace mz_fin_wk = "2" if mz_fin_wk == "Week 2" 
replace mz_fin_wk = "4" if mz_fin_wk == "Week4" 

replace mz_fin_mth = "1" if mz_fin_mth == "January"
replace mz_fin_mth = "1" if mz_fin_mth == "January "

replace mz_fin_mth = "2" if mz_fin_mth == "February"
replace mz_fin_mth = "2" if mz_fin_mth == "February "

replace mz_fin_mth = "3" if mz_fin_mth == "March"
replace mz_fin_mth = "3" if mz_fin_mth == "March "
replace mz_fin_mth = "4" if mz_fin_mth == "April"
replace mz_fin_mth = "4" if mz_fin_mth == "April "

replace mz_fin_mth = "4" if mz_fin_mth == "April "

replace mz_fin_mth = "5" if mz_fin_mth == "May"
replace mz_fin_mth = "5" if mz_fin_mth == "May "
replace mz_fin_mth = "6" if mz_fin_mth == "June"
replace mz_fin_mth = "6" if mz_fin_mth == "June "
replace mz_fin_mth = "7" if mz_fin_mth == "July"
replace mz_fin_mth = "7" if mz_fin_mth == "July "
replace mz_fin_mth = "8" if mz_fin_mth == "August"
replace mz_fin_mth = "8" if mz_fin_mth == "August "
replace mz_fin_mth = "9" if mz_fin_mth == "September"
replace mz_fin_mth = "9" if mz_fin_mth == "September "
replace mz_fin_mth = "10" if mz_fin_mth == "October"
replace mz_fin_mth = "10" if mz_fin_mth == "October "
replace mz_fin_mth = "10" if mz_fin_mth == "November"
replace mz_fin_mth = "10" if mz_fin_mth == "November "
replace mz_fin_mth = "10" if mz_fin_mth == "December"
replace mz_fin_mth = "10" if mz_fin_mth == "December "

replace mz_fin_mth = "4" if mz_fin_mth == "may"

destring mz_fin_wk mz_fin_mth, replace

label define months 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
label define weeks 1 "Week 1" 2 "Week 2" 3 "Week 3" 4 "Week 4" 5 "Week 5" 

label values mz_fin_wk weeks
label values mz_fin_mth months


*********************************************************************
/* Section 15: Non-maize crops and storage */
*********************************************************************
tab q151_42 
rename q151_42 cabbage
label var cabbage "HH grew Cabbage: 1=Yes"

tab q151_16
rename q151_16 carrots
label var carrots "HH grew Carrots: 1=Yes"

tab q151_18
rename q151_18 cassava
label var cassava "HH grew Cassava: 1=Yes"

tab q151_14
rename q151_14 combeans
label var combeans "HH grew Combeans: 1=Yes"

tab q151_10
rename q151_10 cotton
label var cotton "HH grew Cotton: 1=Yes"

tab q151_15
rename q151_15 cowpeas
label var cowpeas "HH grew Cowpeas: 1=Yes"

tab q151_8
rename q151_8 groundnuts
label var groundnuts "HH grew Groundnuts: 1=Yes"

tab q151_11
rename q151_11 ipotato
label var ipotato "HH grew Ipotato: 1=Yes"

tab q151_41
rename q151_41 greens
label var greens "HH grew Greens: 1=Yes"

tab q151_6
rename q151_6 millet
label var millet "HH grew Millet: 1=Yes"

tab q151_40
rename q151_40 okra
label var okra "HH grew Okra: 1=Yes"

tab q151_26
rename q151_26 onions
label var onions "HH grew Onions: 1=Yes"

tab q151_23
rename q151_23 orchard
label var orchard "HH grew Orchard: 1=Yes"

tab q151_39
rename q151_39 peppers
label var peppers "HH grew Peppers: 1=Yes"

tab q151_21
rename q151_21 pea
label var pea "HH grew Pea: 1=Yes"


tab q151_67
rename q151_67 popcorn
label var popcorn "HH grew Popcorn: 1=Yes"

tab q151_66
rename q151_66 pumpkin
label var pumpkin "HH grew pumpkin: 1=Yes"

tab q151_65
rename q151_65 no_other_crops
label var no_other_crops "HH grew no_other_crops 1=Yes"


tab q151_5
rename q151_5 rice
label var rice "HH grew Rice: 1=Yes"

tab q151_4
rename q151_4 sorghum
label var sorghum "HH grew Sorghum: 1=Yes"

tab q151_9
rename q151_9 soybean
label var soybean "HH grew Soybean: 1=Yes"

tab q151_7
rename q151_7 sunflower
label var sunflower "HH grew Sunflower: 1=Yes"

tab q151_17
rename q151_17 spotato
label var spotato "HH grew Sweet Potato: 1=Yes"

tab q151_12
rename q151_12 tobacco
label var tobacco "HH grew Tobacco: 1=Yes"

tab q151_25
rename q151_25 tomatoes
label var tomatoes "HH grew Tomatoes: 1=Yes"

tab q151_24
rename q151_24 othercrop
label var othercrop "HH grew Other crop: 1=Yes"

rename q151_24_text other_text
label var other_text "HH grew other crop: text entry" 

foreach i in cabbage carrots cassava cowpeas groundnuts ipotato greens millet millet okra orchard peppers pea rice sorghum soybean sunflower spotato tobacco tomatoes othercrop popcorn no_other_crops pumpkin {
recode `i' (.=0)
label define `i' 1 "Yes" 0 "No", replace
label values `i' `i'
tab `i'
}

rename	q152_50	NS_earlymaize 
rename	q152_51	NS_mediummaize
rename	q152_52	NS_latemaize
rename	q152_53	NS_localmaize
rename	q152_4	NS_sorghum 
rename	q152_5	NS_rice
rename	q152_6	NS_millet
rename	q152_7	NS_sunflower
rename	q152_8	NS_groundnuts
rename	q152_9	NS_soyabeans
rename	q152_10	NS_cotton
rename	q152_11	NS_irishpot
rename	q152_17	NS_sweetpot
rename	q152_25	NS_tomatoes
rename	q152_26	NS_onions
rename	q152_16	NS_peppers
rename	q152_39	NS_okra
rename	q152_20	NS_leafygreens
rename	q152_19	NS_carrots
rename	q152_13	NS_cabbage
rename	q152_12	NS_tobacco
rename	q152_14	NS_combeans
rename	q152_15	NS_cowpeas
rename	q152_18	NS_cassava
rename	q152_21	NS_pigeonpea
rename	q152_77	NS_popcorn
rename	q152_78	NS_pumpkin
rename	q152_23	NS_orchard
rename	q152_24	NS_other
rename	q152_24_text	NS_othertext

foreach i in NS_earlymaize NS_mediummaize NS_latemaize NS_localmaize NS_sorghum NS_rice NS_millet NS_sunflower NS_groundnuts NS_soyabeans NS_cotton NS_irishpot NS_sweetpot NS_tomatoes NS_onions NS_peppers NS_okra NS_leafygreens NS_carrots NS_cabbage NS_tobacco NS_combeans NS_cowpeas NS_cassava NS_pigeonpea NS_popcorn NS_pumpkin NS_orchard NS_other {
	yesno `i' 
	tab `i'
	}

label var 	NS_earlymaize 	"Next season HH expects to grow early maturing maize "
label var 	NS_mediummaize	"Next season HH expects to grow medium maturing maize"
label var 	NS_latemaize	"Next season HH expects to grow late maturing maize"
label var 	NS_localmaize	"Next season HH expects to grow local maize"
label var 	NS_sorghum 	"Next season HH expects to grow sorghum "
label var 	NS_rice	"Next season HH expects to grow rice"
label var 	NS_millet	"Next season HH expects to grow millet"
label var 	NS_sunflower	"Next season HH expects to grow sunflower"
label var 	NS_groundnuts	"Next season HH expects to grow groundnuts"
label var 	NS_soyabeans	"Next season HH expects to grow soyabeans"
label var 	NS_cotton	"Next season HH expects to grow cotton"
label var 	NS_irishpot	"Next season HH expects to grow irish potatoes"
label var 	NS_sweetpot	"Next season HH expects to grow sweet potatoes"
label var 	NS_tomatoes	"Next season HH expects to grow tomatoes"
label var 	NS_onions	"Next season HH expects to grow onions"
label var 	NS_peppers	"Next season HH expects to grow peppers"
label var 	NS_okra	"Next season HH expects to grow okra"
label var 	NS_leafygreens	"Next season HH expects to grow leafy greens"
label var 	NS_carrots	"Next season HH expects to grow carrots"
label var 	NS_cabbage	"Next season HH expects to grow cabbage"
label var 	NS_tobacco	"Next season HH expects to grow tobacco"
label var 	NS_combeans	"Next season HH expects to grow combeans"
label var 	NS_cowpeas	"Next season HH expects to grow cowpeas"
label var 	NS_cassava	"Next season HH expects to grow cassava"
label var 	NS_pigeonpea	"Next season HH expects to grow pigeon pea"
label var 	NS_popcorn	"Next season HH expects to grow popcorn"
label var 	NS_pumpkin	"Next season HH expects to grow pumpkin"
label var 	NS_orchard	"Next season HH expects to grow orchard"
label var 	NS_other	"Next season HH expects to grow other"
label var 	NS_othertext	"Next season HH expects to grow other text"
	
*********************************************************************
/* Section 16: Weather and Climate Information*/
*********************************************************************
rename 	q161	rainstart17
label define rainstart 1 "1st week October" /* 
*/ 2 "2nd week October" /*
*/ 3 "3rd week October" /*
*/ 4 "4th week October" /*
*/ 5 "1st week November" /*
*/ 6 "2nd week November" /*
*/ 7 "3rd week November" /*
*/ 8 "4th week November" /*
*/ 9 "1st week December" /*
*/ 10 "2nd week December" /*
*/ 11 "3rd week December" /*
*/ 12 "4th week December" /*
*/ 13 "1st week January" /*
*/ 14 "2nd week January" 
label values rainstart17 rainstart

rename 	q162	rainstart16
label values rainstart16 rainstart

rename 	q163	rainstart15
label values rainstart15 rainstart
table rainstart15

rename 	q164	rainstart07
label values rainstart07 rainstart

rename 	q165_1	rank_laterain
rename 	q165_2	rank_dryspell
rename 	q165_3	rank_lowtotal
rename 	q165_4	rank_warm
rename 	q165_5	rank_flooding
rename 	q165_6	rank_other
rename 	q165_6_text	rank_othertext 

rename 	q166_1	exp_late
rename 	q166_2	exp_dryspell
rename 	q166_3	exp_lowtotal
rename 	q166_4	exp_warm
rename 	q166_5	exp_flood
rename 	q166_6	exp_other
rename 	q166_6_text	exp_othertext

rename 	q167	latearrival
rename 	q168	daysnorain
rename 	q169	daysdrought

rename 	q1610_1	drought17_18
rename 	q1610_2	drought16_17
rename 	q1610_3	drought15_16
rename 	q1610_4	drought14_15

rename 	q1611	droughtint

rename 	q1612_1	impact_emergence
rename 	q1612_14	impact_veg
rename 	q1612_15	impact_reprod
rename 	q1612_16	impact_grain 

rename 	q1613_1	drought_crop
rename 	q1613_2	drought_rain
rename 	q1613_3	drought_totalrain
rename 	q1613_4	drought_delayed
rename 	q1613_5	drought_early
rename 	q1613_6	drought_other
rename 	q1613_6_text	drought_othertext

rename 	q1614	droughtfreq
label define droughtfreq 1 "Every year" 2 "Every other year" 3 "Once every 3 years" 4 "Once every 4 years" 5 "Once every 5 years" 6 "Once every 6 years" 7 "Once every 7 years" 8 "Once every 8 years" 9 "Once every 9 years" 10 "Once every 10 years or less frequently" 11 "I have never experienced a drought" 
label value droughtfreq droughtfreq

rename 	q1615	rains
label define rains 1 "Wetter than a typical year" 2 "About the same as a typical year" 3 "Drier than a typical year" 4 "I dont know/ can't predict" 
label value rains rains 


rename 	q1616	forecast_rain
label define forecast_rain 1 "Very confident" 2 "Moderate confidence" 3 "Not very confident" 4 "I don't know" 
label value forecast_rain forecast_rain

rename 	q1617	predict_rains
rename 	q1618	predict_drought

label define predict1 1 "More difficult now compared to 10 years ago" 2 "Easier now compared to 10 years ago" 3 "About the same now as 10 years ago" 4 "I don't know/ I cant predict" 
label value predict_rain predict1
label value predict_drought predict1

rename 	q1619	prepared
label define prepared 1 "Very likely" 2 "Somewhat likely" 3 "Not likely" 4 "I dont know" 

rename 	q1620	activities
recode activities 2=0
label define idk 1 "Yes" 0 "No" 3 "I dont know"  

rename 	q1621_1	act_plant
rename 	q1621_2	act_plantless
rename 	q1621_3	act_planmore
rename 	q1621_4	act_waterharvest
rename 	q1621_5	act_sell
rename 	q1621_6	act_piecework
rename 	q1621_7	act_save
rename 	q1621_8	act_inputs
rename 	q1621_9	act_loans
rename 	q1621_10	act_migrate
rename 	q1621_11	act_other
rename 	q1621_12	act_nothing
rename 	q1621_13	act_idk
rename 	q1621_11_text	act_othertext 

label var	rainstart17	"When did the rains begin in the 2017-2018 season?" 
label var	rainstart16	"When did the rains begin in the 2016-2017 season?" 
label var	rainstart15	"When did the rains begin in the 2015-2016 season?" 
label var	rainstart07	"When did the rains begin about 10 years ago?" 
label var	rank_laterain	"Biggest neg impact on maize: Late rain arrival" 
label var	rank_dryspell	"Biggest neg impact on maize: Dry spells" 
label var	rank_lowtotal	"Biggest neg impact on maize: Low toal seasonal accumulation" 
label var	rank_warm	"Biggest neg impact on maize:Periods of extremely warm temps" 
label var	rank_flooding	"Biggest neg impact on maize: Too much soil moisture" 
label var	rank_other	"Biggest neg impact on maize: Other" 
label var	rank_othertext 	"Biggest neg impact on maize: Other text entry " 
label var	exp_late	"Did you experience the follwoing in 17/18 ag year: : Late rain arrival" 
label var	exp_dryspell	"Did you experience the follwoing in 17/18 ag year: : Dry spells" 
label var	exp_lowtotal	"Did you experience the follwoing in 17/18 ag year: : Low toal seasonal accumulation" 
label var	exp_warm	"Did you experience the follwoing in 17/18 ag year: :Periods of extremely warm temps" 
label var	exp_flood	"Did you experience the follwoing in 17/18 ag year: : Too much soil moisture" 
label var	exp_other	"Did you experience the follwoing in 17/18 ag year: : Other" 
label var	exp_othertext	"Did you experience the follwoing in 17/18 ag year: : Other text entry " 
label var	latearrival	"How many weeks late did rains arrive? " 
label var	daysnorain	"During growing season how days in a row is harmful to maize" 
label var	daysdrought	"How many days without rain is a drought? " 
label var	drought17_18	"Maize was affected by drought in 17/18 ag yr " 
label var	drought16_17	"Maize was affected by drought in 16/17 ag yr " 
label var	drought15_16	"Maize was affected by drought in 15/16 ag yr " 
label var	drought14_15	"Maize was affected by drought in 14/15 ag yr " 
label var	droughtint	"Dry spell intensity " 
label var	impact_emergence	"Droughts have the biggest impact on maize yields during: Emergence" 
label var	impact_veg	"Droughts have the biggest impact on maize yields during: Vegetative stage" 
label var	impact_reprod	"Droughts have the biggest impact on maize yields during: reproductive stage" 
label var	impact_grain 	"Droughts have the biggest impact on maize yields during: grain filling " 
label var	drought_crop	"Drought is defined by: Period without rain during growing season " 
label var	drought_rain	"Drought is defined by: Period without rain that results in dry soil" 
label var	drought_totalrain	"Drought is defined by: low total amount of rain during growing season " 
label var	drought_delayed	"Drought is defined by: Delayed onset of rain during planting " 
label var	drought_early	"Drought is defined by: Early ending of rain season" 
label var	drought_other	"Drought is defined by: Other" 
label var	drought_othertext	"Drought is defined by: Other text " 
label var	droughtfreq	"Drought year frequency " 
label var	rains	"Predictions of rains next season " 
label var	forecast_rain	"Confidence in rainfall forecast " 
label var	predict_rains	"Is ability to predict start of rains different in comp to 10 years ago" 
label var	predict_drought	"Is ability to predict occurance of drought different in comp to 10 years ago" 
label var	prepared	"How likely is HH to be prepared for drought" 
label var	activities	"Activities that can be preformed now in prep for drought " 
label var	act_plant	"Plant a drought resistant crop" 
label var	act_plantless	"Plant less land" 
label var	act_planmore	" Plant more crop types" 
label var	act_waterharvest	"Construct a reservoir for water harvesting" 
label var	act_sell	"Sell family assets, including farm assets and livestock" 
label var	act_piecework	"Seek piecework on another farm" 
label var	act_save	"Save money now for the future" 
label var	act_inputs	"Buy fewer agricultural inputs" 
label var	act_loans	"Seek loans" 
label var	act_migrate	"Migrate to another area" 
label var	act_other	"Other" 
label var	act_nothing	"There is nothing I can do" 
label var	act_idk	"Don't know/refuse to answer" 
label var	act_othertext 	"Other Text" 



*********************************************************************
/* Section 17: Perceptions of Rainfall*/
*********************************************************************

rename	q1721_1_1	aware_type1
rename	q1721_2_1	aware_type2 
rename	q1721_3_1	aware_type3
rename	q1721_4_1	aware_type4
rename	q1721_5_1	aware_type5
rename	q1721_6_1	aware_type6
rename	q1722_1	reliable_type1
rename	q1722_2	reliable_type2
rename	q1722_3	reliable_type3
rename	q1722_4	reliable_type4
rename	q1722_5	reliable_type5
rename	q1722_6	reliable_type6
label define reliable 1 "Not applicable" 2 "Not reliable" 3 "Occasionally reliable" 4 "Mostly reliable" 5 "Always reliable" 6 "Don't know" 
foreach i of num 1/6{ 
	label value reliable_type`i' reliable
	} 
	
rename	q1723_1	informed_activity1
rename	q1723_2	informed_activity2
rename	q1723_3	informed_activity3
rename	q1723_4	informed_activity4
rename	q1723_5	informed_activity5
rename	q1723_6	informed_activity6

rename	q1731_1_1	type1_activity1
rename	q1731_1_2	type1_activity2
rename	q1731_1_3	type1_activity3
rename	q1731_1_4	type1_activity4
rename	q1731_1_5	type1_activity5
rename	q1731_1_6	type1_activity6
rename	q1731_2_1	type2_activity1
rename	q1731_2_2	type2_activity2
rename	q1731_2_3	type2_activity3
rename	q1731_2_4	type2_activity4
rename	q1731_2_5	type2_activity5
rename	q1731_2_6	type2_activity6
rename	q1731_3_1	type3_activity1
rename	q1731_3_2	type3_activity2
rename	q1731_3_3	type3_activity3
rename	q1731_3_4	type3_activity4
rename	q1731_3_5	type3_activity5
rename	q1731_3_6	type3_activity6
rename	q1731_4_1	type4_activity1
rename	q1731_4_2	type4_activity2
rename	q1731_4_3	type4_activity3
rename	q1731_4_4	type4_activity4
rename	q1731_4_5	type4_activity5
rename	q1731_4_6	type4_activity6
rename	q1731_5_1	type5_activity1
rename	q1731_5_2	type5_activity2
rename	q1731_5_3	type5_activity3
rename	q1731_5_4	type5_activity4
rename	q1731_5_5	type5_activity5
rename	q1731_5_6	type5_activity6
rename	q1731_6_1	type6_activity1
rename	q1731_6_2	type6_activity2
rename	q1731_6_3	type6_activity3
rename	q1731_6_4	type6_activity4
rename	q1731_6_5	type6_activity5
rename	q1731_6_6	type6_activity6
rename	q174_1	no_weekly_reason1
rename	q174_2	no_weekly_reason2
rename	q174_3	no_weekly_reason3
rename	q174_4	no_weekly_reason4
rename	q174_5	no_weekly_reason5
rename	q174_6	no_weekly_reason6
rename	q174_7	no_weekly_reason7
rename	q174_8	no_weekly_reason8
rename	q174_9	no_weekly_reason9
rename	q174_10	no_weekly_reason10
rename	q174_11	no_weekly_reason11
rename	q175_1	no_rainfall_reason1
rename	q175_2	no_rainfall_reason2
rename	q175_3	no_rainfall_reason3
rename	q175_4	no_rainfall_reason4
rename	q175_5	no_rainfall_reason5
rename	q175_6	no_rainfall_reason6
rename	q175_7	no_rainfall_reason7
rename	q175_8	no_rainfall_reason8
rename	q175_9	no_rainfall_reason9
rename	q175_10	no_rainfall_reason10
rename	q175_11	no_rainfall_reason11
rename	q1761_1_1	access_source1
rename	q1761_2_1	access_source2
rename	q1761_3_1	access_source3
rename	q1761_4_1	access_source4
rename	q1761_5_1	access_source5
rename	q1761_6_1	access_source6
rename	q1761_7_1	access_source7
rename	q1761_8_1	access_source8
rename	q1761_9_1	access_source9
rename	q1762_1	trust_source1
rename	q1762_2	trust_source2
rename	q1762_3	trust_source3
rename	q1762_4	trust_source4
rename	q1762_5	trust_source5
rename	q1762_6	trust_source6
rename	q1762_7	trust_source7
rename	q1762_8	trust_source8
rename	q1762_9	trust_source9

label define trust 1 "High trust" 2 "Moderate trust" 3 "Low trust" 4 "No trust" 5 "I dont know" 
foreach i of num 1/9 {
	label value trust_source`i' trust
	}
	
rename	q177_1	climate_change_source1
rename	q177_12	climate_change_source2
rename	q177_2	climate_change_source3
rename	q177_10	climate_change_source4
rename	q177_3	climate_change_source5
rename	q177_4	climate_change_source6
rename	q177_5	climate_change_source7
rename	q177_6	climate_change_source8
rename	q177_7	climate_change_source9
rename	q178_1	chall_prev_year1
rename	q178_2	chall_prev_year2
rename	q178_3	chall_prev_year3
rename	q178_4	chall_prev_year4
rename	q178_5	chall_prev_year5
rename	q178_6	chall_prev_year6
rename	q178_7	chall_prev_year7
rename	q178_8	chall_prev_year8
rename	q178_9	chall_prev_year9
rename	q178_10	chall_prev_year10
rename	q178_11	chall_prev_year11
rename	q178_12	chall_prev_year12
rename	q178_12_text	chall_prev_year12_text
rename	q178_13	chall_prev_year13
rename	q178_13_text	chall_prev_year13_text
rename	q178_14	chall_prev_year14
rename	q178_14_text	chall_prev_year14_text
rename	q178_15	chall_prev_year15

label define challenge 1 "Biggest challenge" 2 "Second biggest" 3 "Third biggest" 

foreach i of num 1/15{
	label value chall_prev_year`i' challenge
	}
	

label var	aware_type1	"Are you aware of the 7-days weather forecasts? -  Yes"
label var	aware_type2	"Are you aware of the Storm warnings? -  Yes"
label var	aware_type3	"Are you aware of the Agr Advisories that contain weather and climate info? -  Yes"
label var	aware_type4	"Are you aware of the One-month rainfall forecast? -  Yes"
label var	aware_type5	"Are you aware of the Seasonal rainfall forecasts? -  Yes"
label var	aware_type6	"Are you aware of the Drought early warning information? -  Yes"
label var	reliable_type1	"How reliable is the 7-days weather forecasts?"
label var	reliable_type2	"How reliable is the Storm warnings?"
label var	reliable_type3	"How reliable is the Agr Advisories that contain weather and climate info?"
label var	reliable_type4	"How reliable is the One-month rainfall forecast?"
label var	reliable_type5	"How reliable is the Seasonal rainfall forecasts?"
label var	reliable_type6	"How reliable is the Drought early warning information?"
label var	informed_activity1	"Activities informed during the 2017-2018 growing season - 7-days weather forecasts"
label var	informed_activity2	"Activities informed during the 2017-2018 growing season - Storm warnings"
label var	informed_activity3	"Activities informed during the 2017-2018 growing season - Agr Advisories"
label var	informed_activity4	"Activities informed during the 2017-2018 growing season - One-month rainfall forecast"
label var	informed_activity5	"Activities informed during the 2017-2018 growing season - Seasonal rainfall forecasts"
label var	informed_activity6	"Activities informed during the 2017-2018 growing season - Drought early warning information"
label var	type1_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type1_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type1_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type1_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type1_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type1_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	type2_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type2_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type2_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type2_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type2_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type2_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	type3_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type3_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type3_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type3_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type3_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type3_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	type4_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type4_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type4_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type4_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type4_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type4_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	type5_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type5_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type5_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type5_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type5_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type5_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	type6_activity1	"Ag act inf by 7-days weather forecasts during this season? No actv. informed"
label var	type6_activity2	"Ag act inf by Storm warnings during this season? When to plant/sow"
label var	type6_activity3	"Ag act inf by Agr Advisories  info during this season? varieties to plant"
label var	type6_activity4	"Ag act inf by One-month rainfall forecast during this season? Rotation/intercropping"
label var	type6_activity5	"Ag act inf by Seasonal rainfall forecasts during this season? Land to cultivate"
label var	type6_activity6	"Ag act inf by Drought early warning info during this season? Fertilizer/chemical"
label var	no_weekly_reason1	"Why you did not use these forecasts? I used my own observations"
label var	no_weekly_reason2	"Why you did not use these forecasts? No one can predict the weather/climate; God’s plan"
label var	no_weekly_reason3	"Why you did not use these forecasts? I followed other community members/leaders"
label var	no_weekly_reason4	"Why you did not use these forecasts? I didn’t make decisions based on this info"
label var	no_weekly_reason5	"Why you did not use these forecasts? The info is not accurate"
label var	no_weekly_reason6	"Why you did not use these forecasts? The info came too late"
label var	no_weekly_reason7	"Why you did not use these forecasts? I never received the info"
label var	no_weekly_reason8	"Why you did not use these forecasts? The info was not specific to my town/home/area"
label var	no_weekly_reason9	"Why you did not use these forecasts? I didn't understand the technical nature of the info"
label var	no_weekly_reason10	"Why you did not use these forecasts? Other"
label var	no_weekly_reason11	"Why you did not use these forecasts? I don't know"
label var	no_rainfall_reason1	"Why you did not use these forecasts? I used my own observations"
label var	no_rainfall_reason2	"Why you did not use these forecasts? Can’t predict the weather/climate; God’s plan"
label var	no_rainfall_reason3	"Why you did not use these forecasts? I followed other community members/leaders"
label var	no_rainfall_reason4	"Why you did not use these forecasts? I didn’t make decisions based on this info"
label var	no_rainfall_reason5	"Why you did not use these forecasts? The info is not accurate"
label var	no_rainfall_reason6	"Why you did not use these forecasts? The info came too late"
label var	no_rainfall_reason7	"Why you did not use these forecasts? I never received the info"
label var	no_rainfall_reason8	"Why you did not use these forecasts? The info was not specific to my town/home/area"
label var	no_rainfall_reason9	"Why you did not use these forecasts? I didn't understand the technical nature of the info"
label var	no_rainfall_reason10	"Why you did not use these forecasts? Other"
label var	no_rainfall_reason11	"Why you did not use these forecasts? I don't know"
label var	access_source1	"Do you access information about the weather and climate from Radio?"
label var	access_source2	"Do you access information about the weather and climate from TV?"
label var	access_source3	"Do you access information about the weather and climate from Mobile phones or internet devices (SMS/WhatsApp/Webpages/Emails)?"
label var	access_source4	"Do you access information about the weather and climate from Newspaper and other print material?"
label var	access_source5	"Do you access information about the weather and climate from Community leaders or elders?"
label var	access_source6	"Do you access information about the weather and climate from Other community members (including neighbors / family / friends)?"
label var	access_source7	"Do you access information about the weather and climate from Government agricultural extension officer?"
label var	access_source8	"Do you access information about the weather and climate from NGOs / Development projects?"
label var	access_source9	"Do you access information about the weather and climate from Community Based Organizations (including faith based and farmer groups)?"
label var	trust_source1	"How much do you trust the information you receive from Radio?"
label var	trust_source2	"How much do you trust the information you receive from TV?"
label var	trust_source3	"How much do you trust the information you receive from Mobile phones or internet devices (SMS/WhatsApp/Webpages/Emails)?"
label var	trust_source4	"How much do you trust the information you receive from Newspaper and other print material?"
label var	trust_source5	"How much do you trust the information you receive from Community leaders or elders?"
label var	trust_source6	"How much do you trust the information you receive from Other community members (including neighbors/family/friends)?"
label var	trust_source7	"How much do you trust the information you receive from Government agricultural extension officer?"
label var	trust_source8	"How much do you trust the information you receive from NGOs/Development projects?"
label var	trust_source9	"How much do you trust the information you receive from Community Based Organizations (including faith based and farmer groups)?"
label var	climate_change_source1	"Have you received information about CLIMATE CHANGE from Radio?"
label var	climate_change_source2	"Have you received information about CLIMATE CHANGE from TV?"
label var	climate_change_source3	"Have you received information about CLIMATE CHANGE from Mobile phones or internet devices (SMS/WhatsApp/Webpages/Emails)?"
label var	climate_change_source4	"Have you received information about CLIMATE CHANGE from Newspaper and other print material?"
label var	climate_change_source5	"Have you received information about CLIMATE CHANGE from Community leaders or elders?"
label var	climate_change_source6	"Have you received information about CLIMATE CHANGE from Other community members (including neighbors/family/friends)?"
label var	climate_change_source7	"Have you received information about CLIMATE CHANGE from Government agricultural extension officer?"
label var	climate_change_source8	"Have you received information about CLIMATE CHANGE from NGOs/Development projects?"
label var	climate_change_source9	"Have you received information about CLIMATE CHANGE from Community Based Organizations (including faith based and farmer groups)?"
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
label var	chall_prev_year15	"The three biggest challenges from farming - I don't know"


*********************************************************************
/* Section 18: Cooperatives and FISP*/
*********************************************************************
*per instructions v1033 v1035 v1037 v1039 v1041 v1043 should be left blank therefore we drop them fromt the data
rename 	q181	coop
yesno coop 

rename 	q182	fisp_evouch
label define fisp 1 "Yes, conventional FISP" 2 "Yes, E-Voucher FISP" 3 "No"
label value fisp_evouch fisp

rename 	q183	vouchdate
label define vouchdate 	1	"1st week October 2017"		///
6	"2nd week October 2017"		///
7	"3rd week October 2017"		///
8	"4th week October 2017"		///
2	"1st week November 2017"		///
9	"2nd week November 2017"		///
10	"3rd week November 2017"		///
11	"4th week November 2017"		///
3	"1st week December 2017"		///
12	"2nd week December 2017"		///
13	"3rd week December 2017"		///
14	"4th week December 2017"		///
4	"1st week January  2018"		///
15	"2nd week January  2018"		///
16	"3rd week January  2018"		///
17	"4th week January  2018"		///
5	"1st week February  2018"		///
19	"Was never activated "	
label value vouchdate vouchdate 

rename 	q184	fisp_dlvr
label define delivered 19	"1st week October 2017"		///
1	"2nd week October 2017"		///
6	"3rd week October 2017"		///
7	"4th week October 2017"		///
8	"1st week November 2017"		///
2	"2nd week November 2017"		///
9	"3rd week November 2017"		///
10	"4th week November 2017"		///
11	"1st week December 2017"		///
3	"2nd week December 2017"		///
12	"3rd week December 2017"		///
13	"4th week December 2017"		///
14	"1st week January  2018"		///
4	"2nd week January  2018"		///
15	"3rd week January  2018"		///
16	"4th week January  2018"		///
17	"1st week February  2018"		///
5	"After 1st week of February 2018 "		///
20	"Before first week of October 2017"		

label value fisp_dlvr delivered

rename 	v1030	vfert
rename 	v1031	vfert_bags
rename 	v1032	vmaizeseed
drop	v1033	
rename 	v1034	votherseed
drop	v1035	
rename 	v1036	vequip
drop	v1037	
rename 	v1038	vchem
drop	v1039	
rename 	v1040	vhealth
drop	v1041	
rename 	v1042	vgoods
drop	v1043	

label var	coop	"yesno coop member (1=yes)"
label var	fisp_evouch	"Participate in FISP this ag season "
label var	vouchdate	"when was evouch first used / activated"
label var	fisp_dlvr	"when was evouch first delivered"
label var	vfert	"evouch used on fertilizer (kwacha)"
label var	vfert_bags	"evouch used on fertilizer (bags)"
label var	vmaizeseed	"evouch used on maize seed (kwacha)"
label var	votherseed	"evouch used on other seed (kwacha)"
label var	vequip	"evouch used on implements"
label var	vchem	"evouch used on chemicals"
label var	vhealth	"evouch used on immunizations"
label var	vgoods	"evouch used on non-ag goods"


*********************************************************************
/* Section 19: Charcoal and Firewood */
*********************************************************************

rename q192 Charc
 label var Charc "Did you produce charcoal for sale in July 2017"
 * some values were recorded as 2 and 3 before survey was changed there is no way to recover these values in qualtrics so we code them to missing obs 
 
 recode Charc 2=.
 recode Charc 3=.
 recode Charc 4=0
 label define Charc 1 "yes" 0 "no"

rename q193_4 char_homestead
label var  char_homestead "HH sells charcoal at homestead"
rename q193_5 char_within_village
label var  char_within_village "HH sells charcoal at within the village market"
rename q193_6 char_along_mainroad
label var  char_along_mainroad "HH sells charcoal along the main road"
rename q193_7 char_tarmac_road
label var char_tarmac_road "HH sells charcoal along the tarmac road"
rename q193_8 char_main_distr
label var char_main_distr "HH sells charcoal at the main district town"
 
 *Q19.4
rename q194_1 cust_village_
label var cust_village_ "HH's charcoal customers come from village"
rename q194_2 cust_district
label var cust_district "HH's charcoal customers come from withinin the district"
rename q194_3 cust_provinc
label var cust_provinc "HH's charcoal customers come from withinin the province"
rename q194_4 cust_outs_vil
label var cust_outs_vil "HH's charcoal customers come from outside the village but within the district"
rename q194_5 cust_out_dis
label var cust_out_dis "HH's charcoal customers come from outside the village but within the province"
rename q194_6 cust_out_prov
label var cust_out_prov "HH's charcoal customers come from outside the village but outside the province"

*Q19.5 
rename q195 qcharc
label var qcharc "What bag size of charcoal do you typically sell?"

*Q19.6
rename q196 price_charc
label var price_charc "How much do you charge for the bag of charcoal?"

*Q19.7 
rename q1971_1_1 srev_cha_june_17
lab var srev_cha_june_17 "Money made from charcoal sales in june 2017"
rename q1971_2_1 srev_cha_july_17
lab var srev_cha_july_17 "Money made from charcoal sales in july 2017"
rename q1971_3_1 srev_cha_aug_17
lab var srev_cha_aug_17 "Money made from charcoal sales in august 2017"
rename q1971_4_1 srev_cha_sept_17
lab var srev_cha_sept_17 "Money made from charcoal sales in september 2017"
rename q1971_5_1 srev_cha_oct_17
lab var srev_cha_oct_17 "Money made from charcoal sales in october 2017"
rename q1971_6_1 srev_cha_nov_17
lab var srev_cha_nov_17 "Money made from charcoal sales in november 2017"
rename q1971_7_1 srev_cha_dec_17
lab var srev_cha_dec_17 "Money made from charcoal sales in december 2017"
rename q1971_8_1 srev_cha_jan_18
lab var srev_cha_jan_18 "Money made from charcoal sales in january 2018"
rename q1971_9_1 srev_cha_feb_18
lab var srev_cha_feb_18 "Money made from charcoal sales in february 2018"
rename q1971_10_1 srev_cha_marc_18
lab var srev_cha_marc_18 "Money made from charcoal sales in march 2018"
rename q1971_11_1 srev_cha_april_18
lab var srev_cha_april_18 "Money made from charcoal sales in april 2018"
rename q1971_12_1 srev_cha_may_18
lab var srev_cha_may_18 "Money made from charcoal sales in may 2018"
rename q1971_13_1 srev_cha_june_18
lab var srev_cha_june_18 "Money made from charcoal sales in june 2018"
rename q1971_14_1 srev_cha_july_18
lab var srev_cha_july_18 "Money made from charcoal sales in july 2018"


 rename q1972_1_1 pqchar_june_17
lab var pqchar_june_17 "quantity(kgs) of charcoal produced in june 2017"
rename q1972_2_1 pqchar_july_17
lab var pqchar_july_17 "quantity (kgs) of charcoal produced in july 2017"
rename q1972_3_1 pqchar_aug_17
lab var pqchar_aug_17 "quantity (kgs) of charcoal produced in july 2017"
rename q1972_4_1 pqchar_sept_17
lab var pqchar_sept_17 "quantity (kgs) of charcoal produced in september 2017"
rename q1972_5_1 pqchar_oct_17
lab var pqchar_oct_17 "quantity (kgs) of charcoal produced in october 2017"
rename q1972_6_1 pqchar_nov_17
lab var pqchar_nov_17 "quantity (kgs) of charcoal produced in november 2017"
rename q1972_7_1 pqchar_dec_17
lab var pqchar_dec_17 "quantity (kgs) of charcoal produced in december 2017"
rename q1972_8_1 pqchar_jan_18
lab var pqchar_jan_18 "quantity (kgs) of charcoal produced in january 2018"
rename q1972_9_1 pqchar_feb_18
lab var pqchar_feb_18 "quantity (kgs) of charcoal produced in february 2018"
rename q1972_10_1 pqchar_mar_18
lab var pqchar_mar_18 "quantity (kgs) of charcoal produced in march 2018"
rename q1972_11_1 pqchar_april_18
lab var pqchar_april_18 "quantity (kgs) of charcoal produced in april 2018"
rename q1972_12_1 pqchar_may_18
lab var pqchar_may_18 "quantity (kgs) of charcoal produced in may 2018"
rename q1972_13_1 pqchar_june_18
lab var pqchar_june_18 "quantity (kgs) of charcoal produced in june 2018"
rename q1972_14_1 pqchar_july_18
lab var pqchar_july_18 "quantity (kgs) of charcoal produced in july 2018"


 rename q1973_1_1 sqchar_june_17
lab var sqchar_june_17 "quantity (kgs) of charcoal sold june 2017"
rename q1973_2_1 sqchar_july_17
lab var sqchar_july_17 "quantity (kgs) of charcoal sold july 2017"
rename q1973_3_1 sqchar_aug_17
lab var sqchar_aug_17 "quantity (kgs) of charcoal sold july 2017"
rename q1973_4_1 sqchar_sept_17
lab var sqchar_sept_17 "quantity (kgs) of charcoal sold september 2017"
rename q1973_5_1 sqchar_oct_17
lab var sqchar_oct_17 "quantity (kgs) of charcoal sold october 2017"
rename q1973_6_1 sqchar_nov_17
lab var sqchar_nov_17 "quantity (kgs) of charcoal sold november 2017"
rename q1973_7_1 sqchar_dec_17
lab var sqchar_dec_17 "quantity (kgs) of charcoal sold december 2017"
rename q1973_8_1 sqchar_jan_18
lab var sqchar_jan_18 "quantity (kgs) of charcoal sold january 2018"
rename q1973_9_1 sqchar_feb_18
lab var sqchar_feb_18 "quantity (kgs) of charcoal sold february 2018"
rename q1973_10_1 sqchar_mar_18
lab var sqchar_mar_18 "quantity (kgs) of charcoal sold march 2018"
rename q1973_11_1 sqchar_april_18
lab var sqchar_april_18 "quantity (kgs) of charcoal sold april 2018"
rename q1973_12_1 sqchar_may_18
lab var sqchar_may_18 "quantity (kgs) of charcoal sold may 2018"
rename q1973_13_1 sqchar_june_18
lab var sqchar_june_18 "quantity (kgs) of charcoal sold june 2018"
rename q1973_14_1 sqchar_july_18
lab var sqchar_july_18 "quantity (kgs) of charcoal sold july 2018"
 
*19.8
rename q198 Charc_rev
label var Charc_rev "Total revene from charcoal sales"

*19.9
rename q199_1 char_transport_cost
label var char_transport_cost " transport costs incured to the charcoal business in the past 12 months "
rename q199_2 char_hired_labor_cost
label var char_hired_labor_cost "hired labor costs incured to the charcoal business in the past 12 months "
rename q199_3 char_other_costs
label var char_other_costs "other costs incured to the charcoal business in the past 12 months "

*19.10
rename q19101_1 charc_store
label var charc_store "Did you store charcoal between June 2017-July 2018"
recode charc_store 2=0
label define charc_store 1 "yes" 0 "no"

rename q19102_1_1 days_stor
label var days_stor "How long did you store the product btn prodn and sale"

*19.11
rename q1911_1 ch_buy_ag_inputs
label var ch_buy_ag_inputs "HH spends money from charcoal sells to buy agricultural inputs"
rename q1911_2 ch_school_fees
label var ch_school_fees "HH spends money from charcoal sells for school fees"
rename q1911_3 ch_as_capital
label var ch_as_capital "HH spends money from charcoal sells as capital to finnance other businesses"
rename q1911_4 ch_household_needs
label var ch_household_needs "HH spends money from charcoal sells as capital to buy household needs"

*19.12
rename q1912_2 dist_cut_trees
label var dist_cut_trees "Distance from home to location where they usually cut trees for charcoal"
rename q1912_3 dist_locat_ct_trees
label var dist_locat_ct_trees "Distance to the location of charcoal production"
rename q1912_4 dist_char_sell
label var dist_char_sell "Distance from the place of production to point of sell"
rename q1912_5 dist_char_home_sell
label var dist_char_home_sell "Distance from the home to point of sell"

*19.13
rename q1913 qchar_kiln
label var qchar_kiln "How much charcoal did you produce from the last kiln?"

*19.14
rename 	q19141_1_1	M5_cutdown
rename 	q19141_1_2	F5_cutdown
rename 	q19141_2_1	M5_logs
rename 	q19141_2_2	F5_logs 
rename 	q19141_3_1	M5_prepare
rename 	q19141_3_2	F5_prepare
rename 	q19141_4_1	M5_monitor
rename 	q19141_4_2	F5_monitor
rename 	q19141_5_1	M5_transport
rename 	q19141_5_2	F5_transport 
rename 	q19141_6_1	M5_sales
rename 	q19141_6_2	F5_sales
rename 	q19141_7_1	M5_all
rename 	q19141_7_2	F5_all
rename 	q19142_1_1	time_cutdown
rename 	q19142_2_1	time_logs
rename 	q19142_3_1	time_prepare
rename 	q19142_4_1	time_monitor
rename 	q19142_5_1	time_transport
rename 	q19142_6_1	time_sales
rename 	q19142_7_1	time_all
rename 	q19143_1_1	M9_cutdown
rename 	q19143_1_2	F9_cutdown
rename 	q19143_2_1	M9_logs
rename 	q19143_2_2	F9_logs 
rename 	q19143_3_1	M9_prepare
rename 	q19143_3_2	F9_prepare
rename 	q19143_4_1	M9_monitor
rename 	q19143_4_2	F9_monitor
rename 	q19143_5_1	M9_transport
rename 	q19143_5_2	F9_transport 
rename 	q19143_6_1	M9_sales
rename 	q19143_6_2	F9_sales
rename 	q19143_7_1	M9_all
rename 	q19143_7_2	F9_all
rename 	q19144_1_1	M17_cutdown
rename 	q19144_1_2	F17_cutdown
rename 	q19144_2_1	M17_logs
rename 	q19144_2_2	F17_logs 
rename 	q19144_3_1	M17_prepare
rename 	q19144_3_2	F17_prepare
rename 	q19144_4_1	M17_monitor
rename 	q19144_4_2	F17_monitor
rename 	q19144_5_1	M17_transport
rename 	q19144_5_2	F17_transport 
rename 	q19144_6_1	M17_sales
rename 	q19144_6_2	F17_sales
rename 	q19144_7_1	M17_all
rename 	q19144_7_2	F17_all
rename 	q19145_1_1	M59_cutdown
rename 	q19145_1_2	F59_cutdown
rename 	q19145_2_1	M59_logs
rename 	q19145_2_2	F59_logs 
rename 	q19145_3_1	M59_prepare
rename 	q19145_3_2	F59_prepare
rename 	q19145_4_1	M59_monitor
rename 	q19145_4_2	F59_monitor
rename 	q19145_5_1	M59_transport
rename 	q19145_5_2	F59_transport 
rename 	q19145_6_1	M59_sales
rename 	q19145_6_2	F59_sales
rename 	q19145_7_1	M59_all
rename 	q19145_7_2	F59_all
rename 	q19146_1_1	M60_cutdown
rename 	q19146_1_2	F60_cutdown
rename 	q19146_2_1	M60_logs
rename 	q19146_2_2	F60_logs 
rename 	q19146_3_1	M60_prepare
rename 	q19146_3_2	F60_prepare
rename 	q19146_4_1	M60_monitor
rename 	q19146_4_2	F60_monitor
rename 	q19146_5_1	M60_transport
rename 	q19146_5_2	F60_transport 
rename 	q19146_6_1	M60_sales
rename 	q19146_6_2	F60_sales
rename 	q19146_7_1	M60_all
rename 	q19146_7_2	F60_all

label var	M5_cutdown	"Number of males under 5 cutting down trees "
label var	F5_cutdown	"Number of females under 5 cutting down trees "
label var	M5_logs	"Number of males under 5 bucking up the logs"
label var	F5_logs 	"Number of females under 5 bucking up the logs"
label var	M5_prepare	"Number of males under 5 preparing the kiln"
label var	F5_prepare	"Number of females under 5 preparing the kiln"
label var	M5_monitor	"Number of males under 5 monitoring the kiln"
label var	F5_monitor	"Number of females under 5 monitoring the kiln"
label var	M5_transport	"Number of males under 5 bagging and transporting charcoal "
label var	F5_transport 	"Number of females under 5 bagging and transporting charcoal"
label var	M5_sales	"Number of males under 5 involved in charcoal sales"
label var	F5_sales	"Number of females under 5 involved in charcoal sales"
label var	M5_all	"Number of males under 5 involved in all of the charcoal activities"
label var	F5_all	"Number of females under 5 involved in all of the charcoal activities"
label var	time_cutdown	"Time required for the last kiln to cut down trees"
label var	time_logs	"Time required for the last kiln to move logs "
label var	time_prepare	"Time required for the last kiln to prepare kiln"
label var	time_monitor	"Time required for the last kiln to monitor kiln"
label var	time_transport	"Time required for the last kiln to bag and transport charcoal"
label var	time_sales	"Time required for the last kiln for sales"
label var	time_all	"Time required for the last kiln for all activities"
label var	M9_cutdown	"Number of males age 5-9 cutting down trees "
label var	F9_cutdown	"Number of females age 5-9 cutting down trees "
label var	M9_logs	"Number of males age 5-9 bucking up the logs"
label var	F9_logs 	"Number of females age 5-9 bucking up the logs"
label var	M9_prepare	"Number of males age 5-9 preparing the kiln"
label var	F9_prepare	"Number of females age 5-9 preparing the kiln"
label var	M9_monitor	"Number of males age 5-9 monitoring the kiln"
label var	F9_monitor	"Number of females age 5-9 monitoring the kiln"
label var	M9_transport	"Number of males age 5-9 bagging and transporting charcoal "
label var	F9_transport 	"Number of females age 5-9 bagging and transporting charcoal"
label var	M9_sales	"Number of males age 5-9 involved in charcoal sales"
label var	F9_sales	"Number of females age 5-9 involved in charcoal sales"
label var	M9_all	"Number of males age 5-9 involved in all of the charcoal activities"
label var	F9_all	"Number of females age 5-9 involved in all of the charcoal activities"
label var	M17_cutdown	"Number of males age 10-17 cutting down trees "
label var	F17_cutdown	"Number of females age 10-17 cutting down trees "
label var	M17_logs	"Number of males age 10-17 bucking up the logs"
label var	F17_logs 	"Number of females age 10-17 bucking up the logs"
label var	M17_prepare	"Number of males age 10-17 preparing the kiln"
label var	F17_prepare	"Number of females age 10-17 preparing the kiln"
label var	M17_monitor	"Number of males age 10-17 monitoring the kiln"
label var	F17_monitor	"Number of females age 10-17 monitoring the kiln"
label var	M17_transport	"Number of males age 10-17 bagging and transporting charcoal "
label var	F17_transport 	"Number of females age 10-17 bagging and transporting charcoal"
label var	M17_sales	"Number of males age 10-17 involved in charcoal sales"
label var	F17_sales	"Number of females age 10-17 involved in charcoal sales"
label var	M17_all	"Number of males age 10-17 involved in all of the charcoal activities"
label var	F17_all	"Number of females age 10-17 involved in all of the charcoal activities"
label var	M59_cutdown	"Number of males age 18-59 cutting down trees "
label var	F59_cutdown	"Number of females age 18-59 cutting down trees "
label var	M59_logs	"Number of males age 18-59 bucking up the logs"
label var	F59_logs 	"Number of females age 18-59 bucking up the logs"
label var	M59_prepare	"Number of males age 18-59 preparing the kiln"
label var	F59_prepare	"Number of females age 18-59 preparing the kiln"
label var	M59_monitor	"Number of males age 18-59 monitoring the kiln"
label var	F59_monitor	"Number of females age 18-59 monitoring the kiln"
label var	M59_transport	"Number of males age 18-59 bagging and transporting charcoal "
label var	F59_transport 	"Number of females age 18-59 bagging and transporting charcoal"
label var	M59_sales	"Number of males age 18-59 involved in charcoal sales"
label var	F59_sales	"Number of females age 18-59 involved in charcoal sales"
label var	M59_all	"Number of males age 18-59 involved in all of the charcoal activities"
label var	F59_all	"Number of females age 18-59 involved in all of the charcoal activities"
label var	M60_cutdown	"Number of males age 60+ cutting down trees "
label var	F60_cutdown	"Number of females age 60+ cutting down trees "
label var	M60_logs	"Number of males age 60+ bucking up the logs"
label var	F60_logs 	"Number of females age 60+ bucking up the logs"
label var	M60_prepare	"Number of males age 60+ preparing the kiln"
label var	F60_prepare	"Number of females age 60+ preparing the kiln"
label var	M60_monitor	"Number of males age 60+ monitoring the kiln"
label var	F60_monitor	"Number of females age 60+ monitoring the kiln"
label var	M60_transport	"Number of males age 60+ bagging and transporting charcoal "
label var	F60_transport 	"Number of females age 60+ bagging and transporting charcoal"
label var	M60_sales	"Number of males age 60+ involved in charcoal sales"
label var	F60_sales	"Number of females age 60+ involved in charcoal sales"
label var	M60_all	"Number of males age 60+ involved in all of the charcoal activities"
label var	F60_all	"Number of females age 60+ involved in all of the charcoal activities"

*19.15
rename q19151_1 charcoal_land
label var charcoal_land "Land where household collects charcoal" 
label define charland 1 "Personal land" 2 "Customary land" 3 "State land" 4 "Private land" 
label value charcoal_land charland 

rename q19152_1 no_charcoal 
label var no_charcoal "Are there lands nearby where you are not allowed to produce charcoal/collect firewood" 
yesno no_charcoal 

*19.16
rename q1916 charc_policy
label var charc_policy "Are you aware of the policies governing charcoal sale?"
recode charc_policy 2=0
label define charc_policy 1 "yes" 0 "no"

*19.17
rename q1917 fire_sale
label var fire_sale "Did collect the firewood for sale at any time since July 2017?"
recode fire_sale 4=0
yesno fire_sale 

*19.18
rename q1918_4 sellfirew_homestead
label var sellfirew_homestead "HH sells firewood at homestead"
rename q1918_5 sellfirew_within_village
label var sellfirew_within_village "HH sells firewood within the nearest village market"
rename q1918_6 sellfirew_along_mainroad
label var sellfirew_along_mainroad "HH sells firewood within the nearest along the village road"
rename q1918_7 sellfirew_tarmac_road
label var sellfirew_tarmac_road "HH sells firewood within the nearest along the tarmac road"
rename q1918_8 sellfirew_main_distr
label var sellfirew_main_distr "HH sells firewood within the nearest along the main distict town"

*19.19r
rename q1919_1 fr_cust_homestead
label var fr_cust_homestead "HH's firewood customers come from village"
rename q1919_2 fr_within_district
label var fr_within_district "HH's firewood customers come from within the district"
rename q1919_3 fr_within_provinc
label var fr_within_provinc "HH's firewood customers come from with the province"
rename q1919_4 fr_outside_vill_distr
label var fr_outside_vill_distr "HH's firewood customers come from outside the village but with the district"
rename q1919_5 fr_outside_distr_prov
label var fr_outside_distr_prov "HH's firewood customers come from outside the district but within the province"
rename q1919_6 fr_outside_prov
label var fr_outside_prov "HH's firewood customers come from outside the province"


*19.20 
rename q1920 firewood_bundle
label var firewood_bundle "What is the typical firewood bundle you sell?"
label define firesize 4 "Small" 5 "Medium" 6 "Large" 


*19.21
rename q1921 price_firewood
label var price_firewood "How much do you charge for the bundle of firewood?"

*19.22
rename	q19221_1_1	Fwsales_June17
rename	q19221_2_1	Fwsales_July17
rename	q19221_3_1	Fwsales_Aug17
rename	q19221_4_1	Fwsales_Sept17
rename	q19221_5_1	Fwsales_Oct17
rename	q19221_6_1	Fwsales_Nov17
rename	q19221_7_1	Fwsales_Dec17
rename	q19221_8_1	Fwsales_Jan18
rename	q19221_9_1	Fwsales_Feb18
rename	q19221_10_1	Fwsales_Mar18
rename	q19221_11_1	Fwsales_Apr18
rename	q19221_12_1	Fwsales_May18
rename	q19221_13_1	Fwsales_June18
rename	q19221_14_1	Fwsales_July18
rename	q19222_1_1	Fwbundlescol_June17
rename	q19222_2_1	Fwbundlescol_July17
rename	q19222_3_1	Fwbundlescol_Aug17
rename	q19222_4_1	Fwbundlescol_Sept17
rename	q19222_5_1	Fwbundlescol_Oct17
rename	q19222_6_1	Fwbundlescol_Nov17
rename	q19222_7_1	Fwbundlescol_Dec17
rename	q19222_8_1	Fwbundlescol_Jan18
rename	q19222_9_1	Fwbundlescol_Feb18
rename	q19222_10_1	Fwbundlescol_Mar18
rename	q19222_11_1	Fwbundlescol_Apr18
rename	q19222_12_1	Fwbundlescol_May18
rename	q19222_13_1	Fwbundlescol_June18
rename	q19222_14_1	Fwbundlescol_July18
rename	q19223_1_1	Fwbundlessale_June17
rename	q19223_2_1	Fwbundlessale_July17
rename	q19223_3_1	Fwbundlessale_Aug17
rename	q19223_4_1	Fwbundlessale_Sept17
rename	q19223_5_1	Fwbundlessale_Oct17
rename	q19223_6_1	Fwbundlessale_Nov17
rename	q19223_7_1	Fwbundlessale_Dec17
rename	q19223_8_1	Fwbundlessale_Jan18
rename	q19223_9_1	Fwbundlessale_Feb18
rename	q19223_10_1	Fwbundlessale_Mar18
rename	q19223_11_1	Fwbundlessale_Apr18
rename	q19223_12_1	Fwbundlessale_May18
rename	q19223_13_1	Fwbundlessale_June18
rename	q19223_14_1	Fwbundlessale_July18

label var 	Fwsales_June17	"Money made from firewood sales duringJune17"
label var 	Fwsales_July17	"Money made from firewood sales during July17"
label var 	Fwsales_Aug17	"Money made from firewood sales during Aug17"
label var 	Fwsales_Sept17	"Money made from firewood sales during Sept17"
label var 	Fwsales_Oct17	"Money made from firewood sales during Oct17"
label var 	Fwsales_Nov17	"Money made from firewood sales during Nov17"
label var 	Fwsales_Dec17	"Money made from firewood sales during Dec17"
label var 	Fwsales_Jan18	"Money made from firewood sales during Jan18"
label var 	Fwsales_Feb18	"Money made from firewood sales during Feb18"
label var 	Fwsales_Mar18	"Money made from firewood sales during Mar18"
label var 	Fwsales_Apr18	"Money made from firewood sales during Apr18"
label var 	Fwsales_May18	"Money made from firewood sales during May18"
label var 	Fwsales_June18	"Money made from firewood sales during June18"
label var 	Fwsales_July18	"Money made from firewood sales during July18"
label var 	Fwbundlescol_June17	"Number of bundles of firewood collected for sale during June17"
label var 	Fwbundlescol_July17	"Number of bundles of firewood collected for sale during  July17"
label var 	Fwbundlescol_Aug17	"Number of bundles of firewood collected for sale during  Aug17"
label var 	Fwbundlescol_Sept17	"Number of bundles of firewood collected for sale during  Sept17"
label var 	Fwbundlescol_Oct17	"Number of bundles of firewood collected for sale during  Oct17"
label var 	Fwbundlescol_Nov17	"Number of bundles of firewood collected for sale during  Nov17"
label var 	Fwbundlescol_Dec17	"Number of bundles of firewood collected for sale during  Dec17"
label var 	Fwbundlescol_Jan18	"Number of bundles of firewood collected for sale during  Jan18"
label var 	Fwbundlescol_Feb18	"Number of bundles of firewood collected for sale during  Feb18"
label var 	Fwbundlescol_Mar18	"Number of bundles of firewood collected for sale during  Mar18"
label var 	Fwbundlescol_Apr18	"Number of bundles of firewood collected for sale during  Apr18"
label var 	Fwbundlescol_May18	"Number of bundles of firewood collected for sale during  May18"
label var 	Fwbundlescol_June18	"Number of bundles of firewood collected for sale during  June18"
label var 	Fwbundlescol_July18	"Number of bundles of firewood collected for sale during  July18"
label var 	Fwbundlessale_June17	"Number of bundles of firewood sold during June17"
label var 	Fwbundlessale_July17	"Number of bundles of firewood sold during  July17"
label var 	Fwbundlessale_Aug17	"Number of bundles of firewood sold during  Aug17"
label var 	Fwbundlessale_Sept17	"Number of bundles of firewood sold during  Sept17"
label var 	Fwbundlessale_Oct17	"Number of bundles of firewood sold during  Oct17"
label var 	Fwbundlessale_Nov17	"Number of bundles of firewood sold during  Nov17"
label var 	Fwbundlessale_Dec17	"Number of bundles of firewood sold during  Dec17"
label var 	Fwbundlessale_Jan18	"Number of bundles of firewood sold during  Jan18"
label var 	Fwbundlessale_Feb18	"Number of bundles of firewood sold during  Feb18"
label var 	Fwbundlessale_Mar18	"Number of bundles of firewood sold during  Mar18"
label var 	Fwbundlessale_Apr18	"Number of bundles of firewood sold during  Apr18"
label var 	Fwbundlessale_May18	"Number of bundles of firewood sold during  May18"
label var 	Fwbundlessale_June18	"Number of bundles of firewood sold during  June18"
label var 	Fwbundlessale_July18	"Number of bundles of firewood sold during  July18"


*19.23
 rename q1923 firewood_rev
 label var firewood_rev "Total revene from firewood sales"
 
*19.24
rename q1924_1 fire_transport_cost
label var fire_transport_cost " transport costs incured to the firewood business in the past 12 months "
rename q1924_2 fire_hired_labor_cost
label var fire_hired_labor_cost " hired labor incured to the firewood business in the past 12 months "
rename q1924_3 fire_other_costs
label var fire_other_costs " other costs incured to the firewood business in the past 12 months "

*19.25 
rename q19251_1 FW_store
label var FW_store "Did you store any product for sale from Jun17-July18" 
yesno FW_store

rename q19252_1_1 FW_no_store
label var FW_no_store "How many days did you store firewood between time of production and sale" 

*19.26
rename q1926_1 fr_buy_ag_inputs
label var fr_buy_ag_inputs "HH spends money from firewood sells to buy agricultural inputs"
rename q1926_2 fr_school_fees
label var fr_school_fees "HH spends money from firewood sells to pay school fees"
rename q1926_3 fr_as_capital
label var fr_as_capital "HH spends money from firewood sells as captial to finance other businesses"
rename q1926_4 fr_household_needs
label var fr_household_needs "HH spends money from firewood sells to buy bhousehold needs"

*19.27
rename q1927_2 dist_cuttrees
label var dist_cuttrees "Distance from your homestead to where you cut the trees"
rename q1927_5 dist_sellfire
label var dist_sellfire "Distance from your homestead to where you sell firewood"

*19.28
rename 	q19281_1_1	M_FW5_cutdown
rename 	q19281_1_2	F_FW5_cutdown
rename 	q19281_2_1	M_FW5_logs
rename 	q19281_2_2	F_FW5_logs
rename 	q19281_3_1	M_FW5_trans
rename 	q19281_3_2	F_FW5_trans
rename 	q19281_4_1	M_FW5_sales
rename 	q19281_4_2	F_FW5_sales
rename 	q19281_5_1	M_FW5_all
rename 	q19281_5_2	F_FW5_all
rename 	q19282_1_1	FW_cutdown
rename 	q19282_2_1	FW_logs
rename 	q19282_3_1	FW_trans
rename 	q19282_4_1	FW_sales
rename 	q19282_5_1	FW_all
rename 	q19283_1_1	M_FW9_cutdown
rename 	q19283_1_2	F_FW9_cutdown
rename 	q19283_2_1	M_FW9_logs
rename 	q19283_2_2	F_FW9_logs
rename 	q19283_3_1	M_FW9_trans
rename 	q19283_3_2	F_FW9_trans
rename 	q19283_4_1	M_FW9_sales
rename 	q19283_4_2	F_FW9_sales
rename 	q19283_5_1	M_FW9_all
rename 	q19283_5_2	F_FW9_all
rename 	q19284_1_1	M_FW17_cutdown
rename 	q19284_1_2	F_FW17_cutdown
rename 	q19284_2_1	M_FW17_logs
rename 	q19284_2_2	F_FW17_logs
rename 	q19284_3_1	M_FW17_trans
rename 	q19284_3_2	F_FW17_trans
rename 	q19284_4_1	M_FW17_sales
rename 	q19284_4_2	F_FW17_sales
rename 	q19284_5_1	M_FW17_all
rename 	q19284_5_2	F_FW17_all
rename 	q19285_1_1	M_FW59_cutdown
rename 	q19285_1_2	F_FW59_cutdown
rename 	q19285_2_1	M_FW59_logs
rename 	q19285_2_2	F_FW59_logs
rename 	q19285_3_1	M_FW59_trans
rename 	q19285_3_2	F_FW59_trans
rename 	q19285_4_1	M_FW59_sales
rename 	q19285_4_2	F_FW59_sales
rename 	q19285_5_1	M_FW59_all
rename 	q19285_5_2	F_FW59_all
rename 	q19286_1_1	M_FW60_cutdown
rename 	q19286_1_2	F_FW60_cutdown
rename 	q19286_2_1	M_FW60_logs
rename 	q19286_2_2	F_FW60_logs
rename 	q19286_3_1	M_FW60_trans
rename 	q19286_3_2	F_FW60_trans
rename 	q19286_4_1	M_FW60_sales
rename 	q19286_4_2	F_FW60_sales
rename 	q19286_5_1	M_FW60_all
rename 	q19286_5_2	F_FW60_all

label var	M_FW5_cutdown	"Firewood-number of males under 5 cutting down trees " 
label var	F_FW5_cutdown	"Firewood-number of females under 5 cutting down trees" 
label var	M_FW5_logs	"Firewood-number of males under 5 moving logs " 
label var	F_FW5_logs	"Firewood-number of females under 5  moving logs" 
label var	M_FW5_trans	"Firewood-number of males under 5 transporting firewood" 
label var	F_FW5_trans	"Firewood-number of females under 5 transporting firewood" 
label var	M_FW5_sales	"Firewood-number of males under 5 selling firewood" 
label var	F_FW5_sales	"Firewood-number of females under 5 selling firewood " 
label var	M_FW5_all	"Firewood-number of males under 5 doing all firewood acts" 
label var	F_FW5_all	"Firewood-number of females under 5 doing all firewood acts" 
label var	FW_cutdown	"Firewood: in last 3 months time req to cut down trees" 
label var	FW_logs	"Firewood: in last 3 months time req to move logs" 
label var	FW_trans	"Firewood: in last 3 months time req to transport firewood" 
label var	FW_sales	"Firewood: in last 3 months time req to sell firewood" 
label var	FW_all	"Firewood: in last 3 months time req to do all acts" 
label var	M_FW9_cutdown	"Firewood-number of males age 5-9 cutting down trees " 
label var	F_FW9_cutdown	"Firewood-number of females age 5-9 cutting down trees" 
label var	M_FW9_logs	"Firewood-number of males age 5-9 moving logs " 
label var	F_FW9_logs	"Firewood-number of females age 5-9  moving logs" 
label var	M_FW9_trans	"Firewood-number of males age 5-9 transporting firewood" 
label var	F_FW9_trans	"Firewood-number of females age 5-9 transporting firewood" 
label var	M_FW9_sales	"Firewood-number of males age 5-9 selling firewood" 
label var	F_FW9_sales	"Firewood-number of females age 5-9 selling firewood " 
label var	M_FW9_all	"Firewood-number of males age 5-9 doing all firewood acts" 
label var	F_FW9_all	"Firewood-number of females age 5-9 doing all firewood acts" 
label var	M_FW17_cutdown	"Firewood-number of males age 10-17 cutting down trees " 
label var	F_FW17_cutdown	"Firewood-number of females age 10-17 cutting down trees" 
label var	M_FW17_logs	"Firewood-number of males age 10-17 moving logs " 
label var	F_FW17_logs	"Firewood-number of females age 10-17  moving logs" 
label var	M_FW17_trans	"Firewood-number of males age 10-17 transporting firewood" 
label var	F_FW17_trans	"Firewood-number of females age 10-17 transporting firewood" 
label var	M_FW17_sales	"Firewood-number of males age 10-17 selling firewood" 
label var	F_FW17_sales	"Firewood-number of females age 10-17 selling firewood " 
label var	M_FW17_all	"Firewood-number of males age 10-17 doing all firewood acts" 
label var	F_FW17_all	"Firewood-number of females age 10-17 doing all firewood acts" 
label var	M_FW59_cutdown	"Firewood-number of males age 18-59 cutting down trees " 
label var	F_FW59_cutdown	"Firewood-number of females age 18-59 cutting down trees" 
label var	M_FW59_logs	"Firewood-number of males age 18-59 moving logs " 
label var	F_FW59_logs	"Firewood-number of females age 18-59  moving logs" 
label var	M_FW59_trans	"Firewood-number of males age 18-59 transporting firewood" 
label var	F_FW59_trans	"Firewood-number of females age 18-59 transporting firewood" 
label var	M_FW59_sales	"Firewood-number of males age 18-59 selling firewood" 
label var	F_FW59_sales	"Firewood-number of females age 18-59 selling firewood " 
label var	M_FW59_all	"Firewood-number of males age 18-59 doing all firewood acts" 
label var	F_FW59_all	"Firewood-number of females age 18-59 doing all firewood acts" 
label var	M_FW60_cutdown	"Firewood-number of males age 60+ cutting down trees " 
label var	F_FW60_cutdown	"Firewood-number of females age 60+ cutting down trees" 
label var	M_FW60_logs	"Firewood-number of males age 60+ moving logs " 
label var	F_FW60_logs	"Firewood-number of females age 60+  moving logs" 
label var	M_FW60_trans	"Firewood-number of males age 60+ transporting firewood" 
label var	F_FW60_trans	"Firewood-number of females age 60+ transporting firewood" 
label var	M_FW60_sales	"Firewood-number of males age 60+ selling firewood" 
label var	F_FW60_sales	"Firewood-number of females age 60+ selling firewood " 
label var	M_FW60_all	"Firewood-number of males age 60+ doing all firewood acts" 
label var	F_FW60_all	"Firewood-number of females age 60+ doing all firewood acts" 

*19.29 
rename q19291_1 land_firewood
label var land_firewood "Who's land do you collect firewood materials from" 
label define land_firewood 1 "Personal land" 2 "Customary land" 3 "State land" 4 "Private land"

rename q19292_1 no_firewood
label var no_firewood "Are there nearby areas where you cannot collect firewood" 
yesno no_firewood
 
*19.30
rename q1930 fire_policy
label var fire_policy "Are you aware of the policies governing collecting firewood?"
yesno fire_policy 
recode fire_policy 3=0 
yesno fire_policy 

*19.31
rename q1931 charc_resell
label var charc_resell "Did you buy charcoal for resale?"
yesno charc_resell

*19.32
rename q1932 dist_resale
label var dist_resale "How far is the location where you purchase charcoal for resale?"


*19.33
rename q1933_4 rchar_homestead
lab var rchar_homestead "HH resales charcoal at the homestead"
rename q1933_5 rchar_within_village
lab var rchar_within_village "HH resales charcoal at the within the village market"
rename q1933_6 rchar_along_mainroad
lab var rchar_along_mainroad "HH resales charcoal at the main road with the village"
rename q1933_7 rchar_tarmac_road
lab var rchar_tarmac_road "HH resales charcoal at along the tarmac"
rename q1933_8 rchar_main_distr
lab var rchar_main_distr "HH resales charcoal along the district town"

*19.34
 rename q19341_1_1 qchar_june_17
lab var qchar_june_17 "quantity of charcoal bought for resale june 2017"
rename q19341_2_1 qchar_july_17
lab var qchar_july_17 "quantity of charcoal bought for resale july 2017"
rename q19341_3_1 qchar_aug_17
lab var qchar_aug_17 "quantity of charcoal bought for resale august 2017"
rename q19341_4_1 qchar_sept_17
lab var qchar_sept_17 "quantity of charcoal bought for resale september 2017"
rename q19341_5_1 qchar_oct_17
lab var qchar_oct_17 "quantity of charcoal bought for resale october 2017"
rename q19341_6_1 qchar_nov_17
lab var qchar_nov_17 "quantity of charcoal bought for resale november 2017"
rename q19341_7_1 qchar_dec_17
lab var qchar_dec_17 "quantity of charcoal bought for resale december 2017"
rename q19341_8_1 qchar_jan_18
lab var qchar_jan_18 "quantity of charcoal bought for resale january 2018"
rename q19341_9_1 qchar_feb_18
lab var qchar_feb_18 "quantity of charcoal bought for resale february 2018"
rename q19341_10_1 qchar_mar_18
lab var qchar_mar_18 "quantity of charcoal bought for resale march 2018"
rename q19341_11_1 qchar_april_18
lab var qchar_april_18 "quantity of charcoal bought for resale april 2018"
rename q19341_12_1 qchar_may_18
lab var qchar_may_18 "quantity of charcoal bought for resale may 2018"
rename q19341_13_1 qchar_june_18
lab var qchar_june_18 "quantity of charcoal bought for resale august 2018"
rename q19341_14_1 qchar_july_18
lab var qchar_july_18 "quantity of charcoal bought for resale august 2018"

rename q19342_1_1 cst_cha_june_17
lab var cst_cha_june_17 "cost of charcoal bought for resale june 2017"
rename q19342_2_1 cst_cha_july_17
lab var cst_cha_july_17 "cost of charcoal bought for resale july 2017"
rename q19342_3_1 cst_cha_aug_17
lab var cst_cha_aug_17 "cost of charcoal bought for resale august 2017"
rename q19342_4_1 cst_cha_sept_17
lab var cst_cha_sept_17 "cost of charcoal bought for resale september 2017"
rename q19342_5_1 cst_cha_oct_17
lab var cst_cha_oct_17 "cost of charcoal bought for resale october 2017"
rename q19342_6_1 cst_cha_nov_17
lab var cst_cha_nov_17 "cost of charcoal bought for resale november 2017"
rename q19342_7_1 cst_cha_dec_17
lab var cst_cha_dec_17 "cost of charcoal bought for resale december 2017"
rename q19342_8_1 cst_cha_jan_18
lab var cst_cha_jan_18 "cost of charcoal bought for resale january 2018"
rename q19342_9_1 cst_cha_feb_18
lab var cst_cha_feb_18 "cost of charcoal bought for resale february 2018"
rename q19342_10_1 cst_cha_marc_18
lab var cst_cha_marc_18 "cost of charcoal bought for resale march 2018"
rename q19342_11_1 cst_cha_april_18
lab var cst_cha_april_18 "cost of charcoal bought for resale april 2018"
rename q19342_12_1 cst_cha_may_18
lab var cst_cha_may_18 "cost of charcoal bought for resale may 2018"
rename q19342_13_1 cst_cha_june_18
lab var cst_cha_june_18 "cost of charcoal bought for resale june 2018"
rename q19342_14_1 cst_cha_july_18
lab var cst_cha_july_18 "cost of charcoal bought for resale july 2018"

rename q19343_1_1 rev_cha_june_17
lab var rev_cha_june_17 "revenue charcoal bought for resale june 2017"
rename q19343_2_1 rev_cha_july_17
lab var rev_cha_july_17 "revenue charcoal bought for resale july 2017"
rename q19343_3_1 rev_cha_aug_17
lab var rev_cha_aug_17 "revenue charcoal bought for resale august 2017"
rename q19343_4_1 rev_cha_sept_17
lab var rev_cha_sept_17 "revenue charcoal bought for resale september 2017"
rename q19343_5_1 rev_cha_oct_17
lab var rev_cha_oct_17 "revenue charcoal bought for resale october 2017"
rename q19343_6_1 rev_cha_nov_17
lab var rev_cha_nov_17 "revenue charcoal bought for resale november 2017"
rename q19343_7_1 rev_cha_dec_17
lab var rev_cha_dec_17 "revenue charcoal bought for resale december 2017"
rename q19343_8_1 rev_cha_jan_18
lab var rev_cha_jan_18 "revenue charcoal bought for resale january 2018"
rename q19343_9_1 rev_cha_feb_18
lab var rev_cha_feb_18 "revenue charcoal bought for resale february 2018"
rename q19343_10_1 rev_cha_marc_18
lab var rev_cha_marc_18 "revenue charcoal bought for resale march 2018"
rename q19343_11_1 rev_cha_april_18
lab var rev_cha_april_18 "revenue charcoal bought for resale april 2018"
rename q19343_12_1 rev_cha_may_18
lab var rev_cha_may_18 "revenue charcoal bought for resale may 2018"
rename q19343_13_1 rev_cha_june_18
lab var rev_cha_june_18 "revenue charcoal bought for resale june 2018"
rename q19343_14_1 rev_cha_july_18
lab var rev_cha_july_18 "revenue charcoal bought for resale july 2018"


*19.35
rename q1935_1 rchar_transport_cost
label var rchar_transport_cost " transport cost associated to the resell of charcoal"
rename q1935_2 rchar_hired_labor_cost
label var rchar_hired_labor_cost " hired labor cost associated to the resell of charcoal"
rename q1935_3 rchar_other_costs
label var rchar_other_costs " other cost associated to the resell of charcoal"


*19.36
rename q1936 resale_firewood
label var resale_firewood "Do you resell of firewood?"
yesno resale_firewood

*19.37
rename q1937 dist_fire_resal
label var dist_fire_resal "Distance from point of purchase to point of resale"

*19.38
rename q1938_4 fire_homestead
label var fire_homestead "HH resale firewood at homestead"
rename q1938_5 fire_within_village
label var fire_within_village "HH resale firewood within the village"
rename q1938_6 fire_along_mainroad
label var fire_along_mainroad "HH resale firewood along the village road"
rename q1938_7 fire_tarmac_road
label var fire_tarmac_road "HH resale firewood along the tarmac road"
rename q1938_8 fire_main_distr
label var  fire_main_distr "HH resale firewood along at the main district"

*19.39 
rename 	q19391_1_1	FW_PresaleJun17
rename 	q19391_2_1	FW_PresaleJul17
rename 	q19391_3_1	FW_PresaleAug17
rename 	q19391_4_1	FW_PresaleSept17
rename 	q19391_5_1	FW_PresaleOct17
rename 	q19391_6_1	FW_PresaleNov17
rename 	q19391_7_1	FW_PresaleDec17
rename 	q19391_8_1	FW_PresaleJan18
rename 	q19391_9_1	FW_PresaleFeb18
rename 	q19391_10_1	FW_PresaleMar18
rename 	q19391_11_1	FW_PresaleApr18
rename 	q19391_12_1	FW_PresaleMay18
rename 	q19391_13_1	FW_PresaleJun18
rename 	q19391_14_1	FW_PresaleJul18
rename 	q19392_1_1	FW_payresaleJun17
rename 	q19392_2_1	FW_payresaleJul17
rename 	q19392_3_1	FW_payresaleAug17
rename 	q19392_4_1	FW_payresaleSept17
rename 	q19392_5_1	FW_payresaleOct17
rename 	q19392_6_1	FW_payresaleNov17
rename 	q19392_7_1	FW_payresaleDec17
rename 	q19392_8_1	FW_payresaleJan18
rename 	q19392_9_1	FW_payresaleFeb18
rename 	q19392_10_1	FW_payresaleMar18
rename 	q19392_11_1	FW_payresaleApr18
rename 	q19392_12_1	FW_payresaleMay18
rename 	q19392_13_1	FW_payresaleJun18
rename 	q19392_14_1	FW_payresaleJul18
rename 	q19393_1_1	FW_RresaleJun17
rename 	q19393_2_1	FW_RresaleJul17
rename 	q19393_3_1	FW_RresaleAug17
rename 	q19393_4_1	FW_RresaleSept17
rename 	q19393_5_1	FW_RresaleOct17
rename 	q19393_6_1	FW_RresaleNov17
rename 	q19393_7_1	FW_RresaleDec17
rename 	q19393_8_1	FW_RresaleJan18
rename 	q19393_9_1	FW_RresaleFeb18
rename 	q19393_10_1	FW_RresaleMar18
rename 	q19393_11_1	FW_RresaleApr18
rename 	q19393_12_1	FW_RresaleMay18
rename 	q19393_13_1	FW_RresaleJun18
rename 	q19393_14_1	FW_RresaleJul18

label var	FW_PresaleJun17	"How much firewood did you purchase for resale in Jun17"
label var	FW_PresaleJul17	"How much firewood did you purchase for resale in Jul17"
label var	FW_PresaleAug17	"How much firewood did you purchase for resale in Aug17"
label var	FW_PresaleSept17	"How much firewood did you purchase for resale in Sept17"
label var	FW_PresaleOct17	"How much firewood did you purchase for resale in Oct17"
label var	FW_PresaleNov17	"How much firewood did you purchase for resale in Nov17"
label var	FW_PresaleDec17	"How much firewood did you purchase for resale in Dec17"
label var	FW_PresaleJan18	"How much firewood did you purchase for resale in Jan18"
label var	FW_PresaleFeb18	"How much firewood did you purchase for resale in Feb18"
label var	FW_PresaleMar18	"How much firewood did you purchase for resale in Mar18"
label var	FW_PresaleApr18	"How much firewood did you purchase for resale in Apr18"
label var	FW_PresaleMay18	"How much firewood did you purchase for resale in May18"
label var	FW_PresaleJun18	"How much firewood did you purchase for resale in Jun18"
label var	FW_PresaleJul18	"How much firewood did you purchase for resale in Jul18"
label var	FW_payresaleJun17	"How much did you pay for the firewood for resale in Jun17"
label var	FW_payresaleJul17	"How much did you pay for the firewood for resale in Jul17"
label var	FW_payresaleAug17	"How much did you pay for the firewood for resale in Aug17"
label var	FW_payresaleSept17	"How much did you pay for the firewood for resale in Sept17"
label var	FW_payresaleOct17	"How much did you pay for the firewood for resale in Oct17"
label var	FW_payresaleNov17	"How much did you pay for the firewood for resale in Nov17"
label var	FW_payresaleDec17	"How much did you pay for the firewood for resale in Dec17"
label var	FW_payresaleJan18	"How much did you pay for the firewood for resale in Jan18"
label var	FW_payresaleFeb18	"How much did you pay for the firewood for resale in Feb18"
label var	FW_payresaleMar18	"How much did you pay for the firewood for resale in Mar18"
label var	FW_payresaleApr18	"How much did you pay for the firewood for resale in Apr18"
label var	FW_payresaleMay18	"How much did you pay for the firewood for resale in May18"
label var	FW_payresaleJun18	"How much did you pay for the firewood for resale in Jun18"
label var	FW_payresaleJul18	"How much did you pay for the firewood for resale in Jul18"
label var	FW_RresaleJun17	"How much money did you make from firewood resale in Jun17"
label var	FW_RresaleJul17	"How much money did you make from firewood resale in Jul17"
label var	FW_RresaleAug17	"How much money did you make from firewood resale in Aug17"
label var	FW_RresaleSept17	"How much money did you make from firewood resale in Sept17"
label var	FW_RresaleOct17	"How much money did you make from firewood resale in Oct17"
label var	FW_RresaleNov17	"How much money did you make from firewood resale in Nov17"
label var	FW_RresaleDec17	"How much money did you make from firewood resale in Dec17"
label var	FW_RresaleJan18	"How much money did you make from firewood resale in Jan18"
label var	FW_RresaleFeb18	"How much money did you make from firewood resale in Feb18"
label var	FW_RresaleMar18	"How much money did you make from firewood resale in Mar18"
label var	FW_RresaleApr18	"How much money did you make from firewood resale in Apr18"
label var	FW_RresaleMay18	"How much money did you make from firewood resale in May18"
label var	FW_RresaleJun18	"How much money did you make from firewood resale in Jun18"
label var	FW_RresaleJul18	"How much money did you make from firewood resale in Jul18"

*19.40
rename q1940_1 FW_RS_trans
label var FW_RS_trans "Cash costs incurred for transportation of firewood resale" 
rename q1940_2 FW_RS_labor
label var FW_RS_labor "Cash costs incurred for labor of firewood resale" 
rename q1940_3 FW_RS_other 
label var FW_RS_other "Cash costs incurred for other misc. of firewood resale" 

*********************************************************************
/* Section 20: Administrative */
*********************************************************************
rename q201 Province
label var Province "20.1 Province"
label value Province province 

rename q202_13 camp
label var camp "20.2_13 Camp Name"

rename q202_8 village
label var village "20.2_8 Village Name"

rename q204 sms_partic
label var sms_partic "20.4 Did you particpate in the SMS program?"
recode sms_partic 5=1
recode sms_partic 6=0
yesno sms_partic

rename q206 sms_name 
rename q207 sms_num
label var sms_name "trained individual's name"
label var sms_num "individual's phone number"
label var enumerator "comments on survey"


save "2018 HICPS Follow-up", replace  





