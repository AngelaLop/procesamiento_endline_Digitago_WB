/*==================================================
project:       
Author:        Angela Lopez 
E-email:       ar.lopez@uniandes.edu.co/alopezsanchez@worldbank.org
url:           
Dependencies:  
----------------------------------------------------
Creation Date:    12 Ago 2021 - 12:37:59
Modification Date:   
Do-file version:    01
References:          
Output:             
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
version 16
drop _all
*ssc install ietoolkit

global path "C:\Users\lopez\OneDrive - Universidad de los Andes\WB\GTM - IE DIGITAGRO\07 Endline"
global data 	"${path}\07 01 Data"
global clean	"${path}\07 4 Clean Data"
global output	"${path}\07 3 Docs\Digitagro - balance tables"
global baseline "C:\Users\lopez\OneDrive - Universidad de los Andes\WB\GTM - IE DIGITAGRO\06 Baseline\06 4 Clean Data" 

use "${data}/gua_digitagro_el_clean_no_pii.dta", clear


/*==================================================
             Cleaning up data 
==================================================*/

gen total =1

gen muestra_1= inlist(call_status,1,2) if consentimiento ==1
gen muestra_2= (consentimiento==1) & (call_status ==1) // completados en una sola llamada 
gen muestra_3= (call_status ==1) & (consentimiento ==.) & (last_call_status =="Llamada reprogramada")
gen muestra = (muestra_2==1) | (muestra_3==1)
destring caseid, gen(caseid_d)
gen muestra_dig = muestra if caseid_d < 5000

tab muestra_dig



tab total
encode treatment_bl, g(treatment_el)
gen treatment_el_1=(treatment_el==2)
lab var treatment_el_1 "Effect of the Treatment"


gen control = (treatment_el_1==0)


save "$data/digitagro_clean", replace 

******* Controls ********************************

destring infor_8_1, replace 

destring infor_3, replace

tab infor_17a, nolabel
replace infor_17a=0 if infor_17a==2
replace infor_17a=. if infor_17a==-8

replace infor_17b=0 if infor_17b==2
replace infor_17b=. if infor_17b==-8

joinby caseid using "$baseline\datos_limpios", unmatched(master) update 
save "$data/digitagro_clean", replace 
drop _merge
merge m:m caseid using "$baseline\strata.dta"
keep if muestra_dig ==1
*** household characteristics
	g n_members 	= home_2 // household members
	g n_chidren 	= home_3 
	g adult_men 	= home_4
	g adult_women	= home_5
	g adults_65		= home_6 //members older than 65

	*hh head
	g head_self		= (home_11==1)
	g head_parnter	= (home_11==2)
	g head_parent	= (home_11==6)
	g head_other    = inlist(home_11, 3,4,5,7,8,9,10,11)
	
*** education 
	* women

	g e_ninguno = inlist(home_12,1,2,3)
	g e_primaria = inlist(home_12,4,5,6,7)
	g e_secundaria = inlist(home_12,8)
	g e_terciaria = inlist(home_12,9,10,11)
	
	* partner 
	tab home_16, generate(educa_men)
	
	g e_ninguno_p = inlist(home_16,1,2,3)
	g e_primaria_p = inlist(home_16,4,5,6,7)
	g e_secundaria_p = inlist(home_16,8)
	g e_terciaria_p = inlist(home_16,9,10,11)
	
	
*** marital status 
	tab home_17, generate(marital)
	g pareja = inlist(home_17,1,2)
	g nopareja= inlist(home_17,3,4,5,6,7)
	
*** age  
	g edad = edad_nacimiento
	g edad2 = edad^2
	
***  age brackets

	g age_18_29 	= inrange(edad,18,29)
	g age_30_39 	= inrange(edad,30,39)
	g age_40_49 	= inrange(edad,40,49)
	g age_50_mas 	= edad>=50
	g age_miss 		= edad==.

	
*** hectarias de tierras - cuerdas
	g terreno_cuerdas = farm_2
	replace terreno_cuerdas = . if farm_3 ==999
	replace terreno_cuerdas = . if farm_2 ==-888
	
	g terreno_cuerdas_mayor0_1 = inrange(terreno_cuerdas,0,1)
	g terreno_cuerdas_1_2 = inrange(terreno_cuerdas,1.05,3)
	g terreno_cuerdas_2_3 = inrange(terreno_cuerdas,3.05,5)
	g terreno_cuerdas_6_10 = inrange(terreno_cuerdas,6,10)
	g terreno_cuerdas_10mas = terreno_cuerdas>10
	g terreno_cuerdas_miss = terreno_cuerdas ==.
	
	
	** log terreno_cuerdas
	g terreno_cuerdas_log =log(terreno_cuerdas)
	
	
	g terreno_hectareas = terreno_cuerdas*0.3930395625 // equivalencia en hectareas 
*** land ownership 
	g land_owner = (farm_4==1)
	

 *** fertilizante
	*agricultural practices
	split mark_1, p(" ")
	gen mark_11ns = real(mark_11)
	replace mark_11ns=0 if mark_11ns==.
	replace mark_11ns=7 if mark_11ns==1000
	gen mark_12ns = real(mark_12)
	replace mark_12ns=0 if mark_12ns==.
	gen mark_13ns = real(mark_13)
	replace mark_13ns=0 if mark_13ns==.
	gen mark_14ns = real(mark_14)
	replace mark_14ns=0 if mark_14ns==.
	gen mark_15ns = real(mark_15)
	replace mark_15ns=0 if mark_15ns==.
	gen mark_16ns = real(mark_16)
	replace mark_16ns=0 if mark_16ns==.
	drop mark_11-mark_16 

	forvalues i = 1(1)7 {
	gen practice`i'=0
	replace practice`i'=1 if (mark_11ns==`i'| mark_12ns==`i'| mark_13ns==`i'| mark_14ns==`i'| mark_15ns==`i'| mark_16ns==`i')
	}
	drop mark_11ns mark_12ns mark_13ns mark_14ns mark_15ns mark_16ns

	gen p_abonos 		= (practice1==1)
	gen p_fertilizantes = (practice2==1)
	gen p_pesticidas 	= (practice3==1)
	gen p_semillas_mejoradas = (practice4==1)
	gen p_sistema_riego = (practice5==1)
	gen p_maquinaria	= (practice6==1)
	gen p_ninguna		= (practice7==1)
	
	

******* Module H4 - HARVEST *************************

destring consent, replace 


 * recode household harvest - yield_2*
 *======================================
 
 
 gen yield_2_997_1 = yield_2_997
 gen yield_2_998_1 = yield_2_998
 gen yield_2_999_1 = yield_2_999
 
 *============================================================================
 
local is haba1 // habas ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Aba" | yield_2_text_997 =="Abas" | yield_2_text_997 =="Haba" | yield_2_text_997 =="Habas" | yield_2_text_997=="Ava" | yield_2_text_997=="Frijol de haba" | yield_2_text_997=="haba" 
 }
 local is haba2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_998=="Avas" | yield_2_text_998=="Haba" | yield_2_text_998=="Habas" | yield_2_text_998=="Aba"
 }
 
  local is haba3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Haba" 
 }
 
 clonevar yield_2_44_1 = yield_2_44
 replace  yield_2_44_1 = 1 if yield_2_haba1 ==1
 
 clonevar yield_2_44_2 = yield_2_44
 replace  yield_2_44_2 = 1 if yield_2_haba2 ==1
 
 clonevar yield_2_44_3 = yield_2_44 
 replace   yield_2_44_3 = 1 if yield_2_haba3 ==1
 
 g  yield_2_44_t = 0 if muestra_2==1
 replace yield_2_44_t = 1 if yield_2_44_1==1 | yield_2_44_2 ==1 | yield_2_44_3 ==1 
 
 
 replace yield_2_997_1 =0 if yield_2_44_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_44_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_44_3 ==1 & yield_2_999_1==1  
 

  *=====================================
  
 * fijol ++
 
local is bean1 // bean ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Frijol" | yield_2_text_997 =="Frijol colon" | yield_2_text_997 =="Fríjol, camaron, aba,Ayote" 
 }
 
clonevar yield_2_16_1 = yield_2_16 
 replace yield_2_16_1 = 1 if yield_2_bean1 ==1

 local is bean2 // bean ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Frijol de vara" | yield_2_text_998 =="Frijol tapascal"
 }
 
 clonevar yield_2_16_2 = yield_2_16 
 replace yield_2_16_2 = 1 if yield_2_bean2 ==1
  
  local is bean3 // bean ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Frijol" 
 }
 
 clonevar yield_2_16_3 = yield_2_16 
 replace yield_2_16_3 = 1 if yield_2_bean3 ==1
  
 g  yield_2_16_t = 0 if muestra_2==1
 replace yield_2_16_t = 1 if yield_2_16_1==1 | yield_2_16_2 ==1  | yield_2_16_3 ==1 
  
 replace yield_2_997_1=0 if yield_2_16_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1=0 if yield_2_16_2 ==1 & yield_2_998_1==1 
 replace yield_2_999_1=0 if yield_2_16_3 ==1 & yield_2_999_1==1 

   *=====================================
  
 * Maiz ++
 
local is corn1 // corn 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Elote" | yield_2_text_997 =="Elotes" | yield_2_text_997 =="Maíz y café" | yield_2_text_997 =="Milpa"
 
 }
 
clonevar yield_2_21_1 = yield_2_21 
 replace yield_2_21_1 = 1 if yield_2_corn1 ==1

 local is corn2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Elote" | yield_2_text_998 == "Elotes" | yield_2_text_998 =="Milpa" | yield_2_text_998 =="Hoja de la Milpa"
 
 }
 
 clonevar yield_2_21_2 = yield_2_21 
 replace yield_2_21_2 = 1 if yield_2_corn2 ==1
  
  local is corn3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Maíz Chile cacao" | yield_2_text_999 =="Elote" | yield_2_text_999== "Elotes" | yield_2_text_999=="Milpa"
 
 }
 
 clonevar yield_2_21_3 = yield_2_21 
 replace yield_2_21_3 = 1 if yield_2_corn3 ==1
  
 g  yield_2_21_t = 0 if muestra_2==1
 replace yield_2_21_t = 1 if yield_2_21_1==1 | yield_2_21_2 ==1  | yield_2_21_3 ==1 
  
 replace yield_2_997_1=0 if yield_2_21_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1=0 if yield_2_21_2 ==1 & yield_2_998_1==1 
 replace yield_2_999_1=0 if yield_2_21_3 ==1 & yield_2_999_1==1 
 
 
  *=====================================
   
 local is radish1 // Radish ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Rabano" | yield_2_text_997 =="Rábano" | yield_2_text_997 =="rabano" 
 }
 
  local is radish2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_998 =="Rabanito" |  yield_2_text_998 =="Rabano" | yield_2_text_998 =="Rabano," | yield_2_text_998 =="Rabanos"
 }
 
  local is radish3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Rabano" |  yield_2_text_999 =="Rabano, nabos" | yield_2_text_999 =="Remolacha y rabano" | yield_2_text_999 =="rábano"|   yield_2_text_999 =="Rábano"
 }
 
 clonevar yield_2_42_1 = yield_2_42
 replace  yield_2_42_1 = 1 if yield_2_haba1 ==1
 
 clonevar yield_2_42_2 = yield_2_42 
 replace  yield_2_42_2 = 1 if yield_2_haba2 ==1
 
 clonevar yield_2_42_3 = yield_2_42
 replace   yield_2_42_3 = 1 if yield_2_haba3 ==1
 
 g  yield_2_42_t = 0 if muestra_2==1
 replace yield_2_42_t = 1 if yield_2_42_1==1 | yield_2_42_2 ==1 | yield_2_42_3 ==1 
 
 
 replace yield_2_997_1 =0 if yield_2_42_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_42_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_42_3 ==1 & yield_2_999_1==1  
 
 *=======================================
 
 local is acelga1 // Chard ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Acelga" 
 }
 
 local is acelga3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Acelga, espinaca" 
 }
 
 clonevar yield_2_1_1 = yield_2_1
 replace  yield_2_1_1 = 1 if yield_2_acelga1 ==1
  
 clonevar yield_2_1_3 = yield_2_1
 replace   yield_2_1_3 = 1 if yield_2_acelga3 ==1
 
 g  yield_2_1_t = 0 if muestra_2==1
 replace yield_2_1_t = 1 if yield_2_1_1==1 | yield_2_1_3 ==1 
 
 
 replace yield_2_997_1 =0 if yield_2_1_1 ==1 & yield_2_997_1==1 
 replace yield_2_999_1 =0 if yield_2_1_3 ==1 & yield_2_999_1==1  
 
 *=======================================
 
 
 local is banana1 // banana ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Banano" | yield_2_text_997 =="Bananos" 
 }
 
  local is banana2 // banana ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_998 =="Banano" | yield_2_text_998 =="Bananos" | yield_2_text_998 =="Banano, rambotan, limas, Pacaya,bisnay" | yield_2_text_998 =="Guineo Morado,"
 }
 
   local is banana3 // banana ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Bananas" | yield_2_text_999 =="Banano" | yield_2_text_999 =="Banano y Calabaza" | yield_2_text_999 =="Bananos"
 }
 
 clonevar yield_2_48_1 = yield_2_48 
 replace  yield_2_48_1 = 1 if yield_2_banana1 ==1
 
 clonevar yield_2_48_2 = yield_2_48 
 replace  yield_2_48_2 = 1 if yield_2_banana2 ==1
 
 clonevar yield_2_48_3 = yield_2_48 
 replace   yield_2_48_3 = 1 if yield_2_banana3 ==1
 
 g  yield_2_48_t = 0 if muestra_2==1
 replace yield_2_48_t = 1 if yield_2_48_1==1 | yield_2_48_2 ==1 | yield_2_48_3 ==1 
 
 
 replace yield_2_997_1 =0 if yield_2_48_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_48_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_48_3 ==1 & yield_2_999_1==1 
  
 
 * ======================================
 
 local is brocoli1 // brocoli ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Brocoli" | yield_2_text_997 =="Brócoli" 
 }
 
  local is brocoli2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_998 =="Brócoli" 
 }
 
  local is brocoli3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Brócoli" |  yield_2_text_999 =="Brócoli rabanono cilantro" 
 }
 
 clonevar yield_2_6_1 = yield_2_6
 replace  yield_2_6_1 = 1 if yield_2_brocoli1 ==1
 
 clonevar yield_2_6_2 = yield_2_6 
 replace  yield_2_6_2 = 1 if yield_2_brocoli2 ==1
 
 clonevar yield_2_6_3 = yield_2_6
 replace  yield_2_6_3 = 1 if yield_2_brocoli3 ==1
 
 g  yield_2_6_t = 0 if muestra_2==1
 replace yield_2_6_t = 1 if yield_2_6_1==1 | yield_2_6_2 ==1 | yield_2_6_3 ==1 
 
 
 replace yield_2_997_1 =0 if yield_2_6_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_6_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_6_3 ==1 & yield_2_999_1==1  
 
 *=========================================
 
 local is beetroot1 // Beetroot ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Remolach" | yield_2_text_997 =="Remolacha" | yield_2_text_997 =="Remolacha,coliflor,durazno" | yield_2_text_997 =="Remolachas" 
 } 
 
  local is beetroot2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' =  yield_2_text_998 =="Remolachas" | yield_2_text_998 =="Remolacha"
 }
 
  local is beetroot3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = yield_2_text_999 =="Remolacha" |  yield_2_text_999 =="Remolacha y rabano" |  yield_2_text_999 =="Renolacha" 
 }
 
 clonevar yield_2_49_1 = yield_2_49
 replace  yield_2_49_1 = 1 if yield_2_beetroot1 ==1
 
 clonevar yield_2_49_2 = yield_2_49 
 replace  yield_2_49_2 = 1 if yield_2_beetroot2 ==1
 
 clonevar yield_2_49_3 = yield_2_49
 replace  yield_2_49_3 = 1 if yield_2_beetroot3 ==1
 
 g  yield_2_49_t = 0 if muestra_2==1
 replace yield_2_49_t = 1 if yield_2_49_1==1 | yield_2_49_2 ==1 | yield_2_49_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_49_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_49_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_49_3 ==1 & yield_2_999_1==1  
  
 * ========================================
 
 local is coffee1 // coffee ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Cafe" | yield_2_text_997 =="Cafe,guineo" | yield_2_text_997 =="Café"  | yield_2_text_997 =="Café Robusto" | yield_2_text_997 =="Maíz y café"
 } 
 
  local is coffee2 // coffee ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Cafe" | yield_2_text_998 =="Café" | yield_2_text_998 =="Café Robusto"
 } 
 
 local is coffee3 // coffee ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Cafe" | yield_2_text_999 =="Café" | yield_2_text_999 =="Café Borbón"
 } 
 
