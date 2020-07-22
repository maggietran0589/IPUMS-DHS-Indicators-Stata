/*****************************************************************************************************
Program: 			IPUMS_RC_tables.do
Purpose: 			produce tables for indicators
Author:				Faduma SHaba
Date last modified: March 2020 
*Note this do file will produce the following tables in excel:
	1. 	Tables_background_wm:		Contains the tables for background variables for women
	2. 	Tables_background_mn:		Contains the tables for background variables for men
	3. 	Tables_educ_wm:				Contains the tables for education indicators for women
	4. 	Tables_educ_mn:				Contains the tables for education indicators for women
	5.	Tables_media_wm:			Contains the tables for media exposure and internet use for women
	6.	Tables_media_mn:			Contains the tables for media exposure and internet use for men
	7.	Tables_employ_wm:			Contains the tables for employment and occupation indicators for women
	8.	Tables_employ_mn:			Contains the tables for employment and occupation indicators for men
	9.  Tables_insurance_wm:		Contains the tables for health insurance indicators for women
	10. Tables_insurance_mn:		Contains the tables for health insurance indicators for men
	11. Tables_tobac_wm:			Contains the tables for tobacco use indicators for women
	12. Tables_tobac_mn:			Contains the tables for tobacco use indicators for men
Notes: 					 						
*****************************************************************************************************/

* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
****************************************************

* indicators from IDHS

**************************************************************************************************
* Background characteristics: excel file Tables_background_wm will be produced
**************************************************************************************************

*age
tab age [iw=perwt] 

*marital status
tab marstat [iw=perwt] 

*residence
tab urban [iw=perwt] 

*region
tab defactores [iw=perwt] 

*education
tab educlvl [iw=perwt] 

*wealth
tab wealthq [iw=perwt] 

* output to excel
tabout age marstat urban defactores educlvl wealthq using Tables_background_wm.xls [iw=perwt] , oneway cells(cell freq) replace 
*/
**************************************************************************************************
* Indicators for education and literacy: excel file Tables_educ_wm will be produced
**************************************************************************************************
//Highest level of schooling

*age
tab age educlvl [iw=perweight], row nofreq 

*residence
tab urban educlvl [iw=perweight], row nofreq 

*region
tab defactores educlvl [iw=perweight], row nofreq 

*wealth
tab wealthq educlvl [iw=perweight], row nofreq 

* output to excel
tabout age urban defactores wealthq educlvl using Tables_educ_wm.xls [iw=perweight], c(row) f(1) replace 

//Median years of schooling
tab edyrtotal 

tabout edyrtotal using Tables_educ_wm.xls [iw=perweight] , oneway cells(cell) append 

****************************************************
//Literacy levels

*age
tab age lit2 [iw=perweight], row nof

*residence
tab urban lit2 [iw=perweight], row nof 

*region
tab defactores lit2 [iw=perweight], row nof

*wealth
tab wealthq lit2 [iw=perweight], row nof 

* output to excel
tabout age urban defactores wealthq lit2 using Tables_educ_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Literate 

*age
tab age lityn [iw=perweight], row nof 

*residence
tab urban lityn [iw=perweight], row nof 

*region
tab defactores lityn [iw=perweight], row nof 

*wealth
tab wealthq lityn [iw=perweight], row nof 

* output to excel
tabout age urban defactores wealthq lityn using Tables_educ_wm.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for media exposure and internet use: excel file Tables_media_wm will be produced
**************************************************************************************************
//Reads a newspaper

*age
tab age newswk [iw=perweight], row nof 

*residence
tab urban newswk [iw=perweight], row nof 

*region
tab defactores newswk [iw=perweight], row nof 

*education
tab educlvl newswk [iw=perweight], row nof 

*wealth
tab wealthq newswk [iw=perweight], row nof 

* output to excel
tabout age urban defactores educlvl wealthq newswk using Tables_media_wm.xls [iw=perweight] , c(row) f(1) replace 

****************************************************
//Watches TV

*age
tab age tvwk [iw=perweight], row nof 

*residence
tab urban tvwk [iw=perweight], row nof 

*region
tab defactores tvwk [iw=perweight], row nof 

*education
tab educlvl tvwk [iw=perweight], row nof 

*wealth
tab wealthq tvwk [iw=perweight], row nof 

* output to excel
tabout age urban defactores educlvl wealthq tvwk using Tables_media_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Listens to radio

*age
tab age radiowk [iw=perweight], row nof 

*residence
tab urban radiowk [iw=perweight], row nof 

*region
tab defactores radiowk [iw=perweight], row nof 

*education
tab educlvl radiowk [iw=perweight], row nof 

*wealth
tab wealthq radiowk [iw=perweight], row nof  

* output to excel
tabout age urban defactores educlvl wealthq radiowk using Tables_media_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//All three media

*age
tab age media_all [iw=perweight], row nof 

*residence
tab urban media_all [iw=perweight], row nof 

*region
tab defactores media_all [iw=perweight], row nof 

*education
tab educlvl media_all [iw=perweight], row nof 

*wealth
tab wealthq media_all [iw=perweight], row nof   

* output to excel
tabout age urban defactores educlvl wealthq media_all using Tables_media_wm.xls [iw=perweight], c(row) f(1) append 

****************************************************
//None of the media forms

*age
tab age media_none [iw=perweight], row nof 

*residence
tab urban media_none [iw=perweight], row nof 

*region
tab defactores media_none [iw=perweight], row nof 

*education
tab educlvl media_none [iw=perweight], row nof 

*wealth
tab wealthq media_none [iw=perweight], row nof 

* output to excel
tabout age urban defactores educlvl wealthq media_none using Tables_media_wm.xls [iw=perweight], c(row) f(1) append 

****************************************************
//Ever used the internet

replace internetevyr=. if internetevyr>97
replace internetevyr=1 if internetevyr==11 | internetevyr==12 | internetevyr==12
label define internetevyr 0 "No" 1 "Yes"
label values internetevyr internetevyr

*age
tab age internetevyr [iw=perweight], row nof 

*residence
tab urban internetevyr [iw=perweight], row nof 

*region
tab defactores internetevyr [iw=perweight], row nof 

*education
tab educlvl internetevyr [iw=perweight], row nof 

*wealth
tab wealthq internetevyr [iw=perweight], row nof

* output to excel
tabout age urban defactores educlvl wealthq internetevyr using Tables_media_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months

replace internetevyr=. if internetevyr>97
replace internetevyr=0 if internetevyr==0 | internetevyr==12 | internetevyr==13
replace internetevyr=1 if internetevyr==11 
label define internetevyr 0 "No" 1 "Yes"
label values internetevyr internetevyr

*age
tab age internetevyr [iw=perweight], row nof 

*residence
tab urban internetevyr [iw=perweight], row nof 

*region
tab defactores internetevyr [iw=perweight], row nof 

*education
tab educlvl internetevyr [iw=perweight], row nof 

*wealth
tab wealthq internetevyr [iw=perweight], row nof

* output to excel
tabout age urban defactores educlvl wealthq internetevyr using Tables_media_wm.xls [iw=perweight] , c(row) f(1) append 
****************************************************
//Internet use frequency

*age
tab age internetmo [iw=perweight], row nof 

*residence
tab urban internetmo [iw=perweight], row nof 

*region
tab defactores internetmo [iw=perweight], row nof 

*education
tab educlvl internetmo [iw=perweight], row nof 

*wealth
tab wealthq internetmo [iw=perweight], row nof

* output to excel
tabout age urban defactores educlvl wealthq internetmo using Tables_media_wm.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for employment and occupation: excel file Tables_employ_wm will be produced
**************************************************************************************************
//Employment status

*age
tab age wkworklastyr [iw=perweight], row nof 

*residence
tab urban wkworklastyr [iw=perweight], row nof 

*region
tab defactores wkworklastyr [iw=perweight], row nof 

*education
tab educlvl wkworklastyr [iw=perweight], row nof 

*wealth
tab wealthq wkworklastyr [iw=perweight], row nof

* output to excel
tabout age urban defactores educlvl wealthq wkworklastyr using Tables_employ_wm.xls [iw=perweight] , c(row) f(1) replace 

