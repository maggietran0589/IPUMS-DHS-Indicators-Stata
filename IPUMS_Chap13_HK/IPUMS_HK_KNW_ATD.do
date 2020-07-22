/*****************************************************************************************************
Program: 			  	IPUMS_HK_KNW_ATD.do
Purpose: 				  Code to compute HIV-AIDS related knowledge and attitude indicators 
Data inputs: 				Women and Men's Surveys
Data outputs:				coded variables
Author:				  Faduma Shaba
Date last modified:			 July 2020 
Note:					The indicators below can be computed for men and women. 
					
*****************************************************************************************************/
/*
IPUMS Variables:
age				“Household wealth index in quintiles”
aidsheard			“Heard of AIDS”
aidconlowryn			“Thinks always using a condom reduces AIDS risk (yes/no)”
aid1parlowryn			“Thinks having only 1 sex partner reduces AIDS risk (yes/no)”
aidhealthy			“Thinks a healthy-looking person can have AIDS”
aidgetbite			“Get AIDS from: Mosquito bites”
aidgetwitch			“Get AIDS from: Witchcraft or supernatural means”
aidgetfood			“Get AIDS from: Sharing food with person with AIDS”
aidtranpreg			“How AIDS transmitted from mother to child: During pregnancy”
aidtrandeliv			“How AIDS transmitted from mother to child: During delivery”
aidtranfeed			“How AIDS transmitted from mother to child: Breastfeeding”
aidknopregdrg			“Know about drugs to avoid AIDS transmission to baby during pregnancy”
aidkidschool			“Children with HIV should be allowed to go to school with other children”
aidgetvendor			“Would buy vegetables from vendor with AIDS”
agemn				“Household wealth index in quintiles (men)”
aidsheardmn			“Ever heard of HIV/AIDS (men)”
aidconlowrynmn		“Always using condom during sex reduces HIV/AIDS risk (men)”
aid1parlowrynmn		“Having only 1 partner with no other partners reduces HIV/AIDS risk (men)”
aidhealthymn			“Thinks a healthy-looking person can have HIV (men)”
aidgetbitemn			“Can get HIV from mosquito bites (men)”
aidgetwitchmn		“Can get HIV by witchcraft or supernatural means (men)”
aidgetfoodmn			“Can get HIV by sharing food with a person who has AIDS (men)”
aidtranpregmn		“HIV transmitted from mother to child: During pregnancy (men)”
aidtrandelivmn		“HIV transmitted from mother to child: During delivery (men)”
aidtranfeedmn		“HIV transmitted from mother to child: By breastfeeding (men)”
aidknopregdrgmn		“Know about drugs to avoid HIV transmission to baby during pregnancy (men)”
aidkidschoolmn		Children with HIV should be allowed to go to school with other children (men)”
aidgetvendormn		“Would buy vegetables from vendor with HIV (men)”
*/
/*----------------------------------------------------------------------------
Variables created in this file:
hk_ever_heard			"Have ever heard of HIV or AIDS"
hk_knw_risk_cond		"Know you can reduce HIV risk by using condoms at every sex"
hk_knw_risk_sex			"Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"
hk_knw_risk_condsex		"Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"
hk_knw_hiv_hlth			"Know that a healthy looking person can have HIV"
hk_knw_hiv_mosq			"Know that HIV cannot be transmitted by mosquito bites"
hk_knw_hiv_supernat		"Know that HIV cannot be transmitted by supernatural means"
hk_knw_hiv_food			"Know that cannot become infected by sharing food with a person who has HIV"
hk_knw_hiv_hlth_2miscp	"Know that a healthy looking person can have HIV and reject the two most common local misconceptions"
hk_knw_comphsv			"Have comprehensive knowledge about HIV"
	
hk_knw_mtct_preg		"Know that HIV mother to child transmission can occur during pregnancy"
hk_knw_mtct_deliv		"Know that HIV mother to child transmission can occur during delivery"
hk_knw_mtct_brfeed		"Know that HIV mother to child transmission can occur by breastfeeding"
hk_knw_mtct_all3		"Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"
hk_knw_mtct_meds		"Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"
	
hk_atd_child_nosch		"Think that children living with HIV should not go to school with HIV negative children"
hk_atd_shop_notbuy		"Would not buy fresh vegetables from a shopkeeper who has HIV"
hk_atd_discriminat		"Have discriminatory attitudes towards people living with HIV"
----------------------------------------------------------------------------*/

********************
**WOMEN’S SURVEYS**
********************

* limiting to women age 15-49
drop if age>49

cap label define yesno 0"No" 1"Yes"

