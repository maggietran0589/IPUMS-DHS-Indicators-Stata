/*****************************************************************************************************
Program: 			FE_tables.do
Purpose: 			produce tables for fertility indicators
Author:				Courtney Allen
Date last modified: Oct 21 2019 by Courtney Allen
*Note this do file will produce the following tables in excel:
	1. 	Tables_FERT:		Contains the tables for fertility indicators
	2. 	Tables_POST:		Contains the tables for postpartum and birth interval indicators
Notes: 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

//subgroups
local subgroup residence region education wealth 

**************************************************************************************************
* Indicators for fertility: excel file Tables_FERT will be produced
**************************************************************************************************
//Currently pregnant by background variables

* age
tab age pregnant  [iw=perweight], row nofreq 

* residence
tab urban pregnant  [iw=perweight], row nofreq 

* region
tab v024 pregnant  [iw=perweight], row nofreq 

* education
tab educlvl pregnant  [iw=perweight], row nofreq 

* wealth
tab wealthq pregnant  [iw=perweight], row nofreq 

* output to excel
tabout age urban v024 educlvl wealthq pregnant  using Tables_FE_Fert.xls [iw=perweight] , c(row) f(1) replace 
*/

**************************************************************************************************
//Complete fertility - mean number of children ever born among women age 40-49

* mean number of children ever born among women age 40-49
tabout mean cheb if age5year>=70 & age5year<=80 using Tables_FE_Fert.xls [iw=perweight] , oneway  c(cell) f(1) ptotal(none)  append 

	
**************************************************************************************************
//Number of children ever born

* number of children ever born
tab cheb [iw=perweight]

* by age
tab age cheb [iw=perweight], row

* output to excel
tabout age cheb using Tables_FE_Fert.xls [iw=perweight] , c(row) f(1) ptotal(none)    append 
tabout cheb using Tables_FE_Fert.xls [iw=perweight] , c(cell) f(1) ptotal(none)    append 


**************************************************************************************************
//Number of children ever born among currently married women

* number of children ever born
tab cheb if currmarr==1 [iw=perweight]

* by age
tab age cheb if currmarr==1 [iw=perweight], row

* output to excel
tabout age cheb if currmarr==1 using Tables_FE_Fert.xls [iw=perweight] , c(row) f(1) ptotal(none)    append 
tabout cheb if currmarr==1 using Tables_FE_Fert.xls [iw=perweight] , c(cell) f(1) ptotal(none)    append 

**************************************************************************************************
//Mean number of children ever born

* mean number of children ever born
tabout mean cheb using Tables_FE_Fert.xls [iw=perweight] , oneway  c(cell) f(1) ptotal(none)  append 

* mean number of children ever born, by age group
tabout mean cheb, by(age5year)  using Tables_FE_Fert.xls [iw=perweight] , oneway  c(cell) f(1) ptotal(none)  append 

	
**************************************************************************************************
//Mean number of living children

* mean number of living children
tabout mean chebalive using Tables_FE_Fert.xls [iw=perweight] , oneway  c(cell) f(1) ptotal(none)  append 

* mean number of of living children, by age group
tabout mean chebalive, by(age5year)  using Tables_FE_Fert.xls [iw=perweight] , oneway  c(cell) f(1) ptotal(none)  append 
	

**************************************************************************************************
//Menopause

replace timemenscalc=. if timemenscalc > 997
replace timemenscalc=0 if timemenscalc==0 | timemenscalc==992 | timemenscalc > 993  
replace timemenscalc=1 if timemenscalc==991 | timemenscalc==993
label define timemenscalc 0 "yes" 1 "no"
label values timemenscalc timemenscalc
  
* Experienced menopause
tab timemenscalc [iw=perweight]

* by age
tab age timemenscalc [iw=perweight], row

* output to excel
tabout age timemenscalc using Tables_FE_Fert.xls [iw=perweight] ,  c(row) f(1) ptotal(none)  append 
	
	
**************************************************************************************************	
//Age at first birth by background variables

  //First birth by age 15 
  replace ageat1stbirth=. if ageat1stbirth > 97
	replace ageat1stbirth=0 if ageat1stbirth >=15 & ageat1stbirth <=49
	replace ageat1stbirth=1 if ageat1stbirth > 0 & ageat1stbirth <=14
	label define ageat1stbirth 0 "no" 1 "yes"
	label values ageat1stbirth ageat1stbirth
  tab ageat1stbirth [iw=perweight]

  //First birth by age 18 

