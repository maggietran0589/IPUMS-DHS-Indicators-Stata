/*****************************************************************************************************
Program: 			IPUMS_NT_IYCF.do
Purpose: 			Code to compute infant and child feeding indicators
Data inputs: 			IPUMS DHS Children’s Variables
Data outputs:			coded variables
Author:			Faduma Shaba
Date last modified: 		August 2020 by Faduma Shaba 
Note:				
*****************************************************************************************************/
/* DIRECTIONS
1. Create a data extract at dhs.ipums.org that includes the variables listed under ‘IPUMS Variables’.
	Begin by going to dhs.ipums.org and click on “Children” for the unit of analysis
Select the country samples and years that you will be using then include all the “Children’s” variables listed below.
2. Run this .do file.
*/
/*----------------------------------------------------------------------------------------------------------------------------
IPUMS DHS Variables used in this file:
brsfedur		Duration of breastfeeding in months
mafedsugwat24h		Mother fed youngest child sugar water in past 24 hours
mafedwater24h		"Mother fed youngest child plain water in past 24 hours	"
mafedcoftea24h		"	Mother fed youngest child coffee or tea in past 24 hours"
mafedjuice24h		"Mother fed youngest child juice in past 24 hours	"
mafedsoup24h		Mother fed youngest child soup or broth in past 24 hours
mafedothliq24h		"Mother fed youngest child other liquid in past 24 hours	"
mafedform24h		Mother fed youngest child baby formula in past 24 hours
mafedgenmilk24h		"Mother fed youngest child tinned, powdered, or fresh milk in past 24 hours	"	
mafedcereal24h		"Mother fed youngest child commerciall fortified baby food/cereal in past 24 hours	"
mafedporr24h		"Mother fed youngest child porridge or gruel in past 24 hours	"
fedany24h		"Child fed any solid, semi-solid, or soft foods in past 24 hours (last birth)	"
mafedgrain24h		"Mother fed youngest child grain in past 24 hours	"
mafedyelveg24h		"Mother fed youngest child orange/yellow vegetables in past 24 hours	"
mafedgrnveg24h		"Mother fed youngest child green leafy vegetables in past 24 hours	"
mafedvitafruit24h		"Mother fed youngest child fruits with vitamin A in past 24 hours	"
mafedofrtveg24h		"Mother fed youngest child (other) fruits/vegetables in past 24 hours	"
mafedtuber24h		"Mother fed youngest child local tubers in past 24 hours	"
mafedlegum24h		"Mother fed youngest child legumes (beans, peas, nuts) in past 24 hours	"
mafedmeat24h		"Mother fed youngest child meat in past 24 hours	"
mafedorgan24h		"Mother fed youngest child organ meat in past 24 hours	"
mafedfish24h		"Mother fed youngest child fish or shellfish in past 24 hours	"
mafedegg24h		"Mother fed youngest child eggs in past 24 hours	"
mafedcheese24h		"Mother fed youngest child cheese or yogurt in past 24 hours	"
mafedyogurt24h		"Mother fed youngest child yogurt in past 24 hours	"
mafedother24h		Mother fed youngest child other solid, semi-solid, or soft food in past 24 hours
mafedany24h		"Mother fed youngest child fed any solid, semi-solid, or soft foods in past 24 hours	"
fedany24hx		Times child fed any solid, semi-solid, or soft foods in past 24 hours


----------------------------------------------------------------------------------------------------------------------------*/


