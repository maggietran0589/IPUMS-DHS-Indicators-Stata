/*******************************************************************************
Program: 			        IPUMS_MS_SEX.do
Purpose: 			        Code to use sexual activity indicators
Data inputs: 		      IPUMS DHS First or ever sexual experience variables
Data outputs:		      Variables with no missing values
Author:			  	      Faduma Shaba
Date last modified:   	April 2020 
Note:				
*********************************************************************************/

/*----------------------------------------------------------------------------
Variables used in this file:
	
age1stseximp      Women's: "Age at first intercourse (imputed)"
age1stseximpmn	  Men's: "Age at first intercourse (imputed)"
----------------------------------------------------------------------------*/

Women's variables in IPUMS DHS

replace age1stseximp=. if agefrstmar > 49

//Never had sex
replace age1stseximp=1 if age1stseximp < 1
replace age1stseximp=0 if age1stseximp > 0 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

***Had sex by specific ages***

//First sex by age 15
replace age1stseximp=1 if age1stseximp < 15
replace age1stseximp=0 if age1stseximp > 14 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

//First sex by age 18
replace age1stseximp=1 if age1stseximp < 18
replace age1stseximp=0 if age1stseximp > 17 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

//First sex by age 20
replace age1stseximp=1 if age1stseximp < 20
replace age1stseximp=0 if age1stseximp > 19 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

//First sex by age 22
replace age1stseximp=1 if age1stseximp < 22
replace age1stseximp=0 if age1stseximp > 21 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

//First sex by age 25
replace age1stseximp=1 if age1stseximp < 25
replace age1stseximp=0 if age1stseximp > 24 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

*****************************************************************************************************

Men's variables in IPUMS DHS

replace age1stseximpmn=. if age1stseximpmn > 49

//Never had sex
replace age1stseximpmn=1 if age1stseximp < 1
replace age1stseximpmn=0 if age1stseximp > 0 & age1stseximp < 50
label define 0 "yes" 1 "no"
label values age1stseximp age1stseximp

***Had sex by specific ages***

//First sex by age 15
replace age1stseximpmn=1 if age1stseximpmn < 15
replace age1stseximpmn=0 if age1stseximpmn > 14 & age1stseximpmn < 50
label define 0 "yes" 1 "no"
label values age1stseximpmn age1stseximpmn

//First sex by age 18
replace age1stseximpmn=1 if age1stseximpmn < 18
replace age1stseximpmn=0 if age1stseximpmn > 17 & age1stseximpmn < 50
label define 0 "yes" 1 "no"
label values age1stseximpmn age1stseximpmn

//First sex by age 20
replace age1stseximpmn=1 if age1stseximpmn < 20
replace age1stseximpmn=0 if age1stseximpmn > 19 & age1stseximpmn < 50
label define 0 "yes" 1 "no"
label values age1stseximpmn age1stseximpmn

//First sex by age 22
replace age1stseximpmn=1 if age1stseximpmn < 22
replace age1stseximpmn=0 if age1stseximpmn > 21 & age1stseximpmn < 50
label define 0 "yes" 1 "no"
label values age1stseximpmn age1stseximpmn

//First sex by age 25
replace age1stseximpmn=1 if age1stseximpmn < 25
replace age1stseximpmn=0 if age1stseximpmn > 24 & age1stseximpmn < 50
label define 0 "yes" 1 "no"
label values age1stseximpmn age1stseximpmn