tab v013 ms_afb_18 if v013>=2  [iw=wt], row nofreq 
tab ms_afb_18 if v013>=2 [iw=wt]
tab ms_afb_18 if v013>=3 [iw=wt]

tab v013 ms_afb_20 if v013>=2  [iw=wt], row nofreq 
tab ms_afb_20 if v013>=2 [iw=wt]
tab ms_afb_20 if v013>=3 [iw=wt]

tab v013 ms_afb_22 if v013>=3  [iw=wt], row nofreq 
tab ms_afb_22 if v013>=3 [iw=wt]

tab v013 ms_afb_25 if v013>=3  [iw=wt], row nofreq 
tab ms_afb_25 if v013>=3 [iw=wt]


* output to excel
* percent had first birth by specific ages, by age group
tabout v013 ms_afb_15 using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afb_18 if v013>=2 using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afb_20 if v013>=2 using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afb_22 if v013>=3 using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afb_25 if v013>=3 using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 


**************************************************************************************************
//Never given birth by background variables

* never given birth
tab v013 fe_birth_never  [iw=wt], row nofreq 
tab fe_birth_never if v013>=2 [iw=wt] //among 20-49 yr olds
tab fe_birth_never if v013>=3 [iw=wt] //among 25-49 yr olds

* output to excel
tabout v013 fe_birth_never using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
tabout fe_birth_never if v013>=2 [iw=wt] using Tables_FE_Fert.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout fe_birth_never if v013>=3 [iw=wt] using Tables_FE_Fert.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 

**************************************************************************************************
//Median age at first birth by background variables

*median age at first birth by age group
tabout mafb_1519_all1 mafb_2024_all1 mafb_2529_all1 mafb_3034_all1 mafb_3539_all1 mafb_4044_all1 mafb_4549_all1 mafb_2049_all1 mafb_2549_all1 using Tables_FE_Fert.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 

*median age at first marriage among 25-49 yr olds, by subgroup
local subgroup residence region education wealth 

foreach y in `subgroup' {
	tabout mafb_2549_`y'*  using Tables_FE_Fert.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 
	}

	
**************************************************************************************************
//Teens (age 15-19) had a live birth by background variables

* age
tab v012 fe_teen_birth  [iw=wt], row nofreq 

* residence
tab v025 fe_teen_birth  [iw=wt], row nofreq 

* region
tab v024 fe_teen_birth  [iw=wt], row nofreq 

* education
tab v106 fe_teen_birth  [iw=wt], row nofreq 

* wealth
tab v190 fe_teen_birth  [iw=wt], row nofreq 

* output to excel
tabout v012 v025 v024 v106 v190 fe_teen_birth  using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
*/


**************************************************************************************************
//Teens (age 15-19) currently pregnant by background variables

* age
tab v012 fe_teen_preg  [iw=wt], row nofreq 

* residence
tab v025 fe_teen_preg  [iw=wt], row nofreq 

* region
tab v024 fe_teen_preg  [iw=wt], row nofreq 

* education
tab v106 fe_teen_preg  [iw=wt], row nofreq 

* wealth
tab v190 fe_teen_preg  [iw=wt], row nofreq 

* output to excel
tabout v012 v025 v024 v106 v190 fe_teen_preg  using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
*/


**************************************************************************************************
//Teens (age 15-19) begun childbearing by background variables

* age
tab v012 fe_teen_beg  [iw=wt], row nofreq 

* residence
tab v025 fe_teen_beg  [iw=wt], row nofreq 

* region
tab v024 fe_teen_beg  [iw=wt], row nofreq 

* education
tab v106 fe_teen_beg  [iw=wt], row nofreq 

* wealth
tab v190 fe_teen_beg  [iw=wt], row nofreq 

* output to excel
tabout v012 v025 v024 v106 v190 fe_teen_beg  using Tables_FE_Fert.xls [iw=wt] , c(row) f(1) append 
*/

}
