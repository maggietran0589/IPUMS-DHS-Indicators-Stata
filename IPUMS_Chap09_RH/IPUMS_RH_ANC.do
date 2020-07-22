/*****************************************************************************************************
Program: 			IPUMS_RH_ANC.do
Purpose: 			Code ANC indicators
Data inputs: 			IPUMS Women's Variables
Data outputs:			coded variables
Author:				Faduma Shaba
Date last modified: 		May 2020 by Faduma Shaba
*****************************************************************************************************/

/*----------------------------------------------------------------------------//
IPUMS Variables used in this file:
ancarenone_01		"Nobody provided antenatal care"
ancaretba_01		"Traditional birth attendent provided antenatal care"
ancarehw_01		"Community health-worker provided antenatal care"
ancarenurm_01		"Nurse-midwife provided antenatal care"
ancaredoc_01		"Doctor provided antenatal care"
anvisno_01		"Number of antenatal care visits"
anvismo_01		"Number of months pregnant for first antenatal care visit"
aniron_01		"Took iron tablet/syrup during the pregnancy of last birth"
ancaredeworm_01		"Took intestinal parasite drugs during pregnancy of last birth"
ancarecom_01		"Informed of pregnancy complications during ANC visit"
ancarebp		"Blood pressure was taken during ANC visit"
ancareur		"Urine sample was taken during ANC visit"
ancarebld		"Blood sample was taken during ANC visit"
perweight		"Sample weight for persons"
urban			"Urban-rural status"
birthsin5yrs		"Number of births in last 5 years
antetnus_01		"Received 2+ tetanus injections during last pregnancy"
/*----------------------------------------------------------------------------//
Variables created in this file:
ancprov			"Person providing assistance during ANC"
ancareskilled		"Skilled assistance during ANC"
ancarevisfin		"Number of ANC visits (final report)"
ancarefourpl			"Attended 4+ ANC visits"
ancare1sttri		"Attended ANC <4 months of pregnancy"
ancmedian		"Median months pregnant at first visit" (scalar not a variable)
ancmedurban		"Urban- Median months pregnant at first visit" (scalar not a variable)
ancmedrural		"Rural- Median months pregnant at first visit" (scalar not a variable)
ancneotet		"Protected against neonatal tetanus"
/----------------------------------------------------------------------------*/

*** ANC visit indicators ***

//ANC by type of provider
	gen ancareprov= 0 
	replace ancareprov= 5 if ancarenone_01== 1
	replace ancareprov= 4 if ancaretba_01== 1 
	replace ancareprov= 3 if ancarehw_01== 1 
	replace ancareprov= 2 if ancarenurm_01== 1
	replace ancareprov= 1 if ancaredoc_01== 1

	label define rh_anc_pv ///
	1 "Doctor" 		///
	2 "Nurse/midwife"	///
	3 "Community Health Worker" ///
	4 "Traditional Birth Attendent"		///
	5 "No ANC" 
	label val ancareprov ancareprov
	label var ancareprov "Person providing assistance during ANC"
	
//ANC by skilled provider
** Note: Please check the final report for this indicator to determine what provider is considered skilled.
	recode ancareprov (1/2 = 1 "Skilled provider") (3/5 = 0 "Unskilled/no provider") , gen(ancareskilled)
	label var ancareskilled "Skilled assistance during ANC"	
	
//Number of ANC visits in 4 categories that match the table in the final report
	recode anvisno_01 (0=0 "none") (1=1) (2/3=2 "2-3") (4/90=3 "4+") (else=9 "don't know/missing"), gen(ancarevisfin)  
	label var ancarevisfin "Number of ANC visits"
		
//4+ ANC visits  
	recode ancarevisfin (1 2 9=0 "no") (3=1 "yes"), gen(ancarefourpl)
	lab var ancarefourpl "Attended 4+ ANC visits"
	
//Number of months pregnant at time of first ANC visit 
	replace anvismo_01=. if anvismo_01 > 9

//ANC before 4 months
	recode anvismo_01 (5/9=0 "no") (0/4=1 "yes"), gen(ancare1sttri)
	lab var ancare1sttri "Attended ANC <4 months of pregnancy"

