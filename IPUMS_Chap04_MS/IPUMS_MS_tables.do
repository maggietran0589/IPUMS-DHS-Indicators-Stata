/*****************************************************************************************************
Program: 		  	         IPUMS_MS_tables.do
Purpose: 			            Produce tables for indicators
Author:				            Faduma Shaba
Date last modified:       		April 2020	
*Note this do file will produce the following tables in excel:
	1. 	Tables_Mar_wm:		Contains the tables for knowledge indicators for women
	2. 	Tables_Mar_mn:		Contains the tables for knowledge indicators for men
	3. 	Tables_Sex_wm:		Contains the tables for ever use of family planning for women
	4. 	Tables_Sex_mn:		Contains the tables for current use of family planning for women + timing of sterlization
Notes: 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

**************************************************************************************************
* Indicators for marriage: excel file Tables_Mar_wm will be produced
**************************************************************************************************

//Installing tabout

ssc install tabout

*/
****************************************************

//Marital status by background variables

*age and marital status
tab age5year marstat  [iw=perweight], row nofreq 

* output to excel
tabout age5year marstat using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Currently in union by background variables

*age
tab age5year marstat if marstat < 25 [iw=perweight], row nofreq 

* output to excel
tabout age5year marstat if marstat < 25  using Tables_Mar_wm.xls [iw=perweight] , c(row) f(1) append 
*/


****************************************************
//Number of women's co-wives by background variables

*age
tab age5year wifenum  [iw=perweight], row nofreq 

*residence
tab urban wifenum  [iw=perweight], row nofreq 

*region
tab v024 wifenum  [iw=perweight], row nofreq 

*education
tab educlvl wifenum  [iw=perweight], row nofreq 

*wealth
tab wealthq wifenum  [iw=perweight], row nofreq 

* output to excel
tabout age5year urban v024 educlvl wealthq wifenum using Tables_Mar_wm.xls [iw=perweight] , c(row) f(1) append 
*/

****************************************************
//Women with one ore more co-wives by background variables
*age
tab age5year wifenum if wifenum > 0 & wifenum < 98 [iw=perweight], row nofreq 

*residence
tab urban wifenum if wifenum > 0 & wifenum < 98 [iw=perweight], row nofreq 

*region
tab v024 wifenum if wifenum > 0 & wifenum < 98  [iw=perweight], row nofreq 

*education
tab educlvl wifenum if wifenum > 0 & wifenum < 98  [iw=perweight], row nofreq 

*wealth
tab wealthq wifenum if wifenum > 0 & wifenum < 98  [iw=perweight], row nofreq 

* output to excel
tabout age5year urban v024 educlvl wealthq wifenum if wifenum > 0 & wifenum < 98 using Tables_Mar_wm.xls [iw=perweight], c(row) f(1) append 


**************************************************************************************************
//Age at first marriage by background variables

* percent married by specific ages, by age group
tab age5year agefrstmar if agefrstmar < 15 [iw=perweight], row nofreq 
tab agefrstmar if agefrstmar<15 & if age5year>=30 [iw=perweight]
tab agefrstmar if agefrstmar<15& if age5year>=40 [iw=perweight]

