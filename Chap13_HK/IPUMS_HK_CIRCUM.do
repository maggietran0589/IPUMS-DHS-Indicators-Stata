/*****************************************************************************************************
Program: 			  IPUMS_HK_CIRCUM.do
Purpose: 		  	Code for indicators on male circumcision
Data inputs: 		Men's Surveys
Data outputs:		coded variables
Author:				  Faduma Shaba
Date last modified: July 2020 
Note:				The indicators are computed for men's age 15-49 in line 23. 
					This can be commented out if the indicators are required for all men.
			
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the IPUMS variables listed below.		
2. Run this .do file.
*/
/*****************************************************************************
IPUMS Variables:

*****************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_circum				"Circumcised"
hk_circum_status_prov	"Circumcision status and provider"
	
----------------------------------------------------------------------------*/

* Indicators from MR file

* limiting to men age 15-49
drop if mv012>49

cap label define yesno 0"No" 1"Yes"

**************************

//Circumcised
gen hk_circum = mv483==1
label values hk_circum yesno
label var hk_circum "Circumcised"

//Circumcision status and provider
gen hk_circum_status_prov= mv483b 
replace hk_circum_status_prov=3 if mv483b>2
replace hk_circum_status_prov=0 if mv483==0
replace hk_circum_status_prov=9 if mv483==8
label define hk_circum_status_prov 0"Not circumsised" 1"Traditional practitioner, family member, or friend" 2"Health work or health professional" 3 "Other/dont know/missing" 9"Dont know/missing circumcision status"
label values hk_circum_status_prov hk_circum_status_prov
label var hk_circum_status_prov "Circumcision status and provider"


