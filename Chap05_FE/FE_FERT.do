/*****************************************************************************************************
Program: 			FE_births.do
Purpose: 			Code fertility indicators from birth history
Data inputs: 			IPUMS DHS Fertility files
Data outputs:			coded variables
Author:				Faduma Shaba 
Date last modified: 		April 2020
*****************************************************************************************************/

/*______________________________________________________________________________
Variables used in this file:
//FERTILITY
	pregnant		"Currently pregnant"
	cheb			"Number of children ever born (CEB)"
	chebalive		"Number of living children"
//MENSTRUATION
	timemenscalc		"Computed time since last menstrual period"
//TEEN PREGNANCY AND MOTHERHOOD
	teen_birth		"Teens who have had a live birth"
	teen_preg		"Teens pregnant with first child"
	teen_beg		"Teens who have begun childbearing"
//AGE AT FIRST BIRTH
	ageat1stbirth		"Age of respondent at time of first birth"
______________________________________________________________________________*/

**FERTILITY VARIABLES

	//Currently Pregnant
	replace pregnant=. if pregnant=9
		
	//Number of children ever born 
	replace cheb=. if cheb > 97
	replace cheb=10 if cheb > 10 & cheb < 51

	//Mean number of children ever born 
	mean cheb [iw=perweight]
	
	//Completed fertility, mean number of CEB among women age 40-49
	mean cheb if age5year>=70 & age5year<=80 [iw=perweight]
		
	//Mean number of CEB among all women
	mean cheb [iw=perweight]
	
	//Mean number of CEB among all women, by age group
	mean cheb, by(age5year) [iw=perweight]
			
	//Mean number of living children among all women
	replace chebalive=. if chebalive > 97
	mean chebalive [iw=perweight]
	
	//Mean number of living children among all women, by age group
	mean chebalive, by(age5year) [iw=perweight]

		
**TEENAGE PREGNANCY AND MOTHERHOOD

	//Teens (women age 15-19) who have had a live birth
	gen teen_birth = chebalive if age5year==20
	label var teen_birth "Teens who have had a live birth"
	
	//Teens (women age 15-19) pregnant with first child
	gen teen_preg = 0 if age5year==20
	replace teen_preg = 1 if cheb==0 & pregnant==1 & age5year==20
	label val teen_preg yesnolabel 
	label var teen_preg "Teens pregnant with first child"

	//Teens (women age 15-19) who have begun childbearing
	gen teen_beg = 0 if age5year==20
	replace teen_beg = 1 if (cheb>0 | pregnant==1) & age5year==20
	label val teen_beg yesnolabel 
	label var teen_beg "Teens who have begun childbearing"

**MENOPAUSE
	
	//In Menopause
	replace timemenscalc=. if timemenscalc > 997
	replace timemenscalc=0 if timemenscalc==0 | timemenscalc==992 | timemenscalc > 993  
	replace timemenscalc=1 if timemenscalc==991 | timemenscalc==993
	label define timemenscalc 0 "yes" 1 "no"
	label values timemenscalc timemenscalc
	
	
**FIRST BIRTH BY SPECIFIC AGES 

	//First birth by age 15
	replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=15 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=14
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth
	
	//First birth by age 18
	replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=18 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=17
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth

	//First birth by age 20
	replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=20 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=19
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth

	//First birth by age 22
	replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=22 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=21
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth

	//First birth by age 25
	replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=25 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=24
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth

