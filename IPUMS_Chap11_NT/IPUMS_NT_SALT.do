/*****************************************************************************************************
Program: 			IPUMS_NT_SALT.do
Purpose: 			Code to compute salt indicators in households
Data inputs: 			Household Variables
Data outputs:			coded variables
Author:			  Faduma Shaba
Date last modified: 		August 2020 by Faduma Shaba
Note:				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on “Household Member’s” for the unit of analysis
Select the country samples and years that you will be using then include all the “Household Member’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:

saltest3		“Summary result of salt test for iodine”
----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
nt_salt_any	"Salt among all households"
nt_salt_iod	"Households with iodized salt"
----------------------------------------------------------------------------*/

*Changing Household variables to only include household members
by idhshid, sort: gen nvals=_n==1
count if nvals
keep if nvals==1 


//Salt among all households
recode saltest3 (0/1=1 "With salt tested") (6=2 "With salt but not tested") (3=3 "No salt in household"), gen(nt_salt_any) 
label var nt_salt_any "Salt among all households"

//Have iodized salt
gen nt_salt_iod= saltest3==1 if saltest3<3
label var nt_salt_iod "Households with iodized salt"
