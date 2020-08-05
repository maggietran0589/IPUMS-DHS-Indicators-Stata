/*****************************************************************************************************
Program: 			IPUMS_NT_WM_NUT.do
Purpose: 			Code to compute anthropometry and anemia indicators in women
Data inputs: 			IPUMS DHS Women’s Variables
Data outputs:			coded variables
Author:			Faduma Shaba
Date last modified: 		August 2020 by Faduma Shaba 
Note:				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on “Women” for the unit of analysis
Select the country samples and years that you will be using then include all the “Women’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:
perweightmn		Sample weight for persons
hemoselect		"Household selected for hemoglobin measurements	"
biofhemotest		"Whether hemoglobin level tested (respondents to women's survey)	"
biofhemolevelalt		"Hemoglobin level (g/dl) adjusted for altitude (respondents to women's survey)	"
pregnant		"Currently pregnant	"
biofanemialvl		"Anemia level (respondents to women's survey)	"
intdatecmc		Century month date of interview
kiddobcmc_01		Date of birth of most recent child(CMC)
kidcuragemo_01		Current age of most recent child in months
heightfem		"Height of woman in centimeters	"
biofhemotest		"Whether hemoglobin level tested (respondents to women's survey)	"
birthsin5yrs		"Number of births in last 5 years	"
anirond_01		Days antenatal iron supplement taken for most recent birth
aniron_01		Antenatal care: Took iron tablets/syrup during pregnancy for most recent birth
saltest3		Summary result of salt test for iodine

----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_wm_any_anem		"Any anemia - women"
nt_wm_mild_anem		"Mild anemia - women"
nt_wm_mod_anem		"Moderate anemia - women"
nt_wm_sev_anem		"Severe anemia - women"
nt_wm_ht			"Height under 145cm - women"	
nt_wm_bmi_mean		"Mean BMI  - women"
nt_wm_norm			"Normal BMI - women"
nt_wm_thin			"Thin BMI - women"
nt_wm_mthin			"Mildly thin BMI  - women"
nt_wm_modsevthin	"Moderately and severely thin BMI - women"
nt_wm_ovobese		"Overweight or obese BMI  - women"
nt_wm_ovwt			"Overweight BMI  - women"
nt_wm_obese			"Obese BMI  - women"
nt_wm_micro_iron	"Number of days women took iron supplements during last pregnancy"
nt_wm_micro_dwm		"Women who took deworming medication during last pregnancy"
nt_wm_micro_iod		"Women living in hh with iodized salt"
----------------------------------------------------------------------------*/

*Changing Household variables to only include household members
by idhshid, sort: gen nvals=_n==1
count if nvals
keep if nvals==1 

cap label define yesno 0"No" 1"Yes"
gen wt=perweightmn


*** Anemia indicators ***

//Any anemia
gen nt_wm_any_anem=0 if hemoselect==1 & biofhemotest==0
replace nt_wm_any_anem=1 if (biofhemolevelalt<120 & pregnant==0) | (biofhemolevelalt<110 & pregnant==1)
label values nt_wm_any_anem yesno
label var nt_wm_any_anem "Any anemia - women"

//Mild anemia
gen nt_wm_mild_anem=0 if hemoselect==1 & biofhemotest==0
replace nt_wm_mild_anem=1 if (inrange(biofhemolevelalt,100,119) & pregnant==0) | (inrange(biofhemolevelalt,100,109) & pregnant==1)
label values nt_wm_mild_anem yesno
label var nt_wm_mild_anem "Mild anemia - women"

//Moderate anemia
gen nt_wm_mod_anem=0 if hemoselect==1 & biofhemotest==0
replace nt_wm_mod_anem=1 if biofanemialvl==2
label values nt_wm_mod_anem yesno
label var nt_wm_mod_anem "Moderate anemia - women"

//Severe anemia
gen nt_wm_sev_anem=0 if hemoselect==1 & biofhemotest==0
replace nt_wm_sev_anem=1 if biofanemialvl==1
label values nt_wm_sev_anem yesno
label var nt_wm_sev_anem "Severe anemia - women"

*** Anthropometry indicators ***

