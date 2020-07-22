/*****************************************************************************************************
Program: 			        IPUMS_WE_tables.do
Purpose: 			        produce tables for indicators
Author:				        Faduma Shaba
Date last modified:   		May 2020 
Note this do file will produce the following tables in excel:
	1. 	Tables_emply_wm:	Contains the tables for employment and earning indicators for women
	2.	Tables_emply_mn:	Contains the tables for employment and earning indicators for men
	3. 	Tables_assets_wm:	Contains the tables for asset ownwership indicators for women
	4.	Tables_assets_mn:	Contains the tables for asset ownwership indicators for men
	5. 	Tables_empw_wm:		Contains the tables for empowerment indicators, justification of wife beating, and decision making for women
	6.	Tables_empw_mn:		Contains the tables for empowerment indicators, justification of wife beating, and decision making for men
Notes:	
* the total will show on the last row of each table.
* comment out the tables or indicator section you do not want.
**************************************************************************************************/

***************************
*******Women’s Files********
***************************


* Number of living children
replace chebalive=. if chebalive > 97

**************************************************************************************************
* Employment and earnings
**************************************************************************************************
//Employment in the last 12 months
*age
tab age wkworklastyr [iw=perweight], row

* output to excel
tabout age wkworklastyr using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) replace 
*/
****************************************************
//Employment by type of earnings
*age
tab age wkearntype [iw=perweight], row

* output to excel
tabout age wkearntype using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decision on wife's cash earnings
*age
tab age decfemearn [iw=perweight], row nofreq 

*number of living children
tab chebalive decfemearn [iw=perweight], row nofreq 

*residence
tab urban decfemearn [iw=perweight], row nofreq 

*region
tab GEO-REGION decfemearn [iw=perweight], row nofreq 

*education
tab educlvl decfemearn [iw=perweight], row nofreq 

*wealth
tab wealthq decfemearn [iw=perweight], row nofreq 

* output to excel
tabout age chebalive urban educlvl GEO-REGION wealthq decfemearn using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Comparison of wife's cash earnings with husband
*age
tab age wkearnsmore[iw=perweight], row nofreq 

*number of living children
tab chebalive wkearnsmore[iw=perweight], row nofreq 

*residence
tab urban wkearnsmore[iw=perweight], row nofreq 

*region
tab GEO-REGION wkearnsmore[iw=perweight], row nofreq 

*education
tab educlvl wkearnsmore[iw=perweight], row nofreq 

*wealth
tab wealthq wkearnsmore[iw=perweight], row nofreq 

* output to excel
tabout age chebalive urban educlvl GEO-REGION wealthq wkearnsmore using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decision on husbands's cash earnings
*age
tab age dechusearn  [iw=perweight], row nofreq 

*number of living children
tab chebalive dechusearn  [iw=perweight], row nofreq 

*residence
tab urban dechusearn  [iw=perweight], row nofreq 

*region
tab GEO-REGION dechusearn  [iw=perweight], row nofreq 

*education
tab educlvl dechusearn  [iw=perweight], row nofreq 

*wealth
tab wealthq dechusearn  [iw=perweight], row nofreq 

* output to excel
tabout age chebalive urban educlvl GEO-REGION wealthq dechusearn  using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decision on wife's cash earnings by comparison of wife to husband's earnings
tab wkearnsmore decfemearn [iw=perweight], row

* output to excel
tabout wkearnsmore decfemearn using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 

//Decision on husband's cash earnings by comparison of wife to husband's earnings
gen wkearnsmore2=wkearnsmore   
replace wkearnsmore2=5 if (wkearntype==0 | wkearntype==3) 
replace wkearnsmore2=6 if wkworklastyr   ==0 
label define wkearnsmore2 1"More than husband" 2"Less than husband" 3"Same as husband" 4"Husband has no cash earnings or not working" ///
5"Woman worked but has no cash earnings" 6"Woman did not work" 8"Don't know/missing"

label values wkearnsmore2 wkearnsmore2

