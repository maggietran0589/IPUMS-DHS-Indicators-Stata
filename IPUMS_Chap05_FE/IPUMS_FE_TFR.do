/*****************************************************************************************************
This do file will produce a table of TFRs by background variables as shown in final report (Table_TFR.xls).

Program: 			IPUMS_FE_TFR_IPUMS.do
Purpose: 			Code to compute fertility rates with IPUMS DHS variables
Data inputs: 		IPUMS DHS data extract using WOMEN as unit of analysis, made at dhs.ipums.org
Data outputs:		coded variables
Author:				Elizabeth Boyle & Faduma Shaba, based on the FE_TFR.do file
					prepared by Thomas Pullum and modified by Courtney Allen
Date last modified: April 29, 2020 by Elizabeth Boyle		 
*****************************************************************************************************/

/* DIRECTIONS

1. Create a data extract at dhs.ipums.org using WOMEN as unit of analysis that includes the variables listed below.
	 
2. On lines [121, 370, 389, 582, 706, 724, 800]  below, replace "GEO-REGION" with your sample's region variable name. 
	In IPUMS DHS, each survey's region variable has a unique name to facilitate 
	pooling data. These variables can be found in the IPUMS drop down menu under: 
	
		GEOGRAPHY -> SINGLE SAMPLE GEOGRAPHY.

	The single-sample region variables all follow the same naming convention: 

		geo_[country abbreviation][survey year]

	So, for example, the region variable for Afghanistan's 2015 survey is geo_af2015. 
	The region variable for Tanzania's 1996 survey is geo_tz1996.
	
3. Change the paths on lines [765, 784].
	Save the file in the directory of your choosing. 
	
4. Run this .do file.

***************************/
/*----------------------------------------------------------------------------
 
IPUMS DHS variables needed:

REGION 			Note: This variable has a unique name for each sample.
				Find and select the region variable in the dropdown menu under:
					Topics -> Geography -> Single Sample Geography.
urban			"Urban/Rural"
educlvl			"Highest level of schooling attended or completed"
Start searching here
wealthq	(v190)		"Household wealth in quintiles"
intdatecmc(v008)		"Interview date, century month code"
dobcmc(v011)			"Date of birth, century month code"
perweight(v005)		"Probability weight"
idhspsu (v021)			"Primary Sampling Unit"
clusterno (v001)			"Cluster"
hhnum (v002)			"Household Number"
lineno (v003)			"Woman's Line Number"
edyrtotal(v133)		"Years of education"
idealkid(v613)		"Ideal number of children"
chebalive(v218)		"Children born who are still living"
resident(v135)		"De jure resident"
b3???
Cheb(v201)				“Total Children ever Born”

----------------------------------------------------------------------------
Variables created in this file:
fe_asfr		"age specific fertility rates"
fe_tfr		"fertility rates"
fe_gfr		"general fertility rate"
----------------------------------------------------------------------------*/

*set logtype text

clear
program drop _all
set more off


* Setting up IPUMS variables (missing values and other recodes)
replace educlvl=. if educlvl >8
replace wealthq=. if wealthq >5
replace cheb=. if cheb >90


program define start_month_end_month

	/* 
	This routine calculates the end date and start date for the desired window of time
	Specify the interval as years before the date of interview, e.g. with
	scalar lw=-2
	scalar uw=0  
	for a window from 0 to 2 years before the interview, inclusive
	  (that is, three years)
	lw is the lower end of the window and uw is the upper end.
	(Remember that both are negative or 0.)
	*/

	gen start_month=doi+12*lw-12
	gen end_month=doi+12*uw-1

	replace end_month=min(end_month,doi)

	* calculate the reference date
	summarize start_month [iweight=perweight/1000000]
	scalar mean_start_month=r(mean)

	summarize end_month [iweight=perweight/1000000]
	scalar mean_end_month=r(mean)

	scalar refdate=1900-(1/24)+((mean_start_month+mean_end_month)/2)/12

	summarize doi [iweight=perweight/1000000]
	scalar mean_doi=1900-(1/24)+(r(mean))/12
end

******************************************************************************

