/*****************************************************************************************************
Program: 			CH_ARI_FV.do
Purpose: 			Code ARI and fever variables.
Data inputs: 		KR survey list
Data outputs:		coded variables
Author:				Shireen Assaf
Date last modified: March 13 2019 by Shireen Assaf 
Notes:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_ari				"ARI symptoms in the 2 weeks before the survey"
ch_ari_care			"Advice or treatment sought for ARI symptoms"
ch_ari_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"
ch_ari_govh			"ARI treatment sought from government hospital among children with ARI"
ch_ari_govh_trt		"ARI treatment sought from government hospital among children with ARI that sought treatment"
ch_ari_govcent 		"ARI treatment sought from government health center among children with ARI"
ch_ari_govcent_trt 	"ARI treatment sought from government health center among children with ARI that sought treatment"
ch_ari_pclinc 		"ARI treatment sought from private hospital/clinic among children with ARI"
ch_ari_pclinc_trt 	"ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment"
ch_ari_pdoc			"ARI treatment sought from private doctor among children with ARI"
ch_ari_pdoc_trt		"ARI treatment sought from private doctor among children with ARI that sought treatment"
ch_ari_pharm		"ARI treatment sought from pharmacy among children with ARI"
ch_ari_pharm_trt	"ARI treatment sought from pharmacy among children with ARI that sought treatment"
ch_fever			"Fever symptoms in the 2 weeks before the survey"
ch_fev_care			"Advice or treatment sought for fever symptoms"
ch_fev_care_day		"Advice or treatment sought for ARI symptoms on the same or next day"
ch_fev_antib		"Antibiotics taken for fever symptoms"
----------------------------------------------------------------------------*/

** ARI indicators ***

//ARI symptoms
* ari defintion differs by survey according to whether couchestprob is included or not
	scalar couchestprob_included=1
		capture confirm numeric variable couchestprob, exact 
		if _rc>0 {
		* couchestprob is not present
		scalar couchestprob_included=0
		}
		if _rc==0 {
		* couchestprob is present; check for values
		summarize couchestprob
		  if r(sd)==0 | r(sd)==. {
		  scalar couchestprob_included=0
		  }
		}

if couchestprob_included==1 {
	gen ch_ari=0
	cap replace ch_ari=1 if coushortbre==1 & (couchestprob==1 | couchestprob==3)
	replace ch_ari =. if kidalive==0
}

if couchestprob_included==0 {
	gen ch_ari=0
	cap replace ch_ari=1 if coushortbre==1 & (h31==2)
	replace ch_ari =. if kidalive==0
}
	
/* survey specific changes
if srvy=="IAKR23"|srvy=="PHKR31" {
	drop ch_ari
	gen ch_ari=0
	replace ch_ari=1 if coushortbre==1 & (h31==2|h31==1)
	replace ch_ari =. if kidalive==0
}
*/
	
label var ch_ari "ARI symptoms in the 2 weeks before the survey"
	
