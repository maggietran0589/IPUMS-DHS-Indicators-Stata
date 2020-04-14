/*****************************************************************************************************
Program: 			FE_births.do
Purpose: 			Code fertility indicators from birth history
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Faduma Shaba 
Date last modified: 		April 2020
*****************************************************************************************************/

/*______________________________________________________________________________
Variables created in this file:
//FERTILITY
	fe_preg			"Currently pregnant"
	fe_ceb_num		"Number of children ever born (CEB)"
	fe_ceb_mean		"Mean number of CEB"
	fe_ceb_comp  	"Completed fertility - Mean number of CEB to women age 40-49"
	fe_live_mean	"Mean number of living children"
//MENOPAUSE
	fe_meno			"Menopausal"
//TEEN PREGNANCY AND MOTHERHOOD
	fe_teen_birth	"Teens who have had a live birth"
	fe_teen_preg	"Teens pregnant with first child"
	fe_teen_beg		"Teens who have begun childbearing"
//FIRST BIRTH
	fe_birth_never	"Never had a birth"
	fe_afb_15		"First birth by age 15"
	fe_afb_18		"First birth by age 18"
	fe_afb_20		"First birth by age 20"
	fe_afb_22		"First birth by age 22"
	fe_afb_25		"First birth by age 25"
	fe_mafb_25		"Median age at first birth among age 25-49"
//OTHER INSTRUCTIONS
Change subgroups on line 42-51 and line 206 if other subgroups are needed for mean and medians
______________________________________________________________________________*/

*-->EDIT subgroups here if other subgroups are needed. 
****Subgroups currently include: Residence, region, education, and wealth.

**FERTILITY VARIABLES

	//Currently Pregnant
	replace pregnant=. if pregnant=9
		
	//Number of children ever born 
	replace cheb=. if cheb > 97
	replace cheb=10 if cheb > 10 & cheb < 51

	//Mean number of children ever born 
	mean cheb iw=perweight
	
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
	label define 0 "yes" 1 "no"
	label values timemenscalc timemenscalc
	
	
**FIRST BIRTH

//First marriage by age 15
replace agefrstmar=1 if agefrstmar < 15
replace agefrstmar=0 if agefrstmar > 14 & agefrstmar < 50
label define 0 "yes" 1 "no"
label values agefrstmar agefrstmar

	//First birth by specific ages
	recode v212 (.=0) (0/14 = 1 "yes") (15/49 = 0 "no"), gen (ms_afb_15)
	label var ms_afb_15 "First birth by age 15"

	recode v212 (.=0) (0/17 = 1 "yes") (18/49 = 0 "no"), gen (ms_afb_18)
	replace ms_afb_18 = . if v012<18
	label var ms_afb_18 "First birth by age 18"

	recode v212 (.=0) (0/19 = 1 "yes") (20/49 = 0 "no"), gen (ms_afb_20)
	replace ms_afb_20 = . if v012<20
	label var ms_afb_20 "First birth by age 20"

	recode v212 (.=0) (0/21 = 1 "yes") (22/49 = 0 "no"), gen (ms_afb_22)
	replace ms_afb_22 = . if v012<22
	label var ms_afb_22 "First birth by age 22"

	recode v212 (.=0) (0/24 = 1 "yes") (25/49 = 0 "no"), gen (ms_afb_25)
	replace ms_afb_25 = . if v012<25
	label var ms_afb_25 "First birth by age 25"

	//Never had a first birth
	gen fe_birth_never = 0
	replace fe_birth_never = 1 if v201==0
	label var fe_birth_never "Never had a birth"
	

**MEDIAN AGE AT FIRST BIRTH

//Define program to calculate median age
*********************************************************************************
program define calc_median_age

*-->EDIT subgroups here if other subgroups are needed. 
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
	gen mafb_`a'`b'_`y'`x'=smedian 

	//label subgroup categories
	label var mafb_`a'`b'_`y'`x' "Median age at first birth among `a' to `b' yr olds, `y'"

	if "`y'" != "all" {
	local lab_val: value label `y'
	local lab_cat : label `lab_val' `x'
	label var mafb_`a'`b'_`y'`x' "Median age at first birth among `a' to `b' yr olds, `y': `lab_cat'"
		}
	
	//replace median with O and label "NA" if no median can be calculated for age group
	replace mafb_`a'`b'_`y'`x' = 0 if mafb_`a'`b'_`y'`x'>beg_age
	if mafb_`a'`b'_`y'`x' ==0 {
	label val mafb_`a'`b'_`y'`x' NA
		}

	}
	}


	scalar drop smedian

end
*********************************************************************************
	
	//setup variables for median age at first birth calculated from v212
	gen afb=v212
	replace afb=99 if v212==. 
	gen age=afb
	gen agevar = v012
	gen weightvar = v005
	
	//create median age at first birth for each 5 yr age group
	tokenize 	  19 24 29 34 39 44 49 49 49
	foreach x in  15 20 25 30 35 40 45 20 25 {
				scalar beg_age = `x'
				scalar end_age = `1'
				calc_median_age
				
				macro shift
				}

program drop calc_median_age