* age of most recent child
gen age = intdatecmc - kiddobcmc_01
	
	* to check if survey has b19, which should be used instead to compute age. 
	scalar b19_included=1
		capture confirm numeric variable kidcuragemo_01, exact 
		if _rc>0 {
		* b19 is not present
		scalar b19_included=0
		}
		if _rc==0 {
		* b19 is present; check for values
		summarize kidcuragemo_01
		  if r(sd)==0 | r(sd)==. {
		  scalar b19_included=0
		  }
		}

	if b19_included==1 {
	drop age
	gen age=kidcuragemo_01
	}


//Height less than 145cm
gen nt_wm_ht= heightfem<1450 if inrange(heightfem,1300,2200)
label values nt_wm_ht yesno
label var nt_wm_ht "Height under 145cm - women"

//Mean BMI
gen bmi=biofhemotest/100
summarize bmi if inrange(bmi,12,60) & (pregnant!=1 & (birthsin5yrs==0 | age>=2)) [iw=wt]
gen nt_wm_bmi_mean=round(r(mean),0.1)
label var nt_wm_bmi_mean "Mean BMI  - women"

//Normal weight
gen nt_wm_norm= inrange(biofhemotest,1850,2499) if inrange(biofhemotest,1200,6000)
replace nt_wm_norm=. if (pregnant==1 | age<2)
label values nt_wm_norm yesno
label var nt_wm_norm "Normal BMI - women"

//Thin
gen nt_wm_thin= inrange(biofhemotest,1200,1849) if inrange(biofhemotest,1200,6000)
replace nt_wm_thin=. if (pregnant==1 | age<2)
label values nt_wm_thin yesno
label var nt_wm_thin "Thin BMI - women"

//Mildly thin
gen nt_wm_mthin= inrange(biofhemotest,1700,1849) if inrange(biofhemotest,1200,6000)
replace nt_wm_mthin=. if (pregnant==1 | age<2)
label values nt_wm_mthin yesno
label var nt_wm_mthin "Mildly thin BMI  - women"

//Moderately and severely thin
gen nt_wm_modsevthin= inrange(biofhemotest,1200,1699) if inrange(biofhemotest,1200,6000)
replace nt_wm_modsevthin=. if (pregnant==1 | age<2)
label values nt_wm_modsevthin yesno
label var nt_wm_modsevthin "Moderately and severely thin BMI - women"

//Overweight or obese
gen nt_wm_ovobese= inrange(biofhemotest,2500,6000) if inrange(biofhemotest,1200,6000)
replace nt_wm_ovobese=. if (pregnant==1 | age<2)
label values nt_wm_ovobese yesno
label var nt_wm_ovobese "Overweight or obese BMI  - women"

//Overweight
gen nt_wm_ovwt= inrange(biofhemotest,2500,2999) if inrange(biofhemotest,1200,6000)
replace nt_wm_ovwt=. if (pregnant==1 | age<2)
label values nt_wm_ovwt yesno
label var nt_wm_ovwt "Overweight BMI  - women"

//Obese
gen nt_wm_obese= inrange(biofhemotest,3000,6000) if inrange(biofhemotest,1200,6000)
replace nt_wm_obese=. if (pregnant==1 | age<2)
label values nt_wm_obese yesno
label var nt_wm_obese "Obese BMI  - women"

//Took iron supplements during last pregnancy
gen nt_wm_micro_iron= .
replace nt_wm_micro_iron=0 if aniron_01==0
replace nt_wm_micro_iron=1 if inrange(anirond_01,0,59)
replace nt_wm_micro_iron=2 if inrange(anirond_01,60,89)
replace nt_wm_micro_iron=3 if inrange(anirond_01,90,300)
replace nt_wm_micro_iron=4 if aniron_01==8 | aniron_01==9 | anirond_01==998 | anirond_01==999
replace nt_wm_micro_iron= . if birthsin5yrs==0
label define nt_wm_micro_iron 0"None" 1"<60" 2"60-89" 3"90+" 4"Don't know/missing"
label values nt_wm_micro_iron nt_wm_micro_iron
label var nt_wm_micro_iron "Number of days women took iron supplements during last pregnancy"

//Took deworming medication during last pregnancy
gen nt_wm_micro_dwm= m60_1==1
replace nt_wm_micro_dwm= . if birthsin5yrs==0
label var nt_wm_micro_dwm "Women who took deworming medication during last pregnancy"

//Woman living in household with idodized salt 
gen nt_wm_micro_iod= saltest3==1
replace nt_wm_micro_iod=. if birthsin5yrs==0 | saltest3>1 
label var nt_wm_micro_iod "Women living in hh with iodized salt"
