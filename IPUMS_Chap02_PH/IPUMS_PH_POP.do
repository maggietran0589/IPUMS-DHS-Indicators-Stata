/*****************************************************************************************************
Program: 			IPUMS_PH_POP.do
Purpose: 			Code to compute population characteristics, birth registration, education levels, household composition, orphanhood, and living arrangments
Data inputs: 			IPUMS DHS Variables
Data outputs:			coded variables
Author:			       	Faduma Shaba
Date last modified: 		May 2020 
Note:				In line 244 the code will collapse the data and therefore some indicators produced will be lost. However, they are saved in the file PR_temp_children.dta and this data file will be used to produce the tables for these indicators in the PH_table code. This code will produce the Tables_hh_comps for household composition. 
*****************************************************************************************************/

/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the IPUMS variables listed below.
	 
2. On lines 324 and 327 below, replace "GEO-REGION" with your sample's region variable name. 
	In IPUMS DHS, each survey's region variable has a unique name to facilitate 
	pooling data. These variables can be found in the IPUMS drop down menu under:
		GEOGRAPHY -> SINGLE SAMPLE GEOGRAPHY */

/*----------------------------------------------------------------------------
IPUMS Variables used in this file:
5yearagehh		"De facto population by five-year age groups"
dependagehh		"De facto population by dependency age groups"
childagehh		"De facto population by child and adult populations"
adolescentagehh		"De factor population that are adolesents"
birthrregcerthh		"Child under 5 with registered birth and birth certificate"
birthnoregcerthh	"Child under 5 with registered birth and no birth certificate"
ph_birthreg		"Child under 5 with registered birth"
edsumm			"Highest level of schooling attended or completed among those age 6 or over"
edu_medianfm 		"Median years of education among those age 6 or over - Females"
edu_medianman 		"Median years of education among those age 6 or over - Males"
ph_wealth_quint		"Wealth quintile - dejure population"
ph_chld_liv_noprnt	"Child under 18 not living with a biological parent"
ph_chld_orph		"Child under 18 with one or both parents dead"
ph_hhhead_sex		"Sex of household head"
ph_num_members		"Number of usual household members"
ph_orph_double		"Double orphans under age 18"
ph_orph_single		"Single orphans under age 18"
ph_foster		"Foster children under age 18"
ph_orph_foster		"Orphans and/or foster children under age 18"
----------------------------------------------------------------------------*/
Created Variables
ph_chld_liv_arrang	"Living arrangement and parents survival status for child under 18"

----------------------------------------------------------------------------*/


cap label define yesno 0"No" 1"Yes"

*** Population characteristics ***

gen ager=int(hhage/5)

//Five year age groups
recode ager (0=0 " <5") (1=1 " 5-9") (2=2 " 10-14") (3=3  " 15-19") (4=4 " 20-24") (5=5 " 25-29") (6=6 "30-34") ///
	    (7=7 " 35-39") (8=8 " 40-44") (9=9 " 45-49") (10=10 " 50-54") (11=11 " 55-59") (12=12 " 60-64") ///
	    (13=13 " 65-69") (14=14 " 70-74") (15=15 " 75-79") (16/19=16 " 80+"), gen(5yearagehh)
label var 5yearagehh "De facto population by five-year age groups"

//Dependency age groups
recode ager(0/2=1 " 0-14") (3/12=2 " 15-64") (13/18=3 " 65+") (19/max=98 "Don't know/missing"), gen(dependagehh)
label var dependagehh "De facto population by dependency age groups"

//Child and adult populations
recode hhage (0/17=1 " 0-17") (18/97=2 " 18+"), gen(childagehh)
label var ph_pop_cld_adlt "De facto population by child and adult populations"

//Adolescent population
recode adolescenthh (10/19=1 " Adolescents") (else=0 " not adolesents"), gen(adolescentagehh)
label var ph_pop_adols "De factor population that are adolesents"

*** Birth registration ***