program define setup

	* This routine is mainly to prepare the main input file for repeated runs.

	******************************************
	* BEGIN SEGMENT TO CONSTRUCT VALUE LABELS, WHILE THE IR FILE IS OPEN

	local lcovariates urban GEO-REGION educlvl wealthq

	foreach lcov of local lcovariates {
	levelsof `lcov', local(levels)
	  foreach li of local levels {
	  local lname : label (`lcov') `li'
	  scalar svaluelabel_`lcov'_`li'="`lname'"
	  }
	}
	* END SEGMENT TO CONSTRUCT VALUE LABELS
	******************************************

	rename indatecmc doi
	rename dobcmc dob
	rename cheb ceb
	format ceb %5.3f

	*renpfix b3_0 b3_
	gen curageint=int((doi-dob)/60)-2

	summarize ceb
	scalar maxceb=r(max) 
	local k=maxceb+1 
	while `k'<=20 {
	drop b3_`k'
	local k=`k'+1
	}

	* age intervals are 15-19,..., 45-49 (7 intervals)  
	scalar nageints=7

	save temp.dta, replace
end

******************************************************************************

program define make_exposure

	* CALCULATE EXPOSURE TO AGE INTERVALS WITHIN THE WINDOW, IN MONTHS
	use temp.dta, clear
	start_month_end_month

	drop b*
	local li=1
	scalar agestart=180
	while `li'<=nageints {
	gen mexp`li'=min(doi,end_month,dob+agestart+59)-max(start_month,dob+agestart)+1
	replace mexp`li'=0 if mexp`li'<0 

	replace mexp`li'=mexp`li'-.5 if end_month>=doi & curageint==`li'
	scalar agestart=agestart+60
	local li=`li'+1
	}

	*special section for surveys restricted to ever-married women

	* Note that some surveys are all-woman surveys but awfact is missing.
	* In that case, all the awfacts must be defined and set to 100.

	quietly summarize awfactt
	scalar test_awfact=r(mean)

	if test_awfact==0 | test_awfact==. {
	replace awfactt=100
	replace awfactu=100
	replace awfactr=100
	replace awfacte=100
	replace awfactw=100
	}

	sort caseid
	save exposure.dta,replace
end

******************************************************************************

program define make_births

	* MAKE FILE OF BIRTHS IN AGE INTERVALS WITHIN THE WINDOW

	use temp.dta, clear
	keep caseid b3_* 

	reshape long b3_, i(caseid) j(order)

	drop if b3_==.
	rename b3_ cmcbirth
	sort caseid
	save births.dta,replace
	drop _all

	use temp.dta
	start_month_end_month
	keep caseid dob start_month end_month
	sort caseid
	merge caseid using births.dta
	* tab _merge
	drop _merge

	scalar list lw uw

	* drop births that lie outside the window
	drop if cmcbirth<start_month | cmcbirth>end_month

	local i=0
	scalar agestart=120
	while `i'<=nageints {

	gen births`i'=0
	replace births`i'=births`i'+1 if cmcbirth<=dob+agestart+59 & cmcbirth>=dob+agestart

	scalar agestart=agestart+60
	local i=`i'+1
	}

	drop cmcbirth
	collapse (sum) births*, by(caseid)
	sort caseid
	save births.dta,replace

end

******************************************************************************

program define make_exposure_and_births

	* run_number is a counter for each run through the data file

	quietly make_exposure
	quietly make_births
	use exposure.dta,replace
	merge caseid using births.dta
	tab _merge
	drop _merge

	* The following line may or may not make any difference for the accuracy of the calculations
	recast double mexp* perweight

	local i=1
	while `i'<=nageints {
	gen lnexp`i'=ln(mexp`i'/12)
	replace births`i'=. if mexp`i'==0
	replace births`i'=0 if births`i'==. & mexp`i'>0
	local i=`i'+1
	}

	sort caseid
	save exposure_and_births, replace
end

******************************************************************************

program define save_results

	* This routine save the scalars as variables and then appends to build up an output file
	* It is called in the routine calc_rates

	scalar run_number=run_number+1

	clear
	set obs 1

	local cat=code

	gen v_run_number=run_number
	gen v_covariate=variable
	gen v_label=label
	gen v_value=code
	gen v_lw=lw
	gen v_uw=uw
	gen v_refdate=refdate
	gen v_mean_doi=mean_doi

	local i=1 
	while `i'<=nageints {
	gen v_r`i'  =1000*r`i'_`cat'
	gen v_r`i'_L=1000*r`i'_L_`cat'
	gen v_r`i'_U=1000*r`i'_U_`cat'
	local i=`i'+1
	}

	gen v_TFR     =TFR_`cat'
	gen v_TFR_L   =TFR_L_`cat'
	gen v_TFR_U   =TFR_U_`cat'
	gen v_GFR     =1000*GFR_`cat'
	gen v_GFR_L   =1000*GFR_L_`cat'
	gen v_GFR_U   =1000*GFR_U_`cat'
	gen v_DHSGFR  =1000*DHSGFR_`cat'
	gen v_DHSGFR_L=1000*DHSGFR_L_`cat'
	gen v_DHSGFR_U=1000*DHSGFR_U_`cat'

	if run_number>1 {
	append using partial_results.dta
	}

	save partial_results.dta, replace