tab wkearnsmore2 dechusearn  [iw=perweight], row

* output to excel
tabout wkearnsmore2 dechusearn  using Tables_emply_wm.xls [iw=perweight] , c(row) f(1) append 
*/
**************************************************************************************************
* Ownership of assets
**************************************************************************************************
//Own a house
*age
tab age femownhouse [iw=perweight], row nofreq 

*residence
tab urban femownhouse [iw=perweight], row nofreq 

*region
tab GEO-REGION femownhouse [iw=perweight], row nofreq 

*education
tab educlvl femownhouse [iw=perweight], row nofreq 

*wealth
tab wealthq femownhouse [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq femownhouse using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) replace 
*/
****************************************************
//Own land
*age
tab age femownland  [iw=perweight], row nofreq 

*residence
tab urban femownland  [iw=perweight], row nofreq 

*region
tab GEO-REGION femownland  [iw=perweight], row nofreq 

*education
tab educlvl femownland  [iw=perweight], row nofreq 

*wealth
tab wealthq femownland  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq femownland  using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for house
*age
tab age femhousedeed  [iw=perweight], row nofreq 

*residence
tab urban femhousedeed  [iw=perweight], row nofreq 

*region
tab GEO-REGION femhousedeed  [iw=perweight], row nofreq 

*education
tab educlvl femhousedeed  [iw=perweight], row nofreq 

*wealth
tab wealthq femhousedeed  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq femhousedeed  using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownership for land
*age
tab age femlanddeed  [iw=perweight], row nofreq 

*residence
tab urban femlanddeed  [iw=perweight], row nofreq 

*region
tab GEO-REGION femlanddeed  [iw=perweight], row nofreq 

*education
tab educlvl femlanddeed  [iw=perweight], row nofreq 

*wealth
tab wealthq femlanddeed  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq femlanddeed  using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Have a bank account
*age
tab age bankresp  [iw=perweight], row nofreq 

*residence
tab urban bankresp  [iw=perweight], row nofreq 

*region
tab GEO-REGION bankresp  [iw=perweight], row nofreq 

*education
tab educlvl bankresp  [iw=perweight], row nofreq 

*wealth
tab wealthq bankresp  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq bankresp  using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Have a mobile phone
*age
tab age cellphoneself [iw=perweight], row nofreq 

*residence
tab urban cellphoneself [iw=perweight], row nofreq 

*region
tab GEO-REGION cellphoneself [iw=perweight], row nofreq 

*education
tab educlvl cellphoneself [iw=perweight], row nofreq 

