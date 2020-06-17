/*****************************************************************************************************
Program: 			CH_KNOW_ORS.do
Purpose: 			Code knowledge of ORS variable.
Data inputs: 		IR survey list
Data outputs:		coded variables
Author:				Faduma Shaba
Date last modified: June 2020  
Notes:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ch_know_ors		"Know about ORS as treatment for diarrhea among women with birth in the last 5 years"
----------------------------------------------------------------------------*/

//Know ORS
gen ch_know_ors=0
replace ch_know_ors=1 if diatrorsheard>0 & diatrorsheard<3
replace ch_know_ors=. if birthsin5yrs==0
label var ch_know_ors "Know about ORS as treatment for diarrhea among women with birth in the last 5 years"
