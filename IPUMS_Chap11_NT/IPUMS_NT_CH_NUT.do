/*****************************************************************************************************
Program: 		IPUMS_NT_CH_NUT.do
Purpose: 		Code to compute anthropometry and anemia indicators in children
Data inputs: 		IPUMS DHS Household Member’s Variables
Data outputs:		coded variables
Author:		Faduma Shaba
Date last modified: 	August 2020 by Faduma Shaba 
Note:				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
Begin by going to dhs.ipums.org and click on “Household Members” for the unit of analysis
Select the country samples and years that you will be using then include all the “Household Member’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:

kidcuragemo		“Current age of child in months”
hhweight		“Household sample weight (6 decimals)”
hhslept		“Slept last night in HH”
hwchazwho		“Height for age standard deviations (new WHO) (members under age 5)”
hwcwhzwho		"Weight for height standard deviations (new WHO) (members under age 5)"
hwcwazwho		“Weight for age standard deviations (new WHO) (members under age 5)”
agemohhlt5		"Age in months (members under age 5)"
linenomomhhlt5	"Mother's line number (woman's questionnaire) (members under age 5)"
"hemolevelalthhlt5	"Hemoglobin level adjusted for altitude (members under age 5)
----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_ch_sev_stunt		"Severely stunted child under 5 years"
nt_ch_stunt			"Stunted child under 5 years"
nt_ch_mean_haz		"Mean z-score for height-for-age for children under 5 years"
nt_ch_sev_wast		"Severely wasted child under 5 years"
nt_ch_wast			"Wasted child under 5 years"
nt_ch_ovwt_ht		"Overweight for heigt child under 5 years"
nt_ch_mean_whz		"Mean z-score for weight-for-height for children under 5 years"
nt_ch_sev_underwt	"Severely underweight child under 5 years"
nt_ch_underwt		"Underweight child under 5 years"
nt_ch_ovwt_age		"Overweight for age child under 5 years"
nt_ch_mean_waz		"Mean weight-for-age for children under 5 years"
	
nt_ch_any_anem		"Any anemia - child 6-59 months"
nt_ch_mild_anem		"Mild anemia - child 6-59 months"
nt_ch_mod_anem		"Moderate anemia - child 6-59 months"
nt_ch_sev_anem		"Severe anemia - child 6-59 months"
----------------------------------------------------------------------------*/


*Changing Household variables to only include household members
by idhshid, sort: gen nvals=_n==1
count if nvals
keep if nvals==1 

cap label define yesno 0"No" 1"Yes"
gen wt= hhweight

*** Anthropometry indicators ***

//Severely stunted
gen nt_ch_sev_stunt= 0 if hhslept==1
replace nt_ch_sev_stunt=. if hwchazwho>=9996
replace nt_ch_sev_stunt=1 if hwchazwho<-300 & hhslept==1 
label values nt_ch_sev_stunt yesno
label var nt_ch_sev_stunt "Severely stunted child under 5 years"

//Stunted
gen nt_ch_stunt= 0 if hhslept==1
replace nt_ch_stunt=. if hwchazwho>=9996
replace nt_ch_stunt=1 if hwchazwho<-200 & hhslept==1 
label values nt_ch_stunt yesno
label var nt_ch_stunt "Stunted child under 5 years"

//Mean haz
gen haz=hwchazwho/100 if hwchazwho<996
summarize haz if hhslept==1 [iw=wt]
gen nt_ch_mean_haz=round(r(mean),0.1)
label var nt_ch_mean_haz "Mean z-score for height-for-age for children under 5 years"

//Severely wasted 
gen nt_ch_sev_wast= 0 if hhslept==1
replace nt_ch_sev_wast=. if hwcwhzwho>=9996
replace nt_ch_sev_wast=1 if hwcwhzwho<-300 & hhslept==1 
label values nt_ch_sev_wast yesno
label var nt_ch_sev_wast "Severely wasted child under 5 years"

