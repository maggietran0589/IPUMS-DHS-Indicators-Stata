/*****************************************************************************************************
Program: 			RC_CHAR_IPUMS_DHS.do
Purpose: 			Code to compute respondent characteristics in men and women using IPUMS DHS variables
Credits:			This file replaces files created by The DHS Program, for use with IPUMS DHS
				https://github.com/DHSProgram/DHS-Indicators-Stata/blob/master/Chap03_RC/RC_CHAR.do
Data inputs: 			IPUMS DHS Respondent Characteristics
Data outputs:			coded variables
Author:				Faduma Shaba		
Date last modified:		March 2020
Note:				The indicators below can be computed for women. For men add 'mn' to the end of the 
				variable names. For women and men the indicator is computed for age 15-49 in line 55 and 262. 
				This can be commented out if the indicators are required for all women/men.
				Please check the note on health insurance. This can be country specific and also 
				reported for specific populations. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
IPUMS DHS variables used in this file:
educlvl			"Highest level of schooling attended or completed"
edyrtotal		"
lit2			"Level of literacy"
delete non ipums variables. lityn			"Literate - higher than secondary or can read part or whole sentence"
newswk			"Reads a newspaper at least once a week"
tvwk			"Watches television at least once a week"
radiowk			"Listens to radio at least once a week"
media_all		"Accesses to all three media at least once a week"
media_none		"Accesses none of the three media at least once a week"
internetevyr		"Ever used the internet"
internetevyr		"Used the internet in the past 12 months"
internetmo		"Internet use frequency in the past month - among users in the past 12 months"
wkworklastyr		"Employment status"
wkcurrjob		"Occupation among those employed in the past 12 months"
whoworkfor		"Type of employer among those employed in the past 12 months"
Wkearntype		"Type of earnings among those employed in the past 12 months"
Wkworklastyr		"Continuity of employment among those employed in the past 12 months"
inssocs			"Health insurance coverage - social security"
insemployer		"Health insurance coverage - other employer-based insurance"
insorg			"Health insurance coverage - mutual health org. or community-based insurance"
insprivate		"Health insurance coverage - privately purchased commercial insurance"
insother		"Health insurance coverage - other type of insurance"
inscoveryn		"Have any health insurance"
tosmoke			"Smokes cigarettes"
touseoth		"Smokes other type of tobacco"
tosmokeany		"Smokes any type of tobacco"
tosmokefq		"Smoking frequency"
tocigdayno		"Average number of cigarettes smoked per day"
tosnuffm		"Uses snuff smokeless tobacco by mouth"
tosnuffn		"Uses snuff smokeless tobacco by nose"
tochew			"Chews tobacco"
toghutka		"Uses betel quid with tobacco"
tosmokelessoth		"Uses other type of smokeless tobacco"
tosmokelessany		"Uses any type of smokeless tobacco"
tonosmoke		"Uses any type of tobacco - smoke or smokeless"
----------------------------------------------------------------------------
Variables created in this file:
rc_edu_median		"Median years of education"
lityn "Literate - higher than secondary or can read part or whole sentence"
----------------------------------------------------------------------------*/

*Limiting to women age 15-49
drop if age > 49 & age < 15

*** Education ***

//Highest level of education
replace educlvl=. if educlvl >8

//Median years of education  
replace edyrtotal=. if edyrtotal > 97
replace edyrtotal=20 if edyrtotal>20 & edyrtotal<95

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
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen rc_edu_median=round(sp50-1+(.5-sL)/(sU-sL),.01)
	label var edu_median	"Median years of education"

//Literacy level
replace Lit2=. if lit2 >97

MAKE HEADINGS AND INDENTATIONS SAME AS IN OTHER FILE
//Literate 
gen lityn=0
replace lityn=1 if educlvl==3 | Lit2==11 | Lit2==12	
label values rc_litr yesno
label var lityn "Literate - higher than secondary or can read part or whole sentence"

********* Media exposure *************

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
label values media_none yesno
label var media_none "Accesses none of the three media at least once a week"

//Ever used internet
replace internetevyr=. if internetevyr>97
replace internetevyr=1 if internetevyr==11 | internetevyr==12 | internetevyr==13
label define internetevyr 0 "No" 1 "Yes"
label values internetevyr internetevyr


//Used interent in the past 12 months
replace internetevyr=. if internetevyr>97
replace internetevyr=0 if internetevyr==0 | internetevyr==12 | internetevyr==13
replace internetevyr=1 if internetevyr==11 
label define internetevyr 0 "No" 1 "Yes"
label values internetevyr internetevyr


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

//Health insurance - Other
insother "Health insurance coverage - other type of insurance"

//Health insurance - Any
inscoveryn

*** Tobacco use ***

//Smokes cigarettes
tosmoke "Smokes cigarettes"

//Smokes other type of tobacco
gen tosmokeoth= topipe==1 | tocigar==1 | toshisha==1
label var tosmokeoth "Smokes other type of tobacco"

//Smokes any type of tobacco
gen tosmokeany= tosmoke==1 | topipe==1 | tocigar==1 | toshisha==1 
label var tosmokeany "Smokes any type of tobacco" 

//Smoke frequency
tosmokefq "Smoking frequency"

//Smokes daily
tocigdayno "Average number of cigarettes smoked per day"

//Snuff by mouth
tosnuffm "Uses snuff smokeless tobacco by mouth"

//Snuff by nose
tosnuffn "Uses snuff smokeless tobacco by nose"

//Chewing tobacco
tochew "Chews tobacco"

//Betel quid with tobacco
toghutka "Uses betel quid with tobacco"

//Other type of smokeless tobacco
*Note: there may be other types of smokeless tobacco, please check all v463* variables. 
gen tosmokelessoth=0
replace tosmokelessoth=1 if toshisha==1
label values tosmokelessoth yesno
label var tosmokelessoth "Uses other type of smokeless tobacco"

//Any smokeless tobacco
gen tosmokelessany=0
replace tosmokelessany=1 if tosnuff==1 | tosnuffm==1 | tosnuffn==1 | tochew==1 | toghutka==1 | toshisha==1 
label values tosmokelessany yesno
label var tosmokelessany "Uses other type of smokeless tobacco"

//Any tobacco 
tonosmoke==0 "Uses any type of tobacco - smoke or smokeless"



