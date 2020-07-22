/*****************************************************************************
Program: 			        IPUMS_RH_PNC.do
Purpose: 			        Code PNC indicators for women and newborns
Data inputs: 			      	IPUMS Maternal and Child Variables
Data outputs:			      	coded variables
Author:			        	Faduma Shaba
Date last modified: 			May 2020 
*****************************************************************************/
IPUMS variables used in this file:
Age				       	“age of respondent
delppchkb_01			      	“Mother's health checked by professional after child's birth”
delppchkbwho_01		     		“Person who checked respondent's health after delivery”
ppcheck_01			        “Mother's health checked before discharge”
delppchka_01			      	“Mother's health checked after discharge/home delivery”
ppcheckwho_01		        	“Person who checked respondent's health before discharge”
delppchkawho_01		      		“Person who checked respondent's health after discharge/delivery at home”
delppchkbtim_01		      		“Mother's health check timing after delivery”
pnbabcktm_01		        	“How long after delivery child's postnatal check took place”	
pnbabck_01			        “Child's postnatal check within 2 months”
pnbabckwho_01		        	“Who performed newborn's postnatal check”		
pnbabckhf_01			      	“Child's health checked before discharge”
pnbabckhftim_01		      		“Timing of child's health check before discharge”
pnbabckhfwho_01		      		“Person who checked child health before discharge”
ppchecktm_01		        	“Timing of mother's health check before discharge”
delppchkatm_01 		      		“How long after delivery health check took place (last birth)”
/*----------------------------------------------------------------------------//
Variables created in this file:
rh_pnc_wm_timing		   	"Timing after delivery for mother's PNC check"
rh_pnc_wm_2days 		    	"PNC check within two days for mother"
rh_pnc_wm_pv 		        	"Provider for mother's PNC check"
rh_pnc_nb_timing		    	"Timing after delivery for newborn's PNC check"
rh_pnc_nb_2days 		    	"PNC check within two days for newborn"
rh_pnc_nb_pv 		        	"Provider for newborn's PNC check"	
/----------------------------------------------------------------------------*/
				
*** Mother's PNC if delppchkbtim_01  is in the sample***

//PNC timing for mother	
  recode delppchkbtim_01 (100/103 = 1 "<4hr") (104/123 200 = 2 "4-23hrs") (124/171 201/202 = 3 "1-2 days") ///
	(172/197 203/206 = 4 "3-6 days") (207/241 301/305=5 "7-41 days") (198/199 298/299 398/399 998/999 = 9 "dont know/missing") (242/297 306/397 = 0 "no pnc check") , g(rh_pnc_wm_timing)
	replace rh_pnc_wm_timing = 0 if delppchkb_01==0 | delppchkb_01==9
  replace rh_pnc_wm_timing = 0 if (delppchkbwho_01>29 & delppchkbwho_01<97) | delppchkbwho_01==.
	replace rh_pnc_wm_timing=. if age>=24 | bidx_01!=1  
	label var rh_pnc_wm_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for mother	
  recode rh_pnc_wm_timing (1/3= 1 "visit w/in 2 days") (0 4 5 9  = 0 "No Visit w/in 2 days"), g(rh_pnc_wm_2days)
	label var rh_pnc_wm_2days "PNC check within two days for mother"
	
//PNC provider for mother	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
  recode delppchkbwho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1, gen(rh_pnc_wm_pv)
	replace rh_pnc_wm_pv = 0 if rh_pnc_wm_2days==0 & age<24
	label var rh_pnc_wm_pv "Provider for mother's PNC check"
	
*** Mother's PNC if delppchkbtim_01 is not in the sample***

cap drop rh_pnc_wm_timing

