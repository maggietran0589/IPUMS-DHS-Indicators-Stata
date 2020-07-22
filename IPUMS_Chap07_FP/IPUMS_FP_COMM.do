/*****************************************************************************************************
Program: 			        IPUMS_FP_COMM.do
Purpose: 			        Code communication related indicators: exposure to FP messages, decision on use/nonuse, discussions. 
Data inputs: 		      Information on Family Planning Variables
Data outputs:		      coded variables
Author:				        Faduma Shaba
Date last modified:   April 2020 
Notes:				        For men variables add a 'mn' to the end of the female variables.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
                              *IPUMS DHS VARIABLES*

fpradiohr		          "Exposure to family planning message by radio"
fptvhr		        	  "Exposure to family planning message by TV"
fpnewshr	        	  "Exposure to family planning message by newspaper/magazine"
fptexthr	          	"Exposure to family planning message by mobile phone"
fpdecider      			  "Who makes the decision to use family planning among users"
fpdecidernot    		  "Who makes decision not to use family planning among non-users"
fphomtalkfp       		"Women visited by a FP worker who discussed FP"
fphctalkfp  		     	"Women who visited a health facility in last 12 months and discussed FP"

--------------------------------------------------------------------------------
                                 *NEW VARIABLES*
                                 
fpnone4               "Not exposed to any of the four media sources (TV, radio, paper, mobile)"
fpnone3               "Not exposed to TV, radio, or paper media sources"
fpnotdiscuss	  	"Women non-users who did not discuss FP neither with FP worker or in a health facility"
--------------------------------------------------------------------------------*/


**********************
**Women's Variables***
**********************

*** Family planning messages ***

//Family planning messages by radio
replace fpradiohr=. if fpradiohr > 97

//Family planning messages by TV
replace fptvhr=. if fptvhr > 7

//Family planning messages by newspaper and/or magazine
replace fpnewshr=. if fpnewshr > 7

//Family planning messages by mobile
replace fptexthr=. if fptexthr > 7

//Did not hear a family planning message from any of the 4 media sources
gen fpnone4 = 0
replace fpnone4 =1 if (fpradiohr!=1 & fptvhr!=1 & fpnewshr!=1 & fptexthr!=1)
label var fpnone4 "Not exposed to any of the four media sources (TV, radio, paper, mobile)"

//Did not hear a family planning message from radio, TV or paper
gen fpnone3=0
replace fpnone3 =1 if (fpradiohr!=1 & fptvhr!=1 & fpnewshr!=1)
label var fpnone3 "Not exposed to TV, radio, or paper media sources"

*** Family Planning decision making and discussion ***

//Decision to use among users
replace fpdecider=. if fpdecider > 7

//Decision to not use among non users
replace fpdecidernot=. if fpdecidernot > 7

//Discussed with FP worker
replace fphomtalkfp=. if fphomtalkfp > 7

//Discussed FP in a health facility
replace fphctalkfp=. if fphctalkfp > 7

//Did not discuss FP in health facility or with FP worker
gen fpnotdiscuss = (fphomtalkfp!=1 & fphctalkfp!=1)
replace fpnotdiscuss=. if fpmethnow!=0
label var fpnotdiscuss "Women non-users who did not discuss FP neither with FP worker or in a health facility"



***********************
****Men's Variables****
***********************

*** Family planning messages ***

//Family planning messages by radio
replace fpradiohrmn=. if fpradiohrmn > 97

//Family planning messages by TV
replace fptvhrmn=. if fptvhrmn > 7

//Family planning messages by newspaper and/or magazine
replace fpnewshrmn=. if fpnewshrmn > 7

//Family planning messages by mobile
replace fptexthrmn=. if fptexthrmn > 7

//Did not hear a family planning message from any of the 4 media sources
gen fpnone4mn = 0
replace fpnone4mn =1 if (fpradiohrmn!=1 & fptvhrmn!=1 & fpnewshrmn!=1 & fptexthrmn!=1)
label var fpnone4mn "Not exposed to any of the four media sources (TV, radio, paper, mobile)"

//Did not hear a family planning message from radio, TV or paper
gen fpnone3mn=0
replace fpnone3mn =1 if (fpradiohrmn!=1 & fptvhrmn!=1 & fpnewshrmn!=1)
label var fpnone3mn "Not exposed to TV, radio, or paper media sources"