clonevar yield_2_47_1 = yield_2_47 
 replace  yield_2_47_1 = 1 if yield_2_coffee1 ==1
 
 clonevar yield_2_47_2 = yield_2_47 
 replace  yield_2_47_2 = 1 if yield_2_coffee2 ==1
 
 clonevar yield_2_47_3 = yield_2_47 
 replace  yield_2_47_3 = 1 if yield_2_coffee3 ==1
 
 g  yield_2_47_t = 0 if muestra_2==1
 replace yield_2_47_t = 1 if yield_2_47_1==1 | yield_2_47_2 ==1 | yield_2_47_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_47_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_47_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_47_3 ==1 & yield_2_999_1==1 
 
* ========================================
 
 local is carrots1 // carrots ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Zanahoria" |  yield_2_text_997 =="Repollo  zanahoria" 
 } 
 
 local is carrots3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Zanahoria" 
 } 
 
clonevar yield_2_40_1 = yield_2_40 
 replace  yield_2_40_1 = 1 if yield_2_carrots1 ==1
 

 clonevar yield_2_40_3 = yield_2_40 
 replace  yield_2_40_3 = 1 if yield_2_carrots3 ==1
 
 g  yield_2_40_t = 0 if muestra_2==1
 replace yield_2_40_t = 1 if yield_2_40_1==1  | yield_2_40_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_40_1 ==1 & yield_2_997_1==1 
 replace yield_2_999_1 =0 if yield_2_40_3 ==1 & yield_2_999_1==1 
 
 * ==============================================================
 
 local is pepino1 // pepino ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Pepino"  
 } 
 
 local is pepino2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Pepino" | yield_2_text_998 =="Hierva mora, apazote, Pepin o"
 } 
 
  local is pepino3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Pepino" | yield_2_text_999 =="Guisquil, pepino , chile jalapeño, ch.."
 } 
 
clonevar yield_2_43_1 = yield_2_43 
 replace  yield_2_43_1 = 1 if yield_2_pepino1 ==1
 
 clonevar yield_2_43_2 = yield_2_43 
 replace  yield_2_43_2 = 1 if yield_2_pepino2 ==1
 
 clonevar yield_2_43_3 = yield_2_43 
 replace  yield_2_43_3 = 1 if yield_2_pepino3 ==1
 
 g  yield_2_43_t = 0 if muestra_2==1
 replace yield_2_43_t = 1 if yield_2_43_1==1  | yield_2_43_2 ==1  | yield_2_43_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_43_1 ==1 & yield_2_997_1==1 
 replace yield_2_999_1 =0 if yield_2_43_3 ==1 & yield_2_999_1==1 
 
 
 
 * ========================================
 
     local is chipilin1 // chipillin  ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chipilin" | yield_2_text_997 =="Chipilin , ayote,  rambutanes" | yield_2_text_997 =="Chipilin" | yield_2_text_997 == "Bledo, Chipilin, Cilantro"
 } 
 
  local is chipilin2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Chipilin" | yield_2_text_998 =="Bledo, chipilin" | yield_2_text_998 =="Bledo, chipilin, llerva Mora"
 } 
 
 local is chipilin3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Chipilin" | yield_2_text_999 =="Bledo, chipilin" | yield_2_text_999 =="Bledo, chipilin, llerva mora"
 } 
 
clonevar yield_2_46_1 = yield_2_46 
 replace  yield_2_46_1 = 1 if yield_2_chipilin1 ==1
 
 clonevar yield_2_46_2 = yield_2_46 
 replace  yield_2_46_2 = 1 if yield_2_chipilin2 ==1
 
 clonevar yield_2_46_3 = yield_2_46 
 replace  yield_2_46_3 = 1 if yield_2_chipilin3 ==1
 
 g  yield_2_46_t = 0 if muestra_2==1
 replace yield_2_46_t = 1 if yield_2_46_1==1 | yield_2_46_2 ==1 | yield_2_46_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_46_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_46_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_46_3 ==1 & yield_2_999_1==1 
 
* ===========================================
	
	local is cauliflower1 // Cauliflower  ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Coliflor" 
 } 
 
  local is cauliflower2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Coliflor" | yield_2_text_998 =="Colifrol" | yield_2_text_998 =="Colifror"
 } 
 
 local is cauliflower3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Coliflor" 
 } 
 