//Median number of months pregnant at time of 1st ANC
	
	* Any ANC visits (for denominator)
	recode anvisno_01 (0=0 "None") (1/30= 1 "1+ ANC visit") (else=.), gen(ancany)
	
	replace anvismo_01=. if anvismo_01 > 96 
		
	* Total
	summarize anvismo_01 [iw=perweight], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1
	replace dummy=1 if anvismo_01<sp50 & ancany==1
	summarize dummy [iw=perweight]
	scalar sL=r(mean)
	drop dummy
	
	gen dummy=. 
	replace dummy=0 if ancany==1
	replace dummy=1 if anvismo_01 <=sp50 & ancany==1
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen ancmedian=round(sp50+(.5-sL)/(sU-sL),.01)
	label var ancmedian "Total- Median months pregnant at first visit"
	
	* Urban
	summarize anvismo_01 if urban==1 [iw=perweight], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1 & urban==1 
	replace dummy=1 if anvismo_01<sp50 & ancany==1 & urban==1 
	summarize dummy [iw=perweight]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1 & urban==1 
	replace dummy=1 if anvismo_01 <=sp50 & ancany==1 & urban==1 
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen ancmedurban=round(sp50+(.5-sL)/(sU-sL),.01)
	label var ancmedurban "Urban- Median months pregnant at first visit"
	
	* Rural
	summarize anvismo_01 if urban==2 [iw=perweight], detail
	* 50% percentile
	scalar sp50=r(p50)
	
	gen dummy=. 
	replace dummy=0 if ancany==1  & urban==2 
	replace dummy=1 if anvismo_01<sp50 & ancany==1  & urban==2 
	summarize dummy [iw=perweight]
	scalar sL=r(mean)

	replace dummy=. 
	replace dummy=0 if ancany==1  & urban==2 
	replace dummy=1 if anvismo_01 <=sp50 & ancany==1  & urban==2 
	summarize dummy [iw=perweight]
	scalar sU=r(mean)
	drop dummy

	gen ancmedrural=round(sp50+(.5-sL)/(sU-sL),.01)
	label var ancmedrural "Rural- Median months pregnant at first visit"
	
	
*** ANC components ***	
//Took iron tablets or syrup
	replace aniron_01=. if aniron_01 > 7
	
//Took intestinal parasite drugs 
	replace ancaredeworm_01=. if ancaredeworm_01 > 7	

//Informed of pregnancy complications
	replace ancarecom_01=. if ancarecom_01 > 7
	
//Blood pressure measured
	replace ancarebp=. if ancarebp > 7
	
//Urine sample taken
	replace ancareur=. if ancareur > 7
	
//Blood sample taken
	replace ancarebld=. if ancarebld > 7
	
//tetnaus toxoid injections
	replace antetnus_01=. if antetnus > 7
	
//neonatal tetanus
	* this was copied from the DHS user forum. Code was prepared by Lindsay Mallick.
	
	gen tet2lastp = 0 
    	replace tet2lastp = 1 if antetnusno_01 >1 & antetnusno_01 <8
    	label var tet2lastp "Had 2 or more tetanus shots during last pregnancy"
	
	* temporary vars needed to compute the indicator
	gen totet = 0 
	gen ttprotect = 0 				   
	replace totet = antetnusno_01 if (antetnusno_01>0 & antetnusno_01<8)
	replace totet = pretetnusno_01 + totet if (pretetnusno_01 > 0 & pretetnusno_01 < 8)
				   
	*now generating variable for date of last injection - will be 0 for women with at least 1 injection at last pregnancy
	gen lastinj = 9999
	replace lastinj = 0 if (antetnusno_01>0 & antetnusno_01 <8)
	gen int ageyr = (age)/12 
	replace lastinj = (pretetnusago_01 - ageyr) if pretetnusago_01 <20 & (antetnusno_01==0 | (antetnusno_01>7 & antetnusno_01<9996)) // years ago of last shot - (age at of child), yields some negatives

	*now generate summary variable for protection against neonatal tetanus 
	replace ttprotect = 1 if tet2lastp ==1 
	replace ttprotect = 1 if totet>=2 &  lastinj<=2 //at least 2 shots in last 3 years
	replace ttprotect = 1 if totet>=3 &  lastinj<=4 //at least 3 shots in last 5 years
	replace ttprotect = 1 if totet>=4 &  lastinj<=9 //at least 4 shots in last 10 years
	replace ttprotect = 1 if totet>=5  //at least 2 shots in lifetime
	lab var ttprotect "Full neonatal tetanus Protection"
				   
	gen ancneotet = ttprotect
	replace ancneotet = . if  bidx_01!=1 | age>=period 
	label var ancneotet "Protected against neonatal tetanus"
	
