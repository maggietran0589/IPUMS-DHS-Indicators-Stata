/*****************************************************************************************************
Program: 			  PH_HOUS.do
Purpose: 			  Code to compute household characteristics, possessions, and smoking in the home
Data inputs: 		IPUMS DHS Housing Variables
Data outputs:		coded variables
Author:				  Faduma Shaba
Date last modified: May 2020 
Note:				 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
ph_electric		"Have electricity"
ph_floor		"Flooring material"
ph_rooms_sleep	"Rooms for sleeping"
ph_cook_place	"Place for cooking"
ph_cook_fuel	"Type fo cooking fuel"
ph_cook_solid	"Using solid fuel for cooking"
ph_cook_clean	"Using clean fuel for cooking"
	
ph_smoke		"Frequency of smoking at home"	
ph_radio		"Owns a radio"
ph_tv			"Owns a tv"
ph_mobile		"Owns a mobile phone"
ph_tel			"Owns a non-mobile telephone"
ph_comp			"Owns a computer"
ph_frig			"Owns a refrigerator"
ph_bike			"Owns a bicycle"
ph_cart			"Owns a animal drawn cart"
ph_moto			"Owns a motorcycle/scooter"
ph_car			"Owns a car or truck"
ph_boat			"Owns a boat with a motor"
ph_agriland		"Owns agricultural land"
ph_animals		"Owns livestock or farm animals"
----------------------------------------------------------------------------*/

*** Household characteristics ***

//Have electricity
replace electrchh=. if electrchh > 7

**NOT IN IPUMS:**
//Flooring material
replace edlevyrnow=. if edlevyrnow > 7

//Number of rooms for sleeping
replace sleeprooms=. if sleeprooms > 97

//Place for cooking
replace cookwhere=. if cookwhere > 7

//Type of cooking fuel
reaplce cookfuel=. if cookfuel > 997

//Solid fuel for cooking
gen solidfuel= cookfuel if cookfuel== 240 | cookfuel => 400
replace solidfuel=. if cookfuel > 997
label values solidfuel yesno
label var solidfuel "Using solid fuel for cooking"

//Frequency of smoking in the home
replace tosmkhhfreq=. if tosmkhhfreq > 7

*** Household possessions ***

//Radio
replace radiohh=. if radiohh > 7

//TV
replace tvhh=. if tvhh > 7

//Mobile phone
replace mobphone=. if mobphone > 7

//Non-mobile phone
replace hhphonehh=. if hhphonehh > 7

**Not in IPUMS**
//Computer
gen ph_comp= hv243e==1
label values ph_comp yesno
label var ph_comp "Owns a computer"

//Refrigerator
replace fridgehh=. if fridgehh > 7

//Bicycle
replace bikehh=. if bikehh > 7

//Animal drawn cart
replace drawncart=. if drawncart >7

//Motorcycle or scooter
replace motorcyclhh=. if motorcyclhh > 7

//Car or truck
replace carhh=. if carhh > 6

//Boat with a motor
gen ph_boat= hv243d==1
label values ph_boat yesno
label var ph_boat "Owns a boat with a motor"

//Agricultural land
gen ph_agriland= hv244==1
label values ph_agriland yesno
label var ph_agriland "Owns agricultural land"

//Livestook
gen ph_animals= hv246==1
label values ph_animals yesno
label var ph_animals "Owns livestock or farm animals"
