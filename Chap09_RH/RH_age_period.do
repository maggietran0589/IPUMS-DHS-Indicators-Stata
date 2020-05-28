/*****************************************************************************
Program: 			RH_age_period.do
Purpose: 			compute the age variable and set the period for the analysis
Author:			  Faduma Shaba
Date last modified: 		May 2020 
Notes: 		Choose reference period to select last 2 years or last 5 years.
Using the a period of the last 2 years will not match final report 
but would provide more recent information. 
*****************************************************************************/
/*****************************************************************************
IPUMS DHS Variables Used:
indatecmc			    “Country month date of indicator”
kidcuragemo_01		“Current age of child in months”
kiddobcmc_01			“Child’s date of birth (CMC)”
*****************************************************************************/

*Choose reference period in months, last 2 years or last 5 years
gen period = 24
gen period = 60

//Computing the age variable

*If kidcuragemo_01 is not in the sample data:
gen age = indatecmc - kiddobcmc_01

*If kidcuragemo_01 is in the sample data: 
Gen age=kidcuragemo_01
	
cap label define yesno 0"no" 1"yes"