*wealth
tab wealthq cellphoneself [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq cellphoneself using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Use mobile phone for financial transactions
*age
tab age cellfinanc [iw=perweight], row nofreq 

*residence
tab urban cellfinanc [iw=perweight], row nofreq 

*region
tab GEO-REGION cellfinanc [iw=perweight], row nofreq 

*education
tab educlvl cellfinanc [iw=perweight], row nofreq 

*wealth
tab wealthq cellfinanc [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq cellfinanc using Tables_assets_wm.xls [iw=perweight] , c(row) f(1) append 
*/
**************************************************************************************************
* Decision making indicators
**************************************************************************************************
//Decision making indicators

*on health, household purchases, and visits
tab1 decfemhcare decbighh decfamvisit [iw=perweight]

* output to excel
tabout decfemhcare decbighh decfamvisit using Tables_empw_wm.xls [iw=perweight] , oneway cells(cell) replace 

****************************************************
*Employment by earning 
gen emply=.
replace emply=0 if v731==0
replace emply=1 if v731>0 & v731<8 & (v741==1 | v741==2)
replace emply=2 if v731>0 & v731<8 & (v741==0 | v741==3)
label define emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash"
label values emply emply
label var emply "Employment in the last 12 months"

//Decide on own health care either alone or jointly with partner
*age
tab age decfemhcare [iw=perweight], row nofreq 

*employment by earning
tab emply decfemhcare [iw=perweight], row nofreq 

*number of children
tab chebalive decfemhcare [iw=perweight], row nofreq 

*residence
tab urban decfemhcare [iw=perweight], row nofreq 

*region
tab GEO-REGION decfemhcare [iw=perweight], row nofreq 

*education
tab educlvl decfemhcare [iw=perweight], row nofreq 

*wealth
tab wealthq decfemhcare [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive urban educlvl GEO-REGION wealthq decfemhcare using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decide on household purchases either alone or jointly with partner
*age
tab age decbighh [iw=perweight], row nofreq 

*employment by earning
tab emply decbighh [iw=perweight], row nofreq 

*number of children
tab chebalive decbighh [iw=perweight], row nofreq 

*residence
tab urban decbighh [iw=perweight], row nofreq 

*region
tab GEO-REGION decbighh [iw=perweight], row nofreq 

*education
tab educlvl decbighh [iw=perweight], row nofreq 

*wealth
tab wealthq decbighh [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive urban educlvl GEO-REGION wealthq decbighh using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decide on visits either alone or jointly with partner
*age
tab age decfamvisit [iw=perweight], row nofreq 

*employment by earning
tab emply decfamvisit [iw=perweight], row nofreq 

*number of children
tab chebalive decfamvisit [iw=perweight], row nofreq 

*residence
tab urban decfamvisit [iw=perweight], row nofreq 

*region
tab GEO-REGION decfamvisit [iw=perweight], row nofreq 

*education
tab educlvl decfamvisit [iw=perweight], row nofreq 

*wealth
tab wealthq decfamvisit [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive urban educlvl GEO-REGION wealthq decfamvisit using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/

**************************************************************************************************
* Justification of violence
**************************************************************************************************
//Justify wife beating if burns food
*age
tab age dvaburnfood [iw=perweight], row nofreq 

*employment by earning
tab emply dvaburnfood [iw=perweight], row nofreq 

*number of children
tab chebalive dvaburnfood [iw=perweight], row nofreq 

*marital status
tab v502 dvaburnfood [iw=perweight], row nofreq 

*residence
tab urban dvaburnfood [iw=perweight], row nofreq 

*region
tab GEO-REGION dvaburnfood [iw=perweight], row nofreq 

*education
tab educlvl dvaburnfood [iw=perweight], row nofreq 

*wealth
tab wealthq dvaburnfood [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvaburnfood using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if argues with him
*age
tab age dvaargue [iw=perweight], row nofreq 

*employment by earning
tab emply dvaargue [iw=perweight], row nofreq 

*number of children
tab chebalive dvaargue [iw=perweight], row nofreq 

*marital status
tab v502 dvaargue [iw=perweight], row nofreq 

*residence
tab urban dvaargue [iw=perweight], row nofreq 

*region
tab GEO-REGION dvaargue [iw=perweight], row nofreq 

*education
tab educlvl dvaargue [iw=perweight], row nofreq 

*wealth
tab wealthq dvaargue [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvaargue using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if goes out with telling him
*age
tab age dvagoout [iw=perweight], row nofreq 

*employment by earning
tab emply dvagoout [iw=perweight], row nofreq 

*number of children
tab chebalive dvagoout [iw=perweight], row nofreq 

*marital status
tab v502 dvagoout [iw=perweight], row nofreq 

*residence
tab urban dvagoout [iw=perweight], row nofreq 

*region
tab GEO-REGION dvagoout [iw=perweight], row nofreq 

*education
tab educlvl dvagoout [iw=perweight], row nofreq 

*wealth
tab wealthq dvagoout [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvagoout using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if neglects children
*age
tab age dvanegkid[iw=perweight], row nofreq 

*employment by earning
tab emply dvanegkid[iw=perweight], row nofreq 

*number of children
tab chebalive dvanegkid[iw=perweight], row nofreq 

*marital status
tab v502 dvanegkid[iw=perweight], row nofreq 

*residence
tab urban dvanegkid[iw=perweight], row nofreq 

*region
tab GEO-REGION dvanegkid[iw=perweight], row nofreq 

*education
tab educlvl dvanegkid[iw=perweight], row nofreq 

*wealth
tab wealthq dvanegkid[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvanegkidusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if refuses sex
*age
tab age dvaifnosex[iw=perweight], row nofreq 

*employment by earning
tab emply dvaifnosex[iw=perweight], row nofreq 

*number of children
tab chebalive dvaifnosex[iw=perweight], row nofreq 

*marital status
tab v502 dvaifnosex[iw=perweight], row nofreq 

*residence
tab urban dvaifnosex[iw=perweight], row nofreq 

*region
tab GEO-REGION dvaifnosex[iw=perweight], row nofreq 

*education
tab educlvl dvaifnosex[iw=perweight], row nofreq 

*wealth
tab wealthq dvaifnosex[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvaifnosexusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating - at least one reason
*age
tab age dvaonereas[iw=perweight], row nofreq 

*employment by earning
tab emply dvaonereas[iw=perweight], row nofreq 

*number of children
tab chebalive dvaonereas[iw=perweight], row nofreq 

*marital status
tab v502 dvaonereas[iw=perweight], row nofreq 

*residence
tab urban dvaonereas[iw=perweight], row nofreq 

*region
tab GEO-REGION dvaonereas[iw=perweight], row nofreq 

*education
tab educlvl dvaonereas[iw=perweight], row nofreq 

*wealth
tab wealthq dvaonereas[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive v502 urban educlvl GEO-REGION wealthq dvaonereasusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify having no sex if husband is having sex with another woman
*age
tab age nosexothwf[iw=perweight], row nofreq 

*marital status
tab v502 nosexothwf[iw=perweight], row nofreq 

*residence
tab urban nosexothwf[iw=perweight], row nofreq 

*region
tab GEO-REGION nosexothwf[iw=perweight], row nofreq 

*education
tab educlvl nosexothwf[iw=perweight], row nofreq 

*wealth
tab wealthq nosexothwf[iw=perweight], row nofreq 

* output to excel
tabout age v502 urban educlvl GEO-REGION wealthq nosexothwfusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify asking husband to use condom if he has STI
*age
tab age conaskifsti[iw=perweight], row nofreq 

*marital status
tab v502 conaskifsti[iw=perweight], row nofreq 

*residence
tab urban conaskifsti[iw=perweight], row nofreq 

*region
tab GEO-REGION conaskifsti[iw=perweight], row nofreq 

*education
tab educlvl conaskifsti[iw=perweight], row nofreq 

*wealth
tab wealthq conaskifsti[iw=perweight], row nofreq 

* output to excel
tabout age v502 urban educlvl GEO-REGION wealthq conaskifstiusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/

****************************************************
//Can say no to husband if they dont want to have sex
*age
tab age sxcanrefuse [iw=perweight], row nofreq 

*residence
tab urban sxcanrefuse [iw=perweight], row nofreq 

*region
tab GEO-REGION sxcanrefuse [iw=perweight], row nofreq 

*education
tab educlvl sxcanrefuse [iw=perweight], row nofreq 

*wealth
tab wealthq sxcanrefuse [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq sxcanrefuse using Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Can ask husband to use a condom
*age
tab age conaskpar[iw=perweight], row nofreq 

*residence
tab urban conaskpar[iw=perweight], row nofreq 

*region
tab GEO-REGION conaskpar[iw=perweight], row nofreq 

*education
tab educlvl conaskpar[iw=perweight], row nofreq 

*wealth
tab wealthq conaskpar[iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq conaskparusing Tables_empw_wm.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************



************************
*******Men’s Files********
************************


**************************************************************************************************
* Employment and earnings
**************************************************************************************************
//Employment in the last 12 months
*age
tab age wkworklastyr    [iw=perweight], row

* output to excel
tabout age wkworklastyr    using Tables_emply_mn.xls [iw=perweight] , c(row) f(1) replace 
*/
****************************************************
//Employment by type of earnings
*age
tab age wkearntype    [iw=perweight], row

* output to excel
tabout age wkearntype    using Tables_emply_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Decision on husband's cash earnings
*age
tab age we_earn_mn_decide [iw=perweight], row nofreq 

*number of living children
tab chebalive we_earn_mn_decide [iw=perweight], row nofreq 

*residence
tab urban we_earn_mn_decide [iw=perweight], row nofreq 

*region
tab GEO-REGION we_earn_mn_decide [iw=perweight], row nofreq 

*education
tab educlvl we_earn_mn_decide [iw=perweight], row nofreq 

*wealth
tab wealthq we_earn_mn_decide [iw=perweight], row nofreq 

* output to excel
tabout age chebalive urban educlvl GEO-REGION wealthq we_earn_mn_decide using Tables_emply_mn.xls [iw=perweight] , c(row) f(1) append 
*/
**************************************************************************************************
* Ownership of assets
**************************************************************************************************
//Own a house
*age
tab age manownhouse [iw=perweight], row nofreq 

*residence
tab urban manownhouse [iw=perweight], row nofreq 

*region
tab GEO-REGION manownhouse [iw=perweight], row nofreq 

*education
tab educlvl manownhouse [iw=perweight], row nofreq 

*wealth
tab wealthq manownhouse [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq manownhouse using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) replace 
*/
****************************************************
//Own land
*age
tab age manownland  [iw=perweight], row nofreq 

*residence
tab urban manownland  [iw=perweight], row nofreq 

*region
tab GEO-REGION manownland  [iw=perweight], row nofreq 

*education
tab educlvl manownland  [iw=perweight], row nofreq 

*wealth
tab wealthq manownland  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq manownland  using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for house
*age
tab age manhousedeed  [iw=perweight], row nofreq 

*residence
tab urban manhousedeed  [iw=perweight], row nofreq 

*region
tab GEO-REGION manhousedeed  [iw=perweight], row nofreq 

*education
tab educlvl manhousedeed  [iw=perweight], row nofreq 

*wealth
tab wealthq manhousedeed  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq manhousedeed  using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Title or deed ownwership for land
*age
tab age manlanddeed  [iw=perweight], row nofreq 

*residence
tab urban manlanddeed  [iw=perweight], row nofreq 

*region
tab GEO-REGION manlanddeed  [iw=perweight], row nofreq 

*education
tab educlvl manlanddeed  [iw=perweight], row nofreq 

*wealth
tab wealthq manlanddeed  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq manlanddeed  using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Have a bank account
*age
tab age bankrespmn  [iw=perweight], row nofreq 

*residence
tab urban bankrespmn  [iw=perweight], row nofreq 

*region
tab GEO-REGION bankrespmn  [iw=perweight], row nofreq 

*education
tab educlvl bankrespmn  [iw=perweight], row nofreq 

*wealth
tab wealthq bankrespmn  [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq bankrespmn  using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Have a mobile phone
*age
tab age cellphonselfmn [iw=perweight], row nofreq 

*residence
tab urban cellphonselfmn [iw=perweight], row nofreq 

*region
tab GEO-REGION cellphonselfmn [iw=perweight], row nofreq 

*education
tab educlvl cellphonselfmn [iw=perweight], row nofreq 

*wealth
tab wealthq cellphonselfmn [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq cellphonselfmn using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Use mobile phone for financial transactions
*age
tab age cellfinancmn [iw=perweight], row nofreq 

*residence
tab urban cellfinancmn [iw=perweight], row nofreq 

*region
tab GEO-REGION cellfinancmn [iw=perweight], row nofreq 

*education
tab educlvl cellfinancmn [iw=perweight], row nofreq 

*wealth
tab wealthq cellfinancmn [iw=perweight], row nofreq 

* output to excel
tabout age urban educlvl GEO-REGION wealthq cellfinancmn using Tables_assets_mn.xls [iw=perweight] , c(row) f(1) append 
*/
**************************************************************************************************
* Decision making indicators
**************************************************************************************************
//Decision making indicators

*on health and household purchases
tab1 we_decide_health we_decide_hhpurch [iw=perweight]

* output to excel
tabout we_decide_health we_decide_hhpurch using Tables_empw_mn.xls [iw=perweight] , oneway cells(cell) replace 

****************************************************
*Employment by earning either alone or jointly with partner
gen emply=.
replace emply=0 if mv731==0
replace emply=1 if mv731>0 & mv731<8 & (mv741==1 | mv741==2)
replace emply=2 if mv731>0 & mv731<8 & (mv741==0 | mv741==3)
label define emply 0"Not employed" 1"Employed for cash" 2"Employed not for cash"
label values emply emply
label var emply "Employment in the last 12 months"

//Decide on own health care
*age
tab age decmanhcare [iw=perweight], row nofreq 

*employment by earning
tab emply decmanhcare [iw=perweight], row nofreq 

*number of children
tab chebalive decmanhcare [iw=perweight], row nofreq 

*residence
tab urban decmanhcare [iw=perweight], row nofreq 

*region
tab GEO-REGION decmanhcare [iw=perweight], row nofreq 

*education
tab educlvl decmanhcare [iw=perweight], row nofreq 

*wealth
tab wealthq decmanhcare [iw=perweight], row nofreq 

* output to excel
tabout age chebalive emply urban educlvl GEO-REGION wealthq decmanhcare using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append
*/
****************************************************
//Decide on household purchases either alone or jointly with partner
*age
tab age decbighhmn [iw=perweight], row nofreq 

*employment by earning
tab emply decbighhmn [iw=perweight], row nofreq 

*number of children
tab chebalive decbighhmn [iw=perweight], row nofreq 

*residence
tab urban decbighhmn [iw=perweight], row nofreq 

*region
tab GEO-REGION decbighhmn [iw=perweight], row nofreq 

*education
tab educlvl decbighhmn [iw=perweight], row nofreq 

*wealth
tab wealthq decbighhmn [iw=perweight], row nofreq 

* output to excel
tabout age chebalive emply urban educlvl GEO-REGION wealthq decbighhmn using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/

**************************************************************************************************
* Justification of violence
**************************************************************************************************
//Justify wife beating if burns food
*age
tab age dvaburnfoodmn [iw=perweight], row nofreq 

*employment by earning
tab emply dvaburnfoodmn [iw=perweight], row nofreq 

*number of children
tab chebalive dvaburnfoodmn [iw=perweight], row nofreq 

*marital status
tab mv502 dvaburnfoodmn [iw=perweight], row nofreq 

*residence
tab urban dvaburnfoodmn [iw=perweight], row nofreq 

*region
tab GEO-REGION dvaburnfoodmn [iw=perweight], row nofreq 

*education
tab educlvl dvaburnfoodmn [iw=perweight], row nofreq 

*wealth
tab wealthq dvaburnfoodmn [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvaburnfoodmn using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if argues with him
*age
tab age dvaarguemn [iw=perweight], row nofreq 

*employment by earning
tab emply dvaarguemn [iw=perweight], row nofreq 

*number of children
tab chebalive dvaarguemn [iw=perweight], row nofreq 

*marital status
tab mv502 dvaarguemn [iw=perweight], row nofreq 

*residence
tab urban dvaarguemn [iw=perweight], row nofreq 

*region
tab GEO-REGION dvaarguemn [iw=perweight], row nofreq 

*education
tab educlvl dvaarguemn [iw=perweight], row nofreq 

*wealth
tab wealthq dvaarguemn [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvaarguemn using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if goes out with telling him
*age
tab age dvagooutmn [iw=perweight], row nofreq 

*employment by earning
tab emply dvagooutmn [iw=perweight], row nofreq 

*number of children
tab chebalive dvagooutmn [iw=perweight], row nofreq 

*marital status
tab mv502 dvagooutmn [iw=perweight], row nofreq 

*residence
tab urban dvagooutmn [iw=perweight], row nofreq 

*region
tab GEO-REGION dvagooutmn [iw=perweight], row nofreq 

*education
tab educlvl dvagooutmn [iw=perweight], row nofreq 

*wealth
tab wealthq dvagooutmn [iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvagooutmn using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if neglects children
*age
tab age dvanegkidmn[iw=perweight], row nofreq 

*employment by earning
tab emply dvanegkidmn[iw=perweight], row nofreq 

*number of children
tab chebalive dvanegkidmn[iw=perweight], row nofreq 

*marital status
tab mv502 dvanegkidmn[iw=perweight], row nofreq 

*residence
tab urban dvanegkidmn[iw=perweight], row nofreq 

*region
tab GEO-REGION dvanegkidmn[iw=perweight], row nofreq 

*education
tab educlvl dvanegkidmn[iw=perweight], row nofreq 

*wealth
tab wealthq dvanegkidmn[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvanegkidmnusing Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating if refuses sex
*age
tab age dvaifnosexmn[iw=perweight], row nofreq 

*employment by earning
tab emply dvaifnosexmn[iw=perweight], row nofreq 

*number of children
tab chebalive dvaifnosexmn[iw=perweight], row nofreq 

*marital status
tab mv502 dvaifnosexmn[iw=perweight], row nofreq 

*residence
tab urban dvaifnosexmn[iw=perweight], row nofreq 

*region
tab GEO-REGION dvaifnosexmn[iw=perweight], row nofreq 

*education
tab educlvl dvaifnosexmn[iw=perweight], row nofreq 

*wealth
tab wealthq dvaifnosexmn[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvaifnosexmnusing Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify wife beating - at least one reason
*age
tab age dvaonereasmn[iw=perweight], row nofreq 

*employment by earning
tab emply dvaonereasmn[iw=perweight], row nofreq 

*number of children
tab chebalive dvaonereasmn[iw=perweight], row nofreq 

*marital status
tab mv502 dvaonereasmn[iw=perweight], row nofreq 

*residence
tab urban dvaonereasmn[iw=perweight], row nofreq 

*region
tab GEO-REGION dvaonereasmn[iw=perweight], row nofreq 

*education
tab educlvl dvaonereasmn[iw=perweight], row nofreq 

*wealth
tab wealthq dvaonereasmn[iw=perweight], row nofreq 

* output to excel
tabout age emply chebalive mv502 urban educlvl GEO-REGION wealthq dvaonereasmnusing Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify having no sex if husband is having sex with another woman
*age
tab age nosexothwfmn[iw=perweight], row nofreq 

*marital status
tab mv502 nosexothwfmn[iw=perweight], row nofreq 

*residence
tab urban nosexothwfmn[iw=perweight], row nofreq 

*region
tab GEO-REGION nosexothwfmn[iw=perweight], row nofreq 

*education
tab educlvl nosexothwfmn[iw=perweight], row nofreq 

*wealth
tab wealthq nosexothwfmn[iw=perweight], row nofreq 

* output to excel
tabout age mv502 urban educlvl GEO-REGION wealthq nosexothwfmnusing Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/
****************************************************
//Justify asking husband to use condom if he has STI
*age
tab age conaskparmn [iw=perweight], row nofreq 

*marital status
tab mv502 conaskparmn [iw=perweight], row nofreq 

*residence
tab urban conaskparmn [iw=perweight], row nofreq 

*region
tab GEO-REGION conaskparmn [iw=perweight], row nofreq 

*education
tab educlvl conaskparmn [iw=perweight], row nofreq 

*wealth
tab wealthq conaskparmn [iw=perweight], row nofreq 

* output to excel
tabout age mv502 urban educlvl GEO-REGION wealthq conaskparmn using Tables_empw_mn.xls [iw=perweight] , c(row) f(1) append 
*/