tab age5year agefrstmar if agefrstmar < 18 & if age5year>=30  [iw=perweight], row nofreq 
tab agefrstmar if agefrstmar < 18 & if age5year>=30  [[iw=perweight]
tab agefrstmar if agefrstmar < 18 &  if age5year>=40 [iw=perweight]

tab age5year agefrstmar if agefrstmar < 20 & if age5year>=30 [iw=perweight], row nofreq 
tab agefrstmar if agefrstmar < 20 & if age5year>=30 [iw=perweight]
tab agefrstmar if agefrstmar < 20 & if age5year>=40>=3 [iw=wt]

tab age5year agefrstmar if agefrstmar < 22 & if age5year>=40  [iw=perweight], row nofreq 
tab agefrstmar if agefrstmar < 22 & if age5year>=40 [iw=wt]

tab age5year agefrstmar if agefrstmar < 25 & if age5year>=40  [iw=perweight], row nofreq 
tab agefrstmar if agefrstmar < 25 & if age5year>=40 [iw=perweight]


* output to excel
* percent married by specific ages, by age group
tabout agefrstmar agefrstmar if agefrstmar < 15 using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
tabout agefrstmar agefrstmar if agefrstmar < 18 using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
tabout agefrstmar agefrstmar if agefrstmar < 20 using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
tabout agefrstmar agefrstmar if agefrstmar < 22 using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
tabout agefrstmar agefrstmar if agefrstmar < 25 using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 

* percent married by specific ages, among 20-49 and 25-49 year olds
tabout ms_afm_15 ms_afm_18 ms_afm_20 if v013>=2 [iw=wt] using Tables_Mar_wm.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_afm_15 ms_afm_18 ms_afm_20 ms_afm_22 ms_afm_25 if v013>=3 [iw=wt] using Tables_Mar_wm.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 

**************************************************************************************************
//Never in union by background variables

* never in union by age group
tab v013 ms_mar_never  [iw=wt], row nofreq 
tab ms_mar_never if v013>=2 [iw=wt] //among 20-49 yr olds
tab ms_mar_never if v013>=3 [iw=wt] //among 25-49 yr olds

* output to excel
tabout v013 ms_mar_never using Tables_Mar_wm.xls [iw=wt] , c(row) f(1) append 
tabout ms_mar_never if v013>=2 [iw=wt] using Tables_Mar_wm.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_mar_never if v013>=3 [iw=wt] using Tables_Mar_wm.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 

**************************************************************************************************
//Median age at first marraige by background variables

*median age at first marriage by age group
tabout mafm_1519_all1 mafm_2024_all1 mafm_2529_all1 mafm_3034_all1 mafm_3539_all1 mafm_4044_all1 mafm_4549_all1 mafm_2049_all1 mafm_2549_all1 using Tables_Mar_wm.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 

*median age at first marriage among 25-49 yr olds, by subgroup
local subgroup residence region education wealth 

foreach y in `subgroup' {
	tabout mafm_2549_`y'*  using Tables_Mar_wm.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 
	}
	
	
	
**************************************************************************************************
* Indicators for sex: excel file Tables_Sex_wm will be produced
**************************************************************************************************

**************************************************************************************************
//Age at first sex by background variables

* percent had sex by specific ages, by age group

*percent married by age 15 
tab v013 ms_afs_15  [iw=wt], row nofreq //percent married by age 15, by age
tab ms_afm_15 if v013>=2 [iw=wt]		//percent married by age 15, by age, among age 20-49
tab ms_afs_15 if v013>=3 [iw=wt]		//percent married by age 15, by age, among age 25-49

tab v013 ms_afs_18 if v013>=2  [iw=wt], row nofreq   //percent married by age 18, by age
tab ms_afs_18 if v013>=2 [iw=wt]		//percent married by age, 18 by age, among age 20-49
tab ms_afs_18 if v013>=3 [iw=wt]		//percent married by age, 18 by age, among age 25-49

tab v013 ms_afs_20 if v013>=2  [iw=wt], row nofreq  //percent married by age 20, by age
tab ms_afs_20 if v013>=2 [iw=wt]		//percent married by age, 20 by age, among age 20-49
tab ms_afs_20 if v013>=3 [iw=wt]		//percent married by age, 20 by age, among age 25-49

tab v013 ms_afs_22 if v013>=3  [iw=wt], row nofreq  //percent married by age 22, by age
tab ms_afs_22 if v013>=3 [iw=wt]		//percent married by age, 22 by age, among age 25-49

tab v013 ms_afs_25 if v013>=3  [iw=wt], row nofreq  //percent married by age 25, by age
tab ms_afs_25 if v013>=3 [iw=wt]		//percent married by age 25, by age, among age 25-49


* output to excel
* percent had sex by specific ages, by age group
tabout v013 ms_afs_15 using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) replace 
tabout v013 ms_afs_18 if v013>1 using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afs_20 if v013>1 using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afs_22 if v013>2 using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) append 
tabout v013 ms_afs_25 if v013>2 using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) append 

* percent married by specific ages, among  20-49 and 25-49 year olds
tabout ms_afs_15 ms_afs_18  if v013>=2 [iw=wt] using Tables_Sex_wm.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_afs_15 ms_afs_18 ms_afs_20 ms_afs_22 ms_afs_25 if v013>=3 [iw=wt] using Tables_Sex_wm.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 

**************************************************************************************************
//Never had sex by background variables

* never had sex by age group
tab v013 ms_sex_never  [iw=wt], row nofreq 
tab ms_sex_never if v013>=2 [iw=wt] //among 20-49 yr olds
tab ms_sex_never if v013>=3 [iw=wt] //among 25-49 yr olds

* output to excel
tabout v013 ms_sex_never using Tables_Sex_wm.xls [iw=wt] , c(row) f(1) append 
tabout ms_sex_never if v013>=2 [iw=wt] using Tables_Sex_wm.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_sex_never if v013>=3 [iw=wt] using Tables_Sex_wm.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 

**************************************************************************************************
//Median age at first sex by background variables