end

*********************************************

program define calc_ci

	* Routine to calculate the confidence interval for the TFR using delta method.
	* A document to describe the procedure is being prepared.

	scalar TFR=r1+r2+r3+r4+r5+r6+r7

	scalar F=log(TFR)
	scalar C=1/(TFR*TFR)
	matrix D=(r1,r2,r3,r4,r5,r6,r7)

	matrix M=C*D*V*D'
	scalar sF=sqrt(M[1,1])
	scalar LF=F-1.96*sF
	scalar UF=F+1.96*sF
	scalar L=exp(LF)
	scalar U=exp(UF)

	* now scale up with factor of 5
	scalar TFR=5*TFR
	scalar TFR_L=5*L
	scalar TFR_U=5*U

	scalar list TFR TFR_L TFR_U

end

******************************************************************************

program define calc_rates

	use exposure_and_births.dta, clear

	if variable=="All" {
	gen covariate=1
	}

	if variable~="All" {
	local lname=variable
	gen covariate=`lname'
	}

	gen awfactor=awfactt

	if variable=="urban" {
	replace awfactor=awfactu
	}

	if variable=="GEO-REGION" {
	replace awfactor=awfactr
	}

	if variable=="educlvl" {
	replace awfactor=awfacte
	}

	if variable=="wealthq" {
	replace awfactor=awfactw
	}

	local i=1
	while `i'<=nageints {
	replace mexp`i'=mexp`i'*(awfactor/100)
	replace lnexp`i'=lnexp`i'+ln(awfactor/100)
	local i=`i'+1
	}

	egen stratum=group(GEO-REGION urban)
	gen clusterid=idhspsu

	egen births_GFR=rowtotal(births1 births2 births3 births4 births5 births6 births7)
	egen mexp_GFR=rowtotal(mexp1 mexp2 mexp3 mexp4 mexp5 mexp6 mexp7)
	gen lnexp_GFR=log(mexp_GFR/12)

	egen births_DHSGFR=rowtotal(births0 births1 births2 births3 births4 births5 births6 births7)
	egen mexp_DHSGFR=rowtotal(mexp1 mexp2 mexp3 mexp4 mexp5 mexp6)

	replace mexp_DHSGFR=1 if births7>0 & mexp_DHSGFR==0
	gen lnexp_DHSGFR=log(mexp_DHSGFR/12)

	* May need to adjust for awfactors

	egen womanid=group(caseid)


	levelsof covariate, local(levels)

	* Begin loop through each value of the categorical covariate for the GFR

	foreach cat of local levels {

	scalar code=`cat'

	* Construct a dummy variable to identify the subpopulation 

	gen dummy=0
	replace dummy=1 if covariate==code

	summarize doi if covariate==code


	* Get the GFR and ci

	***********************
	svyset clusterid [pweight=perweight], strata(stratum) singleunit(centered)
	***********************

	* First the usual GFR
	***********************
	svy, subpop(dummy): poisson births_GFR, offset(lnexp_GFR)
	***********************

	matrix T=r(table)
	scalar GFR_`cat'=exp(T[1,1])
	scalar GFR_L_`cat'=exp(T[5,1])
	scalar GFR_U_`cat'=exp(T[6,1])
	scalar list GFR_`cat' GFR_L_`cat' GFR_U_`cat'

	* Second the DHS version of the GFR
	* births0 is births before age 15, must calculate for the DHS version of the GFR.

	* The offset is a little different because it omits exposure to age 45-49.

	* The poisson rate model has a potential problem if a woman in her late 40s has a birth in the 
	*   window but was in age interval 45-49 in the entire window.  She then has no exposure because
	*   exposure while age 45-49 is ignored by the DHS version of the GFR. 
	*   The model will not allow a birth with no exposure.
	*   The easiest fix is to give such a woman a nominal small amount of exposure, one month. 

	replace lnexp_DHSGFR=log(1/12) if mexp_DHSGFR==0 & births_DHSGFR>0
	***********************
	svy, subpop(dummy): poisson births_DHSGFR, offset(lnexp_DHSGFR)
	***********************

	matrix T=r(table)
	scalar DHSGFR_`cat'=exp(T[1,1])
	scalar DHSGFR_L_`cat'=exp(T[5,1])
	scalar DHSGFR_U_`cat'=exp(T[6,1])
	scalar list DHSGFR_`cat' DHSGFR_L_`cat' DHSGFR_U_`cat'

	drop dummy

	}

	* End loop through each value of the categorical covariate for the GFR

	drop *GFR births0

	keep *id stratum births* lnexp* perweight covariate

	***********************
	reshape long births lnexp, i(womanid) j(age)
	***********************

	* This file has one record with births and exposure for each age interval for each woman 

	* Construct dummy variables for ALL age groups (noomit and nocons are crucial!).
	xi, noomit i.age
	rename _I* *

	* births is coded "." if there is no exposure to the age interval; drop such lines
	drop if births==.

	***********************
	svyset clusterid [pweight=perweight], strata(stratum) singleunit(centered)
	***********************

	* Begin loop through each value of the categorical covariate for the asfrs and TFR

	foreach cat of local levels {

	scalar code=`cat'

	* Construct 
	gen dummy=0
	replace dummy=1 if covariate==code

	***********************
	svy, subpop(dummy): poisson births age_*, offset(lnexp) nocons
	***********************

	matrix T=r(table)
	matrix list T

	matrix V=e(V)
	matrix list V


	local li=1
	while `li'<=7 {

	scalar r`li'_`cat'=exp(T[1,`li'])
	scalar r`li'_L_`cat'=exp(T[5,`li'])
	scalar r`li'_U_`cat'=exp(T[6,`li'])

	* must make a correction for any earlier time intervals that have no births

	if T[1,`li']==0 {
	scalar r`li'_`cat'=0
	scalar r`li'_L_`cat'=0
	scalar r`li'_U_`cat'=0
	}

	scalar list r`li'_`cat' r`li'_L_`cat' r`li'_U_`cat'

	* save a set of rates without subscripts to simplify the TFR notation
	scalar r`li'=r`li'_`cat'

	local li=`li'+1
	}

	* calculate a ci for the TFR by calculating a ci for ln[sum of exp(the coeffs)] 
	calc_ci


	scalar TFR_`cat'=TFR
	scalar TFR_L_`cat'=TFR_L
	scalar TFR_U_`cat'=TFR_U
	scalar list TFR_`cat' TFR_L_`cat' TFR_U_`cat'

	drop dummy

	}


	* Loop again through categories, this time just to save the results.

	foreach cat of local levels {
	scalar code=`cat'

	save_results
	}

end
*
**********************************************************

program define final_file_save

	* construct two Stata data files that save the results.
	* The first includes confidence intervals, the second does not

	use partial_results.dta, clear

	renpfix v_

	format r* *GFR* %6.2f
	format lw uw %5.0f
	format run* %3.0f
	format TFR* %6.4f
	format refdate mean_doi %8.2f

	*********************************
	* BEGIN SEGMENT TO ATTACH VARIABLE AND VALUE LABELS

	scalar svaluelabel_All_1="All"
	gen str45 covariatelabel= label

	
	replace covariatelabel="Type of Place" if regexm(covariate,"urban")==1
	replace covariatelabel="Region" if regexm(covariate,"GEO-REGION")==1
	replace covariatelabel="Education" if regexm(covariate,"educlvl")==1
	replace covariatelabel="Wealth Quintile" if regexm(covariate,"wealthq")==1

	gen str15 valuelabel="."

	gen line=_n
	quietly summarize line
	scalar nlines=r(max)

	scalar si=1
	while si<=nlines {

	scalar scov=covariate[si]
	local lcov=scov
	scalar svalue=value[si]
	local lvalue=svalue
	replace valuelabel=svaluelabel_`lcov'_`lvalue' if line==si
	scalar si=si+1
	}

	* Capitalize the first letter of each label
	replace valuelabel=ustrtitle(valuelabel)

	drop line

	* END SEGMENT TO ATTACH VARIABLE AND VALUE LABELS
	*********************************

	sort lw uw covariate value
	list lw uw refdate mean_doi covariate value valuelabel r1 r2 r3 r4 r5 r6 r7 TFR DHSGFR, table clean compress
	list lw uw refdate mean_doi covariate value valuelabel TFR* DHSGFR*, table clean compress

	scalar scid=substr(sfn,1,2)
	scalar spv =substr(sfn,5,2)
	local lcid=scid
	local lpv=spv

	* If you want these files, the next section. The estimates as shown in the final report are produced in line 574. 
	********** Produces Stata file and excel file with all the rates with confidence intervals ******
	* The default names of the saved files begin with the characters 1,2,5,6 of the name of the last
	* IR file.  You can change if you wish.
	save "`lcid'`lpv'_fert_rates_ci.dta", replace
	export excel "Tables_`lcid'`lpv'_fert_rates_ci.xlsx", firstrow(var) replace
	*/

	********* Produce Table as in Final report *****************************
	* Table_TFR would be produced. This will contain the fertility rates by background variables.
	gen N = _n
	keep N covariate covariatelabel valuelabel value TFR DHSGFR r1 r2 r3 r4 r5 r6 r7
	
	rename (r1 r2 r3 r4 r5 r6 r7 TFR DHSGFR) (fe_ASFR15_19 fe_ASFR20_24 fe_ASFR25_29 fe_ASFR30_34 fe_ASFR35_39 fe_ASFR40_44 fe_ASFR45_49 fe_TFR fe_DHS_GFR)
	order N covariate covariatelabel valuelabel value fe_TFR fe_DHS_GFR fe_ASFR15_19 fe_ASFR20_24 fe_ASFR25_29 fe_ASFR30_34 fe_ASFR35_39 fe_ASFR40_44 fe_ASFR45_49
	export excel "Tables_`lcid'`lpv'_TFR.xlsx", firstrow(var) replace

	**********************************************************************
	* optional--erase the working files
	erase temp.dta
	erase births.dta 
	erase exposure.dta 
	erase exposure_and_births.dta 
	erase partial_results.dta 
	*/
