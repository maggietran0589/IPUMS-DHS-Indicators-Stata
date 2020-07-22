/*****************************************************************************************************
Program: 			IPUMS_HK_RSKY_BHV.do
Purpose: 			Code to compute Multiple Sexual Partners, Higher-Risk Sexual Partners, and Condom Use
Data inputs: 			IPUMS DHS Women and Men’s Variables
Data outputs:			coded variables
Author:				  Faduma Shaba
Date last modified:   July 2020
Note:				The indicators below can be computed for men and women. 
		
					
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on Women for the unit of analysis
Select the country samples and years that you will be using then include all the women’s variables listed below.
After selecting all the women’s variables, change the unit of analysis to men’s and include all the men’s variables listed below.

2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:

**********************
**WOMEN’S VARIABLES**
**********************
age			“Age”
timesincesex		“Time since last intercourse”
sxparyrno		“Number of sex partners, including spouse, in past 12 months”
sxpar1rel		“Relationship with most recent sexual partner”
sxpar2rel		“Relationship with 2nd most recent sexual partner”
sxpar3rel		“Relationship with 3rd most recent sexual partner”
conusman1		"Condom used during woman's most recent intercourse"
conusman2		“Condom used in woman's last intercourse with 2nd most recent partner”
conusman3		“Condom used in woman's last intercourse with 3rd most recent partner”
sxparlifeno		"Lifetime total number of sexual partners"
perweight		“Sample weight for persons”

*******************
**MEN’S VARIABLES**
*******************
timesincesexmn	“Time since last intercourse (men)”
sxparyrnomn		“Number of sex partners, including spouse, in past 12 months (men)”
sxpar1relmn		“Relationship with most recent sexual partner (men)”
sxpar2relmn		“Relationship with 2nd most recent sexual partner (men)”
sxpar3relmn		“Relationship with 3rd most recent sexual partner (men)”
conuspar1mn		"Condom used during last sex with most recent partner (men)" 
conuspar2mn		“Condom used during last sex with 2nd most recent partner (men)”
conuspar3mn		“Condom used during last sex with 3rd most recent partner (men)”
sxparlifenomn		"Total lifetime number of sex partners (men)"
perweightmn		“Men's sample weight (men)”
moneyforsexmn	“Ever paid anyone in exchange for sex (men)”
"moneyforsexyrmn	"Paid for sex in last 12 months (men)"
conpaysexyr		"Condom used last time paid for sex in last 12 months (men)"
agemn			"Age (men)"
----------------------------------------------------------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------
Variables created in this file:
hk_sex_2plus		"Have two or more sexual partners in the past 12 months"
hk_sex_notprtnr		"Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"
hk_cond_2plus		"Have two or more sexual partners in the past 12 months and used a condom at last sex"
hk_cond_notprtnr	"Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"
hk_sexprtnr_mean 	"Mean number of sexual partners"
*only among men	
hk_paid_sex_ever	"Ever paid for sex among men 15-49"
hk_paid_sex_12mo	"Paid for sex in the past 12 months among men 15-49"
hk_paid_sex_cond	"Used a condom at last paid sexual intercourse in the past 12 months among men 15-49"
----------------------------------------------------------------------------*/

**********************
**WOMEN’S VARIABLES**
**********************
* limiting to women age 15-49
drop if age>49

cap label define yesno 0"No" 1"Yes"

