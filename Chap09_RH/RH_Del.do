/*****************************************************************************************************
Program: 			RH_DEL.do
Purpose: 			Code Delivery Care indicators
Data inputs: 			IPUMS DHS Children and Women’s Variables
Data outputs:			coded variables
Author:			Faduma Shaba 
Date last modified: 		May 2020				
*****************************************************************************************************/
IPUMS DHS Variables
deldoc			“Doctor provided delivery care”
delnurm			“Nurse-midwife provided delivery care”
deltba			“Traditional birth attendent provided delivery care”
deloth			“Other provider provided delivery care”
delrel			“Relative provided delivery care”
delnone			“Nobody provided delivery care”
delpl			"Live births by place of delivery"
delcesr			"Live births delivered by cesarean"

/*----------------------------------------------------------------------------//
Variables created in this file:
delpltype		"Live births by type of place"
rh_del_pv		"Person providing assistance during birth"
rh_del_pvskill		"Skilled provider providing assistance during birth"
rh_del_cestime		"Timing of decision to have Cesarean"
rh_del_stay		"Duration of stay following recent birth"
/----------------------------------------------------------------------------*/

//Place of delivery
replace delpl=. If delpl > 9997

//Place of delivery - by place type
recode delpl  (2000/2905 = 1 "Health facility - public") (3000/3901 = 2 "Health facility - private") (1000/1901 = 3 "Home")(4000/4901 = 4 "NGO")(5000/5901 = 5 "NGO")(6000/9996 = 6 "other") (9997=7 “Don’t Know”)(9998=9 "Missing"), gen(delpltype)
replace delpltype = . if age>=period
label var delpltype "Live births by type of health facility"

//Assistance during delivery
**Note: Assitance during delivery and skilled provider indicators are both country specific indicators. 
**The table for these indicators in the final report would need to be checked to confirm the code below.
gen delprov=0
replace delprov=1 if deldoc==1
replace delprov=2 if delnurm==1
replace delprov=3 if deltba==1
replace delprov=4 if deloth==1
replace delprov=5 if delrel==1
replace delprov=6 if delnone==1
replace delprov=7 if deldoc==8 | delnurm==8 | deltba==8 | deloth==8 | delrel==8 | delnone==8

	label define delprov 			///
	1 "Doctor" 					///
	2 "Nurse/midwife"			///
	3 "Traditional birth attendant"	///
	4 "Other health worker"		///
	5 "Relative/other"			///
	6 "No one"					///
	7 "Don't know/missing"
	label val delprov delprov 
	label var delprov Person providing assistance during delivery"

//Skilled provider during delivery
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
recode delprov (1/2 = 1 "Skilled provider") (3/5 = 2 "Unskilled provider") (6 = 3 "No one") (7=4 "Don't know/missing"), gen(delskilled)
label var delskilled"Skilled assistance during delivery"
	
//Caesarean delivery
replace delcesr=. If delcesr > 7
	
//Timing of decision for caesarean
replace delcesrdec=. If delceserdec > 7
	
//Duration of stay following recent birth
replace deltime=. If deltime > 997	