*median age at first sex by age group
tabout mafs_1519_all1 mafs_2024_all1 mafs_2529_all1 mafs_3034_all1 mafs_3539_all1 mafs_4044_all1 mafs_4549_all1 mafs_2049_all1 mafs_2549_all1 using Tables_Sex_wm.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 

*median age at first sex among 25-49 yr olds, by subgroup
local subgroup residence region education wealth 

foreach y in `subgroup' {
	tabout mafs_2549_`y'*  using Tables_Sex_wm.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 
	}
}	





/////////////////////////////////////////////////////////////////////////////////////////////////





* indicators from MR file
if file=="MR" {
gen wt=mv005/1000000


**************************************************************************************************
* Indicators for marriage: excel file Tables_Mar_mn will be produced
**************************************************************************************************
//Marital status among men age 15-49
tab1	ms_mar_stat ms_mar_union if mv013<8 [iw=wt]

* output to excel
tabout 	ms_mar_stat ms_mar_union if mv013<8 using Tables_Mar_mn.xls [iw=wt] , oneway cells(cell) f(1) replace 

*/
****************************************************
//Marital status by background variables among men age 15-49

*age (15-49)
tab mv013 ms_mar_stat if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 ms_mar_stat if mv013<8  using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
*/

****************************************************
//Currently in union by background variables among men age 15-49

*age (15-49)
tab mv013 ms_mar_union if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 ms_mar_union if mv013<8 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
*/


****************************************************
//Number of men's wives by background variables among men age 15-49

*age
tab mv013 ms_wives_num  if mv013<8 [iw=wt], row nofreq 

*residence
tab mv025 ms_wives_num  if mv013<8 [iw=wt], row nofreq 

*region
tab mv024 ms_wives_num  if mv013<8 [iw=wt], row nofreq 

*education
tab mv106 ms_wives_num  if mv013<8 [iw=wt], row nofreq 

*wealth
tab mv190 ms_wives_num  if mv013<8 [iw=wt], row nofreq 

* output to excel
tabout mv013 mv025 mv024 mv106 mv190 ms_wives_num  if mv013<8 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
*/


**************************************************************************************************
//Age at first marriage by background variables

*percent married by specific ages by age group

*percent married by age 15 
tab mv013 ms_afm_15  [iw=wt], row nofreq 	//percent married by age 15 by age
tab ms_afm_15 if mv013>=2 & mv013<8 [iw=wt] //percent married by age 15 by age, among age 20-49
tab ms_afm_15 if mv013>=3 & mv013<8 [iw=wt] //percent married by age 15 by age, among age 25-49
tab ms_afm_15 if mv013>=2 [iw=wt] 			//percent married by age 15 by age, among age 20-max age
tab ms_afm_15 if mv013>=3 [iw=wt]			//percent married by age 15 by age, among age 25-max age

*percent married by age 18 
tab mv013 ms_afm_18 if mv013>=2  [iw=wt], row nofreq //percent married by age 18 by age
tab ms_afm_18 if mv013>=2 & mv013<8 [iw=wt]		 //percent married by age 18 by age, among age 20-49
tab ms_afm_18 if mv013>=3 & mv013<8 [iw=wt]		 //percent married by age 18 by age, among age 25-49
tab ms_afm_18 if mv013>=2 [iw=wt]				 //percent married by age 18 by age, among age 20-max age
tab ms_afm_18 if mv013>=3 [iw=wt]				 //percent married by age 18 by age, among age 25-max age

*percent married by age 20 
tab mv013 ms_afm_20 if mv013>=2  [iw=wt], row nofreq //percent married by age 20 by age
tab ms_afm_20 if mv013>=2 & mv013<8 [iw=wt]		 //percent married by age 20 by age, among age 20-49
tab ms_afm_20 if mv013>=3 & mv013<8 [iw=wt]		 //percent married by age 20 by age, among age 25-49	
tab ms_afm_20 if mv013>=2 [iw=wt]		 		 //percent married by age 20 by age, among age 20-max age
tab ms_afm_20 if mv013>=3 [iw=wt]				 //percent married by age 20 by age, among age 25-max age

*percent married by age 22 
tab mv013 ms_afm_22 if mv013>=3  [iw=wt], row nofreq //percent married by age 22 by age
tab ms_afm_22 if mv013>=3 & mv013<8 [iw=wt]		//percent married by age 22 by age, among age 25-49
tab ms_afm_22 if mv013>=3 [iw=wt]   			//percent married by age 22 by age, among age 25-max age

*percent married by age 25 
tab mv013 ms_afm_25 if mv013>=3  [iw=wt], row nofreq //percent married by age 25 by age
tab ms_afm_25 if mv013>=3 & mv013<8 [iw=wt]  	//percent married by age 25 by age, among age 25-49
tab ms_afm_25 if mv013>=3 [iw=wt]  			 	//percent married by age 25 by age, among age 25-max age


* output to excel
* percent married by specific ages, by age group
tabout mv013 ms_afm_15 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afm_18 if mv013>1 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afm_20 if mv013>1 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afm_22 if mv013>2 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afm_25 if mv013>2 using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 

* percent married by specific ages, among 20-49 and 25-49 year olds
tabout ms_afm_15 ms_afm_18 ms_afm_20 if mv013>=2 & mv013<8 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_afm_15 ms_afm_18 ms_afm_20 ms_afm_22 ms_afm_25 if mv013>=3 & mv013<8 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 
tabout ms_afm_15 ms_afm_18 ms_afm_20 if mv013>=2 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_20-59_yr_olds) f(1) append 
tabout ms_afm_15 ms_afm_18 ms_afm_20 ms_afm_22 ms_afm_25 if mv013>=3 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_25-59_yr_olds) f(1) append 

