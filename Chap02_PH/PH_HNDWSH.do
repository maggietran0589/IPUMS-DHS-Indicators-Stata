/*****************************************************************************************************
Program: 			  PH_HNDWSH.do
Purpose: 			  Code to compute handwashing indicators
Data inputs: 		PR survey list
Data outputs:		coded variables
Author:				  Faduma Shaba
Date last modified: May 2020 
Note:				The HR file can also be used to code these indicators among households. The condition hv102 would need to be removed. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
handwashfxd			        "Fixed place for handwashing"
ph_hndwsh_place_mob			"Mobile place for handwashing"
ph_hndwsh_place_any			"Either fixed or mobile place for handwashing"
ph_hndwsh_water				"Place observed for handwashing with water"
ph_hndwsh_soap				"Place observed for handwashing with soap"
ph_hndwsh_clnsagnt			"Place observed for handwashing with cleansing agent other than soap"
ph_hndwsh_basic				"Basic handwashing facility"
ph_hndwsh_limited			"Limited handwashing facility"
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Fixed place for handwashing
gen handwashfxd= handwashplobs==1 
replace handwashfxd=. if handwashplobs > 97
label values handwashfxd yesno
label var handwashfxd "Fixed place for handwashing"

//Mobile place for handwashing
gen handwashmob= handwashplobs==2 
replace handwashmob=. if handwashplobs > 97
label values handwashmob yesno
label var handwashmob "Mobile place for handwashing"

//Fixed or mobile place for handwashing
gen handwashany= inlist(handwashplobs,1,2)
replace handwashany=. if handwashplobs > 97
label values handwashany yesno
label var handwashany "Either fixed or mobile place for handwashing"

//Place observed for handwashing with water
gen ph_hndwsh_water= 0 if inlist(hv230a,1,2) 
replace ph_hndwsh_water= 1 if hv230b==1 
replace handwashfxd=. if handwashplobs > 97
label values ph_hndwsh_water yesno
label var ph_hndwsh_water "Place observed for handwashing with water"

//Place observed for handwashing with soap
gen ph_hndwsh_soap= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_soap=1 if hv232==1
replace handwashfxd=. if handwashplobs > 97
label values ph_hndwsh_soap yesno
label var ph_hndwsh_soap "Place observed for handwashing with soap"

//Place observed for handwashing with cleansing agent other than soap
gen ph_hndwsh_clnsagnt= 0 if inlist(hv230a,1,2)
replace ph_hndwsh_clnsagnt=1 if hv232b==1
replace handwashfxd=. if handwashplobs > 97
label values ph_hndwsh_clnsagnt yesno
label var ph_hndwsh_clnsagnt "Place observed for handwashing with cleansing agent other than soap"

//Basic handwashing facility
gen ph_hndwsh_basic= 0 if inlist(hv230a,1,2,3)
replace ph_hndwsh_basic = 1 if hv230b==1 & hv232==1
replace handwashfxd=. if handwashplobs > 97 
label values ph_hndwsh_basic yesno
label var ph_hndwsh_basic	"Basic handwashing facility"

//Limited handwashing facility
gen ph_hndwsh_limited= 0 if inlist(hv230a,1,2,3)
replace ph_hndwsh_limited = 1 if hv230b==0 | hv232==0
replace handwashfxd=. if handwashplobs > 97
label values ph_hndwsh_limited yesno
label var ph_hndwsh_limited	"Limited handwashing facility"