clonevar yield_2_45_1 = yield_2_45 
 replace  yield_2_45_1 = 1 if yield_2_cauliflower1 ==1
 
 clonevar yield_2_45_2 = yield_2_45 
 replace  yield_2_45_2 = 1 if yield_2_cauliflower1 ==1
 
 clonevar yield_2_45_3 = yield_2_45 
 replace  yield_2_45_3 = 1 if yield_2_cauliflower1 ==1
 
 g  yield_2_45_t = 0 if muestra_2==1
 replace yield_2_45_t = 1 if yield_2_45_1==1 | yield_2_45_2 ==1 | yield_2_45_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_45_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_45_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_45_3 ==1 & yield_2_999_1==1 
 
* ============================================ 

	
local is egg // egg  ++ 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Huevo" 
 } 
 
 clonevar yield_2_56_1 = yield_2_56
 replace yield_2_997_1 = 1 if yield_2_egg ==1
 replace yield_2_997_1 = 0 if yield_2_997_1 ==1 & yield_2_997_1==1 
 
 * ============================================ 

	
	local is lettuce1 // lettuce  ++
 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Lechuga" 
 } 
 
  local is lettuce2 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_998 =="Lechuga" | yield_2_text_998 =="Colifrol" | yield_2_text_998 =="Colifror"
 } 
 
 local is lettuce3 // 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_999 =="Lechuga" | yield_2_text_999 =="Lechuga y güicoy" | yield_2_text_999 =="Bledo, chipilin, llerva mora"
 } 
 
clonevar yield_2_50_1 = yield_2_50 
 replace  yield_2_50_1 = 1 if yield_2_cauliflower1 ==1
 
 clonevar yield_2_50_2 = yield_2_50 
 replace  yield_2_50_2 = 1 if yield_2_cauliflower1 ==1
 
 clonevar yield_2_50_3 = yield_2_50 
 replace  yield_2_50_3 = 1 if yield_2_cauliflower1 ==1
 
 g  yield_2_50_t = 0 if muestra_2==1
 replace yield_2_50_t = 1 if yield_2_50_1==1 | yield_2_50_2 ==1 | yield_2_50_3 ==1 
 
 replace yield_2_997_1 =0 if yield_2_50_1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_50_2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_50_3 ==1 & yield_2_999_1==1 
 
 
* ============================================ 
 
  local is aguacate1 // avocado
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Aguacate" | yield_2_text_997 =="Aguacate  jas" | yield_2_text_997 =="Aguacate Grande" | yield_2_text_997 =="Aguacate y limón" | yield_2_text_997 =="Aguacates" | yield_2_text_997 =="Aguacates milpa y platano" | yield_2_text_997 =="Chile y aguacate"     

 }
 
  local is aguacate2 // avocado
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Aguacate" |  yield_2_text_998  == "Aguacate pequeño"

 }
 
  local is aguacate3 // avocado
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Aguacate" | yield_2_text_999 =="Güisquil y aguacate"

 } 

  gen yield_2_aguacate = 0 if muestra_2==1
 replace yield_2_aguacate = 1 if yield_2_aguacate1 ==1  | yield_2_aguacate2 ==1  | yield_2_aguacate3 ==1 

 
 replace yield_2_997_1 =0 if yield_2_aguacate1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_aguacate2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_aguacate3 ==1 & yield_2_999_1==1 
 
* ============================================== 
 
   local is rice1 // arroz
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Arroz" 
 }
 
  local is rice2 // arroz
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Arroz" 

 }
  
 replace yield_2_997_1 =0 if yield_2_rice1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_rice2 ==1 & yield_2_998_1==1
 
 gen yield_2_rice = 0 if muestra_2==1
 replace yield_2_rice =1 if yield_2_rice1 ==1  | yield_2_rice2 ==1 
 
 * ============================================== 
 
   local is yuca1 // yuca
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Yuca" | yield_2_text_997 =="Yuca y milpa"
 }
 
  local is yuca2 // yuca
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Yuca" 

 }
 
   local is yuca3 // yuca
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Yuca" 

 }
  
 replace yield_2_997_1 =0 if yield_2_yuca1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_yuca1 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_yuca1 ==1 & yield_2_999_1==1 
 
 gen yield_2_yuca = 0 if muestra_2==1
 replace yield_2_yuca=1 if yield_2_yuca1 ==1 | yield_2_yuca2 ==1  | yield_2_yuca3 ==1 
 