//Wasted
gen nt_ch_wast= 0 if hhslept==1
replace nt_ch_wast=. if hwcwhzwho>=9996
replace nt_ch_wast=1 if hwcwhzwho<-200 & hhslept==1 
label values nt_ch_wast yesno
label var nt_ch_wast "Wasted child under 5 years"

//Overweight for height
gen nt_ch_ovwt_ht= 0 if hhslept==1
replace nt_ch_ovwt_ht=. if hwcwhzwho>=9996
replace nt_ch_ovwt_ht=1 if hwcwhzwho>200 & hwcwhzwho<9996 & hhslept==1 
label values nt_ch_ovwt_ht yesno
label var nt_ch_ovwt_ht "Overweight for height child under 5 years"

//Mean whz
gen whz=hwcwhzwho/100 if hwcwhzwho<996
summarize whz if hhslept==1 [iw=wt]
gen nt_ch_mean_whz=round(r(mean),0.1)
label var nt_ch_mean_whz "Mean z-score for weight-for-height for children under 5 years"

//Severely underweight
gen nt_ch_sev_underwt= 0 if hhslept==1
replace nt_ch_sev_underwt=. if hwcwazwho>=9996
replace nt_ch_sev_underwt=1 if hwcwazwho<-300 & hhslept==1 
label values nt_ch_sev_underwt yesno
label var nt_ch_sev_underwt	"Severely underweight child under 5 years"

//Underweight
gen nt_ch_underwt= 0 if hhslept==1
replace nt_ch_underwt=. if hwcwazwho>=9996
replace nt_ch_underwt=1 if hwcwazwho<-200 & hhslept==1 
label values nt_ch_underwt yesno
label var nt_ch_underwt "Underweight child under 5 years"

//Overweight for age
gen nt_ch_ovwt_age= 0 if hhslept==1
replace nt_ch_ovwt_age=. if hwcwazwho>=9996
replace nt_ch_ovwt_age=1 if hwcwazwho>200 & hwcwazwho<9996 & hhslept==1 
label values nt_ch_ovwt_age yesno
label var nt_ch_ovwt_age "Overweight for age child under 5 years"

//Mean waz
gen waz=hwcwazwho/100 if hwcwazwho<996
summarize waz if hhslept==1 [iw=wt]
gen nt_ch_mean_waz=round(r(mean),0.1)
label var nt_ch_mean_waz "Mean weight-for-age for children under 5 years"

*** Anemia indicators ***

//Any anemia
gen nt_ch_any_anem=0 if hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_any_anem=1 if hemolevelalthhlt5<110 & hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_any_anem=. if hemolevelalthhlt5==.
label values nt_ch_any_anem yesno
label var nt_ch_any_anem "Any anemia - child 6-59 months"

//Mild anemia
gen nt_ch_mild_anem=0 if hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_mild_anem=1 if hemolevelalthhlt5>99 & hemolevelalthhlt5<110 & hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_mild_anem=. if hemolevelalthhlt5==.
label values nt_ch_mild_anem yesno
label var nt_ch_mild_anem "Mild anemia - child 6-59 months"

//Moderate anemia
gen nt_ch_mod_anem=0 if hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_mod_anem=1 if hemolevelalthhlt5>69 & hemolevelalthhlt5<100 & hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_mod_anem=. if hemolevelalthhlt5==.
label values nt_ch_mod_anem yesno
label var nt_ch_mod_anem "Moderate anemia - child 6-59 months"

//Severe anemia
gen nt_ch_sev_anem=0 if hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_sev_anem=1 if hemolevelalthhlt5<70 & hhslept==1 & agemohhlt5>5 & agemohhlt5<60
replace nt_ch_sev_anem=. if hemolevelalthhlt5==.
label values nt_ch_sev_anem yesno
label var nt_ch_sev_anem "Severe anemia - child 6-59 months"
