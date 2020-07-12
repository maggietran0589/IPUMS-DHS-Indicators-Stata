/*****************************************************************************
Program: 			HK_BHV_YNG.do
Purpose: 			Code for sexual behaviors among young people
Data inputs: 			IPUMS DHS Women and Men Surveys
Data outputs:			coded variables
Author:				Faduma Shaba
Date last modified: 		July 2020
Note:				The indicators below can be computed for men and women. 
			
*****************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the IPUMS variables listed below.		
2. Run this .do file.
*/
/*****************************************************************************
IPUMS Variables:

**WOMEN’S SURVEY**
age1stseximp		Age at first intercourse (imputed)
age			Age
age1stsex		Age at first intercourse
timesincesex		Time since last intercourse
aidltgotres		Received results from last HIV test
aidstestmoago		Number of months ago respondent had most recent HIV test
marstat			Current marital or union status

**MEN’S SURVEY**
age1stseximpmn		Age at first intercourse (imputed) (men)
agemn			Age (men)
age1stsexmn		Age at first intercourse (men)
timesincesexmn		Time since last intercourse (men)
aidltgotresmn		Received result from last HIV test (men)
aidstestmoagomn		Months since last tested for HIV (men)
marstatmn		Man's current marital or union status

*****************************************************************************/
/*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_15		"Had sexual intercourse before age 15 among those age 15-24"
hk_sex_18		"Had sexual intercourse before age 18 among those age 18-24"
hk_nosex_youth		"Never had sexual intercourse among never-married age 15-24"
hk_sex_youth_test	"Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"
	
----------------------------------------------------------------------------*/


**********************
**WOMEN’S SURVEY**
**********************

cap label define yesno 0"No" 1"Yes"

**************************
//Sex before 15
gen hk_sex_15 = inrange(age1stseximp,1,14)
replace hk_sex_15 = . if age>24
label values hk_sex_15 yesno
label var hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24"

//Sex before 18
gen hk_sex_18 = inrange(age1stseximp,1,17)
replace hk_sex_18 = . if age<18 | age>24
label values hk_sex_18 yesno
label var hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24"

//Never had sexual
gen hk_nosex_youth = (age1stsex==0 | age1stsex==99)
replace hk_nosex_youth = . if age>24 | marstat!=0
label values hk_nosex_youth yesno
label var hk_nosex_youth "Never had sexual intercourse among never-married age 15-24"

//Tested and received HIV test results
gen hk_sex_youth_test = (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & aidltgotres==1 & inrange(aidstestmoago,0,11)
replace hk_sex_youth_test=. if age>24
replace hk_sex_youth_test=. if inrange(timesincesex,252,299) | timesincesex>311 | timesincesex<100
label values hk_sex_youth_test yesno
label var hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"




cap label define yesno 0"No" 1"Yes"

**************************
//Sex before 15
gen hk_sex_15 = inrange(age1stseximpmn,1,14)
replace hk_sex_15 = . if agemn>24
label values hk_sex_15 yesno
label var hk_sex_15 "Had sexual intercourse before age 15 among those age 15-24"

//Sex before 18
gen hk_sex_18 = inrange(age1stseximpmn,1,17)
replace hk_sex_18 = . if agemn<18 | agemn>24
label values hk_sex_18 yesno
label var hk_sex_18 "Had sexual intercourse before age 18 among those age 18-24"

//Never had sexual
gen hk_nosex_youth = (age1stsexmn==0 | age1stsexmn==99)
replace hk_nosex_youth = . if agemn>24 | marstatmn!=0
label values hk_nosex_youth yesno
label var hk_nosex_youth "Never had sexual intercourse among never-married age 15-24"

//Tested and received HIV test results
gen hk_sex_youth_test = (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & aidltgotresmn==1 & inrange(aidstestmoagomn,0,11)
replace hk_sex_youth_test=. if agemn>24
replace hk_sex_youth_test=. if inrange(timesincesexmn,252,299) | timesincesexmn>311 | timesincesexmn<100
label values hk_sex_youth_test yesno
label var hk_sex_youth_test "Had sexual intercourse in the past 12 months and received HIV test and results among those age 15-24"