//Child registered and with birth certificate
gen birthregcerthh= hhbirthcert==11 if hhage < 5
label values birthrregcerthh yesno	
label var birthrregcerthh "Child under 5 with registered birth and birth certificate"

//Child registered and with no birth certificate
gen birthnoregcerthh= hhbirthcert==12 if hhage < 5
label values birthnoregcerthh yesno
label var birthregnocerthh "Child under 5 with registered birth and no birth certificate"

//Child is registered
gen birthreghh= hhbirthcert if hhbirthcert== 11 | hhbirthcert==12 & if hhage < 5
label values birthreghh yesno
label var birthreghh "Child under 5 with registered birth"

*** Wealth quintile ***

replace wealthqhh=. if wealthqhh > 7

*** Education levels ***

//Highest level of schooling attended or completed
replace edsumm=. if edsumm > 7

//Median years of education - Females
replace edyrtotal=. if edyrtotal > 97
replace edyrtotal=20 if edyrtotal>20 & edyrtotal<95

summarize edyrtotal if sex==1 [iw=perweight], detail
*summarize saves the data in the r()store
scalar sp50=r(p50)
*This saves a scalar-sp50- as the 50th percentile in the edyrtotal r store.

	gen dummy=.
	replace dummy=0
	replace dummy=1 if edyrtotal<sp50
	*This makes all edyrtotal over the median (sp50) = the categorical binary 1
	summarize dummy [iw=perweight]
	scalar sL=r(mean)
	*This saves a scalar-sL- as the mean in the edyrtotal r store.
	drop dummy

	gen dummy=.
	replace dummy=0
	replace dummy=1 if eduyr <=sp50
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen edu_medianfm=round(sp50-1+(.5-sL)/(sU-sL),.01)
	label var edu_medianfm	"Median years of education"
	
//Median years of education - Males
replace edyrtotal=. if edyrtotal > 97
replace edyrtotal=20 if edyrtotal>20 & edyrtotal<95

summarize edyrtotal if sex==1 [iw=perweight], detail
*summarize saves the data in the r()store
scalar sp50=r(p50)
*This saves a scalar-sp50- as the 50th percentile in the edyrtotal r store.

	gen dummy=.
	replace dummy=0
	replace dummy=1 if edyrtotal<sp50
	*This makes all edyrtotal over the median (sp50) = the categorical binary 1
	summarize dummy [iw=perweight]
	scalar sL=r(mean)
	*This saves a scalar-sL- as the mean in the edyrtotal r store.
	drop dummy

	gen dummy=.
	replace dummy=0
	replace dummy=1 if eduyr <=sp50
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen edu_medianman=round(sp50-1+(.5-sL)/(sU-sL),.01)
	label var edu_medianman	"Median years of education"

*** Living arrangments ***

* IMPORTANT: Children must be de jure residents AND coresidence with parents requires that
* the parents are also de jure residents

* add a code 99 to hv112 if the mother is in the hh but is not de jure
* add a code 99 to hv114 if the mother is in the hh but is not de jure

* Preparing files to produce the indicators, this required several merges

keep hv001 hv002 hvidx hv005 hv009 hv024 hv025 hv101-hv105 hv111-hv114 hv270 ph_*
save PR_temp.dta, replace

* Prepare a file of potential mothers
use PR_temp.dta, clear
drop if sex==1
drop if hhage<15 & hhage > 97
keep hv001 hv002 hvidx hv102
gen in_mothers=1
rename hv102 hv102_mo
rename hvidx hv112
sort hv001 hv002 hv112
save PR_temp_mothers.dta, replace

* Prepare a file of potential fathers
use PR_temp.dta, clear
drop if hv104==2
drop if hv105<15
keep hv001 hv002 hvidx hv102
gen in_fathers=1
rename hv102 hv102_fa
rename hvidx hv114
sort hv001 hv002 hv114
save PR_temp_fathers.dta, replace

* Prepare file of children for merges
use PR_temp.dta, clear
drop if hv102==0
drop if hv105>17
gen in_children=1