****************************************************************************
//Occupation

*age
tab age wkcurrjob [iw=perweight], row nof 

*residence
tab urban wkcurrjob [iw=perweight], row nof 

*region
tab defactores wkcurrjob [iw=perweight], row nof 

*education
tab educlvl wkcurrjob [iw=perweight], row nof 

*wealth
tab wealthq wkcurrjob [iw=perweight], row nof

* output to excel
tabout age urban defactores educlvl wealthq wkcurrjob using Tables_employ_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************************************
//Agriculture

gen agri=.
replace agri=0 if wkcurrjob==0 | wkcurrjob==10 | wkcurrjob==20| wkcurrjob==21| wkcurrjob==22| wkcurrjob==40| wkcurrjob==41| wkcurrjob==42| wkcurrjob==50| wkcurrjob==51| wkcurrjob==52| wkcurrjob==60| wkcurrjob==96| wkcurrjob==97
replace agri=1 if wkcurrjob==30 | wkcurrjob==31 | wkcurrjob==32 
label define 0 "Non-Agriculture" 1 "Agriculture"

//Type of employer
tab whoworkfor agri [iw=perweight], col nof 

//Type of earnings
tab wkearntype agri [iw=perweight], col nof 

*Continuity of employment
tab wkworklastyr agri [iw=perweight], col nof 

* output to excel
cap tabout whoworkfor wkearntype wkworklastyr agri using Tables_employ_wm.xls [iw=perweight], c(col) f(1) append 

**************************************************************************************************
* Indicators for health insurance: excel file Tables_insurance_wm will be produced
**************************************************************************************************
//Social security

*age
tab age inssocs [iw=perweight], row nof 

*residence
tab urban insscos [iw=perweight], row nof 

*region
tab v024 insscos [iw=perweight], row nof 

*education
tab educlvl inssocs [iw=perweight], row nof 

*wealth
tab wealthq inssocs [iw=perweight], row nof

* output to excel
tabout age urban v024 educlvl wealthq inssocs using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1)

****************************************************
//Other employer based insurance

*age
tab age insemployer [iw=perweight], row nof 

*residence
tab urban insemployer [iw=perweight], row nof 

*region
tab v024 insemployer [iw=perweight], row nof 

*education
tab educlvl insemployer [iw=perweight], row nof 

*wealth
tab wealthq insemployer [iw=perweight], row nof

* output to excel
tabout age urban v024 educlvl wealthq insemployer using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Community-based insurance

*age
tab age insorg [iw=perweight], row nof 

*residence
tab urban insorg [iw=perweight], row nof 

*region
tab v024 insorg [iw=perweight], row nof 

*education
tab educlvl insorg [iw=perweight], row nof 

