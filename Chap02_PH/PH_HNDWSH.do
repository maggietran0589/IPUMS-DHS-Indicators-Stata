/*****************************************************************************************************
Program: 			  PH_HNDWSH.do
Purpose: 			  Code to compute handwashing indicators
Data inputs: 		IPUMS DHS HH survey list
Data outputs:		coded variables
Author:				  Faduma Shaba
Date last modified: May 2020 
Note:				
*****************************************************************************************************/

/*----------------------------------------------------------------------------
IPUMS DHS Variables used in this file:
handwashwtr				      "Place observed for handwashing with water"
hwsoap      				    "Place observed for handwashing with soap"
handwashsand      			"Place observed for handwashing with cleansing agent other than soap"
----------------------------------------------------------------------------
Variables Created:
handwashfxd			        "Fixed place for handwashing"
handwashmob			        "Mobile place for handwashing"
handwashany			        "Either fixed or mobile place for handwashing"
hwbasic				          "Basic handwashing facility"
hwlimited			          "Limited handwashing facility"
----------------------------------------------------------------------------*/
cap label define yesno 0"No" 1"Yes"

//Fixed place for handwashing
gen handwashfxd= handwashplobs==21 
replace handwashfxd=. if handwashplobs > 97
label values handwashfxd yesno
label var handwashfxd "Fixed place for handwashing"

//Mobile place for handwashing
gen handwashmob= handwashplobs==22
replace handwashmob=. if handwashplobs > 97
label values handwashmob yesno
label var handwashmob "Mobile place for handwashing"

//Fixed or mobile place for handwashing
gen handwashany= handwashplobs if handwashplobs==21 | handwashplobs==22
replace handwashany=. if handwashplobs > 97
label values handwashany yesno
label var handwashany "Either fixed or mobile place for handwashing"

//Place observed for handwashing with water
replace handwashwtr=. if handwashwtr > 7

//Place observed for handwashing with soap
replace hwsoap=. if hwsoap > 7

//Place observed for handwashing with cleansing agent other than soap
replace handwashsand=. if handwashsand > 7

//Basic handwashing facility
gen hwbasic= 0 
replace hwbasic = 1 if handwashsand==1 & hwsoap==1
label values ph_hndwsh_basic yesno
label var ph_hndwsh_basic	"Basic handwashing facility"

//Limited handwashing facility
gen hwlimited= 0 
replace hwlimited = 1 if hwsoap==0 | handwashsand==0
label values ph_hndwsh_limited yesno
label var ph_hndwsh_limited	"Limited handwashing facility"