end

******************************************************************************

program define recodes

	* Routine to recode or construct covariates

	* Be sure that the components are included in the the original save and reshape commands

	* Example: combine codes 2 and 3 of educlvl, Education

	*gen educlvlr=educlvl
	*replace educlvlr=2 if educlvl==3
	*save, replace

	*/

	* If there are any recodes, you must include "save, replace"
	save, replace

end

******************************************************************************

program define covariate_segment

	* This routine checks whether an "include" scalar is specified, is coded 1, and 
	*   calculates the rates for each category

	* FOR EACH COVARIATE, USE A GROUP OF LINES LIKE THE FOLLOWING
	/*
	scalar variable="urban"
	scalar label="Type of Place"
	scalar list variable label
	quietly calc_rates
	*/

	local lvarname=svarname
	local lvarlabel=svarlabel

	capture confirm scalar include_`lvarname'
	if _rc==0 {
	  if include_`lvarname'==1 {
		scalar variable="`lvarname'"
		scalar label="`lvarlabel'"
		scalar list variable label
		quietly calc_rates
	  }
	scalar include_`lvarname'=0
	}

end

******************************************************************************

program define main

	* Can use this line to restrict to de jure residents, i.e. resident=1, if needed. Rarely needed.
	*keep if resident==1

	keep caseid clusterno hhnum lineno perweight indatecmc dobcmc cheb b3_* GEO-REGION edyrtotal awfact* idhspsu GEO-REGION urban educlvl wealthq 

	* YOU CAN RECODE OR CONSTRUCT COVARIATES 

	quietly setup

	quietly recodes

	quietly make_exposure_and_births

	local a = abs(uw)
	local b = abs(lw)
	local c = `b' + 1	//create for better variable naming
	
	scalar variable="All"
	scalar label="All, `a' to `c' years before the interview"
	quietly calc_rates

	scalar svarname="GEO-REGION"
	scalar svarlabel="Region"
	covariate_segment

	scalar svarname="educlvl"
	scalar svarlabel="Education"
	covariate_segment

	scalar svarname="wealthq"
	scalar svarlabel="Wealth quintile"
	covariate_segment

	scalar svarname="urban"		//run last for CBR scalars
	scalar svarlabel="Type of Place"
	covariate_segment