*wealth
tab wealthq insorg [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq insorg using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Private insurance

*age
tab age insprivate [iw=perweight], row nof 

*residence
tab urban insprivate [iw=perweight], row nof 

*region
tab v024 insprivate [iw=perweight], row nof 

*education
tab educlvl insprivate [iw=perweight], row nof 

*wealth
tab wealthq insprivate [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq insprivate using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Other type of insurance

*age
tab age insother [iw=perweight], row nof 

*residence
tab urban insother [iw=perweight], row nof 

*region
tab v024 insother [iw=perweight], row nof 

*education
tab educlvl insother [iw=perweight], row nof 

*wealth
tab wealthq insother [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq insother using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Have any insurance

*age
tab age inscoveryn [iw=perweight], row nof 

*residence
tab urban inscoveryn [iw=perweight], row nof 

*region
tab v024 inscoveryn [iw=perweight], row nof 

*education
tab educlvl inscoveryn [iw=perweight], row nof 

*wealth
tab wealthq inscoveryn [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq inscoveryn using Tables_insurance_wm.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for tobacco use: excel file Tables_tobac_wm will be produced
**************************************************************************************************
//Smokes cigarettes

*age
tab age tosmoke [iw=perweight], row nof 

*residence
tab urban tosmoke [iw=perweight], row nof 

*region
tab v024 tosmoke [iw=perweight], row nof 

*education
tab educlvl tosmoke [iw=perweight], row nof 

*wealth
tab wealthq tosmoke [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq tosmoke using Tables_tobac_wm.xls [iw=perweight] , c(row) f(1) replace 

****************************************************
//Smokes other type of tobacco

*age
tab age tosmokeoth [iw=perweight], row nof 

*residence
tab urban tosmokeoth [iw=perweight], row nof 

*region
tab v024 tosmokeoth [iw=perweight], row nof 

*education
tab educlvl tosmokeoth [iw=perweight], row nof 

*wealth
tab wealthq tosmokeoth [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq tosmokeoth using Tables_tobac_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Smokes any tobacco

gen tosmokeany= tosmoke==1 | topipe==1 | tocigar==1 | toshisha==1 
label var tosmokeany "Smokes any type of tobacco"

*age
tab age tosmokeany [iw=perweight], row nof 

*residence
tab urban tosmokeany [iw=perweight], row nof 

*region
tab v024 tosmokeany [iw=perweight], row nof 

*education
tab educlvl tosmokeany [iw=perweight], row nof 

*wealth
tab wealthq tosmokeany [iw=perweight], row nof 

* output to excel
tabout age urban v024 educlvl wealthq tosmokeany using Tables_tobac_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
* Smokeless tobacco use

//Snuff by mouth
tab tosnuffm [iw=perweight]

//Snuff by nose
tab tosnuffn [iw=perweight]

//Chews tobacco
tab tochew [iw=perweight]

//Betel quid with tobacco
tab toghutka [iw=perweight]

//Other type of smokless tobacco
tab tosmokelessoth [iw=perweight]

//Any smokeless tobacco
tab tosmokelessany [iw=perweight]

//Uses any type of tobacco
tab tonosmoke if tonosmoke==0 [iw=wt]

* output to excel
tabout tosnuffm tosnuffn tochew toghutka tosmokelessoth tosmokelessany tonosmoke if tonosmoke==0 using Tables_tobac_wm.xls [iw=perweight] , oneway cells(cell freq) append 

}

****************************************************************************
****************************************************************************

* indicators from MR file
if file=="MR" {
gen wt=mv005/1000000


**************************************************************************************************
* Background characteristics: excel file Tables_background_mn will be produced
**************************************************************************************************

*age
tab agemn [iw=perweight] 

*marital status
tab marstatmn [iw=perweight] 

*residence
tab urbanmn [iw=perweight] 

*region
tab mv024 [iw=perweight] 

*education
tab educlvlmn [iw=perweight] 

*wealth
tab wealthqmn [iw=perweight]

* output to excel
tabout agemn marstatmn urbanmn mv024 educlvlmn wealthqmn using Tables_background_mn.xls [iw=perweight] , oneway cells(cell freq) replace 
*/
**************************************************************************************************
* Indicators for education and literacy: excel file Tables_educ_mn will be produced
**************************************************************************************************
//Highest level of schooling

*age
tab agemn educlvlmn [iw=perweight], row nof 

*residence
tab urbanmn educlvlmn [iw=perweight], row nof 

*region
tab mv024 educlvlmn [iw=perweight], row nof 

*wealth
tab wealthqmn educlvlmn [iw=perweight], row nof 

* output to excel
tabout agemn marstatmn urbanmn mv024 wealthqmn educlvlmn using Tables_educ_mn.xls [iw=perweight] , c(row) f(1) replace 

//Median years of schooling
tab edyrtotalmn 

tabout rc_edu_median using Tables_educ_mn.xls [iw=wt] , oneway cells(cell) append 

****************************************************
//Literacy levels

*age
tab age lit2mn [iw=perweight], row nof

*residence
tab urban lit2mn [iw=perweight], row nof 

*region
tab mv024 lit2mn [iw=perweight], row nof

*wealth
tab wealthq lit2mn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 wealthqmn lit2mn using Tables_educ_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Literate 

*age
tab agemn litynmn [iw=perweight], row nof 

*residence
tab urbanmn litynmn [iw=perweight], row nof 

*region
tab mv024 litynmn [iw=perweight], row nof 

*wealth
tab wealthqmn litynmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 wealthqmn litynmn using Tables_educ_mn.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for media exposure and internet use: excel file Tables_media_mn will be produced
**************************************************************************************************
//Reads a newspaper

*age
tab agemn newswkmn [iw=perweight], row nof 

*residence
tab urbanmn newswkmn [iw=perweight], row nof 

*region
tab mv024 newswkmn [iw=perweight], row nof 

*education
tab educlvlmn newswkmn [iw=perweight], row nof 

*wealth
tab wealthqmn newswkmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 wealthqmn litynmn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) replace 

****************************************************
//Watches TV

*age
tab agemn tvwkmn [iw=perweight], row nof 

*residence
tab urbanmn tvwkmn [iw=perweight], row nof 

*region
tab mv024 tvwkmn [iw=perweight], row nof 

*education
tab educlvlmn tvwkmn [iw=perweight], row nof 

*wealth
tab wealthqmn tvwkmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tvwkmn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Listens to radio

*age
tab agemn radiowkmn [iw=perweight], row nof 

*residence
tab urbanmn radiowkmn [iw=perweight], row nof 

*region
tab mv024 radiowkmn [iw=perweight], row nof 

*education
tab educlvlmn radiowkmn [iw=perweight], row nof 

*wealth
tab wealthqmn radiowkmn [iw=perweight], row nof  

* output to excel
tabout agemn urbanmn defactores educlvlmn wealthqmn radiowkmn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//All three media

*age
tab agemn media_allmn [iw=perweight], row nof 

*residence
tab urbanmn media_allmn [iw=perweight], row nof 

*region
tab mv024 media_allmn [iw=perweight], row nof 

*education
tab educlvlmn media_allmn [iw=perweight], row nof 

*wealth
tab wealthqmn media_allmn [iw=perweight], row nof   

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn media_allmn using Tables_media_mn.xls [iw=perweight], c(row) f(1) append 

****************************************************
//None of the media forms

*age
tab agemn media_nonemn [iw=perweight], row nof 

*residence
tab urbanmn media_nonemn [iw=perweight], row nof 

*region
tab mv024 media_nonemn [iw=perweight], row nof 

*education
tab educlvlmn media_nonemn [iw=perweight], row nof 

*wealth
tab wealthqmn media_nonemn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn media_nonemn using Tables_media_mn.xls [iw=perweight], c(row) f(1) append 

****************************************************
//Ever used the internet

replace internetevyrmn=. if internetevyrmn>97
replace internetevyrmn=1 if internetevyrmn==11 | internetevyrmn==12 | internetevyrmn==12
label define internetevyrmn 0 "No" 1 "Yes"
label values internetevyrmn internetevyrmn

*age
tab agemn internetevyrmn [iw=perweight], row nof 

*residence
tab urbanmn internetevyrmn [iw=perweight], row nof 

*region
tab mv024 internetevyrmn [iw=perweight], row nof 

*education
tab educlvlmn internetevyrmn [iw=perweight], row nof 

*wealth
tab wealthqmn internetevyrmn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn internetevyrmn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Internet use in the last 12 months

replace internetevyrmn=. if internetevyrmn>97
replace internetevyrmn=0 if internetevyrmn==0 | internetevyrmn==12 | internetevyrmn==13
replace internetevyrmn=1 if internetevyrmn==11 
label define internetevyrmn 0 "No" 1 "Yes"
label values internetevyrmn internetevyrmn

*age
tab agemn internetevyrmn [iw=perweight], row nof 

*residence
tab urbanmn internetevyrmn [iw=perweight], row nof 

*region
tab mv024 internetevyrmn [iw=perweight], row nof 

*education
tab educlvlmn internetevyrmn [iw=perweight], row nof 

*wealth
tab wealthqmn internetevyrmn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn internetevyrmn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Internet use frequency

*age
tab agemn internetmomn [iw=perweight], row nof 

*residence
tab urbanmn internetmomn [iw=perweight], row nof 

*region
tab mv024 internetmomn [iw=perweight], row nof 

*education
tab educlvlmn internetmomn [iw=perweight], row nof 

*wealth
tab wealthqmn internetmomn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn internetmomn using Tables_media_mn.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for employment and occupation: excel file Tables_employ_mn will be produced
**************************************************************************************************
//Employment status

*age
tab agemn wkworklastyrmn [iw=perweight], row nof 

*residence
tab urbanmn wkworklastyrmn [iw=perweight], row nof 

*region
tab mv024 wkworklastyrmn [iw=perweight], row nof 

*education
tab educlvlmn wkworklastyrmn [iw=perweight], row nof 

*wealth
tab wealthqmn wkworklastyrmn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn wkworklastyrmn using Tables_employ_mn.xls [iw=perweight] , c(row) f(1) replace 

****************************************************************************
//Occupation

*age
tab agemn wkcurrjobmn [iw=perweight], row nof 

*residence
tab urbanmn wkcurrjobmn [iw=perweight], row nof 

*region
tab mv024 wkcurrjobmn [iw=perweight], row nof 

*education
tab educlvlmn wkcurrjobmn [iw=perweight], row nof 

*wealth
tab wealthqmn wkcurrjobmn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn wkcurrjobmn using Tables_employ_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************************************
//Agriculture

gen agrimn=.
replace agrimn=0 if wkcurrjobmn==0 | wkcurrjobmn==10 | wkcurrjobmn==20| wkcurrjobmn==21| wkcurrjobmn==22| wkcurrjobmn==40| wkcurrjobmn==41| wkcurrjobmn==42| wkcurrjobmn==50| wkcurrjobmn==51| wkcurrjobmn==52| wkcurrjobmn==60| wkcurrjobmn==96| wkcurrjobmn==97
replace agri=1 if wkcurrjobmn==30 | wkcurrjobmn==31 | wkcurrjobmn==32 
label define 0 "Non-Agriculture" 1 "Agriculture"

//Type of employer
tab whoworkformn agrimn [iw=perweight], col nof 

//Type of earnings
tab wkearntypemn agrimn [iw=perweight], col nof 

*Continuity of employment
tab wkworklastyrmn agrimn [iw=perweight], col nof 

* output to excel
cap tabout whoworkformn wkearntypemn wkworklastyrmn agrimn using Tables_employ_mn.xls [iw=perweight], c(col) f(1) append 

**************************************************************************************************
* Indicators for health insurance: excel file Tables_insurance_wm will be produced
**************************************************************************************************
//Social security

*age
tab agemn inssocsmn [iw=perweight], row nof 

*residence
tab urbanmn insscosmn [iw=perweight], row nof 

*region
tab mv024 insscosmn [iw=perweight], row nof 

*education
tab educlvlmn inssocsmn [iw=perweight], row nof 

*wealth
tab wealthqmn inssocsmn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn inssocsmn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1)

****************************************************
//Other employer based insurance

*age
tab agemn insemployermn [iw=perweight], row nof 

*residence
tab urbanmn insemployermn [iw=perweight], row nof 

*region
tab mv024 insemployermn [iw=perweight], row nof 

*education
tab educlvlmn insemployermn [iw=perweight], row nof 

*wealth
tab wealthqmn insemployermn [iw=perweight], row nof

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn insemployermn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Community-based insurance

*age
tab agemn insorgmn [iw=perweight], row nof 

*residence
tab urbanmn insorgmn [iw=perweight], row nof 

*region
tab mv024 insorgmn [iw=perweight], row nof 

*education
tab educlvlmn insorgmn [iw=perweight], row nof 

*wealth
tab wealthqmn insorgmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn insorgmn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Private insurance

*age
tab agemn insprivatemn [iw=perweight], row nof 

*residence
tab urbanmn insprivatemn [iw=perweight], row nof 

*region
tab mv024 insprivatemn [iw=perweight], row nof 

*education
tab educlvlmn insprivatemn [iw=perweight], row nof 

*wealth
tab wealthqmn insprivatemn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn insprivatemn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Other type of insurance

*age
tab agemn insothermn [iw=perweight], row nof 

*residence
tab urbanmn insothermn [iw=perweight], row nof 

*region
tab mv024 insothermn [iw=perweight], row nof 

*education
tab educlvlmn insothermn [iw=perweight], row nof 

*wealth
tab wealthqmn insothermn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn insothermn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Have any insurance

*age
tab agemn inscoverynmn [iw=perweight], row nof 

*residence
tab urbanmn inscoverynmn [iw=perweight], row nof 

*region
tab mv024 inscoverynmn [iw=perweight], row nof 

*education
tab educlvlmn inscoverynmn [iw=perweight], row nof 

*wealth
tab wealthqmn inscoverynmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn inscoverynmn using Tables_insurance_mn.xls [iw=perweight] , c(row) f(1) append 

**************************************************************************************************
* Indicators for tobacco use: excel file Tables_tobac_mn will be produced
**************************************************************************************************
//Smokes cigarettes

*age
tab agemn tosmokemn [iw=perweight], row nof 

*residence
tab urbanmn tosmokemn [iw=perweight], row nof 

*region
tab mv024 tosmokemn [iw=perweight], row nof 

*education
tab educlvlmn tosmokemn [iw=perweight], row nof 

*wealth
tab wealthqmn tosmokemn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tosmokemn using Tables_tobac_mn.xls [iw=perweight] , c(row) f(1) replace 

****************************************************
//Smokes other type of tobacco

*age
tab agemn tosmokeothmn [iw=perweight], row nof 

*residence
tab urbanmn tosmokeothmn [iw=perweight], row nof 

*region
tab mv024 tosmokeothmn [iw=perweight], row nof 

*education
tab educlvlmn tosmokeothmn [iw=perweight], row nof 

*wealth
tab wealthqmn tosmokeothmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tosmokeothmn using Tables_tobac_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Smokes any tobacco

*gen tosmokeanymn= tosmoke==1 | topipe==1 | tocigar==1 | toshisha==1 
label var tosmokeanymn "Smokes any type of tobacco"

*age
tab agemn tosmokeanymn [iw=perweight], row nof 

*residence
tab urbanmn tosmokeanymn [iw=perweight], row nof 

*region
tab mv024 tosmokeanymn [iw=perweight], row nof 

*education
tab educlvlmn tosmokeanymn [iw=perweight], row nof 

*wealth
tab wealthqmn tosmokeanymn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tosmokeanymn using Tables_tobac_wm.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Smoking frequency

*age
tab agemn tosmokefqmn [iw=perweight], row nof 

*residence
tab urbanmn tosmokefqmn [iw=perweight], row nof 

*region
tab mv024 tosmokefqmn [iw=perweight], row nof 

*education
tab educlvlmn tosmokefqmn [iw=perweight], row nof 

*wealth
tab wealthqmn tosmokefqmn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tosmokefqmn using Tables_tobac_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
//Average number of cigarettes per day

*age
tab agemn tocigdaynomn [iw=perweight], row nof 

*residence
tab urbanmn tocigdaynomn [iw=perweight], row nof 

*region
tab mv024 tocigdaynomn [iw=perweight], row nof 

*education
tab educlvlmn tocigdaynomn [iw=perweight], row nof 

*wealth
tab wealthqmn tocigdaynomn [iw=perweight], row nof 

* output to excel
tabout agemn urbanmn mv024 educlvlmn wealthqmn tocigdaynomn using Tables_tobac_mn.xls [iw=perweight] , c(row) f(1) append 

****************************************************
* Smokeless tobacco use

//Uses Snuff
tab tosnuffmn [iw=perweight]

//Chews tobacco
tab tochewmn [iw=perweight]

//Betel quid with tobacco
tab toghutkamn [iw=perweight]

//Other type of smokless tobacco
tab tosmokelessothmn if tosmokelessmn==1 [iw=perweight]

//Any smokeless tobacco
tab tosmokelessanymn [iw=perweight]

//Uses any type of tobacco
tab tonosmokemn if tonosmoke==0 [iw=perweight]

* output to excel
tabout snuffmn tochewmn toghutkamn tosmokelessothmn tosmokelessanymn tonosmokemn if tonosmokemn==0 using Tables_tobac_mn.xls [iw=perweight] , oneway cells(cell freq) append 

}
