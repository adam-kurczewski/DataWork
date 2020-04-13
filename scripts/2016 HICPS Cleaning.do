********************************************************************************
*****************   Cleaning code for HICCPS 2016 Data *************************
********************************************************************************
//Started on September 13, 2016
********************************************************************************
//Always maintain the same filepath




capture log close
clear
set more off
drop _all

cd "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2016 HICPS" 

insheet using "C:\Users\gv4\Box Sync\Zambia HICPS\HICPS Cleaning 07_12_19\2016 HICPS\2016 HICPS Baseline Raw Data.csv", names 


//***************************************************//
//	       Cleaning codes added by Yujun	     //
//***************************************************//
*******************************************************************************
//labeling with qualtrics headers
foreach var of varlist * {
  label variable `var' "`=`var'[1]'"
  replace `var'="" if _n==1
  destring `var', replace
}

********************************************************************************
** a variable not labelled correctly because it contains "" 
label variable qid382_text "1.5 - Mobile phone number contact of respondent (omit the leading , entry shou.."
drop if status == .

*programs to help clean 
label define yesnoL 1 "Yes" 0 "No" 

capture program drop yesno 
program define yesno 
	replace `1'=0 if `1'==2
	label values `1' yesnoL
end 





*Merge with HHID
*gen row_number = _n
*joinby row_number using hhid_new.dta, _merge(merge16) unmatched(both)

******************************************
* Any responses with a start/end date before 6/13 are not legitimate data.
******************************************
**************25 Invalid observation dropped ****************
split enddate,parse(" ")
gen survey_date = date(enddate1,"MD20Y")
*gen DVadmission1 = date(startdate, "DM20Y")
format survey_date %td
order survey_date,after(enddate)
drop if survey_date < date("13jun2016","DM20Y")


**************same result if using startdate(omitted) ****************
/*  split startdate,parse(" ")
order startdate1,after(startdate)
split startdate1,parse(?)
order startdate12,after(startdate1)
gen survey_date = date(startdate12,"20YMD")
*gen DVadmission1 = date(startdate, "DM20Y")
format survey_date %td
drop if survey_date < date("13jun2016","DM20Y")
*/


***************************************************
** rename and combine variables 
**********************************************
rename qid662_text latitude
rename qid663_text longitude
rename qid381_text name
rename qid614_text name2
rename qid615 phone
rename qid382_text phone_number
rename qid802_text sms_name

***************************************************
// combine district by province into one district variable 
***************************************************
rename qid267 province
* generate new district variable and put it next to province
gen district= .
label variable district "1.7- District"
order district, after(province) 

replace district = 100 + qid808 if province ==1  /* districts in "Central"*/

replace district = 200 + qid809 if province ==2 //"Copperbelt"//

replace district = 300 + qid810 if province ==3 //"Eastern"//

replace district = 400 + qid811 if province ==4 //"Northern"//

replace district = 500 + qid812 if province ==5 //"Northwestern"//

replace district = 600 + qid813 if province ==6 //"Southern"//


// label province values 
label define province 1 "Central" 2 "Copperbelt" 3 "Eastern" 4 "Northern" 5 "Northwestern" 6 "Southern" 
label values province province 

// label district values (all combinations)
label define district 101 "Mkushi " /*
*/102 "Mumbwa"/* 
*/201 "Mpongwe"/* 
*/202 "Masaiti"/* 
*/301 "Lundazi"/* 
*/302 "Petauke"/* 
*/401 "Mbala"/* 
*/402 "Mungwi"/* 
*/501 "Mufumbwe"/* 
*/502 "Solwezi"/* 
*/601 "Choma"/* 
*/602 "Namwala"

label values district district 

order qid808-qid813,last

rename qid49_13 camp
rename qid49_8 village

rename qid579 enumerator_16
// label enumerator values 
label define enumerator 1 "Agness" 2 "Enoch" 3 "Dominic" 4 "Protensia" 5 "Nelly" 6 "Allan" 7 "Noah" 8 "Elijah"   9 "Christabell"  10 "Nashon"  11 "Nana"  12 "Mwangdala"  
label values enumerator enumerator 

rename qid379 language
// label language values 
label define language 1 "Bemba" 2 "Nyanja" 3 "Tonga" 4 "Kaonde" 5 "Tumbuka" 6 "Lozi" 7 "Mambwe" 8 "English" 9 "Ila" 10 "Lunda"  11 "Luvale" 12 "Other"
label values language language 

drop qid808 qid809 qid810 qid811 qid812 qid813
drop qid617_7_1_888d044a082f46fba83b2

***************************************************
//1.13 minutes to the nearest tarmac road /public transport, etc. 
***************************************************
rename qid413_1 tarmacroad /* extreme values of 9999 and 99999 in tarmacroad */
rename qid413_7 pubtransport
destring pubtransport,force replace

rename qid413_2 villagemkt
rename qid413_4 waterloc
rename qid413_5 firewoodloc
rename qid413_6 maizefield

//Q330 
rename qid861 ZESCO
replace ZESCO=0 if ZESCO==4 
label values ZESCO yesno 

***************************************************
//Q332 how many structures of the following types are part of household's compund?  
***************************************************
rename qid863_1 sleeping
rename qid863_2 cooking
rename qid863_4 crop_storage
rename qid863_5 toilet
rename qid863_6 sitting_area
rename qid863_7 struc_other


***************************************************
//Section 2: HH members questions 
***************************************************
rename qid570_text hh_num

//2.1 Name the variables with "var"_`i', with var being the column(sex,year of birth) and `i' the ith row (ith person respond to this survey)
foreach i of numlist 1/17{
rename qid617_`i'_1 relate_`i'
rename qid617_`i'_2 sex_`i'
rename qid617_`i'_3 birth_`i'
rename qid617_`i'_4 edu_`i'
rename qid617_`i'_5 here_`i'

}
***************************************************
// relationship to household head 
***************************************************
// check and replace non-numeric values
 *describe relate_*

foreach  i of numlist 1/17{
tab relate_`i'
}

//replace the text in the responses with numbers (13-17 already in numbers)
foreach  i of numlist 1/12{
replace relate_`i'="1" if relate_`i'=="Head"
replace relate_`i'="1" if relate_`i'=="Respondent"
replace relate_`i'="1" if relate_`i'=="Self"

replace relate_`i'="2" if relate_`i'=="Wife"
replace relate_`i'="2" if relate_`i'=="Spouse"
replace relate_`i'="2" if relate_`i'=="Spouses"
replace relate_`i'="2" if relate_`i'=="Spouse 1"
replace relate_`i'="2" if relate_`i'=="Spouse 2"

replace relate_`i'="3" if relate_`i'=="Daughter"
replace relate_`i'="3" if relate_`i'=="Son"
replace relate_`i'="3" if relate_`i'=="Daugter"

replace relate_`i'="4" if relate_`i'=="Step-son"
replace relate_`i'="4" if relate_`i'=="step-daughter"
replace relate_`i'="4" if relate_`i'=="Step-daughter"

replace relate_`i'="6" if relate_`i'=="Grand daughter"
replace relate_`i'="6" if relate_`i'=="Granddaughter"
replace relate_`i'="6" if relate_`i'=="Grandson"
replace relate_`i'="6" if relate_`i'=="Grand son"

replace relate_`i'="8" if relate_`i'=="O8"
replace relate_`i'="8" if relate_`i'=="Sister"
replace relate_`i'="8" if relate_`i'=="Brother"
replace relate_`i'="13" if relate_`i'=="Brother-inlaw"

replace relate_`i'="7" if relate_`i'=="Mother"

replace relate_`i'="1" if relate_`i'=="Niece"
replace relate_`i'="1" if relate_`i'=="Nephew"
replace relate_`i'="12" if relate_`i'=="Daughter-inlaw"
replace relate_`i'="12" if relate_`i'=="Daughter in law"
replace relate_`i'="6" if relate_`i'=="Step-granddaughter"

destring relate_`i', force replace
}

// label relationship to hh head

capture lab drop relate

label define relate  1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter" /*
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

foreach  i of numlist 1/17{
label values relate_`i' relate
}


***************************************************
// Year of birth for hh members: fix a few glitches
***************************************************
/* foreach  i of numlist 1/17{
tab birth_`i'
} */
replace birth_1=1991 if birth_1==19991
replace birth_3=1984 if birth_3==19884
replace birth_3=2000 if birth_3==200
replace birth_6=2000 if birth_6==200
replace birth_7=2015 if birth_7==2915
replace birth_8=2014 if birth_8==20014

* Start of correction codes Added by Armand
replace birth_1=1939 if birth_1==1839
replace birth_2=1985 if birth_2==1885
** End of correction codes added by Armand

* generate age for HH members 
foreach i of numlist 1/17{
gen age_`i' = 2015 - birth_`i'
order age_`i', after(birth_`i')
label var age_`i' "Age of household member"
}
// Note: Armand changed year 2016 to 2015, because we are using these ages for the 2015 growing season

 
***************************************************
// sex of hh members
***************************************************
label define sex  1 "Male" 0 "Female"

/* foreach  i of numlist 1/17{
tab sex_`i'
}
*/
 
foreach  i of numlist 1/17{
//replace the text in the responses with numbers 
replace sex_`i'="1" if sex_`i'=="M"
replace sex_`i'="1" if sex_`i'=="Male"
replace sex_`i'="0" if sex_`i'=="Female"
replace sex_`i'="0" if sex_`i'=="F"

destring sex_`i', force replace
}


foreach  i of numlist 1/17{
label values sex_`i'  sex 
}

***************************************************
// education of hh members
***************************************************
/*
foreach  i of numlist 1/17{
tab edu_`i'
}
*/
destring edu_1, force replace

***********edu has values of 10 11 12, don't know what that means in the questionaire*********
label define edu 1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown" 



foreach  i of numlist 1/17{
label values edu_`i'  edu
}

***************************************************
//Lived here since birth?
***************************************************

foreach  i of numlist 1/17{
*tab here_`i'
}


// replace yes or no with numeric values , one observation answered "U"
foreach  i of numlist 1/17{
replace here_`i'="1" if here_`i'=="Yes"
replace here_`i'="0" if here_`i'=="No"
replace here_`i'="1" if here_`i'=="YES"
replace here_`i'="0" if here_`i'=="NO"
replace here_`i'="1" if here_`i'=="Y"
replace here_`i'="0" if here_`i'=="N"
replace here_`i'="1" if here_`i'=="YEy"
replace here_`i'="1" if here_`i'=="Ye"
replace here_`i'="1" if here_`i'=="Y s"
replace here_`i'="1" if here_`i'=="yes"
replace here_`i'="1" if here_`i'=="YEs"
replace here_`i'="1" if here_`i'=="y"
replace here_`i'="0" if here_`i'=="Np"

 destring here_`i', force replace
}

foreach  i of numlist 1/17{
label values here_`i' yesno
}
//


***********************************find the household head ***********

* the household head is the ith person that answers question 2.1
foreach  i of numlist 1/17{
 egen hh_head_`i'= anymatch(relate_`i'), values(1)
}

* get the information for the household head only
gen hh_head =1 if hh_head_1 ==1
gen hh_head_age= age_1 if hh_head_1 ==1
gen hh_head_birth= birth_1 if hh_head_1 ==1
gen hh_head_sex= sex_1 if hh_head_1 ==1
gen hh_head_edu= edu_1 if hh_head_1 ==1
gen hh_head_here= here_1 if hh_head_1 ==1

foreach  i of numlist 1/17{
replace hh_head = relate_`i' if hh_head_`i' ==1 
replace hh_head_age = age_`i' if hh_head_`i' ==1 
replace hh_head_birth = birth_`i' if hh_head_`i' ==1 
replace hh_head_sex = sex_`i' if hh_head_`i' ==1 
replace hh_head_edu = edu_`i' if hh_head_`i' ==1 
replace hh_head_here = here_`i' if hh_head_`i' ==1 
}

*tab hh_head
* out of 1174 households, 29 of them don't have HH head
/*
foreach i of  numlist 1/17{
tab relate_`i' if hh_head!=1
}
*/

***************labelling *******************
label variable hh_head "Does this household have a household head?"
label variable hh_head_age  "Age of household head"
label variable hh_head_birth  "Birth Year of household head"
label variable hh_head_sex  "Sex of household head"
label variable hh_head_edu "Education attainment of household head"
label variable hh_head_here "Does the household head lived here since birth ?"




label define hh_head_edu  1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown" 

label values hh_head_edu hh_head_edu 
label values hh_head_sex sex
label values hh_head_here yesno

* drop the temporary variable
drop hh_head_1-hh_head_17

foreach var of varlist hh_head*{
order `var',before(relate_1)
}
//




***************************************************
* Section 3: Labor migration questions: start from 3.1 of the surveys
***************************************************

//3.1 is a migrant supporting the HH ? 
rename qid643 mig1_exist
replace mig1_exist=0 if mig1_exist==4 
label values mig1_exist yesno

***************************************************
// 3.1.1 to 3.1.13 migrant related questions for the first migrant,start with mig1_
***************************************************

//3.1.1 relationship to household head 
rename qid603 mig1_relate
// no gliches in the answers, start labelling relationship to hh head
label define mig1_relate  1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter" /*
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

label values mig1_relate mig1_relate 

//3.1.2 Sex
rename qid604 mig1_sex
*tab mig1_Sex
*change the value of Female to be 0 instead of 2
replace mig1_sex = 0 if mig1_sex ==2
label values mig1_sex sex

//3.1.3 Year of birth
rename qid605_text mig1_birth
*tab mig1_birth
*an observation is 19 and another one is 40, don't know what that means

//3.1.4 Education attainment
rename qid606 mig1_edu
*tab mig1_edu
label define mig1_edu 1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown" 
label values mig1_edu mig1_edu

//3.1.5 Occupation in household before moving away
rename qid608 mig1_occ
*tab mig1_occ
label define mig1_occ 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other" /*   "other" specified in text data in variable "mig1_occ_other" */
label values mig1_occ mig1_occ


//3.1.5 (continue) Occupation in household before moving away (other)
rename qid608_9_text mig1_occ_other 
*tab mig1_occ_other

//3.1.6 Which of the following conditions factored into the labor migrants' decision to leave this household?
rename qid405 mig1_reason

//3.1.7 Occupation while living elsewhere and supporting this family financially
rename qid609 mig1_occ_away
*tab mig1_occ_away
label define mig1_occ_away 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other" /*   "other" specified in text data in variable "mig1_occ_away_other" */
label values mig1_occ_away mig1_occ_away

//3.1.7 (continue) Occupation while living elsewhere and supporting this family financially (other)
rename qid609_9_text mig1_occ_away_other 
*tab mig1_occ_away_other

// 3.1.8 Year in which individual first began to support this household while living elsewhere:
rename qid610_text mig1_year
*tab mig1_year

// 3.1.9 How many weeks did the individual spend away from the household in the last 12 months? 
rename qid666_text mig1_weeks_away
*tab mig1_weeks_away

//3.1.10 Approximately how much money did this individual give to the household in the last 12 months? (in kwacha)
rename qid611_text mig1_money
*tab mig1_money

// 3.1.11 What is the approximate value (in kwacha) of the non-cash remittances you received from this individual in the last 12 months?
rename qid803_text mig1_noncash
*tab mig1_noncash

//3.1.12 Has the individual left the household permanently or temporarily?
rename qid612 mig1_permanent
*tab mig1_permanet
label define mig1_permanent 1 "Permanently" 2 " Temporarily " 3 " I don't know "
label values mig1_permanent mig1_permanent


//3.1.13 Was this person listed in the demographic list in Section 2?
rename qid664 mig1_listed
*tab mig1_listed
replace mig1_listed=0 if mig1_listed==2
label values mig1_listed yesno

***************************************************
// 3.2.0 to 3.2.12 migrant related questions for the first migrant,start with mig2_
***************************************************
//3.2.0 Is there a SECOND individual labour migrant currently supporting the household who is currently living somewhere else?
rename qid644 mig2_exist
replace mig2_exist=0 if mig2_exist==4
label values mig2_exist yesno
//3.2.1 Relationship to Household Head
rename qid619 mig2_relate
*tab mig2_relate
 // no gliches in the answers, start labelling relationship to hh head
label define mig2_relate  1 "Head" 2 "Spouse" 3 "Son/daughter" 4 "Stepson/Stepdaughter" /*
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
label values mig2_relate mig2_relate 

//3.2.2 Sex
rename qid620  mig2_sex
*tab mig2_sex
*change the value of Female to be 0 instead of 2
replace mig2_sex = 0 if mig2_sex ==2
label values mig2_sex sex


//3.2.3 Year of birth
rename qid645_text mig2_birth
*tab mig2_birth


//3.2.4 Education attainment
rename qid647 mig2_edu
*tab mig1_edu
label define mig2_edu 1 "None" /*
*/2 "Some Primary"/*
*/3 "Completed Primary"/*
*/4 "Some Secondary"/*
*/5 "Completed Secondary" /*
*/6 "Some Post-Secondary"/*
*/7 "Completed Post-Secondary"/*
*/8 "Unknown" 
label values mig2_edu mig2_edu

   
//3.2.5 Occupation in household before moving away
rename qid648  mig2_occ  
*tab mig2_occ
label define mig2_occ 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other" /*   "other" specified in text data in variable "mig1_occ_other" */
label values mig2_occ mig2_occ


//3.2.5 (continue) Occupation in household before moving away (other)
rename qid648_9_text mig2_occ_other 
*tab mig1_occ_other

//3.2.6 Which of the following conditions factored into the labor migrants' decision to leave this household?
rename qid665 mig2_reason

//3.2.7 Occupation while living elsewhere and supporting this family financially
rename qid649 mig2_occ_away
*tab mig2_occ_away
label define mig2_occ_away 1 "On this or another small farm" /*
*/2 "On a commercial farm"/*
*/3 "Other industrial work"/*
*/4 "Teacher"/*
*/5 "Civil Servant" /*
*/6 "Clerk"/*
*/7 "Shop attendant"/*
*/8 "Non-agricultural piecework"/*
*/9 "Other" /*   "other" specified in text data in variable "mig1_occ_away_other" */
label values mig2_occ_away mig2_occ_away


//3.2.7 (continue) Occupation while living elsewhere and supporting this family financially (other)
rename qid649_9_text mig2_occ_away_other 
*tab mig2_occ_away_other

// 3.2.8 Year in which individual first began to support this household while living elsewhere:
rename qid650_text mig2_year
*tab mig2_year 
 
 
 // 3.2.9 How many weeks did the individual spend away from the household in the last 12 months? 
rename qid667_text mig2_weeks_away
*tab mig2_weeks_away

//3.2.10 Approximately how much money did this individual give to the household in the last 12 months? (in kwacha)
rename  qid651_text mig2_money
*tab mig2_money

// 3.2.11 What is the approximate value (in kwacha) of the non-cash remittances you received from this individual in the last 12 months?
rename qid804_text mig2_noncash
*tab mig2_noncash

//3.2.12 Has the individual left the household permanently or temporarily?
rename qid652 mig2_permanent
*tab mig2_permanet
label define mig2_permanent 1 "Permanently" 2 " Temporarily " 3 " I don't know "
label values mig2_permanent mig2_permanent






***************************************************
* Section 4: Asset questions: start from 4.1 of the surveys
***************************************************

//4.1 Mobile phones (including touchscreen phones):
rename qid182 asset_phone
*tab asset_phone 
recode asset_phone 7=0
label define asset_phone  5 "5+" 
label values asset_phone asset_phone

//4.2 What year did someone from your household first acquire a mobile phone?
rename qid560_text phone_year
*tab phone_year

//4.3 Televisions:
rename qid192 tv
*tab tv
recode tv 7=0
label define tv 5 "5+" 
label values tv tv 

//4.4 Radios:
rename qid185 radio
*tab radio
recode radio 6=0
label define radio  5 "5+" 
label values radio radio 

//4.5 Bicycles:
rename qid186 bike
*tab bike
recode bike 6=0
label define bike 5 "5+" 
label values bike bike


//4.6 Motorcycles:
rename qid187 motorcycle
*tab motorcycle
recode motorcycle 6=0
label define motorcycle 5 "5+" 
label values motorcycle motorcycle

//4.7 Water pump/treadles:
rename qid189 water_pump
*tab water_pump
recode water_pump 6=0
label define water_pump  5 "5+"  
label values water_pump water_pump

//4.8 Ploughs:
rename qid190 plough
recode plough 6=0
label define plough 5 "5+"  
label values plough plough


//4.9 Sprayers:
rename qid188 sprayers
recode sprayers 6=0
label define sprayers 5 "5+" 
label values sprayers sprayers

//4.10 Ox carts:
rename qid191 ox_carts
recode ox_carts 6=0
label define ox_carts  5 "5+"  
label values ox_carts ox_carts

//4.11 Vehicles (car, Canter...):
rename qid653 vehicle
recode vehicle 5=0
label define vehicle 4 "+4" 
label values vehicle vehicle

//4.12 Does this household have iron sheets?
rename qid654 iron_sheets
*tab iron_sheets
replace iron_sheets=1 if iron_sheets==23
replace iron_sheets=0 if iron_sheets==24
label values iron_sheets yesno

//4.13 Solar Panels (50W or larger):
rename qid396 solar
*tab solar

//4.14 Do you have any of the following livestock?
rename qid814_1 oxen
rename qid814_2 breeding_bull
rename qid814_3 donkey 

// 2 or 3 answers are "1,2" , which means both Yes AND No.. should be a typo, I deleted them
*tab oxen

replace oxen="" if oxen=="1,2"
destring oxen,replace
replace oxen=0 if oxen==2
label values oxen yesno

*tab breeding_bull
replace breeding_bull="" if breeding_bull=="1,2"
destring breeding_bull,replace
replace breeding_bull=0 if breeding_bull==2
label values breeding_bull yesno

*tab donkey
replace donkey=0 if donkey==2
label values donkey yesno
 

//4.15 How many of the following livestock does your household currently own?
rename qid193_1_1 female_cattle_number
rename qid193_2_1 goat_sheep_number
rename qid193_3_1 poultry_number
rename qid193_4_1 pigs_number

*tab female_cattle_number
replace female_cattle_number="0" if female_cattle_number=="O"
destring female_cattle_number,replace

*tab goat_sheep_number
replace goat_sheep_number="0" if goat_sheep_number=="O"
destring goat_sheep_number,replace



//4.16 Approximately how much income (in Kwacha) did your household receive from the following activities in the past 12 months
rename qid64_1 income_piecework
rename qid64_2 income_salary
*tab income_salary
replace income_salary="11400" if income_salary=="11,400"
replace income_salary="14400" if income_salary=="14,400"
destring income_salary,replace


rename qid64_9 income_smallbusiness
rename qid64_10 income_charcoal
rename qid64_12 income_gardening
rename qid64_13 income_forestproduct
rename qid64_6 income_livestock
rename qid64_8 income_remittance
rename qid64_16 income_other
*tab income_other
// an observation is "P" should be a typo,I deleted it.
replace income_other="" if income_other=="P"
destring income_other,replace


//4.17 How many members of your household did piecework (for cash or food) in the last 12 months?
rename qid70_text piecework_members
 
// 4.18 What kinds of piecework did household members do?
rename qid441 piecework_kind

//4.19 Does anyone in this household have a bank account?
rename qid65 bank_account
replace bank_account=0 if bank_account==2 
label values bank_account yesno

//4.20 Has anyone in the household taken out any formal loans in the past 12 months?
rename qid66 formal_loan
replace formal_loan=0 if formal_loan==2
label values formal_loan yesno

//4.21 If you needed to borrow the following amounts, would you be able to (either formal or informal)?
*tab qid561_2
rename qid561_1 borrow500 
rename qid561_2 borrow2500
rename qid561_3 borrow10000

*tab borrow10000
replace borrow500=0 if borrow500==2
replace borrow2500=0 if borrow2500==2
replace borrow10000=0 if borrow10000==2


label values borrow500 yesno
label values borrow2500 yesno
label values borrow10000 yesno


//4.22 Has any member of your household received or transferred money using their mobile phone?
rename qid394 phone_transfer
*tab phone_transfer
replace phone_transfer=1 if phone_transfer==23
replace phone_transfer=0 if phone_transfer==24


label values phone_transfer yesno

//4.23 How much money did your household spend on food in the last 7 days? 
rename qid669_text food_budget_7day

//4.24 How much money did your household spend on talktime in the last 7 days? 
rename qid670_text talktime_budget_7day

//4.25 How much money did your household spend on the following in the last month? (in kwacha)
rename qid455_2 veterinary_cost_month
* tab veterinary_cost_month
// an observation is "O" should be a typo of 0 instead
replace veterinary_cost_month="0" if veterinary_cost_month=="O"
destring veterinary_cost_month,replace

rename qid455_3 clothing_cost_month
rename qid455_4 transportation_cost_month
rename qid455_5 alcohol_cost_month
*tab alcohol_cost_month
// an observation is "P" should be a typo,I deleted it.
replace alcohol_cost_month="" if alcohol_cost_month=="P"
destring alcohol_cost_month,replace

rename qid455_6 firewood_cost_month
rename qid455_7 charcoal_cost_month
*tab charcoal_cost_month
// an observation is "60,00", it seems a bit unlikely to be 6000. But I'm not sure,so I leave it there.

rename qid455_1 talktime_cost_month
rename qid455_8 other_cost_month

***************************************************
// Section 5: Food related questions: start from 5.1 of the surveys
***************************************************
*5.0 If the person in charge of cooking and feeding family is available, please get that person at this time. Was this person available to answer the questions in this section? 
rename qid668 cook_person
replace cook_person=0 if cook_person==2

label values cook_person yesno

//5.1 In the past 7 days, have there been times when you did not have enough food for the household?
rename qid7 enough_food
replace enough_food=0 if enough_food==2

label values enough_food yesno

//5.2 In the period right after harvest how many kgs of maize does your household consume in one month?
rename qid671_text maize_consu_harvest


//5.3 How many days in the last week have members of your household eaten the following foods in your household?
rename qid275_1 eat_cereal_days
rename qid275_15 eat_cassava_days
rename qid275_2 eat_carrot_days
rename qid275_3 eat_vegetable_days
rename qid275_4 eat_other_vegetable_days
rename qid275_5 eat_fruit_days
rename qid275_6 eat_other_fruit_days
rename qid275_7 eat_meat_days
rename qid275_30 eat_insect_days
rename qid275_8 eat_egg_days
rename qid275_9 eat_fish_days
rename qid275_10 eat_pulses_days
rename qid275_11 eat_milk_days
rename qid275_12 eat_oil_days
rename qid275_13 eat_sweets_days
rename qid275_29 eat_spice_beverage_days

*tab   eat_oil_days
// change the value of answer to question table 5.3 into proper days 
foreach var of varlist eat_*  {
replace `var' = 0 if `var'==1
replace `var' = 1 if `var'==9
replace `var' = 2 if `var'==10
replace `var' = 3 if `var'==11
replace `var' = 4 if `var'==12
replace `var' = 5 if `var'==13
replace `var' = 6 if `var'==14
replace `var' = 7 if `var'==15
}
//
 
 
//5.4 How many different markets did you visit within the last month? 

rename qid791_text mkts_visited

//5.5 During the last 7 days, where did you purchase the following products?

* another multi-response question 

//5.5_2 buy_from village market
rename qid816_1 buy_from_village

//5.5_2 buy_from_tarmac road
rename qid816_2 buy_from_tarmac

//5.5_3 buy_from_district
rename qid816_3 buy_from_district

 //5.5_4 buy_from nearby farmer
rename qid816_4 buy_from_farmer

 //5.5_5 buy_from Processor/miller
rename qid816_5 buy_from_miller

 //5.5_6 buy_from other
rename qid816_6 buy_from_other

  //5.5_7 Did not purchase 
rename qid816_7 buy_none

 //5.6 In the last 7 days, has your household had to (please check those that apply):
rename qid166 food_secure

//***************************************************//
//	       Cleaning codes added by Armand (Nico updated May 2019) //
//***************************************************//
//Always maintain the same filepath
/*
capture log close
clear
set more off
drop _all
*cd "/Users/patreseanderson/Desktop/HICPS Cleaning" 
cd "C:\Users\nicol\Desktop\UIUC\Baylis\Zambia new\HICPS\2016 HICPS"
*/

*********************************************************************
/* Section 6: Land*/
*********************************************************************

label define yesno 1 "Yes" 0 "No", replace


rename qid72_text farmland
rename qid75_text title_land
rename qid408_text cultivown_land
rename qid76_text fallow_land
rename qid409 clear_land
replace clear_land = 1 if clear_land == 5
replace clear_land = 0 if clear_land == 6

label values clear_land yesno
rename qid80_text  rentfrom_land
rename qid673_text rentto_land
rename qid78 fallow_reasons

//Plantings related questions:
*> recoding the answers for Yes/No questions
foreach i in qid94 qid280 qid864 qid797 qid685 qid865 qid798 qid701 qid866 qid799 qid766 qid867 qid800 qid782 qid868 qid801 {
replace `i'=0 if `i'==2
label values `i' yesno
}

*********************************************************************
/* Section 7: Maize Plantings Starter */
*********************************************************************
//
*7.1
rename qid94 grewmaize

*7.2
rename qid96 plantnum

*********************************************************************
/* Section 8, 9, 10, 11, 12: Maize Plantings */
*********************************************************************


*Seed companies and variety labels

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


*Section 8:Planting 1
rename qid277 date_1
rename qid278 reason_1
rename qid278_5_text reason_txt_1
rename qid674 company_1
rename qid676 seed_co_1
rename qid823 mri_1
rename qid824 pioneer_1
rename qid822 pannar_1
rename qid825 zamseed_1
rename qid826 dekalb_1

rename qid827_text oth_variety1
rename qid677 v_recyc1
rename qid376 pl_2nd1
rename qid675 replnt1
rename qid280 fseed_1
rename qid864 vseed16_1
rename qid281_text qseed_1
rename qid282_text plot_1
rename qid283_text qharv_1
rename qid797 unharv_1
rename qid284 ferts_1
rename qid458_text qbasal_1
rename qid661_text qtop_1
rename qid202 inter_1
rename qid459_4 cult_1
rename qid459_6 plnt_1
rename qid459_7 weed_1
rename qid459_8 harv_1
		

*Section 9: Planting 2
rename qid678 date_2
rename qid679 reason_2
rename qid679_5_text reason_txt_2
rename qid680 company_2
rename qid833 seed_co_2
rename qid831 mri_2

	
rename qid835 pioneer_2
rename qid832 pannar_2
rename qid836 zamseed_2
rename qid830 dekalb_2

rename qid834_text oth_variety2
rename qid682 v_recyc2
rename qid683 pl_2nd2
rename qid684 replnt2
rename qid685 fseed_2
rename qid865 vseed16_2
rename qid686_text qseed_2
rename qid687_text plot_2
rename qid688_text qharv_2
rename qid798 unharv_2
rename qid689 ferts_2
rename qid690_text qbasal_2
rename qid691_text qtop_2
rename qid692 inter_2
rename qid693_4 cult_2
rename qid693_6 plnt_2
rename qid693_7 weed_2
rename qid693_8 harv_2


*Section 10: Planting 3
rename qid694 date_3
rename qid695 reason_3
rename qid695_5_text reason_txt_3
rename qid696 company_3
rename qid840 seed_co_3
rename qid838 mri_3
rename qid842 pioneer_3
rename qid839 pannar_3
rename qid843 zamseed_3
rename qid837 dekalb_3

rename qid841_text oth_variety3
rename qid698 v_recyc3
rename qid699 pl_2nd3
rename qid700 replnt3
rename qid701 fseed_3
rename qid866 vseed16_3
rename qid702_text qseed_3
rename qid703_text plot_3
rename qid704_text qharv_3
rename qid799 unharv_3
rename qid705 ferts_3
rename qid706_text qbasal_3
rename qid707_text qtop_3
rename qid708 inter_3
rename qid758_4 cult_3
rename qid758_6 plnt_3
rename qid758_7 weed_3
rename qid758_8 harv_3


*Section 11: Planting 4
rename qid759 date_4
rename qid760 reason_4
rename qid760_5_text reason_txt_4
rename qid761 company_4
rename qid848 seed_co_4
rename qid846 mri_4
rename qid850 pioneer_4
rename qid847 pannar_4
rename qid851 zamseed_4
rename qid845 dekalb_4

rename qid849_text oth_variety4
rename qid763 v_recyc4
rename qid764 pl_2nd4
rename qid765 replnt4
rename qid766 fseed_4
rename qid867 vseed16_4
rename qid767_text qseed_4
rename qid768_text plot_4
rename qid769_text qharv_4
rename qid800 unharv_4
rename qid770 ferts_4
rename qid771_text qbasal_4
rename qid772_text qtop_4
rename qid773 inter_4
rename qid774_4 cult_4
rename qid774_6 plnt_4
rename qid774_7 weed_4
rename qid774_8 harv_4





*Section 12: Planting 5
rename qid775 date_5
rename qid776 reason_5
rename qid776_5_text reason_txt_5
rename qid777 company_5
rename qid855 seed_co_5
rename qid853 mri_5
rename qid857 pioneer_5
rename qid854 pannar_5
rename qid858 zamseed_5
rename qid852 dekalb_5

rename qid856_text oth_variety5
rename qid779 v_recyc5
rename qid780 pl_2nd5
rename qid781 replnt5
rename qid782 fseed_5
rename qid868 vseed16_5
rename qid783_text qseed_5
rename qid784_text plot_5
rename qid785_text qharv_5
rename qid801 unharv_5
rename qid786 ferts_5
rename qid788_text qbasal_5
rename qid787_text qtop_5
rename qid789 inter_5
rename qid790_4 cult_5
rename qid790_6 plnt_5
rename qid790_7 weed_5
rename qid790_8 harv_5




** Recoding values to match the years 2017 and 2018 added by Gowthami


** Recoding seed company variables from 2016 to match 2017

forvalues i = 1/5{
recode company_`i'(14 = 13) (10 = 14) (11 = 15) (13 = 10) (9 = 11)
}

** Recoding mri varieties from 2016 to match 2017

forvalues i = 1/5{
recode mri_`i' (5=16) (6=13) (7=15) (8=11) (9=18)
}


** Recoding pan varieties from 2016 to match 2017


forvalues i = 1/5{
recode pannar_`i' (1=13) (2=5) (3=14) (4=1) (5=15) (6=16) (7=17) (8=7) (9=12)
}


** Recoding zamseed varieties from 2016 to match 2017

forvalues i = 1/5{
recode zamseed_`i' (2=16) (11=17)
}



*attaching labels

forvalues i = 1/5{
label value date_`i' dates
label value company_`i' seed_company
label value seed_co_`i' seed_co_var
label value mri_`i' mri_var
label value pioneer_`i' pioneer_var
label value pannar_`i' pannar_var
label value zamseed_`i' zamseed_var
label value dekalb_`i' dekalb_var
}
*********************************************************************************


*rename and label values
forvalues i = 1/5 {
	rename oth_variety`i' oth_variety_`i' 
	}


forvalues i = 1/5 {
		foreach var in v_recyc pl_2nd replnt {
			replace `var'`i' = 0 if `var'`i' == 74
			replace `var'`i' = 0 if `var'`i' == 2
		}
}
forvalues i = 1/5 {
	rename pl_2nd`i' second_`i'
	rename v_recyc`i' recycl_`i'
	rename replnt`i' replnt_`i'
}

forvalues i = 1/5 {
		foreach var in second_ recycl_ replnt_ {
			label values `var'`i' yesno
		}
}

*********************************************************************
/* Section 9: Maize storage and sales*/
*********************************************************************

rename qid417_text storage
rename qid420_1 mz_fin_wk
rename qid420_2 mz_fin_mth
rename qid416_text qharvested
rename qid656 nonharv
replace nonharv=1 if nonharv==28
replace nonharv=0 if nonharv==29

label values nonharv yesno

rename qid859_text qleft
rename qid419_text kgs_stor_now
rename qid430_text stor_last
rename qid418 sold_kgs_current
replace sold_kgs_current=1 if sold_kgs_current==5
replace sold_kgs_current=0 if sold_kgs_current==6
yesno sold_kgs_current

rename qid423 sold_who_current

rename qid421_text rct_sale_kgs
rename qid422_text rct_sale_kwacha
rename qid805_text bartered
rename qid433_text plan_sell
rename qid431 give_maize
replace give_maize=1 if give_maize==5
replace give_maize=0 if give_maize==6
yesno give_maize

rename qid432_text give_maize_kgs
rename qid435 rcv_maize
yesno rcv_maize

rename qid442_text rcv_maize_kgs
rename qid436 buy_maize
yesno buy_maize

rename qid443_text buy_maize_kgs
rename qid444_text buy_maize_price
rename qid445 buy_maize_loc
label define buymaize 4 "Market" 3 "Another farmer" 2 "Mill" 5 "Other" 
label val buy_maize_loc  buymaize

rename qid437 buy_meal
yesno buy_meal 

rename qid453 sold_who_prev
*label define sold_who_prev 1 "Briefcase buyers(in village)" 2 "FRA" 3 "Private buyers in town" 4 "Individuals" 5 "Batering patner" 6 "I did not sell maize"
*label value sold_who_prev sold_who_prev
*Could not label due to multiple responses
rename qid450_text kgs_sold_prev
rename qid454_text kgs_soldfra
rename qid514 fra_month_sold

label define monthsold 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October"  11 "November"  12 "December"  
label var fra_month_sold monthsold 

rename qid792 fra_month_paid
label value fra_month_paid monthsold 
rename qid515_text fra_dist

	
*********************************************************************
/* Section 10: Non-Maize crops and storage*/
*********************************************************************

rename qid117 crop16 
rename qid117_24_text crop16_text



//relabeling Question "10.2 From October 2015 until now, what was the most important crop that you planted other than maize?"
rename qid504 impcrop16_1
rename qid504_24_text impcrop16_text1
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
	65 "No other crops were planted"

rename qid145_text area_crop_1
rename qid146 sold_most_1
rename qid512 purchased_from_1
rename qid509 evoucher_seed_1

rename qid795 impcrop16_2
rename qid795_24_text impcrop16_text2
rename qid505_text area_crop_2
rename qid506 sold_most_2
rename qid508 purchased_from_2
rename qid513 evoucher_seed_2

rename qid793 impcrop16_3
rename qid793_24_text impcrop16_text3
rename qid152_text area_crop_3
rename qid149 sold_most_3
rename qid510 purchased_from_3
rename qid511 evoucher_seed_3

rename qid794 NS_crop
rename qid794_24_text NS_crop_other
rename qid507_text dealernum

forvalues i = 1/3 {
	label values impcrop16_`i' staples
	}

label define purchase 1 "Neighbor" 2 "Agro-dealer" 3 "Local market" 4 "NGO" 5 "Seed representative" 6 "Given to respondent" 7 "Recycled own seed"

foreach i of num 1/3{
	yesno sold_most_`i'
	label value purchased_from_`i' purchase
	replace evoucher_seed_`i'=1 if evoucher_seed_`i'==4
	replace evoucher_seed_`i'=0 if evoucher_seed_`i'==5
	yesno evoucher_seed_`i' 
	}
	
*********************************************************************
/* Section 11: Weather and Climate Information*/
*********************************************************************

***relabeling Question "11.1 To the best of your memory, when did the rains begin in the 2015-2016 season?"
rename qid6 rainstart15
label define rainstart15 1 "2nd week October" /*
*/ 2 "3rd week October" /*
*/ 3 "4th week October" /*
*/ 4 "1st week November" /*
*/ 5 "2nd week November" /*
*/ 6 "3rd week November" /*
*/ 7 "4th week November" /*
*/ 8 "1st week December" /*
*/ 9 "2nd week December" /*
*/ 10 "3rd week December" /*
*/ 11 "4th week December" /*
*/ 12 "1st week January" /*
*/ 13 "2nd week January", replace
label values rainstart15 rainstart15
*tab rainstart15, sort


***relabeling Question "11.2 To the best of your memory, when did the rains begin in the 2014-2015 season?"
rename qid424 rainstart14
label define rainstart14 1 "2nd week October" /*
*/ 2 "3rd week October" /*
*/ 3 "4th week October" /*
*/ 4 "1st week November" /*
*/ 5 "2nd week November" /*
*/ 6 "3rd week November" /*
*/ 7 "4th week November" /*
*/ 8 "1st week December" /*
*/ 9 "2nd week December" /*
*/ 10 "3rd week December" /*
*/ 11 "4th week December" /*
*/ 12 "1st week January" /*
*/ 13 "2nd week January", replace
label values rainstart14 rainstart14
*tab rainstart14, sort


***relabeling Question "11.3 To the best of your memory, when did the rains begin in the 2013-2014 season?"
rename qid287 rainstart13
label define rainstart13 1 "2nd week October" /*
*/ 2 "3rd week October" /*
*/ 3 "4th week October" /*
*/ 4 "1st week November" /*
*/ 5 "2nd week November" /*
*/ 6 "3rd week November" /*
*/ 7 "4th week November" /*
*/ 8 "1st week December" /*
*/ 9 "2nd week December" /*
*/ 10 "3rd week December" /*
*/ 11 "4th week December" /*
*/ 12 "1st week January" /*
*/ 13 "2nd week January", replace
label values rainstart13 rainstart13
*tab rainstart13, sort


***relabeling Question "11.4 To the best of your memory, when did the rains begin in the 2012-2013 season?"
rename qid288 rainstart12
label define rainstart12 1 "2nd week October" /*
*/ 2 "3rd week October" /*
*/ 3 "4th week October" /*
*/ 4 "1st week November" /*
*/ 5 "2nd week November" /*
*/ 6 "3rd week November" /*
*/ 7 "4th week November" /*
*/ 8 "1st week December" /*
*/ 9 "2nd week December" /*
*/ 10 "3rd week December" /*
*/ 11 "4th week December" /*
*/ 12 "1st week January" /*
*/ 13 "2nd week January", replace
label values rainstart12 rainstart12
*tab rainstart12, sort


***relabeling Question "11.5 To the best of your memory, when did the rains begin about 10 years ago?"
rename qid289 rainstart05
label define rainstart05 1 "2nd week October" /*
*/ 2 "3rd week October" /*
*/ 3 "4th week October" /*
*/ 4 "1st week November" /*
*/ 5 "2nd week November" /*
*/ 6 "3rd week November" /*
*/ 7 "4th week November" /*
*/ 8 "1st week December" /*
*/ 9 "2nd week December" /*
*/ 10 "3rd week December" /*
*/ 11 "4th week December" /*
*/ 12 "1st week January" /*
*/ 13 "2nd week January", replace
label values rainstart05 rainstart05
*tab rainstart05, sort


***relabeling Question "11.6 How would you characterize the rainfall from the 2015-2016 growing season?"
*"rainint" as in "rain intensity"
rename qid425 rainint
la var rainint "how intense was the raindfall during this season"
destring rainint,replace
label define rainint 1 "1_Severe drought" /*
*/ 2 "2_Moderate drought" /*
*/ 4 "4_Average" /*
*/ 5 "5_Above average" /*
*/ 6 "6_Too much", replace
label values rainint rainint

*tab rainint15, sort


***relabeling Question "11.7 How often would you say that you experience a flood?"
***relabeling Question "11.8 How often would you say that you experience a drought year?"
* "floodfreq" as in "flood intensity"
rename qid125 floodfreq
rename 	qid126	droughtfreq
label define freq ///
	1 "Every year" 		 ///
	2 "Every other year" ///
	3 "Once every 3 years" ///
	4 "Once every 4 years" ///
	5 "Once every 5 years" ///
	6 "Once every 6 years" ///
	7 "Once every 7 years" ///
	8 "Once every 8 years" ///
	9 "Once every 9 years" ///
	10 "Once every 10 years or less frequently"
label value floodfreq freq
label value droughtfreq freq
*tab floodfreq15

***relabeling Question "11.9 How long did the longest dry spell last in the 2015-2016 growing season? (in days)"
*"droughtint" as in "drought intensity"
rename qid128_text droughtint
*tab droughtint15

***relabeling Question "11.10 How did this dry spell impact your harvest?"
*"droughtimp" as in "drought impact"
rename qid129 droughtimp
label define droughtimp 1 "None" /*
*/ 2 "Somewhat" /*
*/ 3 "Significantly", replace
label values droughtimp droughtimp

*11.11 How do you know when the rainy season has started? 
rename qid426 know_rain
label define knowrain 4 "When there is a day of substantial rain in October or November" 3 "There are several days of consecutive rainfall" 1 "Total quantity of rainfall reaches a certain amount" 2 "Soil becomes moist"  5 "Other (please describe)"
label value know_rain knowrain
rename qid426_5_text know_rain_other

***relabeling Question "11.12 What is the most important factor in deciding when to plant?"
*"plantdec" as in "planting decision"
rename qid428 plantdec
label define plantdec 3 "I always plant on a specific date" /*
*/ 1 "When I think the rains are coming soon" /*
*/ 7 "After the first day of heavy rainfall" /*
*/ 4 "After there are several days of consecutive rainfall" /*
*/ 2 "When the soil is wet/moist enough to plant", replace
label values plantdec plantdec

*11.13 How many days of consecutive rainfall do you wait before you plant?
rename qid427_text days_toplant

*11.14 After planting, how many days can the local maize seeds you usually plant survive without rain?
rename qid429_text local_survive

*11.15 After planting, how many days can the hybrid maize seeds you usually plant survive without rain?
rename qid796_text hybrid_survive

*11.16 Do you think the rain in the 2016-2017 growing season will be the same, more, or less than the 2015-2016 growing season?
rename qid131 rain_prediction

***relabeling Question "11.17 Has your household been affected by floods in the last 5 years?"
*"floodaff" as in "flood affected"
rename qid132 floodaff
label values floodaff yesno
*tab floodaff15


***relabeling Question "11.18 In which years was your household affected by flood?"
*"floodyr" as in "flood year"
rename qid135 floodyr

***relabeling question "11.20 Has your household been affected by drought in the last 5 years?"
rename qid133 drought5yr
label values drought5yr yesno
*tab drought5yr15

**relabeling question "11.21 In which years was your household affected by drought"
rename qid141 droughtyr

***relabeling question "11.22 Has your household been affected by dry spells in the last 5 years?"
rename qid134 dspell5yr
label values dspell5yr yesno
*tab dspell5yr15


**relabeling question "11.23 In which years was your household affected by dry spells"
rename qid323 dspellyr


***relabeling Question "11.24 What was the impact of the most recent dry spells on your household in the last 5 years?"
*"dspellimp" as in "dry spells impact"
rename qid153 dspellimp
label define dspellimp 1 "Severe" /*
*/ 2 "Moderate" /*
*/ 3 "Little Impact", replace
label values dspellimp dspellimp
*tab dspellimp15, sort

*11.25 If you plant 20 kg of local maize seed on December 1st in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid492_text normal_dec_local
*11.26 If you plant 20 kg of local maize seed on December 1st in a year with a bad dry spell on your farm what would you expect the harvest to be? (in kg)
rename qid493_text dry_dec_local 
*11.27 If you plant 20 kg of local maize seed on January 1st  in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid494_text normal_jan_local

*** relabeling question "11.28 Do you have experience with medium maturing hybrid maize?"
rename qid817 mmaizeexp
label values mmaizeexp yesno
*tab mmaizeexp15, sort

*11.29 If you plant 20 kg of medium maturing hybrid maize seed on December 1st in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid497_text normal_dec_medium
*11.30 If you plant 20 kg of medium maturing hybrid maize seed on December 1st in a year with a bad dry spell on your farm what would you expect the harvest to be? (in kg)
rename qid498_text dry_dec_medium 
*11.31 If you plant 20 kg of medium maturing hybrid maize seed on January 1st in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid499_text normal_jan_medium

*** relabeling question "11.32 Do you have experience with early maturing hybrids?"
rename qid502 emaizeexp
label define emaizeexp 4 "Yes" 5 "No", replace
label values emaizeexp emaizeexp
*tab emaizeexp15, sort

*11.33 If you planted 20kg of early maturing hybrid on December 1st in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid818_text normal_dec_early
*11.34 If you planted 20kg of early maturing hybrid on December 1st in a year with a bad dry spell year on your farm what would you expect the harvest to be? (in kg)
rename qid819_text dry_dec_early
*11.35 If you planted 20kg of early maturing hybrid on January 1st in a normal/typical year on your farm what would you expect the harvest to be? (in kg)
rename qid501_text normal_jan_early
*11.36 If you planted 20kg of early maturing hybrid on January 1st in a year with a bad dry spell on your farm what would you expect the harvest to be? (in kg)
rename qid503_text dry_jan_early


*********************************************************************
/* Section 12: Cooperatives and FISP*/
*********************************************************************

*Question "12.1: the variable for agricultural cooperative membership in 2015"
rename qid630 coop
replace coop=0 if coop==2
label values coop yesno
*tab coop15 

// relabeling Question 12.2: the variable for agricultural cooperative names
rename qid631_text coopname
tab coopname

// relabeling question "12.3 What is the annual cost/membership fee to be a member of this cooperative? (in Kwacha)"
rename qid632_text coopfee
sum coopfee
*tab coopfee15


// relabeling Question "12.4 Did you participate in FISP in the 2015-2016 growing season?"
rename qid636 fisp
replace fisp=0 if fisp==2

// relabeling Question "12.5 Did you participate in the FISP E-Voucher program in the 2015-2016 agricultural season?"
rename qid633 vouch
replace vouch=0 if vouch==2

foreach i in fisp vouch {
label values `i' yesno
tab `i' 
}
//

//relabeling question "12.6 When was your FISP E-Voucher card activated?"
rename qid634 vouchdate

label define vouchdate 1 "1st week October 2015" /*
*/ 6 "2nd week October 2015" /*
*/ 7 "3rd week October 2015" /*
*/ 8 "4th week October 2015" /*
*/ 2 "1st week November 2015" /*
*/ 9 "2nd week November 2015" /*
*/ 10 "3rd week November 2015" /*
*/ 11 "4th week November 2015" /*
*/ 3 "1st week December 2015" /*
*/ 12 "2nd week December 2015" /*
*/ 13 "3rd week December 2015" /*
*/ 14 "4th week December 2015" /*
*/ 4 "1st week January 2016" /*
*/ 15 "2nd week January 2016" /*
*/ 16 "3rd week January 2016" /*
*/ 17 "4th week January 2016" /*
*/ 5 "1st week February 2016", replace
label values vouchdate vouchdate
*tab vouchdate15, sort


// relabeling question "12.7 How much of your FISP E-Voucher credit did you spend in the following categories?"

rename qid635_1_1 vfert
label var vfert "FISP E-Voucher credit spent on Fertilizer: Kwacha"

rename qid635_2_1 vmaizeseed
label var vmaizeseed "FISP E-Voucher credit spent on Maize Seeds: Kwacha"

rename qid635_10_1 votherseed
label var votherseed "FISP E-Voucher credit spent on Other crop seeds: Kwasha"

rename qid635_7_1 vequip
label var vequip "FISP E-Voucher credit spent on Implements (plows/pumps/sprayers): Kwacha"

rename qid635_5_1 vchem
label var vchem "FISP E-Voucher credit spent on Fungicides/Pesticides/Herbicides: Kwacha"

rename qid635_6_1 vhealth
label var vhealth "FISP E-Voucher credit spent on Immunizations/Vaccinations: Kwacha"

rename qid635_14_1 vgoods
label var vgoods "FISP E-Voucher credit spent on Non-Agricultural Goods: Kwacha"


*** relabeling question "12.9 When was the FISP package delivered or did you purchase seed using your E-Voucher card?"
rename qid637 vouchdate_delivered	

label define vouchdate 1 "1st week October 2015" /*
*/ 2 "2nd week October 2015" /*
*/ 3 "3rd week October 2015" /*
*/ 4 "4th week October 2015" /*
*/ 5 "1st week November 2015" /*
*/ 6 "2nd week November 2015" /*
*/ 7 "3rd week November 2015" /*
*/ 8 "4th week November 2015" /*
*/ 9 "1st week December 2015" /*
*/ 10 "2nd week December 2015" /*
*/ 11 "3rd week December 2015" /*
*/ 12 "4th week December 2015" /*
*/ 13 "1st week January 2016" /*
*/ 14 "2nd week January 2016" /*
*/ 15 "3rd week January 2016" /*
*/ 16 "4th week January 2016" /*
*/ 17 "1st week February 2016" /*
*/ 18 "2nd week February 2016", replace
label values vouchdate_delivered vouchdate



*********************************************************************
/* Section 13: Charcoal and Firewood*/
*********************************************************************

rename qid399 char_mnts
rename qid401 char_mrkts
rename qid475 prim_coll
rename qid862 way_coll
rename qid862_4_text way_other
rename qid477_text times_week
rename qid478 loc_coll
rename qid479_text time_coll
rename qid483 obstacle_coll
rename qid483_6_text obstacle_coll_other
rename qid485 diff_firewood
rename qid481 firewood_av10
rename qid484 tree_sp
rename qid484_4_text tree_sp_text
rename qid486 charcoal_6mth
rename qid807 disturb_coll
rename qid487_1 impact_fire
rename qid487_2 impact_clearing
rename qid487_3 impact_charcoal
rename qid487_4 impact_protected
rename qid487_5 impact_other
rename qid487_7 impact_demand
rename qid487_5_text impact_other_text
rename qid488 ban_firewood_areas
rename qid489 area_responsible
rename qid860 sms_survey
rename qid821_text comments

label define charcoal_mth 1 "June 2015" 2 "July 2015" 3 "August 2015" 11 "September 2015" ///
12 "October 2015" 13 "November 2015" 14 "December 2015" 15 "January 2016" 16 "February 2016" ///
17 "March 2016" 18 "April 2016" 19 "May 2016" 20 "June 2016" 21 "Did not produce"


label define mkt 1 "Neighbors" 2 "Along Roads" 3 "Nearby Markets" 4 "Middleman" 5 "Other" 


label define collector  ///
	1 "This household purchases firewood and does not collect it" ///
	2 "Spouse" 		///
	3 "Son" 		///
	4 "Daughter" 	///
	5 "Stepson/daughter"		/// 
	6 "Adopted son/daughter" 	///
	7 "Granddaughter"			///
	8 "Grandson"				///
	9 "Father" 					///
	10 "Mother" 				///
	11 "Brother" 				///
	12 "Sister" 				///
	13 "Self"					
	
label values prim_coll collector

label define how  1 "Walking/by hand" 2 "Ox cart" 3 "Bicycle" 4 "Other"



replace loc_coll = 0 if loc_coll == 6
replace loc_coll = 1 if loc_coll == 5
label values loc_coll yesno

label define obstacle ///
	1 "Distance to collection area"   ///
	2 "Density of available firewood" ///
	3 "Someone with time to do the collection" ///
	4 "Poor quality of available firewood"  ///
	5 "Limitations of access/protected area" ///
	6 "Other"	///
	7 "No significant restrictions to finding firewood" 

label values obstacle_coll obstacle

replace diff_firewood = 0 if diff_firewood == 2 
label values diff_firewood yesno

label define available 1 "Increased" 2 "Stayed the same" 3 "Decreased" 

label values firewood_av10 available 

replace tree_sp = 0 if tree_sp == 5
replace tree_sp = 1 if tree_sp == 4

label values tree_sp yesno

replace charcoal_6mth = 0 if charcoal_6mth == 2

label values charcoal_6mth yesno

replace disturb_coll = 0 if disturb_coll == 2

label values disturb_coll yesno

label define impact 1 "Significant impact" 2 "Slight impact" 3 "No impact"

label values impact_fire impact
label values impact_clearing impact
label values impact_charcoal impact
label values impact_protected impact
label values impact_other impact
label values impact_demand impact

replace ban_firewood_areas = 0 if ban_firewood_areas == 6
replace ban_firewood_areas = 1 if ban_firewood_areas == 5

label values ban_firewood_areas  yesno

label define responsible ///
	1 "National Government" ///
	2 "Local Government" ///
	3 "Traditional Land/Traditional Authority" ///
	6 "Myself / my household" ///
	5 "Private Individual (family)" /// 
	4 "Private Individual (not related)" 

label values area_responsible responsible

replace sms_survey = 0 if sms_survey == 6
replace sms_survey = 1 if sms_survey == 5

label values sms_survey yesno

gen year = 2016


gen date=substr(startdate,2,10)

*correct the odd miscoding*
replace province=5 if camp=="Lwamala"


****note: 2016 File was cleaned by Yujen and Armand in 2016 Kathy then created the HHIDs using two separate do file. When I add Kathy's two .do files to this .do file the generated HHIDs do not match the HHIDs that have been used in the follow-up surveys. To "resolve" this problem we merge a file of just HHIDs on a set of uniquely identifying variables. 

*merge with HHID file to get HHIDS 
merge 1:1 name name2 startdate using "HHIDs 2016_created by Kathy&Yujen", keepusing(HHID)  

save "2016 HICPS G", replace

***all variables are merged properly 
