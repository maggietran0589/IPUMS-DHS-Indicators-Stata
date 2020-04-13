/*****************************************************************************************************
Program: 			FE_births.do
Purpose: 			Code fertility indicators from birth history
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: October 21 2019
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

	//Mean number of children ever born (CEB)
			/*-------------------------------------------------------
			NOTE: Though this gives you the mean estimate, ignore 
			standard errors and confidence intervals because this data
			has not been survey set. Whenever standard errors are needed, 
			survey data must be survey set for approproate standard
			error estimates.
			-------------------------------------------------------*/
		  
	//Completed fertility, mean number of CEB among women age 40-49
	mean cheb if age5year>=70 & age5year<=80 [iw=perweight]

		
	//Mean number of CEB among all women
	mean cheb [iw=perweight]
	

	//Mean number of CEB among all women, by age group
	levelsof v013
	local levels `r(levels)'
	foreach y of local levels {
		mean v201 if v013==`y' [iw=wt]
		gen fe_ceb_mean_age`y' = e(b)[1,1]
	
		//label variable and subgroups
		local lab_val: value label v013
		local lab_cat : label `lab_val' `y'
		label var fe_ceb_mean_age`y' "Mean number of CEB, agegroup: `lab_cat'"
		}
			
	//Mean number of living children among all women
	mean v218 [iw=wt]
	gen fe_live_mean = e(b)[1,1]
	label var fe_live_mean "Mean number of living children"
	
	//Mean number of living children among all women, by age group
	levelsof v013
	local levels `r(levels)'
	foreach y of local levels {
		mean v218 if v013==`y' [iw=wt]
		gen fe_live_mean_age`y' = e(b)[1,1]

		//label variable and subgroups
		local lab_val: value label v013
		local lab_cat : label `lab_val' `y'
		label var fe_live_mean_age`y' "Mean number of CEB, agegroup: `lab_cat'"
		}
		
**TEENAGE PREGNANCY AND MOTHERHOOD

	//Teens (women age 15-19) who have had a live birth
	*gen fe_teen_birth = v201 if v013==1
	recode v201 (0=0 "No") (1/max=1 "Yes") if v013==1, gen(fe_teen_birth)
	label var fe_teen_birth "Teens who have had a live birth"
	
	//Teens (women age 15-19) pregnant with first child
	gen fe_teen_preg = 0 if v013==1
	replace fe_teen_preg = 1 if v201==0 & v213==1 & v013==1
	label val fe_teen_preg yesnolabel 
	label var fe_teen_preg "Teens pregnant with first child"

	//Teens (women age 15-19) who have begun childbearing
	gen fe_teen_beg = 0 if v013==1
	replace fe_teen_beg = 1 if (v201>0 | v213==1) & v013==1
	label val fe_teen_beg yesnolabel 
	label var fe_teen_beg "Teens who have begun childbearing"

**MENOPAUSE
	
	//Women age 30-49 experiencing menopause (exclude pregnant or those with postpartum amenorrhea) 
	gen fe_meno = 0 if  v013>3
	replace fe_meno = 1 if (v226>5 & v226<997) & v213==0 & v405==0  & v013>3
	label val fe_meno yesnolabel 
	label var fe_meno "Experienced menopause"

	//Menopausal age group, 30-49, two-year intervals after 40
	egen fe_meno_age = cut(v012), at(0 30 35 40 42 44 46 48)
	label define menolabel 30 "30-34" 35 "35-39" 40 "40-41" ///
						   42 "42-43" 44 "44-45" 46 "46-47" 48 "48-49"
	label val fe_meno_age meno_label
	label var fe_meno_age "Age groups for Menopause table"
	
**FIRST BIRTH

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
