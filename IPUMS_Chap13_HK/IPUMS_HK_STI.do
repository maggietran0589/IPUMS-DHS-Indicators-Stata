/*****************************************************************************************************
Program: 			IPUMS_HK_STI.do
Purpose: 			Code for STI indicators
Data inputs: 		IPUMS DHS Women and Men’s Variables
Data outputs:		coded variables
Author:				Faduma Shaba
Date last modified: August 2020
Note:				The indicators below can be computed for men and women. 
				
			
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on Women for the unit of analysis
Select the country samples and years that you will be using then include all the women’s variables listed below.
After selecting all the women’s variables, change the unit of analysis to men’s and include all the men’s variables listed below.

2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:

**********************
**WOMEN’S VARIABLES**
**********************
age		"Age	"
stianyr		"Had any sexually transmitted infection in last 12 months	"
age1stsex		"Age at first intercourse	"
stidischgyr		"Had genital discharge in last 12 months	"
stisoreyr		"Had genital ulcer/sore in last 12 months	"
stiadprivdrug		"Sought STI advice from: Private pharmacy, dispensary, or drug store"
stiadshop		"Sought STI advice from: Shop	"
stiadother		"Sought STI advice from: Other	"
stiadvice		"Sought advice for last STI	"	
stiadpubhos		"Sought STI advice from: Public hospital	"
stiadpubhc		"Sought STI advice from: Public health center"
stiadpubvct		Sought STI advice from: Public voluntary counseling testing (VCT) center
stiadpubfpc		Sought STI advice from: Family planning clinic (public)
stiadpubmob		"Sought STI advice from: Public mobile clinic	"
stiadpubfw		"Sought STI advice from: Public fieldworker"
stiadpuboth		"Sought STI advice from: Other public"
stiadprivhos		"Sought STI advice from: Private hospital/clinic/doctor"
stiadprivvct		"Sought STI advice from: Voluntary counseling testing (VCT) center (private)"
stiadprivmob		"Sought STI advice from: Private mobile clinic	"
stiadprivfw		"Sought STI advice from: Private fieldworker	"
stiadprivoth		"Sought STI advice from: Other private medical	"

*******************
**MEN’S VARIABLES**
*******************
agemn			"Age	"
stianyrmn		Had any sexually transmitted infection in last 12 months (men)
age1stsexmn		Age at first intercourse
stidischgyrmn		"Had foul smelling genital discharge in last 12 months	 (men)"
stisoreyrmn		Had genital sore/ulcer in last 12 months (men)
stiadvicemn		"Sought advice for last STI	"


----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sti				"Had an STI in the past 12 months"
hk_gent_disch		"Had an abnormal (or bad-smelling) genital discharge in the past 12 months"
hk_gent_sore		"Had a genital sore or ulcer in the past 12 months"
hk_sti_symp			"Had an STI or STI symptoms in the past 12 months"
hk_sti_trt_doc		"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"
hk_sti_trt_pharm	"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"
hk_sti_trt_other	"Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"
hk_sti_notrt		"Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"
	
----------------------------------------------------------------------------*/

**********************
**WOMEN’S VARIABLES**
**********************

* limiting to women age 15-49
drop if age>49

cap label define yesno 0"No" 1"Yes"

**************************

//STI in the past 12 months
gen hk_sti= stianyr==1
replace hk_sti=. if age1stsex==0 | age1stsex==99 | age1stsex==.
label values hk_sti yesno
label var hk_sti "Had an STI in the past 12 months"

//Discharge in the past 12 months
gen hk_gent_disch= stidischgyr==1
replace hk_gent_disch=. if age1stsex==0 | age1stsex==99 | age1stsex==.
label values hk_gent_disch yesno
label var hk_gent_disch "Had an abnormal (or bad-smelling) genital discharge in the past 12 months"

//Genital sore in past 12 months
gen hk_gent_sore= stisoreyr==1
replace hk_gent_sore=. if age1stsex==0 | age1stsex==99 | age1stsex==.
label values hk_gent_sore yesno
label var hk_gent_sore "Had a genital sore or ulcer in the past 12 months"

