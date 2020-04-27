/*****************************************************************************************************
Program: 			  WE_ASSETS.do
Purpose: 			  Code to compute employment, earnings, and asset ownership in men and women
Data inputs: 		IPUMS DHS Work Variables
Data outputs:		coded variables
Author:				  Faduma Shaba
Date last modified: April 2020
Note:				The indicators below can be computed for men and women. 
					For women and men the indicator is computed for age 15-49 in line 33 and 111. This can be commented out if the indicators are required for all women/men.
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
wkworklastyr				"Employment status in the last 12 months among those currently in a union"
wkearntype      		"Type of earnings among those employed in the past 12 months and currently in a union"
decfemearn        	"Who decides on wife's cash earnings for employment in the last 12 months"
wkearnsmore       	"Comparison of cash earnings with husband's cash earnings"
dechusearnmn       	"Who decides on husband's cash earnings for employment in the last 12 months among men currently in a union"
dechusearn        	"Who descides on husband's cash earnings for employment in the last 12 months among women currently in a union"
femownhouse		      "Ownership of housing"
femownland			    "Ownership of land"
we_house_deed		"Title or deed possesion for owned house"
we_land_deed		"Title or deed possesion for owned land"
we_bank				"Use an account in a bank or other financial institution"
we_mobile			"Own a mobile phone"
we_mobile_finance	"Use mobile phone for financial transactions"
----------------------------------------------------------------------------*/
********************
***WOMEN'S FILES****
********************

*** Employment and earnings ***

//Employment in the last 12 months
replace wkworklastyr=. if wkworklastyr > 97

//Employment by type of earnings
replace wkearntype=. if wkearntype > 7

//Control over earnings
replace decfemearn=. if decfemearn > 97

//Comparison of earnings with husband/partner
replace wkearnsmore=. if wkearnsmore > 7

//Who decides on how husband's cash earnings are used
replace dechusearn=. if dechusearn > 97

*** Ownership of assets ***

//Own a house
replace femownhouse=. if femownhouse > 97

//Own land
replace femownland=. if femownland > 97

//Ownership of house deed
replace femhousedeed=. if femhousedeed > 97

//Ownership of land deed
replace femlanddeed=. if femlanddeed > 97

//Own a bank account
replace bankresp=. if bankresp > 7

//Own a mobile phone
replace cellphonself=. if cellphonself > 7

//Use mobile for finances
replace cellfinanc=. if cellfinanc > 7


******************
***MEN'S FILES****
******************


*** Employment and earnings ***

//Employment in the last 12 months
replace wkworklastyrmn=. if wkworklastyrmn > 97

//Employment by type of earnings
replace wkearntypemn=. if wkearntypemn > 7

//Who decides on how husband's cash earnings are used
replace decmanearn=. if decmanearn > 97

*** Ownership of assets ***

//Own a house
replace manownhouse=. if manownhouse > 97

//Own land
replace manownland=. if manownland > 97

//Ownership of house deed
replace manhousedeed=. if manhousedeed > 97

//Ownership of land deed
replace manlanddeed=. if manlanddeed > 97

//Own a bank account
replace bankrespmn=. if bankrespmn > 7

//Own a mobile phone
replace cellphonselfmn=. if cellphonselfmn > 7

//Use mobile for finances
replace cellfinancmn=. if cellfinancmn > 7
