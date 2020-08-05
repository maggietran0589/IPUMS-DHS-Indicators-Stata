/*****************************************************************************************************
Program: 			IPUMS_NT_MN_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in men
Data inputs: 			IPUMS DHS Men’s Variables
Data outputs:			coded variables
Author:			  Faduma Shaba
Date last modified: 		August 2020 by Faduma Shaba 
Note:				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on “Men” for the unit of analysis
Select the country samples and years that you will be using then include all the “Children’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:
perweightmn		Men's sample weight
hwmhemolevelalt		"Hemoglobin level adjusted by altitude (male household members)	"
hhslept		Slept last night in HH
hhemoselec		"Household selected for hemoglobin	"
hwmhemotest		"Whether hemoglobin level tested (male household members)	"
hwmbmi		"Body mass index (BMI) (male household members)	"
age5yearmn		"Age in 5-year groups	"
----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_mn_any_anem		"Any anemia - men"
nt_mn_bmi_mean		"Mean BMI  - men 15-49"
nt_mn_bmi_mean_all 	"Mean BMI  - all men"
nt_mn_norm			"Normal BMI - men"
nt_mn_thin			"Thin BMI - men"
nt_mn_mthin			"Mildly thin BMI  - men"
nt_mn_modsevthin	"Moderately and severely thin BMI - men"
nt_mn_ovobese		"Overweight or obese BMI  - men"
nt_mn_ovwt			"Overweight BMI  - men"
nt_mn_obese			"Obese BMI  - men"
----------------------------------------------------------------------------*/

*Changing Household variables to only include household members
by idhshid, sort: gen nvals=_n==1
count if nvals
keep if nvals==1 

cap label define yesno 0"No" 1"Yes"
gen wt=perweightmn

*** Anemia indicators ***

//Any anemia
gen nt_mn_any_anem=0 
replace nt_mn_any_anem=1 if hwmhemolevelalt<130 
replace nt_mn_any_anem=. if hhslept==0 | hhemoselec!=1 | hwmhemotest!=0
label values nt_mn_any_anem yesno
label var nt_mn_any_anem "Any anemia - men"

*** Anthropometry indicators ***

//Mean BMI - men 15-49
gen bmi=hwmbmi/100
summarize bmi if inrange(bmi,12,60) & age5yearmn<8 [iw=wt]
gen nt_mn_bmi_mean=round(r(mean),0.1)
label var nt_mn_bmi_mean "Mean BMI  - men 15-49"

//Mean BMI - all men
summarize bmi if inrange(bmi,12,60) [iw=wt]
gen nt_mn_bmi_mean_all=round(r(mean),0.1)
label var nt_mn_bmi_mean_all "Mean BMI  - all men"

//Normal weight
gen nt_mn_norm= inrange(hwmbmi,1850,2499) if inrange(hwmbmi,1200,6000)
label values nt_mn_norm yesno
label var nt_mn_norm "Normal BMI - men"

//Thin
gen nt_mn_thin= inrange(hwmbmi,1200,1849) if inrange(hwmbmi,1200,6000)
label values nt_mn_thin yesno
label var nt_mn_thin "Thin BMI - men"

//Mildly thin
gen nt_mn_mthin= inrange(hwmbmi,1700,1849) if inrange(hwmbmi,1200,6000)
label values nt_mn_mthin yesno
label var nt_mn_mthin "Mildly thin BMI  - men"

//Moderately and severely thin
gen nt_mn_modsevthin= inrange(hwmbmi,1200,1699) if inrange(hwmbmi,1200,6000)
label values nt_mn_modsevthin yesno
label var nt_mn_modsevthin "Moderately and severely thin BMI - men"

//Overweight or obese
gen nt_mn_ovobese= inrange(hwmbmi,2500,6000) if inrange(hwmbmi,1200,6000)
label values nt_mn_ovobese yesno
label var nt_mn_ovobese "Overweight or obese BMI  - men"

//Overweight
gen nt_mn_ovwt= inrange(hwmbmi,2500,2999) if inrange(hwmbmi,1200,6000)
label values nt_mn_ovwt yesno
label var nt_mn_ovwt "Overweight BMI  - men"

//Obese
gen nt_mn_obese= inrange(hwmbmi,3000,6000) if inrange(hwmbmi,1200,6000)
label values nt_mn_obese yesno
label var nt_mn_obese "Obese BMI  - men"