//STI or STI symptoms in the past 12 months
gen hk_sti_symp= stianyr==1 | stisoreyr==1 | stidischgyr==1 
replace hk_sti_symp=. if age1stsex==0 | age1stsex==99 | age1stsex==.
label values hk_sti_symp yesno
label var hk_sti_symp "Had an STI or STI symptoms in the past 12 months"

//Sought care from clinic/hospital/private doctor for STI
gen hk_sti_trt_doc = 0 if stianyr==1 | stisoreyr==1 | stidischgyr==1
replace hk_sti_trt_doc=1 if stiadpubhos==1 | stiadpubhc==1| stiadpubvct==1| stiadpubfpc ==1| stiadpubmob==1|stiadpubfw==1| stiadpuboth==1| stiadprivhos==1| stiadprivvct==1|  stiadprivmob==1| stiadprivfw==1| stiadprivoth==1
label values hk_sti_trt_doc yesno
label var hk_sti_trt_doc "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a clinic/hospital/private doctor"

//Sought care from pharmacy for STI
gen  hk_sti_trt_pharm = 0 if stianyr==1 | stisoreyr==1 | stidischgyr==1
replace hk_sti_trt_pharm=1 if stiadprivdrug==1 | stiadshop==1
label values hk_sti_trt_pharm yesno
label var hk_sti_trt_pharm "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from a pharmacy"

//Sought care from any other source for STI
gen hk_sti_trt_other = 0 if stianyr==1 | stisoreyr==1 | stidischgyr==1
replace hk_sti_trt_other =1 if  stiadother==1
label values hk_sti_trt_other yesno
label var hk_sti_trt_other "Had an STI or STI symptoms in the past 12 months and sought advice or treatment from any other source"

//Did not seek care for STI
gen hk_sti_notrt = 0 if stianyr==1 | stisoreyr==1 | stidischgyr==1
replace hk_sti_notrt=1 if stiadvice==0
label values  hk_sti_notrt yesno
label var hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"

*******************
**MEN’S VARIABLES**
*******************

* limiting to men age 15-49
drop if agemn>49

cap label define yesno 0"No" 1"Yes"

**************************

//STI in the past 12 months
gen hk_sti= stianyrmn==1
replace hk_sti=. if age1stsexmn==0 | age1stsexmn==99 | age1stsexmn==.
label values hk_sti yesno
label var hk_sti "Had an STI in the past 12 months"

//Discharge in the past 12 months
gen hk_gent_disch= stidischgyrmn==1
replace hk_gent_disch=. if age1stsexmn==0 | age1stsexmn==99 | age1stsexmn==.
label values hk_gent_disch yesno
label var hk_gent_disch "Had an abnormal (or bad-smelling) genital discharge in the past 12 months"

//Genital sore in past 12 months
gen hk_gent_sore= stisoreyrmn==1
replace hk_gent_sore=. if age1stsexmn==0 | age1stsexmn==99 | age1stsexmn==.
label values hk_gent_sore yesno
label var hk_gent_sore "Had a genital sore or ulcer in the past 12 months"

//STI or STI symptoms in the past 12 months
gen hk_sti_symp= stianyrmn==1 | stisoreyrmn ==1 | stidischgyrmn==1 
replace hk_sti_symp=. if age1stsexmn==0 | age1stsexmn==99 | age1stsexmn==.
label values hk_sti_symp yesno
label var hk_sti_symp "Had an STI or STI symptoms in the past 12 months"


//Did not seek care for STI
gen hk_sti_notrt = 0 if stianyrmn==1 | stisoreyrmn==1 | stidischgyrmn==1
replace hk_sti_notrt=1 if stiadvicemn==0
label values  hk_sti_notrt yesno
label var hk_sti_notrt "Had an STI or STI symptoms in the past 12 months and sought no advice or treatment"