* ============================================== 
 


    local is chile1 // chile
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chile" | yield_2_text_997 =="Chile Pimiento" | yield_2_text_997 =="Chile Santo Domingo" | yield_2_text_997 =="Chile chilpete" | yield_2_text_997 =="Chile chiltepe" | yield_2_text_997 =="Chile chocolate" | yield_2_text_997 =="Chile diente de perro" | yield_2_text_997 =="Chile jalapeño" | yield_2_text_997 =="Chile jalapeño, chaya" | yield_2_text_997 =="Chile nance" | yield_2_text_997 =="Chile pimienta" | yield_2_text_997 =="Chile pimiento" | yield_2_text_997 =="Chile pimiento y apio" | yield_2_text_997 =="Chile purun" | yield_2_text_997 =="Chile y aguacate" | yield_2_text_997 =="Chiltepe"
 }
 
 local is chile2 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Chile" | yield_2_text_998 =="Chile Jalapeño" | yield_2_text_998 =="Chile chiltepe" | yield_2_text_998 =="Chile chocolate" | yield_2_text_998 =="Chile jalapeño" | yield_2_text_998 =="Chile picante" | yield_2_text_998 =="Chile pimiento" | yield_2_text_998 =="Chilen Poron" | yield_2_text_998 =="Chiltepe"

 }
 
   local is chile3 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Chile" | yield_2_text_999 =="Chile Jalapeño" | yield_2_text_999 =="Chile chiltepe" | yield_2_text_999 =="Chile jalapeño" | yield_2_text_999 =="Chiltepe" | yield_2_text_999 == "chile , jenjibre," | yield_2_text_999 == "Maíz Chile cacao"  | yield_2_text_999 == "Licha, chiles carambola" |  yield_2_text_999 == "Hierbamora, chile pimiento, chiltepe" |  yield_2_text_999 =="Mangos y Chile" |  yield_2_text_999 =="Diete de perro" | yield_2_text_999 =="Jalapeño"

 }
  
 replace yield_2_997_1 =0 if yield_2_chile1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_chile2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_chile3 ==1 & yield_2_999_1==1 
 
 gen yield_2_chile = 0 if muestra_2==1
 replace yield_2_chile=1 if yield_2_chile1 ==1 | yield_2_chile2 ==1 | yield_2_chile3 ==1 
 
 
 *============================================================================
 
 * Ejote 
 local is ejote1 // ejote
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Ejote" | yield_2_text_997 =="Ejotes" 
 }
 
 local is ejote2 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Ejote" 
 }
 
   local is ejote3 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Ejote" | yield_2_text_999 =="Ejotes" 
 }
  
 replace yield_2_997_1 =0 if yield_2_ejote1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_ejote2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_ejote3 ==1 & yield_2_999_1==1 
 
 gen yield_2_ejote = 0 if muestra_2==1
 replace yield_2_ejote=1 if yield_2_ejote1 ==1  | yield_2_ejote2 ==1  | yield_2_ejote3 ==1  
 
 
  
* ============================================================================
 * Guisquil
  local is guisquil1 // Guisquil
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Guisquil" | yield_2_text_997 =="Guisquil es" | yield_2_text_997 =="Guisquiles" | yield_2_text_997 =="Guusquil" | yield_2_text_997 =="Güisquil" | yield_2_text_997 == "Wisquil" | yield_2_text_997 == "Limón, guisquil"
 }
 
  local is guisquil2 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Guisquil" | yield_2_text_998 =="Guisquiles" | yield_2_text_998 =="GÜISQUIL" | yield_2_text_998 =="Güisquil" | yield_2_text_998 =="Quisquil" | yield_2_text_998 =="Matas de alberja y Guiquiles"
 }
 
   local is guisquil3 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Guisquil" | yield_2_text_999 =="Guisquil, pepino , chile jalapeño, ch.." | yield_2_text_999 =="Guisquiles"  | yield_2_text_999 =="Güisquil y aguacate" 
 }
  
 replace yield_2_997_1 =0 if yield_2_guisquil1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_guisquil2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_guisquil3 ==1 & yield_2_999_1==1 
 
 gen yield_2_guisquil = 0 if muestra_2==1
 replace yield_2_guisquil=1 if yield_2_guisquil1 ==1  | yield_2_guisquil2 ==1  | yield_2_guisquil3 ==1
 
* ===========================================================================

* maxan
  local is maxan1 // hoja de mashan
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_997 =="Hoja de mashan" | yield_2_text_997 =="Hoja machan" | yield_2_text_997 =="Hojas de Mashan" | yield_2_text_997 =="Hojas de machan" | yield_2_text_997 =="Hojas de mashan" | yield_2_text_997 == "Hojas de mashan para envolver tamales" | yield_2_text_997 == "Hojas mashan" | yield_2_text_997 =="Hojas para tamal" | yield_2_text_997 =="Mashan"
 }
 
 local is maxan2 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_998 =="Hoja de mashan" | yield_2_text_998 =="Hoja de maxtan" | yield_2_text_998 =="Mashan y hoja canache" 
 }
 
   local is maxan3 // 
 foreach i of local is {
 gen yield_2_`i' = 0 if  consent !=1
 replace yield_2_`i' = 1 if yield_2_text_999 =="Hoja de mashan" | yield_2_text_999 =="Hoja para tamal" | yield_2_text_999 =="Hojas de Maxan"  | yield_2_text_999 =="Ojas de mashan" 
 }
  
 replace yield_2_997_1 =0 if yield_2_maxan1 ==1 & yield_2_997_1==1 
 replace yield_2_998_1 =0 if yield_2_maxan2 ==1 & yield_2_998_1==1
 replace yield_2_999_1 =0 if yield_2_maxan3 ==1 & yield_2_999_1==1 
 
 gen yield_2_maxan = 0 if muestra_2==1
 replace yield_2_maxan=1 if yield_2_maxan1 ==1  | yield_2_maxan2 ==1  | yield_2_maxan3 ==1  
  
*===============================================================================
* controles climatios 

