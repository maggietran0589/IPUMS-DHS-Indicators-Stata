/*******************************************************************************
Program: 			      MS_MAR.do
Purpose: 			      Code to use marital indicators
Data inputs:			      IPUMS DHS marriage and cohabitation variables
Data outputs:		    	      Variables with no missing values
Author:				      Faduma Shaba
Date last modified: 		      April 2020  
Note:				
*********************************************************************************/

/*----------------------------------------------------------------------------
Variables used in this file:
	
marstat			"Current marital status"
wifenum			"Number of other wives"
agefrstmar		"Age at first marriage or cohabitation"
----------------------------------------------------------------------------*/

Women's variables in IPUMS DHS
				
//Marital status
replace marstat=. if marstat > 97

//Co-wives
replace wifenum=. if wifenum > 98

***Married by specific ages***

replace agefrstmar=. if agefrstmar > 49

//First marriage by age 15
replace agefrstmar=1 if agefrstmar < 15
replace agefrstmar=0 if agefrstmar > 14 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

//First marriage by age 18
replace agefrstmar=1 if agefrstmar < 18
replace agefrstmar=0 if agefrstmar > 17 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

//First marriage by age 20
replace agefrstmar=1 if agefrstmar < 20
replace agefrstmar=0 if agefrstmar > 19 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

//First marriage by age 22
replace agefrstmar=1 if agefrstmar < 22
replace agefrstmar=0 if agefrstmar > 21 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

//First marriage by age 25
replace agefrstmar=1 if agefrstmar < 25
replace agefrstmar=0 if agefrstmar > 24 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

*****************************************************************************************************

Men's variables in IPUMS DHS
	
//Marital status
replace marstatmn if marstatmn > 97

//Number of wives
replace wifenummn if wifenummn > 98

***Married by specific ages***

replace agefrstmar=. if agefrstmar > 49

//First marriage by age 15
replace agefrstmarmn=1 if agefrstmarmn < 15
replace agefrstmarmn=0 if agefrstmarmn > 14 & agefrstmarmn < 50
label define 0 "yes" 1 "no"
label values agefrstmarmn agefrstmarmn

//First marriage by age 18
replace agefrstmarmn=1 if agefrstmarmn < 18
replace agefrstmarmn=0 if agefrstmarmn > 17 & agefrstmarmn < 50
label define 0 "yes" 1 "no"
label values agefrstmarmn agefrstmarmn

//First marriage by age 20
replace agefrstmarmn=1 if agefrstmarmn < 20
replace agefrstmarmn=0 if agefrstmarmn > 19 & agefrstmarmn < 50
label define 0 "yes" 1 "no"
label values agefrstmarmn agefrstmarmn

//First marriage by age 22
replace agefrstmarmn=1 if agefrstmarmn < 22
replace agefrstmarmn=0 if agefrstmarmn > 21 & agefrstmarmn < 50
label define 0 "yes" 1 "no"
label values agefrstmarmn agefrstmarmn

//First marriage by age 25
replace agefrstmarmn=1 if agefrstmarmn < 25
replace agefrstmarmn=0 if agefrstmarmn > 24 & agefrstmarmn < 50
label define 0 "yes" 1 "no"
label values agefrstmarmn agefrstmarmn