end


/******************************************************************************
WANTED FERTILITY
PLEASE SEE https://github.com/DHSProgram/DHS-Indicators-Stata/tree/master/Chap06_FF
to calculate Wanted Fertility
******************************************************************************/




******************************************************************************
******************************************************************************
* EXECUTION BEGINS HERE

* run_number is a counter used for the construction of the output file
scalar run_number=0

* The covariates you want to use must be specified in "main"

* IDENTIFY WHERE YOU WANT THE LOG AND OUTPUT FILES TO GO AND THE NAME OF THE LOG FILE

***********************
* Specify the path to the log file and the output files as a scalar; 
scalar soutpath="C:/Users/$user/ICF/Analysis - Shared Resources/Code/DHS-Indicators-Stata/Chap05_FE"	//!!!CHANGE PATH HERE
local loutpath=soutpath
cd "`loutpath'"
***********************

***********************
/* Specify the name of the log file as a scalar
scalar slogfile="DHS_fertility_rates_log.txt"
local llogfile=slogfile
***********************/

*log using "`llogfile'",replace

* A WORKING NAME OF THE OUTPUT FILE IS ASSIGNED IN "final_file_save"; you can change it

* IDENTIFY THE PATH AND NAME OF THE INPUT FILE 

***********************
* Specify the path to the input data as a scalar
scalar spath="C:/Users/$user/ICF/Analysis - Shared Resources/Data/DHSdata" 				//!!!CHANGE PATH HERE
local lpath=spath
***********************