* por producto/cultivo - climaticas Endline 
 
		  gen zc_fria = 0 if muestra_2==1
		  replace zc_fria =1 if yield_2_1_t ==1 | yield_2_6_t ==1 | yield_2_9 ==1 | yield_2_13==1 | yield_2_ejote ==1 | yield_2_15==1 | yield_2_guisquil==1 | yield_2_31==1 | yield_2_35 ==1 | yield_2_40_t==1 | yield_2_42_t==1 | yield_2_44_t==1 | yield_2_45_t ==1 | yield_2_49_t ==1 | yield_2_50_t==1
		  
		  gen zc_caliente =0 if muestra_2==1
		  replace zc_caliente =1 if yield_2_rice ==1 | yield_2_chile==1| yield_2_16_t==1 | yield_2_21_t ==1 | yield_2_maxan==1 | yield_2_34==1 | yield_2_yuca==1 | yield_2_37==1 | yield_2_43_t ==1 | yield_2_46_t ==1 | yield_2_47_t==1 | yield_2_48_t ==1 
		  
		  gen zc_ambas = 0 if muestra_2==1
		  replace zc_ambas =1 if yield_2_aguacate==1 | yield_2_20==1 

		 
*===============================================================================
* controles por tipo de cultivo 	  

		  gen ciclo_corto = 0 if muestra_2==1
		  replace ciclo_corto = 1 if yield_2_1_t ==1 | yield_2_rice ==1 | yield_2_6_t ==1 | yield_2_9==1 | yield_2_chile ==1 | yield_2_13==1 | yield_2_ejote==1 | yield_2_15==1 | yield_2_16_t==1 | yield_2_guisquil==1 | yield_2_21_t==1 | yield_2_31==1 |  yield_2_34==1 |  yield_2_35==1 | yield_2_37==1 |  yield_2_yuca==1 | yield_2_40_t==1 | yield_2_42_t==1 | yield_2_43_t==1 | yield_2_44_t==1 | yield_2_45_t==1 | yield_2_46_t==1 | yield_2_49_t==1 | yield_2_50_t==1
		  
		  gen ciclo_perenne =0 if muestra_2==1
		  replace ciclo_perenne =1 if yield_2_aguacate ==1 | yield_2_20==1| yield_2_maxan==1 | yield_2_47_t==1 | yield_2_48_t==1 		  

		  gen ciclo_nd =0 if muestra_2==1
		  replace ciclo_nd =1 if ciclo_perenne==0 & ciclo_corto ==0 & yield_2_1000 ==0
		  
		  
*==================================================================
*		  Outcomes de analisis
*==================================================================

* a.	Harvested any agricultural (animal) product 

	  g harvested = 0 if muestra_2 ==1
replace harvested = 1 if yield_2_1000 ==0 | yield_4_1000 ==0
label var harvested "Any agricultural-animal product"

* b.	Harvested any COVID-19 PAE agricultural or animal product 

	  g harvested_pae_covid1 = 0 if muestra_2 ==1 & harvested ==1
replace harvested_pae_covid1 = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_ejote==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_37==1 | yield_2_yuca | yield_2_40_t ==1 | yield_2_43_t==1 | yield_2_48_t==1 | yield_4_56==1) & harvested ==1
	
* c.	Harvested any COVID-19 non-PAE agricultural or animal product 

	  g harvested_no_pae_covid = 0 if muestra_2 ==1 & harvested ==1
replace harvested_no_pae_covid = 1 if harvested ==1 & harvested_pae_covid1==0

* d.	Harvested any COVID-19 PAE agricultural product  

	  g harvested_pae_covid_agri = 0  if muestra_2 ==1 & yield_2_1000 ==0
	  replace harvested_pae_covid_agri = 1 if harvested_pae_covid1==1 & yield_2_1000 ==0
	  replace harvested_pae_covid_agri = 0 if yield_4_56==1 & yield_2_1000 ==0

* e.	Harvested any COVID-19 non-PAE agricultural product  
		  g harvested_no_pae_covid_agri = 0 if muestra_2 ==1 & yield_2_1000 ==0
	replace harvested_no_pae_covid_agri = 1 if harvested_pae_covid_agri==0 & yield_2_1000 ==0

* f.	Harvested any COVID-19 PAE animal product  
	  g harvested_pae_covid_anim = 0 if muestra_2 ==1 & yield_4_1000 ==0
	  replace harvested_pae_covid_anim = 1 if yield_4_56==1 & yield_4_1000 ==0

* g.	Harvested any COVID-19 non-PAE animal product  
	  g harvested_no_pae_covid_anim = 0 if muestra_2 ==1 & yield_4_1000 ==0
	  replace harvested_no_pae_covid_anim = 1 if yield_4_56==0 & yield_4_1000 ==0

*===============================================================================
*Traditional PAE products 


* a.	Harvested any traditional PAE agricultural or animal product 

	  g harvested_pae_traditional1 = 0 if muestra_2 ==1 & harvested ==1
replace harvested_pae_traditional1 = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_13==1 | yield_2_ejote==1 | yield_2_15==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_34==1 | yield_2_35==1 | yield_2_37==1 | yield_2_40_t ==1 | yield_2_46_t==1  | yield_4_53==1 | yield_4_62==1 | yield_4_63==1) & harvested ==1
	
* b.	Harvested any traditional non-PAE agricultural or animal product 

	  g harvested_no_pae_traditional = 0 if muestra_2 ==1 & harvested ==1