**************************************************************************************************
//Never in union by background variables

* never in union by age group
tab mv013 ms_mar_never  [iw=wt], row nofreq 
tab ms_mar_never if mv013>=2 & mv013<8 [iw=wt] //among 20-49 yr olds
tab ms_mar_never if mv013>=3 & mv013<8 [iw=wt] //among 25-49 yr olds
tab ms_mar_never if mv013>=2 [iw=wt] //among 20-49 yr olds
tab ms_mar_never if mv013>=3 [iw=wt] //among 25-49 yr olds

* output to excel
tabout mv013 ms_mar_never using Tables_Mar_mn.xls [iw=wt] , c(row) f(1) append 
tabout ms_mar_never if mv013>=2 & mv013<8 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_mar_never if mv013>=3 & mv013<8 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 
tabout ms_mar_never if mv013>=2 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_20-59_yr_olds) f(1) append 
tabout ms_mar_never if mv013>=3 [iw=wt] using Tables_Mar_mn.xls, oneway c(cell) clab(Among_25-59_yr_olds) f(1) append 

**************************************************************************************************
//Median age at first marriage by background variables

*median age at first marriage by age group
tabout mafm_1519_all1 mafm_2024_all1 mafm_2529_all1 mafm_3034_all1 mafm_3539_all1 mafm_4044_all1 mafm_4549_all1 mafm_2049_all1 mafm_2549_all1 mafm_2059_all1 mafm_2559_all1 using Tables_Mar_mn.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 

*median age at first marriage among 25-49 yr olds, by subgroup
local subgroup residence region education wealth 

*median ages by subgroups, CHANGE AGE RANGE HERE IF NEEDED (change var from mafm_2549_ to mafm_20-49_ for median age among those age 20-49 yrs old)
foreach y in `subgroup' {
	tabout mafm_2549_`y'*  using Tables_Mar_mn.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 
	}
tabout mafm_2549_all1 using Tables_Mar_mn.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 



**************************************************************************************************
* Indicators for sex: excel file Tables_Sex_mn will be produced
**************************************************************************************************

**************************************************************************************************
//Age at first sex by background variables

* percent had sex by specific ages, by age group

*percent married by age 15 
tab mv013 ms_afs_15 if mv013<8  [iw=wt], row nofreq //percent married by age 15, by age
tab ms_afm_15 if mv013>=2 & mv013<8 [iw=wt]	//percent married by age 15, by age, among age 20-49
tab ms_afs_15 if mv013>=3 & mv013<8 [iw=wt]	//percent married by age 15, by age, among age 25-49
tab ms_afm_15 if mv013>=2 [iw=wt]			//percent married by age 15, by age, among age 20-59
tab ms_afs_15 if mv013>=3 [iw=wt]			//percent married by age 15, by age, among age 25-59

tab mv013 ms_afs_18 if mv013>=2 & mv013<8  [iw=wt], row nofreq   //percent married by age 18, by age
tab ms_afs_18 if mv013>=2 & mv013<8 [iw=wt]	//percent married by age 18, by age, among age 20-49
tab ms_afs_18 if mv013>=3 & mv013<8 [iw=wt]	//percent married by age 18, by age, among age 25-49
tab ms_afm_18 if mv013>=2 [iw=wt]			//percent married by age 18, by age, among age 20-59
tab ms_afs_18 if mv013>=3 [iw=wt]			//percent married by age 18, by age, among age 25-59

