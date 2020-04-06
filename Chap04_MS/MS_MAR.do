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

/* NOTES
		sp50 is the integer-valued median produced by summarize, detail;
		what we need is an interpolated or fractional value of the median.
		In the program, "age" is reset as age at first cohabitation.
		
		sL and sU are the cumulative values of the distribution that straddle
		the integer-valued median.
		
		The final result is stored as a scalar.
		
		Medians can found for subgroups by adding to the variable list below in 
		the same manner (i.e. subgroup1 = var ; subgroup2 = var etc, then subgroup
		names must be added to the local on line 55
		**************************************************************************/


//Define program to calculate median age
*********************************************************************************
program define calc_median_age

local subgroup region education wealth residence all

foreach y in `subgroup' {
	levelsof `y', local(`y'lv)
	foreach x of local `y'lv {
	
local a= beg_age
local b= end_age
cap summarize age [fweight=weightvar] if agevar>= beg_age & agevar<= end_age & `y'==`x', detail

scalar sp50=r(p50)

gen dummy=.
replace dummy=0 if agevar>= beg_age & agevar<= end_age & `y'==`x'
replace dummy=1 if agevar>= beg_age & agevar<= end_age & `y'==`x' & age<sp50 
summarize dummy [fweight=weightvar]
scalar sL=r(mean)

replace dummy=.
replace dummy=0 if agevar>= beg_age & agevar<= end_age &`y'==`x'
replace dummy=1 if agevar>= beg_age & agevar<= end_age & `y'==`x' & age<=sp50
summarize dummy [fweight=weightvar]
scalar sU=r(mean)
drop dummy

scalar smedian=round(sp50+(.5-sL)/(sU-sL),.01)
scalar list sp50 sL sU smedian



// warning if sL and sU are miscalculated
if sL>.5 | sU<.5 {
//ERROR IN CALCULATION OF L AND/OR U
}

//create variable for median
gen mafm_`a'`b'_`y'`x'=smedian 

//label subgroup categories
	label var mafm_`a'`b'_`y'`x' "Median age at first marriage among `a' to `b' yr olds, `y'"

	if "`y'" != "all" {
	local lab_val: value label `y'
	local lab_cat : label `lab_val' `x'
	label var mafm_`a'`b'_`y'`x' "Median age at first marriage among `a' to `b' yr olds, `y': `lab_cat'"
	}
	
	//replace median with O and label "NA" if no median can be calculated for age group
	replace mafm_`a'`b'_`y'`x' = 0 if mafm_`a'`b'_`y'`x'>beg_age
	if mafm_`a'`b'_`y'`x' ==0 {
	label val mafm_`a'`b'_`y'`x' NA
	}

}
}


scalar drop smedian

end
*********************************************************************************



Women's variables in IPUMS DHS

//Median age at first marriage
	//make subgroups here//
	gen all = 1
	clonevar region = v024
	clonevar wealth = v190
	clonevar education = v149
	clonevar residence = v025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first marriage calculated from v511, for women age 20 to 49
	gen afm=v511
	replace afm=99 if v511==. 
	gen age=afm
	gen agevar = v012
	gen weightvar = v005
	//create median age at first marriage for each 5 yr age group
	tokenize 	  19 24 29 34 39 44 49 49 49
	foreach x in  15 20 25 30 35 40 45 20 25 {
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}
				
//Marital status
replace marstat if marstat > 97

//Co-wives
replace wifenum if wifenum > 98

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

drop all region residence education wealth age agevar weightvar
label drop NA
}




*****************************************************************************************************




Men's variables in IPUMS DHS

//Median age at first marriage
	//make subgroups here//
	gen all = 1
	clonevar region = mv024
	clonevar wealth = mv190
	clonevar education = mv149
	clonevar residence = mv025
	label define NA 0 "NA" //for sub groups where no median can be defined

	
	//setup variables for median age at first marriage calculated from v511, for women age 20 to 49
	gen afm=mv511
	replace afm=99 if mv511==. 
	gen age=afm
	gen agevar = mv012
	gen weightvar = mv005

	//create median age at first marriage for each 5 yr age group - Men typically have higher age groups
	tokenize 	  19 24 29 34 39 44 49 49 49 59 59 59
	foreach x in  15 20 25 30 35 40 45 20 25 20 25 30{
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}


	
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

drop all region residence education wealth age agevar weightvar
label drop NA
}
