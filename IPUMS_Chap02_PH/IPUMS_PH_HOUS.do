/*****************************************************************************************************
Program: 			  IPUMS_PH_HOUS.do
Purpose: 			  Code to compute household characteristics, possessions, and smoking in the home
Data inputs: 			IPUMS DHS Housing Variables
Data outputs:			coded variables
Author:				  Faduma Shaba
Date last modified: May 2020 
Note:				 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables created in this file:
electrchh		"Have electricity"
floor		"Flooring material"
sleeprooms	"Rooms for sleeping"
cookwhere	"Place for cooking"
cookfuel	"Type of cooking fuel"
solidfuel	"Using solid fuel for cooking"
cleanfuel	"Using clean fuel for cooking"
	
tosmkhhfreq		"Frequency of smoking at home"	
radiohh		"Owns a radio"
tvhh			"Owns a tv"
mobphone		"Owns a mobile phone"
hhphonehh			"Owns a non-mobile telephone"
pc			"Owns a computer"
fridgehh			"Owns a refrigerator"
bikehh			"Owns a bicycle"
drawncart			"Owns a animal drawn cart"
motorcyclhh			"Owns a motorcycle/scooter"
carhh			"Owns a car or truck"
boatwmotor			"Owns a boat with a motor"
aglandyn		"Owns agricultural land"
livestockyn		"Owns livestock or farm animals"
----------------------------------------------------------------------------*/

*** Household characteristics ***

//Have electricity
replace electrchh=. if electrchh > 7

//Flooring material
replace floor=. if floor > 997

//Number of rooms for sleeping
replace sleeprooms=. if sleeprooms > 97

//Place for cooking
replace cookwhere=. if cookwhere > 7

//Type of cooking fuel
reaplce cookfuel=. if cookfuel > 997

//Solid fuel for cooking
gen solidfuel= cookfuel if cookfuel== 600 | cookfuel==410
replace solidfuel=. if cookfuel > 997
label values solidfuel yesno
label var solidfuel "Using solid fuel for cooking"

//Clean fuel for cooking
gen cleanfuel= cookfuel if cookfuel== 100 | cookfuel==300
replace cleanfuel=. if cookfuel > 997
label values cleanfuel yesno
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
replace pc=. if pc > 7

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
replace boatwmotor=. if boatwmotor > 7

//Agricultural land
replace aglandyn=. if aglandyn > 7

//Livestook
replace livestockyn=. if livestockyn > 7
