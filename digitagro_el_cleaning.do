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
version 17
drop _all
*ssc install ietoolkit

global path "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\07 Endline"
global data 	"${path}\07 01 Data"
global clean	"${path}\07 4 Clean Data"
global output	"${path}\07 3 Docs\Digitagro - balance tables"
global baseline "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\06 Baseline\06 4 Clean Data" 

use "${data}/gua_digitagro_el_raw_no_pii.dta", clear


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

keep if muestra_dig ==1

tab total
encode treatment_bl, g(treatment_el)
gen treatment_el_1=(treatment_el==2)
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

merge m:m caseid using "$baseline\strata.dta"

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
	tab home_12, generate(educa_wmen)
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
	
*** hectarias de tierras - cuerdas
	g terreno_cuerdas = farm_2
	replace terreno_cuerdas = . if farm_3 ==999
	replace terreno_cuerdas = . if farm_2 ==-888
	
	g terreno_hectareas = terreno_cuerdas*0.3930395625 // equivalencia en hectareas 
*** land ownership 
	g land_owner = (farm_4==1)
	replace land_owner = . if farm_4==3

*** fertilizante
	
******* Stratas *********************************
* pending - whatsapp top5% comunities 
egen strata1=group(municipality)

******* Module H4 - HARVEST *************************

 * recode household harvest - yield_2*
 
 gen yield_2_habas = . // Fava bean ++
 replace yield_2_habas = 1 if yield_2_text_997 =="Aba" | yield_2_text_997 =="Abas" | yield_2_text_997 =="Haba" | yield_2_text_997 =="Habas" | yield_2_text_997=="Ava" | yield_2_text_997=="Frijol de haba" | yield_2_text_997=="haba" | yield_2_text_998=="Avas" | yield_2_text_998=="Haba" | yield_2_text_998=="Habas"
 
 replace yield_2_44 =1 if yield_2_habas ==1
 replace yield_2_997=0 if yield_2_habas ==1
 replace yield_2_998=0 if yield_2_habas ==1 
 replace yield_2_999=0 if yield_2_habas ==1
 
 
 local is radish // Radish ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Rabano" | yield_2_text_997 =="Rábano" | yield_2_text_997 =="rabano" |  yield_2_text_998 =="Rabanito" |  yield_2_text_998 =="Rabano" | yield_2_text_998 =="Rabano," | yield_2_text_998 =="Rabanos"
 }
 replace yield_2_44 =1 if yield_2_radish ==1
 
 local is acelga // Chard ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Acelga" 
 }
 
 replace yield_2_1 =1 if yield_2_acelga ==1
 replace yield_2_997 =0 if yield_2_acelga ==1
 
    local is banana // banana ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Banano" | yield_2_text_997 =="Bananos" | yield_2_text_998 =="Banano" | yield_2_text_998 =="Bananos"
 }
 
 replace yield_2_48 =1 if yield_2_banana ==1
 
 
 
     local is brocoli // brocoli ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Brocoli" | yield_2_text_997 =="Brócoli" | yield_2_text_998 =="Brócoli" 
 }
 
 replace yield_2_6 =1 if yield_2_brocoli ==1
  replace yield_2_997 =0 if yield_2_brocoli ==1
 
     local is beetroot // Beetroot ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Remolach" | yield_2_text_997 =="Remolacha" | yield_2_text_997 =="Remolacha,coliflor,durazno" | yield_2_text_997 =="Remolachas" | yield_2_text_998 =="Remolachas" | yield_2_text_998 =="Remolacha"
 } 
 
  replace yield_2_49 =1  if yield_2_beetroot ==1
  replace yield_2_997 =0 if yield_2_beetroot ==1
  replace yield_2_998 =0 if yield_2_beetroot ==1
  
      local is coffee // coffee ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Cafe" | yield_2_text_997 =="Cafe,guineo" | yield_2_text_997 =="Café" | yield_2_text_998 =="Cafe" | yield_2_text_998 =="Café" | yield_2_text_998 =="Café Robusto"
 } 
 
 replace yield_2_47 =1  if yield_2_coffee ==1
 replace yield_2_997 =0 if yield_2_coffee ==1
 replace yield_2_998 =0 if yield_2_coffee ==1
  
     local is chipilin // chipillin  ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chipilin" | yield_2_text_997 =="Chipilin , ayote,  rambutanes" | yield_2_text_997 =="Chipilin"
 } 
 
 replace yield_2_46 =1  if yield_2_chipilin ==1
 replace yield_2_997 =0 if yield_2_chipilin ==1
 replace yield_2_998 =0 if yield_2_chipilin ==1
 
	
	local is cauliflower // Cauliflower  ++
 
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Coliflor" | yield_2_text_998 =="Coliflor" | yield_2_text_998 =="Colifrol" | yield_2_text_998 =="Colifror"
 } 
 
 replace yield_2_45 =1  if yield_2_cauliflower ==1
 replace yield_2_997 =0 if yield_2_cauliflower ==1
 replace yield_2_998 =0 if yield_2_cauliflower ==1
 
  local is aguacate // avocado
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Aguacate" | yield_2_text_997 =="Aguacate  jas" | yield_2_text_997 =="Aguacate Grande" | yield_2_text_997 =="Aguacate y limón" | yield_2_text_997 =="Aguacates" | yield_2_text_997 =="Aguacates milpa y platano"   | yield_2_text_998 =="Aguacate"
 }
  
 replace yield_2_997 =0 if yield_2_aguacate ==1
 replace yield_2_998 =0 if yield_2_aguacate ==1
 
 
   local is alverja // pee
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Alberga" | yield_2_text_997 =="Alberge" | yield_2_text_997 =="Alberja" | yield_2_text_997 =="Alberja y ejote" | yield_2_text_997 =="Alberja, rabano" | yield_2_text_997 =="Alberjas" | yield_2_text_997 =="Arbeja" | yield_2_text_997 =="Arveja" | yield_2_text_997 =="Arverja" 
 }
 
 replace yield_2_997 =0 if yield_2_alverja ==1
 replace yield_2_998 =0 if yield_2_alverja ==1
 
    local is chile // chile
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chilacayote" | yield_2_text_997 =="Chile" | yield_2_text_997 =="Chile Pimiento" | yield_2_text_997 =="Chile Santo Domingo" | yield_2_text_997 =="Chile chilpete" | yield_2_text_997 =="Chile chiltepe" | yield_2_text_997 =="Chile chocolate" | yield_2_text_997 =="Chile diente de perro" | yield_2_text_997 =="Chile jalapeño" | yield_2_text_997 =="Chile jalapeño, chaya" | yield_2_text_997 =="Chile nance" | yield_2_text_997 =="Chile pimienta" | yield_2_text_997 =="Chile pimiento" | yield_2_text_997 =="Chile pimiento y apio" | yield_2_text_997 =="Chile purun" | yield_2_text_997 =="Chile y aguacate" | yield_2_text_998 =="Chile" | yield_2_text_998 =="Chile Jalapeño" | yield_2_text_998 =="Chile chiltepe" | yield_2_text_998 =="Chile chocolate" | yield_2_text_998 =="Chile jalapeño" | yield_2_text_998 =="Chile picante" | yield_2_text_998 =="Chile pimiento" 
 }
 
 replace yield_2_997 =0 if yield_2_chile ==1
 replace yield_2_998 =0 if yield_2_chile ==1
  
  local is cacao // cacao
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Cacaho" | yield_2_text_997 =="Cacao" | yield_2_text_998 =="Cacao" 
 }
 replace yield_2_997 =0 if yield_2_cacao ==1
 replace yield_2_998 =0 if yield_2_cacao ==1
 
 
******* Module H6 - PAE *************************

tab1 infor_*, nolabel

local variables infor_4 infor_5d infor_9 infor_9a infor_12 infor_13 infor_14

foreach variable of local variables{
replace `variable' =0 if `variable'==2	
replace `variable' =. if `variable'==3
}

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

 save "$data/digitagro_clean", replace