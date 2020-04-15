/*****************************************************************************************************
Program: 			          FF_tables.do
Purpose: 			          produce tables for indicators of fertility preferences chapter
Author:				          Faduma Shaba
Date last modified:     April 2020
*Note this do file will produce the following tables in excel:
	1. 	Tables_Pref_wm:	Contains tables for fertility preferences for women 
	2. 	Tables_Pref_mn:	Contains tables for fertility preferences for men 
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

**************************************************************************************************
* Indicators for fertilty preferences
**************************************************************************************************

//Want no more children

replace kiddesire=0 if kiddesire!=40
label define kiddesire 0 "Wants no more kids" 1 "Wants more kids"
label values kiddesire kiddesire

* Residence
tab	urban kiddesire [iw=perweight] , col 

* Education
tab	educlvl kiddesire [iw=perweight] , col

*Weatlh quintle
tab	wealthq kiddesire [iw=perweight] , col


* output to excel
*urban
tabout urban kiddesire using Tables_Pref_wm.xls [iw=perweight] , c(col) h1("urban") f(1) append 
*education
tabout educlvl kiddesire using Tables_Pref_wm.xls [iw=perweight] , c(col)  h1("higher education") f(1) append 
*wealth
tabout wealthq kiddesire using Tables_Pref_wm.xls [iw=perweight] , c(col) h1("hightest wealth quintile") f(1) append 

****************************************************
//Ideal number of children

* by number of living children
tab	ff_ideal_num numch [iw=wt] , col

* output to excel
tabout ff_ideal_num numch using Tables_Pref_wm.xls [iw=wt] , c(col) f(1) append 
*/

* mean ideal number of children for all women 14-59
ta ff_ideal_mean_all

* to obtain mean ideal number of children for all women 15-49 and by number of children
bysort numch: sum v613 if v613<95 [iw=wt]

*output to excel
* all women 15-49
tabout numch if v613<95 using Tables_Pref_wm.xls [fw=v005] , clab("all_women_15_49") oneway sum cells(mean v613) f(1) append 

* mean ideal number of children for married women 15-49
ta ff_ideal_mean_mar

* to obtain mean ideal number of children for all women 15-49 and by number of children
bysort numch: sum v613 if v613<95 & v502==1 [iw=wt]

*output to excel
* married women 15-49
tabout numch if v613<95 & v502==1 using Tables_Pref_wm.xls [fw=v005] , clab("mar_women_15_49") oneway sum cells(mean v613) f(1) append 

******
* For table of mean indeal number of children by background variable

*age
bysort v013: sum v613 if v613<95 [iw=wt]

*residence
bysort v025: sum v613 if v613<95 [iw=wt]

*region
bysort v024: sum v613 if v613<95 [iw=wt]

*education
bysort v106: sum v613 if v613<95 [iw=wt]

*wealth quintle
bysort v190: sum v613 if v613<95 [iw=wt]

tabout v013 v025 v024 v106 v190 if v613<95 using Tables_Pref_wm.xls [fw=v005] , oneway clab("all_women_15_49") sum cells(mean v613) f(1) append 

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {

gen wt=mv005/1000000

**************************************************************************************************
* Indicators for fertilty preferences
**************************************************************************************************
//Type of desire for children
* tabulate by number of living children which includes currrent pregnancy for wife
gen numch=mv218
replace numch=numch+1 if mv213==1
replace numch=6 if numch>6
label define numch 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6+"
label values numch numch
label var numch "number of living children"

tab	ff_want_type numch [iw=wt] , col

* output to excel
tabout ff_want_type numch using Tables_Pref_mn.xls [iw=wt] , c(col) f(1) replace 
*/
****************************************************

//Want no more children
* Residence
*urban
tab	ff_want_nomore numch if mv025==1 [iw=wt] , col
*rural
tab	ff_want_nomore numch if mv025==2 [iw=wt] , col

* Education
*none
tab	ff_want_nomore numch if mv106==0 [iw=wt] , col
*primary
tab	ff_want_nomore numch if mv106==1 [iw=wt] , col
*secondary
tab	ff_want_nomore numch if mv106==2 [iw=wt] , col
*higher
tab	ff_want_nomore numch if mv106==3 [iw=wt] , col

*Weatlh quintle
*lowest
tab	ff_want_nomore numch if mv190==1 [iw=wt] , col
*second
tab	ff_want_nomore numch if mv190==2 [iw=wt] , col
*middle
tab	ff_want_nomore numch if mv190==3 [iw=wt] , col
*fourth
tab	ff_want_nomore numch if mv190==4 [iw=wt] , col
*highest
tab	ff_want_nomore numch if mv190==5 [iw=wt] , col


* output to excel
*urban
tabout ff_want_nomore numch if mv025==1 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("urban") f(1) append 
*rural
tabout ff_want_nomore numch if mv025==2 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("rural") f(1) append 
*no education
tabout ff_want_nomore numch if mv106==0 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("no education") f(1) append 
*primary education 
tabout ff_want_nomore numch if mv106==1 using Tables_Pref_mn.xls [iw=wt] , c(col)  h1("primary education") f(1) append 
*secondary
tabout ff_want_nomore numch if mv106==2 using Tables_Pref_mn.xls [iw=wt] , c(col)  h1("secondary education") f(1) append 
*higher
tabout ff_want_nomore numch if mv106==3 using Tables_Pref_mn.xls [iw=wt] , c(col)  h1("higher education") f(1) append 
*lowest wealth quintle
tabout ff_want_nomore numch if mv190==1 using Tables_Pref_mn.xls [iw=wt] , c(col)  h1("lowest wealth quintile") f(1) append 
* second
tabout ff_want_nomore numch if mv190==2 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("second wealth quintile") f(1) append 
* middle
tabout ff_want_nomore numch if mv190==3 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("middle wealth quintile") f(1) append 
*fourth
tabout ff_want_nomore numch if mv190==4 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("fourth wealth quintile") f(1) append 
*highest
tabout ff_want_nomore numch if mv190==5 using Tables_Pref_mn.xls [iw=wt] , c(col) h1("hightest wealth quintile") f(1) append 

*Total
tabout ff_want_nomore numch using Tables_Pref_mn.xls [iw=wt] , c(col) f(1) append 

*/
****************************************************
//Ideal number of children
tab	ff_ideal_num numch [iw=wt] , col

* output to excel
tabout ff_ideal_num numch using Tables_Pref_mn.xls [iw=wt] , c(col) f(1) append 
*/
****************************************************

* mean ideal number of children for all men 14-59
ta ff_ideal_mean_all

* to obtain mean ideal number of children for all men 15-49 and by number of children
bysort numch: sum mv613 if mv613<95 [iw=wt]

* mean ideal number of children for married men 15-49
ta ff_ideal_mean_all

* to obtain mean ideal number of children for all men 15-49 and by number of children
bysort numch: sum mv613 if mv613<95 & mv502==1 [iw=wt]

*output to excel
* all men 15-49
tabout numch if mv613<95 using Tables_Pref_mn.xls [fw=mv005] , clab("all_men_15_49") oneway sum cells(mean mv613) f(1) append 

*output to excel
* married men 15-49
tabout numch if mv613<95 & mv502==1 using Tables_Pref_mn.xls [fw=mv005] , clab("mar_men_15_49") oneway sum cells(mean mv613) f(1) append 
****************************************************
}