//PNC timing for mother		
	*did the mother have any check
	gen momcheck = 0 if age<24 
	replace momcheck = 1 if (ppcheck_01==1 | delppchka_01==1) & age<24
	
	*create combined timing variable
	gen pnc_wm_time = 999 if (age<24 & momcheck==1) 

	*start with women who delivered in a health facility with a check
	replace pnc_wm_time = ppchecktm_01 if inrange(ppcheckwho_01,11,29) & age<24 

	*Account for provider of PNC- country specific- see table footnotes
  	replace pnc_wm_time = 0 if (pnc_wm_time < 1000 & ppcheckwho_01 >30 & ppcheckwho_01 < 100 & age<24) 

	*Add in women who delivered at home with a check
  	replace pnc_wm_time = delppchkatm_01 if  (pnc_wm_time == 999 & inrange(delppchkawho_01, 11,29) & age<24) 

	*Account for provider of PNC- country specific- see table footnotes
  	replace pnc_wm_time = 0 if delppchkatm_01 < 1000 & delppchkawho_01 >30 & delppchkawho_01 < 100 & age<24 

	*Add in women who had no check 
	replace pnc_wm_time = 0 if momcheck == 0 & age<24 
	
	*Recode variable into categories as in FR
  	recode pnc_wm_time (0 242/299 306/899 = 0 "No check or past 41 days") ( 100/103 = 1 "less than 4 hours") (104/123 200 = 2 "4 to 23 hours") (124/171 201/202 = 3 "1-2 days") 
  	(172/197 203/206 = 4 "3-6 days") (207/241 300/305 = 5 "7-41 days")  (else = 9 "Don't know or missing") if age<24, gen(rh_pnc_wm_timing) 

	*label variable
	label var rh_pnc_wm_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for mother	
  	recode rh_pnc_wm_timing (1/3 = 1 "Within 2 days") (0 4 5 9 = 0 "Not in 2 days"), gen(rh_pnc_wm_2days) 
	label var rh_pnc_wm_2days "PNC check within two days for mother"
	
//PNC provider for mother	
** This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
	
	*Providers of PNC for facility deliveries 
  	recode ppcheckwho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1, gen(pnc_wm_pv_hf)
	replace pnc_wm_pv_hf = 0 if rh_pnc_wm_2days==0 & age<24
	
	*Providers of PNC for home deliveries or checks after discharge
  	recode delppchkawho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ( else = 9 "Don't know or missing") if age<24 & rh_pnc_wm_2days==1 , gen(pnc_wm_pv_home)
	replace pnc_wm_pv_home = 0 if rh_pnc_wm_2days==0  & age<24

	*Combine two PNC provider variables 	
	clonevar rh_pnc_wm_pv = pnc_wm_pv_hf 
  	replace rh_pnc_wm_pv = pnc_wm_pv_home if (pnc_wm_pv_hf==9 & rh_pnc_wm_2days==1 & age<24)
  
	*label variable
	label var rh_pnc_wm_pv "Provider for mother's PNC check"


*** Newborn's PNC  if survey has newborn PNC indicators & if delppchkbtim_01 is in the sample***
			
//PNC timing for newborn
  recode pnbabcktm_01 (207/297 301/397 = 0 "No check or past 7 days") ( 100 = 1 "less than 1 hour") (101/103 = 2 "1-3 hours") (104/123 200 = 3 "4 to 23 hours") (124/171 201/202 = 4 "1-2 days") ///
  (172/197 203/206 = 5 "3-6 days new") (198/199 298/299 398/399 998/999 = 9 "dont know/missing") if age<24 , gen(rh_pnc_nb_timing) 
		 
  	*Recode babies with no check and babies with check by unskilled provider back to 0 
	replace rh_pnc_nb_timing = 0 if (pnbabck_01==0 | pnbabck_01==9)

	*Account for provider of PNC- country specific- see table footnotes
  	replace rh_pnc_nb_timing = 0 if (pnbabckwho_01>29 & pnbabckwho_01<97) | pnbabckwho_01==.
	replace rh_pnc_nb_timing = . if age>=24 | bidx_01!=1  
		 
	*label variable
	label var rh_pnc_nb_timing "Timing after delivery for newborn's PNC check"

//PNC within 2days for newborn	
  	recode rh_pnc_nb_timing (1/4 = 1 "Visit within 2 days") (0 5 9 = 0 "No Visit within 2 days"), g(rh_pnc_nb_2days)

	*label variable	
	label var rh_pnc_nb_2days "PNC check within two days for newborn"