/*----------------------------------------------------------------------------
Variables created in this file:
nt_bf_status		"Breastfeeding status for last-born child under 2 years"
nt_ebf				"Exclusively breastfed - last-born under 6 months"
nt_predo_bf			"Predominantly breastfed - last-born under 6 months"
nt_ageapp_bf		"Age-appropriately breastfed - last-born under 2 years"
nt_food_bf			"Introduced to solid, semi-solid, or soft foods - last-born 6-8 months"
nt_bf_curr			"Currently breastfeeding - last-born under 2 years"
nt_bf_cont_1yr		"Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years"
nt_bf_cont_2yr		"Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years"
nt_formula			"Child given infant formula in day/night before survey - last-born under 2 years"
nt_milk				"Child given other milk in day/night before survey- last-born under 2 years"
nt_liquids			"Child given other liquids in day/night before survey- last-born under 2 years"
nt_bbyfood			"Child given fortified baby food in day/night before survey- last-born under 2 years"
nt_grains			"Child given grains in day/night before survey- last-born under 2 years"
nt_vita				"Child given vitamin A rich food in day/night before survey- last-born under 2 years"
nt_frtveg			"Child given other fruits or vegetables in day/night before survey- last-born under 2 years"
nt_root				"Child given roots or tubers in day/night before survey- last-born under 2 years"
nt_nuts				"Child given legumes or nuts in day/night before survey- last-born under 2 years"
nt_meatfish			"Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"
nt_eggs				"Child given eggs in day/night before survey- last-born under 2 years"
nt_dairy			"Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"
nt_solids			"Child given any solid or semisolid food in day/night before survey- last-born under 2 years"
nt_fed_milk			"Child given milk or milk products- last-born 6-23 months"
nt_mdd				"Child with minimum dietary diversity- last-born 6-23 months"
nt_mmf				"Child with minimum meal frequency- last-born 6-23 months"
nt_mad				"Child with minimum acceptable diet- last-born 6-23 months"
nt_ch_micro_vaf		"Youngest children age 6-23 mos living with mother given Vit A rich food"
nt_ch_micro_irf		"Youngest children age 6-23 mos living with mother given iron rich food"
----------------------------------------------------------------------------*/

*** Breastfeeding and complemenatry feeding ***

//currently breastfed
gen nt_bf_curr= brsfedur==95
label values nt_bf_curr yesno
label var nt_bf_curr "Currently breastfeeding - last-born under 2 years"

//breastfeeding status
	gen water=0
	gen liquids=0
	gen milk=0
	gen solids=0

	*Child is given water
	replace water=1 if (mafedwater24h>=1 & mafedwater24h<=7)
		   
	*Child given liquids
foreach xvar of varlist mafedsugwat24h mafedjuice24h mafedcoftea24h mafedsoup24h mafedothliq24h{
	replace liquids=1 if `xvar'>=1 & `xvar'<=7
	}

	*Given powder/tinned milk, formula, or fresh milk
	foreach xvar of varlist mafedgenmilk24h mafedform24h {
	replace milk=1 if `xvar'>=1 & `xvar'<=7
	}

	*Given any solid food
foreach xvar of varlist mafedgrain24h mafedyelveg24h mafedgrnveg24h mafedvitafruit24h mafedofrtveg24h mafedtuber24h mafedlegum24h mafedmeat24h mafedorgan24h mafedfish24h mafedegg24h mafedcheese24h mafedyogurt24h mafedother24h mafedany24h{
	replace solids=1 if `xvar'>=1 & `xvar'<=7
	}
	replace solids=1 if (mafedcereal24h==1 | mafedporr24h==1 | fedany24h==1)
	gen nt_bf_status=1
	replace nt_bf_status=2 if water==1
	replace nt_bf_status=3 if liquids==1
	replace nt_bf_status=4 if milk==1
	replace nt_bf_status=5 if solids==1
	replace nt_bf_status=0 if nt_bf_curr==0
label define bf_status 0"not bf" 1"exclusively bf" 2"bf & plain water" 3"bf & non-milk liquids" 4"bf & other milk" 5"bf & complemenatry foods"
	label values nt_bf_status bf_status
	label var nt_bf_status "Breastfeeding status for last-born child under 2 years"

//exclusively breastfed
recode nt_bf_status (1=1) (else=0) if age<6, gen(nt_ebf)
label values nt_ebf yesno
label var nt_ebf "Exclusively breastfed - last-born under 6 months"

//predominantly breastfeeding
recode nt_bf_status (1/3=1) (else=0) if age<6, gen(nt_predo_bf)
label values nt_predo_bf yesno
label var nt_predo_bf "Predominantly breastfed - last-born under 6 months"

//age appropriate breastfeeding
gen nt_ageapp_bf=0
replace nt_ageapp_bf=1 if nt_ebf==1
replace nt_ageapp_bf=1 if nt_bf_status==5 & inrange(age,6,23)
label values nt_ageapp_bf yesno
label var nt_ageapp_bf "Age-appropriately breastfed - last-born under 2 years"