***********************
* Specify the file name as a scalar. This must be an IR standard recode file in Stata format.
scalar sfn="$irdata"
***********************

local lfn=sfn
use "`lpath'\\`lfn'", clear

* IMPORTANT: Reduce to the variables that are needed

* INSERT changes for Wanted fertility
*************************************************
keep caseid clusterno hhnum lineno perweight indatecmc dobcmc idhspsu urban GEO-REGION GEO-REGION educlvl wealthq edyrtotal cheb awfact* idealkid b3_* b6_* b7_* chebalive b5_*

rename b*_0* b*_*
* note: putting this statement here means that a renpfix line in setup must be removed

rename caseid original_caseid
gen caseid=_n
save IRtemp.dta, replace 


* The following segment is needed for "all" fertility but not for "wanted" 
*

use IRtemp.dta, clear
scalar lw=-19
scalar uw=-15
main

use IRtemp.dta, clear
scalar lw=-14
scalar uw=-10
main

use IRtemp.dta, clear
scalar lw=-9
scalar uw=-5
main

use IRtemp.dta, clear
scalar lw=-4
scalar uw=0
main

use IRtemp.dta, clear //Run last so that most recent rates are saved as scalars for CBR calculation later
scalar lw=-2
scalar uw=0
main

*save scalars for CBR
forvalues i = 1/7 {
scalar cbr_r`i' = r`i'
}

use IRtemp.dta, clear //Run last so that most recent rates are saved as scalars for CBR calculation later
scalar include_v024=1
scalar include_educlvl=1
scalar include_wealthq=1
scalar include_urban=1
main


*/

* THE NEXT LINE IS ESSENTIAL AT THE END OF THE RUN
final_file_save

******************************************************************************

erase IRtemp.dta




//