//PNC provider for newborn
*This is country specific, please check table in final report
  	recode pnbabckwho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ( 98/99 = 9 "Don't know or missing") if age<24 & rh_pnc_nb_timing<9 & rh_pnc_nb_timing>0, gen(rh_pnc_nb_pv)
	replace rh_pnc_nb_pv = 0 if rh_pnc_nb_2days ==0 & age<24
	label var rh_pnc_nb_pv "Provider for newborn's PNC check"
		
*** Newborn's PNC if delppchkbtim_01 is not in the sample ***

//PNC timing for newborn	
		
	*Newborn check
	gen nbcheck = 1 if (pnbabck_01==1 | pnbabckhf_01==1 )
  
	*create combined timing variable
	gen pnc_nb_timing_all = 999 if age<24 & nbcheck==1 
		
	*start with women who delivered in a health facility with a check
  	replace pnc_nb_timing_all = pnbabckhftim_01 if inrange(pnbabckhfwho_01,11,29) & age<24 

	*Account for provider of PNC- country specific- see table footnotes
  	replace pnc_nb_timing_all = 0 if pnc_nb_timing_all < 1000 & pnbabckhfwho_01 >30 & pnbabckhfwho_01 < 100 & age<24 
		
	*Add in women who delivered at home with a check
  	replace pnc_nb_timing_all = pnbabcktm_01 if (pnc_nb_timing_all==999 & inrange(pnbabckwho_01,11,29) & age<24)

	*Account for provider of PNC- country specific- see table footnotes
  	replace pnc_nb_timing_all = 0 if (pnbabcktm_01 < 1000 & pnbabckwho_01 >30 & pnbabckwho_01 < 100 & age<24)

	*Add in women who had no check 
	replace pnc_nb_timing_all = 0 if (nbcheck!=1) & age<24 
		
	*Recode variable into categories as in FR
  	recode pnc_nb_timing_all (0 207/297 301/397 = 0 "No check or past 7 days") ( 100=1 "less than 1 hour") (101/103 =2 "1-3 hours") (104/123 200 = 3 "4 to 23 hours") (124/171 201/202 = 4 "1-2 days")  (172/197 203/206 = 5 "3-6 days new") (else = 9 "Don't know or missing") if age<24 , gen (rh_pnc_nb_timing)
 
	*label variable
	label var rh_pnc_nb_timing "Timing after delivery for mother's PNC check"

//PNC within 2days for newborn	
	recode rh_pnc_nb_timing (1/4 = 1 "visit within 2 days") (0 5 9 = 0 "No Visit within			2 days"), g(rh_pnc_nb_2days)
	label var rh_pnc_nb_2days "PNC check within two days for newborn"

//PNC provider for newborn
* This is country specific and could be different for different surveys, please check footnote of the table for this indicator in the final report. 
		
	*Providers of PNC for home deliveries or checks after discharge
    	recode pnbabckwho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other") ( else = 9 "Don't know or missing") if age<24 & rh_pnc_nb_2days==1, gen(pnc_nb_pv_home)
	replace pnc_nb_pv_home = 0 if rh_pnc_nb_2days==0 & age<24
		
	*Providers of PNC for facility deliveries 
    	recode pnbabckhfwho_01 (0 = 0 "No check") (11 = 1 "Doctor") (12/13 = 2 "Nurse/Midwife") ( 14/15 = 3 "Other skilled provider") (16/90 = 4 "Non-skilled provider") (96 = 5 "Other")( else = 9 "Don't know or missing") if age<24 & rh_pnc_nb_2days==1 , gen(pnc_nb_pv_hf)
	replace pnc_nb_pv_hf = 0 if rh_pnc_nb_2days==0  & age<24
		
	*Combine two PNC provider variables 	
	clonevar rh_pnc_nb_pv = pnc_nb_pv_hf 
    	replace rh_pnc_nb_pv = pnc_nb_pv_home if (pnc_nb_pv_hf ==9) &  rh_pnc_nb_2days ==1 & age<24 

	*label variable
	label var rh_pnc_nb_pv "Provider for newborns's PNC check"
		

*** Newborn's PNC  if sample does not have newborn PNC indicators***
* replace indicators as missing
gen rh_pnc_nb_timing = .
gen rh_pnc_nb_2days = . 	
gen rh_pnc_nb_pv = . 