//introduced to food
gen nt_food_bf = 0
replace nt_food_bf=1 if (mafedcereal24h==1 | mafedporr24h==1 | fedany24h==1)
replace nt_food_bf=1 if (mafedgrain24h==1 | mafedyelveg24h==1 | mafedgrnveg24h==1 |  mafedvitafruit24h==1 | mafedofrtveg24h==1 |  mafedtuber24h==1 |  mafedlegum24h==1 |  mafedmeat24h==1 |  mafedorgan24h==1 |  mafedfish24h ==1 | mafedegg24h ==1 | mafedcheese24h==1 |  mafedyogurt24h==1 |  mafedother24h==1 |  mafedany24h==1 )

replace nt_food_bf=. if !inrange(age,6,8)
label values nt_food_bf yesno
label var nt_food_bf "Introduced to solid, semi-solid, or soft foods - last-born 6-8 months"
	

//continuing breastfeeding at 1 year
gen nt_bf_cont_1yr= brsfedur==95 if inrange(age,12,15)
label values nt_bf_cont_1yr yesno
label var nt_bf_cont_1yr "Continuing breastfeeding at 1 year (12-15 months) - last-born under 2 years"

//continuing breastfeeding at 2 years
gen nt_bf_cont_2yr= brsfedur==95 if inrange(age,20,23)
label values nt_bf_cont_2yr yesno
label var nt_bf_cont_2yr "Continuing breastfeeding at 2 year (20-23 months) - last-born under 2 years"

*** Foods consumed ***

//Given formula
gen nt_formula= mafedform24h==1
label values nt_formula yesno
label var nt_formula "Child given infant formula in day/night before survey - last-born under 2 years"

//Given other milk
gen nt_milk= mafedgenmilk24h==1
label values nt_milk yesno 
label var nt_milk "Child given other milk in day/night before survey- last-born under 2 years"

//Given other liquids
gen nt_liquids= mafedjuice24h==1 | mafedsoup24h==1 | mafedothliq24h==1
label values nt_liquids yesno 
label var nt_liquids "Child given other liquids in day/night before survey- last-born under 2 years"

//Give fortified baby food
gen nt_bbyfood= mafedcereal24h==1
label values nt_bbyfood yesno 
label var nt_bbyfood "Child given fortified baby food in day/night before survey- last-born under 2 years"

//Given grains
gen nt_grains= mafedcereal24h==1 | mafedgrain24h==1
label values nt_grains yesno 
label var nt_grains "Child given grains in day/night before survey- last-born under 2 years"

//Given Vit A rich foods
gen nt_vita= mafedyelveg24h==1 | mafedgrnveg24h==1 | mafedvitafruit24h==1
label values nt_vita yesno 
label var nt_vita "Child given vitamin A rich food in day/night before survey- last-born under 2 years"

//Given other fruits or vegetables
gen nt_frtveg= mafedofrtveg24h==1
label values nt_frtveg yesno 
label var nt_frtveg "Child given other fruits or vegetables in day/night before survey- last-born under 2 years"

//Given roots and tubers
gen nt_root= mafedtuber24h==1
label values nt_root yesno 
label var nt_root "Child given roots or tubers in day/night before survey- last-born under 2 years"

//Given nuts or legumes
gen nt_nuts= mafedlegum24h==1
label values nt_nuts yesno 
label var nt_nuts "Child given legumes or nuts in day/night before survey- last-born under 2 years"

//Given meat, fish, shellfish, or poultry
gen nt_meatfish= mafedmeat24h==1 | mafedorgan24h==1 | mafedfish24h==1
label values nt_meatfish yesno 
label var nt_meatfish "Child given meat, fish, shellfish, or poultry in day/night before survey- last-born under 2 years"
	
//Given eggs
gen nt_eggs= mafedegg24h==1
label values nt_eggs yesno 
label var nt_eggs "Child given eggs in day/night before survey- last-born under 2 years"

//Given dairy
gen nt_dairy= mafedcheese24h==1 | mafedyogurt24h==1 
label values nt_dairy yesno 
label var nt_dairy "Child given cheese, yogurt, or other milk products in day/night before survey- last-born under 2 years"

//Given other solid or semi-solid foods
gen nt_solids= nt_bbyfood==1 | nt_grains==1 | nt_vita==1 | nt_frtveg==1 | nt_root==1 | nt_nuts==1 | nt_meatfish==1 | nt_eggs==1 | nt_dairy==1 | mafedother24h==1
label values nt_solids yesno 
label var nt_solids "Child given any solid or semisolid food in day/night before survey- last-born under 2 years"