replace harvested_no_pae_traditional = 1 if harvested ==1 & harvested_pae_traditional1 ==0

* c.	Harvested any traditional PAE agricultural product  

	 g harvested_pae_traditional_agri = 0  if muestra_2 ==1 & yield_2_1000 ==0
 replace harvested_pae_traditional_agri = 1 if harvested_pae_traditional1==1 & yield_2_1000 ==0
 replace harvested_pae_traditional_agri = 0 if ( yield_4_53==1 | yield_4_62==1 | yield_4_63==1) & yield_2_1000 ==0

* d.	Harvested any traditional non-PAE agricultural product  
	g harvested_no_pae_tradi_agri = 0 if muestra_2 ==1 & yield_2_1000 ==0
replace harvested_no_pae_tradi_agri = 1 if harvested_pae_traditional_agri==0 & yield_2_1000 ==0

* e.	Harvested any traditional PAE animal product  
		g harvested_pae_traditional_anim = 0 if muestra_2 ==1 & yield_4_1000 ==0
replace harvested_pae_traditional_anim = 1 if ( yield_4_53==1 | yield_4_62==1 | yield_4_63==1) & yield_4_1000 ==0

* f.	Harvested any traditional non-PAE animal product  
		g harvested_no_pae_tradi_anim = 0 if muestra_2 ==1 & yield_4_1000 ==0
	replace harvested_no_pae_tradi_anim = 1 if (yield_4_53==0 | yield_4_62==0 | yield_4_63==0) & yield_4_1000 ==0	  
	  
  
	  
******* Module H6 - PAE *************************

tab1 infor_*, nolabel

local variables infor_4 infor_5d infor_9 infor_9a infor_12 infor_13 infor_14

foreach variable of local variables{
replace `variable' =0 if `variable'==2	
replace `variable' =. if `variable'==3
}


*==================================================================
*		  Outcomes de analisis
*==================================================================

*a. Know about PAE market 

	label var infor_2 "Knows about PAE market"

* Knows through MAGA or Videos&SMS 

	        g maga_sms = 0 if infor_2 ==1
	  replace maga_sms = 1 if infor_3_1==1 | infor_3_5 ==1
	label var maga_sms "Knows through MAGA or Videos&SMS"

* Knows through MAGA 

	label var infor_3_1 "MAGA"

* Knows through Videos&SMS 

	label var infor_3_5 "Videos&SMS"

* Knows through other sources: MINEDUC campaign, another farmer, school/teacher/OPF, friends/relatives/neighbors/others. 

			g other_sources = 0 if infor_2 ==1
	  replace other_sources = 1 if (infor_3_1==0 | infor_3_5 ==0) & infor_2 ==1
	label var other_sources "Other sources"
 
* Household registered to sell crops to the SFP
   label var infor_4 "HH registered to sell crops to the SFP"

* If not registered 

* Knows SFP can buy products (5a) 

	label var infor_5a "Knows SFP can buy products"

* Knows that can register as SFP (5b) 

	label var infor_5b "Knows that can register as SFP"

* Knows the steps to register (5c, but input 5c = 0 if 5b!=yes, to get rid of the 0s) 

	  g steps = infor_5c
replace steps = 0 if infor_5b==0
label var steps "Knows the steps to register"

*Interested in registering (6, but replace 6 = 0 if 5a!=yes and 5b!=yes) 

	  g registro = infor_6
replace registro = 0 if infor_5b==1 |  infor_5a==1 | infor_6==2 | infor_6==-8
label var registro "Interested in registering"

*Sold crops a registered SFP provider (9)? (me parece que esta debería ser incondicional a las otras preguntas?) 

label var infor_9 "Sold crops to a registered SFP provider"
 
*Plans to speak to a registered SFP provider (12, but replace answer as in 6) 

 g plan = infor_12
  replace plan = 0 if infor_5b==1 | infor_5a==1 
label var plan "Plans to speak to a registered SFP provider"
 
* Contact information from a provider 13

label var infor_13 "HH have a provider's contact information"

* Knows the type of crops buy for the PAE 14

label var infor_14 "Knows about the crops that the schools buy from the SFP"

* 15 have spoken with a specialist from MAGA

label var infor_15 "Has spoken with a specialist from MAGA"

* 17 Knows SFP product quality standards (=1 if 17a==2&17b==1) 

 g quality = infor_17a==0 | infor_17b==1
replace quality =. if infor_17b==.






******* Module H7 - Agro practices *************************

replace mark_2=4 if mark_2==-8 // no sabe
tab mark_2, g(mark_2_)
tab mark_6, g(mark_6_)

******* Module H8 - Marketing *************************

g taxin = (mark_info_7a==1)
g invoice = (mark_info_7b==1) 
g invoice_interest = (mark_info_8==1)

******* Module H10 - perception *************************

tab inst_2a, gen(inst_2a_) 
tab inst_2b, gen(inst_2b_) 
tab inst_2c, gen(inst_2c_)

******* Module H11 - attitudes *************************

tab attitud_3_a, gen(attitud_3_a_) 
tab attitud_3_b, gen(attitud_3_b_)

******* Module H13 - life conditions *************************

tab life_cond_2a, gen(life_cond_2a_)

*** 
gen complete_controls = 1 
replace complete_controls = 0 if muestra_3 ==1


 save "$data\digitagro_clean.dta", replace