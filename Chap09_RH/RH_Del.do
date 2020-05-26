/*****************************************************************************************************
Program: 			RH_DEL.do
Purpose: 			Code Delivery Care indicators
Data inputs: 		BR data files
Data outputs:		coded variables
Author:				Courtney Allen 
Date last modified: July 9 2018 by Shireen Assaf to adding missing categories and fix an error in the rh_del_cestime indicator 				
*****************************************************************************************************/
IPUMS Variables used in this file:
deldoc
delnurm
deltba
deloth
delrel
delnone
/*----------------------------------------------------------------------------//
Variables created in this file:
delskilled		"Live births by place of delivery"
rh_del_pltype		"Live births by type of place"
rh_del_pv			"Person providing assistance during birth"
rh_del_pvskill		"Skilled provider providing assistance during birth"
rh_del_ces			"Live births delivered by cesarean"
rh_del_cestime		"Timing of decision to have Cesarean"
rh_del_stay			"Duration of stay following recent birth"
/----------------------------------------------------------------------------*/

//Place of delivery
	recode m15 (20/39 = 1 "Health facility") (10/19 = 2 "Home") (40/98 = 3 "Other") (99=9 "Missing"), gen(rh_del_place)
	replace rh_del_place = . if age>=period
	label var rh_del_place "Live births by place of delivery"

//Place of delivery - by place type
	recode m15 (20/29 = 1 "Health facility - public") (30/39 = 2 "Health facility - private") (10/19 = 3 "Home")(40/98 = 4 "Other") (99=9 "Missing"), gen(rh_del_pltype)
	replace rh_del_pltype = . if age>=period
	label var rh_del_pltype "Live births by type of health facility"

//Assistance during delivery

replace deldoc=. if deldoc > 7 
replace delnurm=. if delnurm > 7
replace deltba=. if deltba > 7
replace deloth=. if deloth > 7
replace delrel=. if delrel > 7
replace delnone=. if delnone > 7


//Skilled provider during delivery
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	gen delskilled=.
  replace delskilled=0 if deltba==1 | deloth==1 | delrel==1
  replace delskilled=1 if deldoc==1 | delnurm==1
  replace delskilled=2 if delnone==1
  label define 0 "Unskilled" 1 "Skilled" 2 "No Provider"
  label val delskilled delskilled
  label var delskilled "Skilled assistance during delivery"
  
	
//Caesarean delivery
	gen rh_del_ces = 0
	replace rh_del_ces = 1 if m17==1
	replace rh_del_ces = . if age>=period
	label define rh_del_ceslab 0 "No" 1 "Yes"
	label val rh_del_ces rh_del_ceslab
	label var rh_del_ces "Live births delivered by Caesarean"
	
//Timing of decision for caesarean
	gen rh_del_cestime = 0
	cap confirm numeric variable m17a, exact
	*some surveys did not ask this question, confirm m17a exists
	if _rc==0 {  
		replace rh_del_cestime = m17a if m17a!=.
		replace rh_del_cestime = . if age>=period 
		label define cestimelab 0 "Vaginal Birth" 1 "before labor started" 2 "after labor started"
		label val rh_del_cestime cestimelab
		label var rh_del_cestime "Timing of decision to have Caesarean"
		}
//Duration of stay following recent birth
	recode m61 (0/105 = 1 "<6 hours") (106/111 = 2 "6-11 hours") (112/123 = 3 "12-23 hours") ///
	(124/171 201/202 = 4 "1-2 days") (172/199 203/399= 5 "3+ days") (998 = 9 "Don't know/Missing") (else= 9), gen(rh_del_stay)
	replace rh_del_stay = . if rh_del_place!=1 | bidx!=1 | age>=period
	label var rh_del_stay "Duration of stay following recent birth"
	