*** HIV related knowledge ***
//Ever heard of HIV/AIDS
gen hk_ever_heard= aidsheard==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Know reduce risk - use condoms
gen hk_knw_risk_cond= aidconlowryn==1
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= aid1parlowryn==1
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"

//Know reduce risk - use condoms and limit to one partner
gen hk_knw_risk_condsex= aidconlowryn==1 & aid1parlowryn==1
label values hk_knw_risk_condsex yesno
label var hk_knw_risk_condsex "Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= aidhealthy==1
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= aidgetbite==0
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites"

//Know HIV cannot be transmitted by supernatural means
gen hk_knw_hiv_supernat= aidgetwitch==0
label values hk_knw_hiv_supernat yesno
label var hk_knw_hiv_supernat "Know that HIV cannot be transmitted by supernatural means"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= aidgetfood==0
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV"

//Know healthy person can have HIV and reject two common local misconceptions
gen hk_knw_hiv_hlth_2miscp= aidhealthy==1 & aidgetbite==0 & aidgetwitch==0
label values hk_knw_hiv_hlth_2miscp yesno
label var hk_knw_hiv_hlth_2miscp "Know that a healthy looking person can have HIV and reject the two most common local misconceptions"

//HIV comprehensive knowledge
gen hk_knw_comphsv= aidconlowryn==1 & aid1parlowryn==1 & aidhealthy==1 & aidgetbite==0 & aidgetwitch==0
label values hk_knw_comphsv yesno
label var hk_knw_comphsv "Have comprehensive knowledge about HIV"

//Know that HIV MTCT can occur during pregnancy
gen hk_knw_mtct_preg= aidtranpreg==1
label values hk_knw_mtct_preg yesno
label var hk_knw_mtct_preg "Know that HIV mother to child transmission can occur during pregnancy"

//Know that HIV MTCT can occur during delivery
gen hk_knw_mtct_deliv= aidtrandeliv==1
label values hk_knw_mtct_deliv yesno
label var hk_knw_mtct_deliv "Know that HIV mother to child transmission can occur during delivery"

//Know that HIV MTCT can occur during breastfeeding
gen hk_knw_mtct_brfeed= aidtranfeed==1
label values hk_knw_mtct_brfeed yesno
label var hk_knw_mtct_brfeed "Know that HIV mother to child transmission can occur by breastfeeding"

//Know all three HIV MTCT
gen  hk_knw_mtct_all3= aidtranpreg==1 & aidtrandeliv==1 & aidtranfeed==1
label values hk_knw_mtct_all3 yesno
label var hk_knw_mtct_all3 "Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= aidknopregdrg==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"

*** Attitudes ***

//Think that children with HIV should not go to school with HIV negative children
gen hk_atd_child_nosch= aidkidschool==0 
replace hk_atd_child_nosch=. if aidsheard==0
label values hk_atd_child_nosch yesno	
label var hk_atd_child_nosch "Think that children living with HIV should not go to school with HIV negative children"

//Would not buy fresh vegetabels from a shopkeeper who has HIV
gen hk_atd_shop_notbuy= aidgetvendor==0 
replace hk_atd_shop_notbuy=. if aidsheard==0
label values hk_atd_shop_notbuy yesno
label var hk_atd_shop_notbuy "Would not buy fresh vegetables from a shopkeeper who has HIV"

//Have discriminatory attitudes towards people living with HIV-AIDS
gen hk_atd_discriminat= (aidkidschool==0 | aidgetvendor==0) 
replace hk_atd_discriminat=. if aidsheard==0
label values hk_atd_discriminat yesno
label var hk_atd_discriminat "Have discriminatory attitudes towards people living with HIV"



*****************
**MEN’S SURVEYS**
*****************
drop if agemn>49

cap label define yesno 0"No" 1"Yes"

*** HIV related knowledge ***
//Ever heard of HIV/AIDS
gen hk_ever_heard=aidsheardmn==1
label values hk_ever_heard yesno
label var hk_ever_heard "Have ever heard of HIV or AIDS"

//Know reduce risk - use condoms
gen hk_knw_risk_cond= aidconlowrynmn==1
label values hk_knw_risk_cond yesno
label var hk_knw_risk_cond "Know you can reduce HIV risk by using condoms at every sex"

//Know reduce risk - limit to one partner
gen hk_knw_risk_sex= aid1parlowrynmn==1
label values hk_knw_risk_sex yesno
label var hk_knw_risk_sex "Know you can reduce HIV risk by limiting to one uninfected sexual partner who has no other partners"