* Merge children with potential mothers
sort hv001 hv002 hv112
merge hv001 hv002 hv112 using PR_temp_mothers.dta
rename _merge _merge_child_mother

* Merge children with potential fathers
sort hv001 hv002 hv114
merge hv001 hv002 hv114 using PR_temp_fathers.dta
rename _merge _merge_child_father

gen hv112r=hv112
gen hv114r=hv114

* Code 99 of the mother or father is not de jure
replace hv112r=99 if hv112>0 & hv102_mo==0
replace hv114r=99 if hv114>0 & hv102_fa==0

keep if in_children==1
drop in_* _merge*

label define HV112R 0 "Mother not in household" 99 "In hh but not de jure"
label define HV114R 0 "Father not in household" 99 "In hh but not de jure"

label values hv112r HV112R
label values hv114r HV114R

tab1 hv112r hv114r

//Living arrangement for children under 18
gen orphan_type=.
replace orphan_type=1 if motheralive==1 & fatheralive==1
replace orphan_type=2 if motheralive==1 & fatheralive==0
replace orphan_type=3 if motheralive==0 & fatheralive==1
replace orphan_type=4 if motheralive==0 & fatheralive==0
replace orphan_type=5 if motheralive==8  | fatheralive==8

gen cores_type=.
replace cores_type=1 if motherlineno==1  & fatherlineno==1
replace cores_type=2 if motherlineno==1  & fatherlineno==0
replace cores_type=3 if motherlineno==0 & fatherlineno==1
replace cores_type=4 if motherlineno==0 & fatherlineno==0

gen ph_chld_liv_arrang=.
replace ph_chld_liv_arrang=1  if cores_type==1
replace ph_chld_liv_arrang=2  if cores_type==2 & (orphan_type==1 | orphan_type==3)  
replace ph_chld_liv_arrang=3  if cores_type==2 & (orphan_type==2 | orphan_type==4)
replace ph_chld_liv_arrang=4  if cores_type==3 & (orphan_type==1 | orphan_type==2)
replace ph_chld_liv_arrang=5  if cores_type==3 & (orphan_type==3 | orphan_type==4)
replace ph_chld_liv_arrang=6  if cores_type==4 & orphan_type==1
replace ph_chld_liv_arrang=7  if cores_type==4 & orphan_type==3
replace ph_chld_liv_arrang=8  if cores_type==4 & orphan_type==2
replace ph_chld_liv_arrang=9  if cores_type==4 & orphan_type==4
replace ph_chld_liv_arrang=10 if orphan_type==5

#delimit ;
label define orphan_type 1 "Both parents alive" 2 "Mother alive, father dead" 
3 "Father alive, mother dead" 4 "Both parents dead" 5 "Missing";

label define cores_type 1 "Living with both parents" 2 "With mother, not father" 
3 "With father, not mother" 4 "Living with neither parent";

label define ph_chld_liv_arrang 1 "With both parents" 2 "With mother only, father alive" 
3 "With mother only, father dead" 4 "With father only, mother alive" 
5 "With father only, mother dead" 6 "With neither, both alive" 
7 "With neither, only father alive" 8 "With neither, only mother alive" 
9 "With neither, both dead" 10 "Survival info missing"; 
#delimit cr

label values orphan_type orphan_type
label values cores_type cores_type
label values ph_chld_liv_arrang ph_chld_liv_arrang
label var ph_chld_liv_arrang	"Living arrangment and parents survival status for child under 18"

//Child under 18 not living with either parent
gen     ph_chld_liv_noprnt=0
replace ph_chld_liv_noprnt=1 if ph_chld_liv_arrang>=6 & ph_chld_liv_arrang<=9 
label values ph_chld_liv_noprnt yesno
label var ph_chld_liv_noprnt	"Child under 18 not living with a biological parent"

//Child under 18 with one or both parents dead
gen     ph_chld_orph=0
replace ph_chld_orph=1 if motheralive==0 | fatheralive==0
label values ph_chld_orph yesno
label var ph_chld_orph "Child under 18 with one or both parents dead"