tab mv013 ms_afs_20 if mv013>=2 & mv013<8  [iw=wt], row nofreq  //percent married by age 20, by age
tab ms_afs_20 if mv013>=2 & mv013<8 [iw=wt]	//percent married by age 20, by age, among age 20-49
tab ms_afs_20 if mv013>=3 & mv013<8 [iw=wt]	//percent married by age 20, by age, among age 25-49
tab ms_afm_20 if mv013>=2 [iw=wt]			//percent married by age 20, by age, among age 20-59
tab ms_afs_20 if mv013>=3 [iw=wt]			//percent married by age 20, by age, among age 25-59

tab mv013 ms_afs_22 if mv013>=3 & mv013<8  [iw=wt], row nofreq  //percent married by age 22, by age
tab ms_afs_22 if mv013>=3 & mv013<8 [iw=wt]	//percent married by age 22, by age, among age 25-49
tab ms_afs_20 if mv013>=3 [iw=wt]			//percent married by age 22, by age, among age 25-59

tab mv013 ms_afs_25 if mv013>=3  [iw=wt], row nofreq  //percent married by age 25, by age
tab ms_afs_25 if mv013>=3 & mv013<8 [iw=wt]	//percent married by age 25, by age, among age 25-49
tab ms_afs_20 if mv013>=3 [iw=wt]			//percent married by age 25, by age, among age 25-59


* output to excel
* percent had sex by specific ages, by age group
tabout mv013 ms_afs_15 using Tables_Sex_mn.xls [iw=wt] , c(row) f(1) replace 
tabout mv013 ms_afs_18 if mv013>1 using Tables_Sex_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afs_20 if mv013>1 using Tables_Sex_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afs_22 if mv013>2 using Tables_Sex_mn.xls [iw=wt] , c(row) f(1) append 
tabout mv013 ms_afs_25 if mv013>2 using Tables_Sex_mn.xls [iw=wt] , c(row) f(1) append 


* percent married by specific ages, among  20-49 and 25-49 year olds
tabout ms_afs_15 ms_afs_18 ms_afs_20 if mv013>=2 & mv013<8 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_afs_15 ms_afs_18 ms_afs_20 if mv013>=2 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_20-59_yr_olds) f(1) append 
tabout ms_afs_15 ms_afs_18 ms_afs_20 ms_afs_22 ms_afs_25 if mv013>=3 & mv013<8 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 
tabout ms_afs_15 ms_afs_18 ms_afs_20 ms_afs_22 ms_afs_25 if mv013>=3 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_25-59_yr_olds) f(1) append 

**************************************************************************************************
//Never had sex by background variables

* never had sex by age group
tab mv013 ms_sex_never  [iw=wt], row nofreq 
tab ms_sex_never if mv013>=2 & mv013<8 [iw=wt] //among 20-49 yr olds
tab ms_sex_never if mv013>=3 & mv013<8 [iw=wt] //among 25-49 yr olds
tab ms_sex_never if mv013>=2 [iw=wt] //among 20-49 yr olds
tab ms_sex_never if mv013>=3 [iw=wt] //among 25-49 yr olds

* output to excel
tabout mv013 ms_sex_never using Tables_sex_mn.xls [iw=wt] , c(row) f(1) append 
tabout ms_sex_never if mv013>=2 & mv013<8 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_20-49_yr_olds) f(1) append 
tabout ms_sex_never if mv013>=3 & mv013<8 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_25-49_yr_olds) f(1) append 
tabout ms_sex_never if mv013>=2 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_20-59_yr_olds) f(1) append 
tabout ms_sex_never if mv013>=3 [iw=wt] using Tables_Sex_mn.xls, oneway c(cell) clab(Among_25-59_yr_olds) f(1) append 

**************************************************************************************************
//Median age at first sex by background variables

*median age at first sex by age group
tabout mafs_1519_all1 mafs_2024_all1 mafs_2529_all1 mafs_3034_all1 mafs_3539_all1 mafs_4044_all1 mafs_4549_all1 mafs_2049_all1 mafs_2549_all1 mafs_2059_all1 mafs_2559_all1 using Tables_Sex_mn.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 

*median age at first sex among 25-49 yr olds, by subgroup
local subgroup residence region education wealth 

*median age by subgroup CHANGE AGE RANGE HERE IF NEEDED (change var from mafm_2549_ to mafm_20-49_ for median age among those age 20-49 yrs old)
foreach y in `subgroup' {
	tabout mafs_2549_`y'*  using Tables_Sex_mn.xls [iw=wt] , oneway  c(cell) f(1) ptotal(none)  append 
	}
}	