*** Minimum feeding indicators ***

//Fed milk or milk products
gen totmilkf = 0
replace totmilkf=totmilkf + v469e if v469e<8
replace totmilkf=totmilkf + v469f if v469f<8
replace totmilkf=totmilkf + v469x if v469x<8
gen nt_fed_milk= ( totmilkf>=2 | brsfedur==95) if inrange(age,6,23)
label values nt_fed_milk yesno
label var nt_fed_milk "Child given milk or milk products- last-born 6-23 months"

//Min dietary diversity
	* 8 food groups
	*1. breastmilk
	gen group1= brsfedur==95

	*2. infant formula, milk other than breast milk, cheese or yogurt or other milk products
	gen group2= nt_formula==1 | nt_milk==1 | nt_dairy==1

	*3. foods made from grains, roots, tubers, and bananas/plantains, including porridge and fortified baby food from grains
	gen group3= nt_grains==1 | nt_root==1 | nt_bbyfood==1
	 
	*4. vitamin A-rich fruits and vegetables
	gen group4= nt_vita==1

	*5. other fruits and vegetables
	gen group5= nt_frtveg==1

	*6. eggs
	gen group6= nt_eggs==1

	*7. meat, poultry, fish, and shellfish (and organ meats)
	gen group7= nt_meatfish==1

	*8. legumes and nuts
	gen group8= nt_nuts==1

* add the food groups
egen foodsum = rsum(group1 group2 group3 group4 group5 group6 group7 group8) 
recode foodsum (1/4 .=0 "No") (5/8=1 "Yes"), gen(nt_mdd)
replace nt_mdd=. if age<6
label values nt_mdd yesno 
label var nt_mdd "Child with minimum dietary diversity, 5 out of 8 food groups- last-born 6-23 months"
/*older surveys are 4 out of 7 food groups, can use code below
egen foodsum = rsum(group2 group3 group4 group5 group6 group7 group8) 
recode foodsum (1/3 .=0 "No") (4/7=1 "Yes"), gen(nt_mdd)
*/

//Min meal frequency
gen feedings=totmilkf
replace feedings= feedings + fedany24hx if fedany24hx>0 & fedany24hx<8
gen nt_mmf = (brsfedur==95 & inrange(fedany24hx,2,7) & inrange(age,6,8)) | (brsfedur==95 & inrange(fedany24hx,3,7) & inrange(age,9,23)) | (brsfedur!=95 & feedings>=4 & inrange(age,6,23))
replace nt_mmf=. if age<6
label values nt_mmf yesno
label var nt_mmf "Child with minimum meal frequency- last-born 6-23 months"

//Min acceptable diet
egen foodsum2 = rsum(nt_grains nt_root nt_nuts nt_meatfish nt_vita nt_frtveg nt_eggs)
gen nt_mad = (brsfedur==95 & nt_mdd==1 & nt_mmf==1) | (brsfedur!=95 & foodsum2>=4 & nt_mmf==1 & totmilkf>=2)
replace nt_mad=. if age<6
label values nt_mad yesno
label var nt_mad "Child with minimum acceptable diet- last-born 6-23 months"

//Consumed Vit A rich food
gen nt_ch_micro_vaf= 0
replace nt_ch_micro_vaf=1 if (mafedegg24h==1 | mafedmeat24h==1 |  mafedyelveg24h==1 |  mafedgrnveg24h==1 |  mafedvitafruit24h==1 |  mafedorgan24h==1 |  mafedfish24h==1)
replace nt_ch_micro_vaf=. if !inrange(age,6,23)
label values nt_ch_micro_vaf yesno 
label var nt_ch_micro_vaf "Youngest children age 6-23 mos living with mother given Vit A rich food"

//Consumed iron rich food
gen nt_ch_micro_irf=0
replace nt_ch_micro_irf=1 if (mafedegg24h==1 |  mafedmeat24h==1 |  mafedorgan24h==1 |  mafedfish24h==1)
replace nt_ch_micro_irf=. if !inrange(age,6,23)
label values nt_ch_micro_irf yesno 
label var nt_ch_micro_irf "Youngest children age 6-23 mos living with mother given iron rich food"