*** Orphanhood ***

//Double orphan: both parents dead
gen     ph_orph_double=0
replace ph_orph_double=1 if motheralive==0 & fatheralive==0

//Single orphan: one parent dead 
gen     ph_orph_single=0
replace ph_orph_single=1 if ph_chld_orph==1 & ph_orph_double==0

//Foster child: not living with a parent but one or more parents alive
gen     ph_foster=0
replace ph_foster=1 if cores_type==4 

//Foster child and/or orphan
gen     ph_orph_foster=0
replace ph_orph_foster=1 if ph_foster==1 | ph_orph_single==1 | ph_orph_double==1

sort clusternoall hhnumall hhlineno
save PR_temp_children.dta, replace

*** Household characteristics *** 
*  Warning, this code will collapse the data and therefore the indicators produced will be lost. However, they are saved in the file PR_temp2_children.dta 

use PR_temp.dta, clear
keep if hhresident==1
sort clusternoall hhnumall hhlineno
merge clusternoall hhnumall hhlineno using PR_temp_children.dta
drop _merge

//Household size
gen n=1
egen hhsize=count(n), by(clusternoall hhnumall)
gen     ph_num_members=hhsize
replace ph_num_members=9 if hhsize>9 

* Sort to be sure that the head of the household (with hhrelate=1) is the first person listed in the household
sort clusternoall hhnumall hhrelate

* Reduce to one record per household, that of the hh head
collapse (first) hhweight hhsize ph_num_members sex urbanhh GEO-REGION (sum) ph_orph_double ph_orph_single ph_foster ph_orph_foster, by(clusternoall hhnumall)

* re-attach labels after collapse
label values GEO-REGION GEO-REGION
label values urbanhh Urbanhh
label values sex Sex

label define ph_num_members 1"1" 2"2" 3"3" 4"4" 5"5" 6"6" 7"7" 8"8" 9"9+"
label values ph_num_members ph_num_members

replace ph_foster=1 if ph_foster>1 
replace ph_orph_foster=1 if ph_orph_foster>1 
replace ph_orph_single=1 if ph_orph_single>1 
replace ph_orph_double=1 if ph_orph_double>1 

cap label define yesno 0"No" 1"Yes"

label values ph_foster yesno
label values ph_orph_foster yesno
label values ph_orph_single yesno
label values ph_orph_double yesno

label var ph_orph_foster "Orphans and/or foster children under age 18"
label var ph_foster "Foster children under age 18"
label var ph_orph_single "Single orphans under age 18"
label var ph_orph_double "Double orphans under age 18"

label var urbanhh "type of place of residence"

//Sex of household head
rename sex ph_hhhead_sex
label var ph_hhhead_sex "Sex of household head"

****************************************************

*** Table for household composition ***

gen wt = hhweight/1000000

//Household headship and and 
tab ph_hhhead_sex urbanhh [iw=perweight], col
* export to excel
tabout ph_hhhead_sex urbanhh using Tables_hh_comps.xls [iw=perweight] , c(col) f(1) replace 

// Number of usual members
tab ph_num_members urbanhh [iw=perweight], col
* export to excel
tabout  ph_num_members urbanhh using Tables_hh_comps.xls [iw=perweight] , c(col) f(1) append 

//Mean household size; use fweight
tab urbanhh [fweight=hhweight], summarize(hhsize) means
* export to excel
tabout urbanhh using Tables_hh_comps.xls [fweight=hhweight], oneway cells(mean hhsize) sum append

//Percentage of households with orphans and foster children under 18
local lvars ph_orph_double ph_orph_single ph_foster ph_orph_foster
foreach lv of local lvars {
tab `lv' urbanhh [iweight=hhweight/1000000], col
tabout `lv' urbanhh using Tables_hh_comps.xls [iw=perweight] , c(col) f(1) append 
}

****************************************************

*erase unnessary temp files
erase PR_temp_fathers.dta
erase PR_temp_mothers.dta