//ARI care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes traditional practitioner (usually h32t). The variable for traditional healer may be different for different surveys (you can check this by: des h32*). 
*** Some surveys also exclude pharmacies, shop, or other sources.
gen ch_ari_care=0 if ch_ari==1
foreach c in a b c d e f g h i j k l m n o p q r s u v w x {
replace ch_ari_care=1 if ch_ari==1 & h32`c'==1
}
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove 
* the 'k in the list on line 79 or do the following.
replace ch_ari_care=0 if ch_ari==1 & FEVTRPRIVDRUG==1
replace ch_ari_care =. if kidalive==0
*/
label var ch_ari_care "Advice or treatment sought for ARI symptoms"

//ARI care-seeking same or next day

gen ch_ari_care_day=0 
replace ch_ari_care_day=1 fevtrewaitdays < 2
replace ch_ari_care_day =. if kidalive==0

label var ch_ari_care_day "Advice or treatment sought for ARI symptoms on the same or next day"

	scalar h46b_included=1
		capture confirm numeric variable h46b, exact 
		if _rc>0 {
		* h46b is not present
		scalar h46b_included=0
		}
		if _rc==0 {
		* h46b is present; check for values
		summarize h46b
		  if r(sd)==0 | r(sd)==. {
		  scalar h46b_included=0
		  }
		}

if h46b_included==0{
replace ch_ari_care_day=.
}

*** ARI treatment by source *** 
* Two population bases: 1. among children with ARI symptoms, 2. among children with ARI symptoms that sought treatment
* This is country specific and needs to be checked to produce the specific source of interest. 
* Some sources are coded below and the same logic can be used to code other sources. fevtrpubhos-z indicates the source.

//ARI treamtment in government hospital
gen ch_ari_govh=0 if ch_ari==1
replace ch_ari_govh=1 if ch_ari==1 & fevtrpubhos==1
replace ch_ari_govh =. if kidalive==0
label var ch_ari_govh "ARI treatment sought from government hospital among children with ARI"

gen ch_ari_govh_trt=0 if ch_ari_care==1
replace ch_ari_govh_trt=1 if ch_ari_care==1 & fevtrpubhos==1
replace ch_ari_govh_trt =. if kidalive==0
label var ch_ari_govh_trt "ARI treatment sought from government hospital among children with ARI that sought treatment"

//ARI treamtment in government health center
gen ch_ari_govcent=0 if ch_ari==1
replace ch_ari_govcent=1 if ch_ari==1 & fevtrpubhc==1
replace ch_ari_govcent =. if kidalive==0
label var ch_ari_govcent "ARI treatment sought from government health center among children with ARI"

gen ch_ari_govcent_trt=0 if ch_ari_care==1
replace ch_ari_govcent_trt=1 if ch_ari_care==1 & fevtrpubhc==1
replace ch_ari_govcent_trt =. if kidalive==0
label var ch_ari_govcent_trt "ARI treatment sought from government health center among children with ARI that sought treatment"

//ARI treatment from a private hospital/clinic
gen ch_ari_pclinc=0 if ch_ari==1
replace ch_ari_pclinc=1 if ch_ari==1 & fevtrprivhos==1
replace ch_ari_pclinc =. if kidalive==0
label var ch_ari_pclinc "ARI treatment sought from private hospital/clinic among children with ARI"

gen ch_ari_pclinc_trt=0 if ch_ari_care==1
replace ch_ari_pclinc_trt=1 if ch_ari_care==1 & fevtrprivhos==1
replace ch_ari_pclinc_trt =. if kidalive==0
label var ch_ari_pclinc_trt "ARI treatment sought from private hospital/clinic  among children with ARI that sought treatment"

//ARI treatment from a private doctor
gen ch_ari_pdoc=0 if ch_ari==1
replace ch_ari_pdoc=1 if ch_ari==1 & fevtrprivdr==1
replace ch_ari_pdoc =. if kidalive==0
label var ch_ari_pdoc "ARI treatment sought from private doctor among children with ARI"

gen ch_ari_pdoc_trt=0 if ch_ari_care==1
replace ch_ari_pdoc_trt=1 if ch_ari_care==1 & fevtrprivdr==1
replace ch_ari_pdoc_trt =. if kidalive==0
label var ch_ari_pdoc_trt "ARI treatment sought from private doctor among children with ARI that sought treatment"

//ARI treatment from a pharmacy
gen ch_ari_pharm=0 if ch_ari==1
replace ch_ari_pharm=1 if ch_ari==1 & FEVTRPRIVDRUG==1
replace ch_ari_pharm =. if kidalive==0
label var ch_ari_pharm "ARI treatment sought from a pharmacy among children with ARI"

gen ch_ari_pharm_trt=0 if ch_ari_care==1
replace ch_ari_pharm_trt=1 if ch_ari_care==1 & FEVTRPRIVDRUG==1
replace ch_ari_pharm_trt =. if kidalive==0
label var ch_ari_pharm_trt "ARI treatment sought from a pharmacy among children with ARI that sought treatment"


*** Fever indicators ***

//Fever 
gen ch_fever=0
cap replace ch_fever=1 if fevrecent==1 
replace ch_fever =. if kidalive==0
label var ch_fever "Fever symptoms in the 2 weeks before the survey"
	
//Fever care-seeking
*** this is country specific and the footnote for the final table needs to be checked to see what sources are included. 
*** The code below only excludes traditional practitioner (usually h32t). The variable for traditional healer may be different for different surveys (you can check this by: des h32*). 
*** Some surveys also exclude pharmacies, shop, or other sources.
gen ch_fev_care=0 if ch_fever==1
foreach c in a b c d e f g h i j k l m n o p q r s u v w x {
replace ch_fev_care=1 if ch_fever==1 & h32`c'==1
}
/* If you want to also remove pharmacy for example as a source of treatment (country specific condition) you can remove 
* the 'k in the list on line 185 or do the following.
replace ch_fev_care=0 if ch_fever==1 & FEVTRPRIVDRUG==1
*/
replace ch_fev_care =. if kidalive==0
label var ch_fev_care "Advice or treatment sought for fever symptoms"

//Fever care-seeking same or next day
gen ch_fev_care_day=0 if ch_fever==1
replace ch_fev_care_day=1 if ch_fever==1 & ch_fev_care==1 & h46b<2
replace ch_fev_care_day =. if kidalive==0
label var ch_fev_care_day "Advice or treatment sought for fever symptoms on the same or next day"

//Fiven antibiotics for fever 
gen ch_fev_antib=0 if ch_fever==1
cap replace ch_fev_antib=1 if ch_fever==1 & (h37i==1 | h37j==1)
cap replace ch_fev_antib=1 if ch_fever==1 & (ml13i==1 | ml13j ==1)
replace ch_fev_antib =. if kidalive==0
label var ch_fev_antib "Antibiotics taken for fever symptoms"
