/*****************************************************************************************************
Program: 			RC_CHAR.do
Purpose: 			Code to compute respondent characteristics in men and women
Data inputs: 		IR or MR survey list
Data outputs:		coded variables
Author:			
Date last modified: 
Note:				The indicators below can be computed for men and women. 
					For women and men the indicator is computed for age 15-49 in line 55 and 262. This can be commented out if the indicators are required for all women/men.
					Please check the note on health insurance. This can be country specific and also reported for specific populations. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
rc_edu				"Highest level of schooling attended or completed"
rc_edu_median		"Median years of education"
rc_litr_cats		"Level of literacy"
rc_litr				"Literate - higher than secondary or can read part or whole sentence"
rc_media_newsp		"Reads a newspaper at least once a week"
rc_media_tv			"Watches television at least once a week"
rc_media_radio		"Listens to radio at least once a week"
rc_media_allthree	"Accesses to all three media at least once a week"
rc_media_none		"Accesses none of the three media at least once a week"
rc_intr_ever		"Ever used the internet"
rc_intr_use12mo		"Used the internet in the past 12 months"
rc_intr_usefreq		"Internet use frequency in the past month - among users in the past 12 months"
rc_empl				"Employment status"
rc_occup			"Occupation among those employed in the past 12 months"
rc_empl_type		"Type of employer among those employed in the past 12 months"
rc_empl_earn		"Type of earnings among those employed in the past 12 months"
rc_empl_cont		"Continuity of employment among those employed in the past 12 months"
rc_hins_ss			"Health insurance coverage - social security"
rc_hins_empl		"Health insurance coverage - other employer-based insurance"
rc_hins_comm		"Health insurance coverage - mutual health org. or community-based insurance"
rc_hins_priv		"Health insurance coverage - privately purchased commercial insurance"
rc_hins_other		"Health insurance coverage - other type of insurance"
rc_hins_any			"Have any health insurance"
rc_tobc_cig			"Smokes cigarettes"
rc_tobc_other		"Smokes other type of tobacco"
rc_tobc_smk_any		"Smokes any type of tobacco"
rc_smk_freq			"Smoking frequency"
rc_cig_day			"Average number of cigarettes smoked per day"
rc_tobc_snuffm		"Uses snuff smokeless tobacco by mouth"
rc_tobc_snuffn		"Uses snuff smokeless tobacco by nose"
rc_tobc_chew		"Chews tobacco"
rc_tobv_betel		"Uses betel quid with tobacco"
rc_tobc_osmkless	"Uses other type of smokeless tobacco"
rc_tobc_anysmkless	"Uses any type of smokeless tobacco"
rc_tobc_any			"Uses any type of tobacco - smoke or smokeless"
----------------------------------------------------------------------------*/

*Limiting to women age 15-49
drop if age > 49 & age < 15

*** Education ***
//Highest level of education
educlvl "Highest level of schooling attended or completed"

//Median years of education  
replace edyrtotal=20 if edyrtotal>20 

summarize edyrtotal [iw=perweight], detail
*summarize saves the data in the r()store
scalar sp50=r(p50)
*This saves a scalar-sp50- as the 50th percentile in the edyrtotal r store.

gen dummy=.
replace dummy=0
replace dummy=1 if edyrtotal<sp50
*This makes all edyrtotal over the median (sp50) = the categorical binary 1
summarize dummy [iw=perweight]
scalar sL=r(mean)
*This saves a scalar-sL- as the mean in the edyrtotal r store.
drop dummy

gen dummy=.
replace dummy=0
replace dummy=1 if eduyr <=sp50
summarize dummy iw=perweight]
scalar sU=r(mean)
drop dummy

gen rc_edu_median=round(sp50-1+(.5-sL)/(sU-sL),.01)
label var rc_edu_median	"Median years of education"

//Literacy level
Lit2 "Level of literacy"

********** //Literate ******
gen lityn=0
replace lityn=1 if educlvl==3 | Lit2==11 | Lit2==12	
label values rc_litr yesno
label var lityn "Literate - higher than secondary or can read part or whole sentence"

Media exposure

//Media exposure - newspaper
Newswk "Reads a newspaper at least once a week"

//Media exposure - TV
tvwk "Watches television at least once a week"

//Media exposure - Radio
radiowk "Listens to radio at least once a week"

******//Media exposure - all three******
gen media_all=0
replace media_all=1 if newswk==1 & tvwk==1 & radiowk==1
label values media_all yesno
label var media_all "Access to newspaper, TV, and radio once a week"

*****//Media exposure - none******
gen media_none=0
replace media_none=1 if newswk==0 & tvwk==0 & radiowk==0 
label values rc_media_none yesno
label var rc_media_none "Accesses none of the three media at least once a week"

//Ever used internet
internetevyr==10 "Ever used the internet"

//Used interent in the past 12 months
internetevyr==11 "Used the internet in the past 12 months"

//Internet use frequency
Internetmo "Internet use frequency in the past month - among users in the past 12 months"

*** Employment ***
//Employment status
wkworklastyr "Employment status"

//Occupation
wkcurrjob "Occupation among those employed in the past 12 months"

//Type of employer
whoworkfor "Type of employer among those employed in the past 12 months"

//Type of earnings
Wkearntype "Type of earnings among those employed in the past 12 months"

//Continuity of employment
Wkworklastyr==11 & Wkworklastyr==12 & Wkworklastyr==13 "Continuity of employment among those employed in the past 12 months"

*** Health insurance ***
inssocs "Health insurance coverage - social security"

//Health insurance - Other employer-based insurance
insemployer "Health insurance coverage - other employer-based insurance"

//Health insurance - Mutual Health Organization or community-based insurance
insorg "Health insurance coverage - mutual health org. or community-based insurance"

//Health insurance - Privately purchased commercial insurance
insprivate "Health insurance coverage - privately purchased commercial insurance"

//Health insuanqnrance - Other
insother "Health insurance coverage - other type of insurance"

//Health insurance - Any
inscoveryn

*** Tobacco use ***

//Smokes cigarettes
tosmoke "Smokes cigarettes"

//Smokes other type of tobacco
touseoth "Smokes other type of tobacco"

//Smokes any type of tobacco
tosome "Smokes any type of tobacco"

//Snuff by mouth
tosnuffm "Uses snuff smokeless tobacco by mouth"

//Snuff by nose
tosnuffn "Uses snuff smokeless tobacco by nose"

//Chewing tobacco
tochew "Chews tobacco"

//Betel quid with tobacco
toghutka "Uses betel quid with tobacco"

//Other type of smokeless tobacco

gen tosmokeless=0
replace tosmokeless==1 if tochew==1 | tosnuffm==1 | tosnuffn==1 | toghutka==1
label values tosmokeless yesno
label var tosmokeless "Uses other type of smokeless tobacco"

//Any smokeless tobacco
to smokeless "Uses other type of smokeless tobacco"

//Any tobacco 
tonosmoke==0 "Uses any type of tobacco - smoke or smokeless"



