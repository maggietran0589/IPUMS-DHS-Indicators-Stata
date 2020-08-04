/*****************************************************************************************************
Program: 			 IPUMS_NT_CH_MICRO.do
Purpose: 		 	Code to compute micronutrient indicators in children
Data inputs: 			IPUMS DHS Children’s Variables
Data outputs:			coded variables
Author:			Faduma Shaba
Date last modified: 		August 2020
Note:				The indicators below can be computed for children 
				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on “Children” for the unit of analysis
Select the country samples and years that you will be using then include all the “Children’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:
kidcuragemo		“Current age of child in months”
mnpwk		“Child given multiple micronutrient powder (MNP) in past 7 days”
kidalive		“Child is alive”
vacvitalastmo		“Month child received vitamin A vaccination (most recent)”
vacvitalastday		"Day child received vitamin A vaccination (most recent"
vacvitalastyr		“Year child received vitamin A vaccination (most recent)”	
intdatecdc		“Century day date of interview”	
saltest3		"Summary result of salt test for iodine"
rutfwk			"Child given ready-to-use therapeutic food (RUTF) in past 7 days"
rusfwk			“Child given ready-to-use supplemental food (RUSF) in past 7 days”
----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_ch_micro_mp		"Children age 6-23 mos given multiple micronutrient powder"
nt_ch_micro_iod		"Children age 6-59 mos live in hh with iodized salt"
nt_ch_food_ther		"Children age 6-35 mos given therapeutic food"
nt_ch_food_supp		"Children age 6-35 mos given supplemental food"
----------------------------------------------------------------------------*/

*Changing Household member variables to only include household members
by idhshid, sort: gen nvals=_n==1
count if nvals
keep if nvals==1 

//Received multiple micronutrient powder
gen nt_ch_micro_mp= mnpwk==1 
replace nt_ch_micro_mp=. if !inrange(kidcuragemo,6,23) | kidalive==0
label values nt_ch_micro_mp yesno 
label var nt_ch_micro_mp "Children age 6-23 mos given multiple micronutrient powder"

//Received Vit. A supplements
recode vacvitalastmo (98=.), gen(vacvitalastmo2)
recode vacvitalastday (98=15), gen(vacvitalastday2)
recode vacvitalastyr (9998=.), gen(vacvitalastyr2)

//Child living in household with idodized salt 
gen nt_ch_micro_iod= saltest3==1
replace nt_ch_micro_iod=. if !inrange(kidcuragemo,6,59) | kidalive==0 | saltest3>1
label values nt_ch_micro_iod yesno 
label var nt_ch_micro_iod "Children age 6-59 mos live in hh with iodized salt"

//Received therapeutic food
gen nt_ch_food_ther= rutfwk==1
replace nt_ch_food_ther=. if !inrange(kidcuragemo,6,35) | kidalive==0
label values nt_ch_food_ther yesno 
label var nt_ch_food_ther "Children age 6-35 mos given therapeutic food"

//Received supplemental food
gen nt_ch_food_supp= rusfwk==1
replace nt_ch_food_supp=. if !inrange(kidcuragemo,6,35) | kidalive==0
label values nt_ch_food_supp yesno 
label var nt_ch_food_supp "Children age 6-35 mos given supplemental food"