//Know reduce risk - use condoms and limit to one partner
gen hk_knw_risk_condsex= aidconlowrynmn==1 & aid1parlowrynmn==1
label values hk_knw_risk_condsex yesno
label var hk_knw_risk_condsex "Know you can reduce HIV risk by using condoms at every sex and limiting to one uninfected partner with no other partner"

//Know healthy person can have HIV
gen hk_knw_hiv_hlth= aidhealthymn==1
label values hk_knw_hiv_hlth yesno
label var hk_knw_hiv_hlth "Know that a healthy looking person can have HIV"

//Know HIV cannot be transmitted by mosquito bites
gen hk_knw_hiv_mosq= maidgetbite==0
label values hk_knw_hiv_mosq yesno
label var hk_knw_hiv_mosq "Know that HIV cannot be transmitted by mosquito bites"

//Know HIV cannot be transmitted by supernatural means
gen hk_knw_hiv_supernat= aidgetwitchmn==0
label values hk_knw_hiv_supernat yesno
label var hk_knw_hiv_supernat "Know that HIV cannot be transmitted by supernatural means"

//Know HIV cannot be transmitted by sharing food with HIV infected person
gen hk_knw_hiv_food= aidgetfoodmn==0
label values hk_knw_hiv_food yesno
label var hk_knw_hiv_food "Know that cannot become infected by sharing food with a person who has HIV"

//Know healthy person can have HIV and reject two common local misconceptions
gen hk_knw_hiv_hlth_2miscp= aidhealthymn==1 & maidgetbite==0 & aidgetwitchmn==0
label values hk_knw_hiv_hlth_2miscp yesno
label var hk_knw_hiv_hlth_2miscp "Know that a healthy looking person can have HIV and reject the two most common local misconceptions"

//HIV comprehensive knowledge
gen hk_knw_comphsv= aidconlowrynmn==1 & aid1parlowrynmn==1 & aidhealthymn==1 & maidgetbite==0 & aidgetwitchmn==0
label values hk_knw_comphsv yesno
label var hk_knw_comphsv "Have comprehensive knowledge about HIV"

//Know that HIV MTCT can occur during pregnancy
gen hk_knw_mtct_preg= aidtranpregmn==1
label values hk_knw_mtct_preg yesno
label var hk_knw_mtct_preg "Know that HIV mother to child transmission can occur during pregnancy"

//Know that HIV MTCT can occur during delivery
gen hk_knw_mtct_deliv= aidtrandelivmn==1
label values hk_knw_mtct_deliv yesno
label var hk_knw_mtct_deliv "Know that HIV mother to child transmission can occur during delivery"

//Know that HIV MTCT can occur during breastfeeding
gen hk_knw_mtct_brfeed= aidtranfeedmn==1
label values hk_knw_mtct_brfeed yesno
label var hk_knw_mtct_brfeed "Know that HIV mother to child transmission can occur by breastfeeding"

//Know all three HIV MTCT
gen  hk_knw_mtct_all3= aidtranpregmn==1 & aidtrandelivmn==1 & aidtranfeedmn==1
label values hk_knw_mtct_all3 yesno
label var hk_knw_mtct_all3 "Know that HIV mother to child transmission can occur during pregnancy, delivery, and by breastfeeding"

//Know risk of HIV MTCT can be reduced by meds
gen hk_knw_mtct_meds= aidknopregdrgmn==1
label values hk_knw_mtct_meds yesno
label var hk_knw_mtct_meds "Know that risk of HIV mother to child transmission can be reduced by the mother taking special drugs"

*** Attitudes ***

//Think that children with HIV should not go to school with HIV negative children
gen hk_atd_child_nosch= aidkidschoolmn==0 
replace hk_atd_child_nosch=. if aidsheardmn==0
label values hk_atd_child_nosch yesno	
label var hk_atd_child_nosch "Think that children living with HIV should not go to school with HIV negative children"

//Would not buy fresh vegetabels from a shopkeeper who has HIV
gen hk_atd_shop_notbuy= aidgetvendormn==0 
replace hk_atd_shop_notbuy=. if aidsheardmn==0
label values hk_atd_shop_notbuy yesno
label var hk_atd_shop_notbuy "Would not buy fresh vegetables from a shopkeeper who has HIV"

//Have discriminatory attitudes towards people living with HIV-AIDS
gen hk_atd_discriminat= (aidkidschoolmn==0 | aidgetvendormn==0) 
replace hk_atd_discriminat=. if aidsheardmn==0
label values hk_atd_discriminat yesno
label var hk_atd_discriminat "Have discriminatory attitudes towards people living with HIV"