**********************************
//Two or more sexual partners
gen hk_sex_2plus= (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & inrange(sxparyrno,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & (inrange(sxpar1rel,2,6) | inlist(sxpar1rel,8,96))
*next-to-last-partner
gen risk2= (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & (inrange(sxpar2rel,2,6) | inlist(sxpar2rel,8,96))
*third-to-last-partner
gen risk3= (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & (inrange(sxpar3rel,2,6) | inlist(sxpar3rel,8,96))
*combining all partners
gen hk_sex_notprtnr=risk1>0|risk2>0|risk3>0
label values hk_sex_notprtnr yesno
label var hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"

//Have two or more sexual partners and used condom at last sex
gen hk_cond_2plus= (inrange(timesincesex,100,251) | inrange(timesincesex,300,311)) & inrange(sxparyrno,2,99) & conusman1==1
replace hk_cond_2plus=. if sxparyrno<2
label values hk_cond_2plus yesno
label var hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex"

//Had sex with a person that was not their partner and used condom
gen hk_cond_notprtnr=0 if hk_sex_notprtnr==1
*see risk1, risk2, and risk3 variables above
replace hk_cond_notprtnr=1 if risk1==1 & conusman1==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2==1 & conusman2==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2!=1 & risk3==1 & conusman3==1
label values hk_cond_notprtnr yesno
label var hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouce and does not live with them in the past 12 months"

//Mean number of sexual partners
summarize sxparlifeno if inrange(sxparlifeno,1,95) [fweight=v005], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of sexual partners"




*******************
**MEN’S VARIABLES**
*******************

* limiting to men age 15-49
drop if agemn>49

cap label define yesno 0"No" 1"Yes"
***********************************

//Two or more sexual partners
gen hk_sex_2plus= (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & inrange(sxparyrnomn,2,99) 
label values hk_sex_2plus yesno
label var hk_sex_2plus "Have two or more sexual partners in the past 12 months"

//Had sex with a person that was not their partner
*last partner
gen risk1= (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & (inrange(sxpar1relmn,2,6) | inlist(sxpar1relmn,8,96))
*next-to-last-partner
gen risk2= (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & (inrange(sxpar2relmn,2,6) | inlist(sxpar2relmn,8,96))
*third-to-last-partner
gen risk3= (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & (inrange(sxpar3relmn,2,6) | inlist(sxpar3relmn,8,96))
*combining all partners
gen hk_sex_notprtnr=risk1>0|risk2>0|risk3>0
label values hk_sex_notprtnr yesno
label var hk_sex_notprtnr "Had sexual intercourse with a person that is not their spouse and does not live with them in the past 12 months"

//Have two or more sexual partners and used condom at last sex
gen hk_cond_2plus= (inrange(timesincesexmn,100,251) | inrange(timesincesexmn,300,311)) & inrange(sxparyrnomn,2,99) & conuspar1mn==1
replace hk_cond_2plus=. if sxparyrnomn<2
label values hk_cond_2plus yesno
label var hk_cond_2plus "Have two or more sexual partners in the past 12 months and used a condom at last sex"

//Had sex with a person that was not their partner and used condom
gen hk_cond_notprtnr=0 if hk_sex_notprtnr==1
*see risk1, risk2, and risk3 variables above
replace hk_cond_notprtnr=1 if risk1==1 & conuspar1mn==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2==1 & conuspar2mn==1
replace hk_cond_notprtnr=1 if risk1!=1 & risk2!=1 & risk3==1 & conuspar3mn==1
label values hk_cond_notprtnr yesno
label var hk_cond_notprtnr "Used a condom at last sex with a partner that is not their spouse and does not live with them in the past 12 months"

//Mean number of sexual partners
summarize sxparlifenomn if inrange(sxparlifenomn,1,95) [fweight=perweightmn], detail
gen hk_sexprtnr_mean=r(mean)
label var hk_sexprtnr_mean "Mean number of sexual partners"

//Ever paid for sex
gen hk_paid_sex_ever= moneyforsexmn==1
label values hk_paid_sex_ever yesno	
label var hk_paid_sex_ever "Ever paid for sex among men 15-49"

//Paid for sex in the last 12 months
gen hk_paid_sex_12mo= moneyforsexyrmn==1
label values hk_paid_sex_12mo yesno
label var hk_paid_sex_12mo "Paid for sex in the past 12 months among men 15-49"

//Used a condom at last paid sex in the last 12 months
gen hk_paid_sex_cond= 0 if moneyforsexyrmn==1 
replace hk_paid_sex_cond= 1 if conpaysexyr==1
label values hk_paid_sex_cond yesno
label var hk_paid_sex_cond "Used a condom at last paid sexual intercourse in the past 12 months among men 15-49"


