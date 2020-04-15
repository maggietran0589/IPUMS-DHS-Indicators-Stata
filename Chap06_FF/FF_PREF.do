/*****************************************************************************************************
Program: 			FF_PREF.do
Purpose: 			Code to compute fertility preferences in men and women
Data inputs: 			IPUMS DHS Fertility variables
Data outputs:			coded variables
Author:				Faduma Shaba
Date last modified: 		April 2020 
Note:				The five indicators below can be computed for men and women. 
*****************************************************************************************************/

/*----------------------------------------------------------------------------
Variables used in this file:
kiddesire 		      "Desire for more children"
ff_want_nomore		  "Want no more children"
ff_ideal_num		    "Ideal number of children"
ff_ideal_mean_all	  "Mean ideal number of children for all"
ff_ideal_mean_mar	  "Mean ideal number of children for married"
----------------------------------------------------------------------------*/
***Women Variables***

//Desire for children
replace kiddesire=. if kiddesire > 97

//Want no more
replace kiddesire=0 if kiddesire!=40
label define kiddesire 0 "Wants no more kids" 1 "Wants more kids"
label values kiddesire kiddesire

//Ideal number of children
replace idealkid=. if idealkid > 96

//Mean ideal number of children - all women
mean idealkid [iw=perweight]	

//Mean ideal number of children - married women
mean idealkid if currmarr==1 [iw=perweight]


***Men Variables***
//Desire for children
replace kiddesiremn=. if kiddesiremn > 97

//Want no more
replace kiddesiremn=0 if kiddesiremn!=40
label define kiddesiremn 0 "Wants no more kids" 1 "Wants more kids"
label values kiddesiremn kiddesiremn

//Ideal number of children
replace idealkidmn=. if idealkidmn > 96

//Mean ideal number of children - all men
mean idealkidmn [iw=perweight]	

//Mean ideal number of children - married men
mean idealkidmn if currmarrmn==1 [iw=perweight]
