/*==================================================
project:       
Author:        Angela Lopez 
E-email:       ar.lopez@uniandes.edu.co
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

global path 	"C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\07 Endline"
global data 	"${path}\07 01 Data"
global clean	"${path}\07 4 Clean Data"
global output	"${path}\07 3 Docs\Digitagro - balance tables"
global baseline "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\06 Baseline\06 4 Clean Data" 

use "${data}/gua_digitagro_el_09082021.dta", clear


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
encode treatment_bl, g(treatment_bl_1)
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
	* partner 
	tab home_16, generate(educa_men)
*** marital status 
	tab home_17, generate(marital)
*** age  
	g edad = edad_nacimiento
	g edad2 = edad^2
	
*** hectarias de tierras

*** fertilizante
	
******* Stratas *********************************
* pending


 
******* Module H6 - PAE *************************



tab1 infor_*, nolabel



local variables infor_4 infor_5d infor_9 infor_9a infor_12 infor_13 infor_14

foreach variable of local variables{
replace `variable' =0 if `variable'==2	
replace `variable' =. if `variable'==3
}



*** Balance table *******************************

gen treatment_1 = (treatment_bl_1==2)

iebaltab infor_2 infor_3_1 infor_3_2 infor_3_3 infor_3_4 infor_3_5 infor_3_6 infor_3_999 infor_4 infor_5a infor_5b infor_5c infor_5d infor_6 infor_7_1 infor_7_2 infor_7_3 infor_7_4 infor_7_5 infor_7_6 infor_7_7 infor_7_999 infor_8_1_1 infor_8_1_2 infor_8_1_3 infor_8_1_4 infor_8_1_5 infor_8_1_999 infor_9 infor_9a infor_9b_1 infor_9b_2 infor_9b_3 infor_9b_4 infor_9b_5 infor_9b_6 infor_9b_7 infor_9b_999 infor_12 infor_13 infor_14 infor_15 infor_17a infor_17b if muestra_1==1 , pt grpvar(treatment_1) save("$output\PAE_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
infor_2 "2. % woman with knowledge about the existence of the School Feeding Program (SFP)" @ ///
infor_3_1	"3. SFP information source: Ministry of Agriculture, Livestock and Food (MAGA)" @ ///
infor_3_2	"3. SFP information source: Ministry of Educcation (MINEDUC) campaign" @ ///
infor_3_3	"3. SFP information source: Another farmer" @ ///
infor_3_4	"3. SFP information source: School/ Teacher/ OPF" @ ///
infor_3_5	"3. SFP information source: Informative videos and SMSs" @ /// 
infor_3_6	"3. SFP information source: Friends/ Relatives/ Neighbors" @ ///
infor_3_999 "3. SFP information source: Other" @ ///
infor_4 	"4. Household registered to sell crops to the SFP" @ ///
infor_5a	"5a. knowledge that the SFP buys crops and / or animal products from local farmers" @ ///
infor_5b	"5b. knowledge that someone in the household can register as a provider of the SFP" @ ///
infor_5c	"5c. knowledge of the requirements to register as a provider of the SFP" @ ///
infor_5d	"5d. think the process to register as a supplier is simple" @ ///
infor_6 	"6. interested in registering" @ ///
infor_7_1 	"7. Why would you not be interested in registering: Does not know / Doubts" @ ///
infor_7_2	"7. Why would you not be interested in registering: Lack of time" @ ///
infor_7_3 	"7. Why would you not be interested in registering: Little capital / resources / land / labor" @ ///
infor_7_4 	"7. Why would you not be interested in registering: Produces little" @ ///
infor_7_5 	"7. Why would you not be interested in registering: Does not have the products they ask for" @ ///
infor_7_6 	"7. Why would you not be interested in registering: ND1" @ ///
infor_7_7 	"7. Why would you not be interested in registering: ND2" @ ///
infor_7_999 "7. Why would you not be interested in registering: Others" @ ///
infor_8_1_1	"8. Expected benefits from participating in the PAE: To generate income" @ ///
infor_8_1_2	"8. Expected benefits from participating in the PAE: They pay good prices" @ ///
infor_8_1_3	"8. Expected benefits from participating in the PAE: Support the community and children" @ ///
infor_8_1_4	"8. Expected benefits from participating in the PAE: Have a secure / fixed buyer" @ ///
infor_8_1_5	"8. Expected benefits from participating in the PAE: Prices are stable" @ /// 
infor_8_1_999 "8. Expected benefits from participating in the PAE: other" @ ///
infor_9		"9. Households selling their products to an already registered supplier of the SFP" @ ///
infor_9a	"9a Knowledge crops can be sold to suppliers already registered in the SFP" @ ///
infor_9b_1	"9b1. reasons why the household didn't sell crops to a registered SFP provider: Does not know / Doubts " @ ///
infor_9b_2	"9b2 reasons why the household didn't sell crops to a registered SFP provider: Lack of time" @ ///
infor_9b_3	"9b3 reasons why the household didn't sell crops to a registered SFP provider: Little capital / resources / land / labor" @ ///
infor_9b_4	"9b4 reasons why the household didn't sell crops to a registered SFP provider: Produces little" @ ///
infor_9b_5	"9b5 reasons why the household didn't sell crops to a registered SFP provider: Does not have the products they ask for" @ ///
infor_9b_6	"9b6 reasons why the household didn't sell crops to a registered SFP provider: Prices are not good" @ ///
infor_9b_7	"9b7 reasons why the household didn't sell crops to a registered SFP provider: ND1" @ ///
infor_9b_999 "9b999 reasons why the household didn't sell crops to a registered SFP provider: Other (Specify)" @ ///
infor_12	"12. someone in the household plan to speak with a provider later" @ ///
infor_13	"13. the household have a provider's phone number or contact information" @ ///
infor_14	"14. knowledge about the crops that the schools buy from the SFP" @ ///
infor_15	"15. have spoken with a specialist from MAGA" @ ///
infor_17a	"17a.Crops sold to schools in the School Feeding Program must edible, even if they are a little mistreated or spoiled " @ ///
infor_17b 	"17b.Crops sold to schools in the School Feeding Program must have no sign of abuse or decay " ///
) replace 



******* Module H5 - SALES *************************


 
 *** Balance table *******************************


iebaltab comm_3_1 comm_3_2 comm_3_3 comm_3_4 comm_3_5 comm_3_6 comm_3_7 comm_3_999 comm_3_1000 comm_6a_1 comm_6a_2 comm_6a_3 comm_6a_4 comm_6b_1 comm_6b_2 comm_6b_3 comm_6b_4 comm_11_1 comm_11_2 comm_11_3 comm_11_4 comm_11_999 comm_12 comm_13a comm_13b_1 comm_13b_2 comm_13b_3 comm_13b_4 comm_13b_5 comm_13b_6 comm_13b_7 comm_13b_999 comm_13b_1000, pt grpvar(treatment_1) save("$output\sales_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
comm_3_1 	"In June and July 2021, to whom did the household sell its crops and / or animal products?: 		1. Coyote /Middlemen/Intermediary (no PAE)" @ ///
comm_3_2	"	2. Assocition/ Cooperative" @ ///
comm_3_3	"	3. Someone who sells to the school (PAE provider) " @ ///
comm_3_4	"	4. Directly to the school" @ ///
comm_3_5	"	5. Merchant / Warehouse keeper (Specify)" @ ///
comm_3_6	"	6. Directly to the person (relatives, neighbors, etc.)" @ /// 
comm_3_7	"	7. In the square / market / terminal" @ ///
comm_3_999	"	999. Other (Specify)" @ ///
comm_3_1000	"	1000. None" @ ///
comm_6a_1	" 6a In the months of June and July 2021, who from your household decided on the crop that was sold?:	1. You " @ ///
comm_6a_2	"		2. Husband " @ ///
comm_6a_3	"		3. Other male member if the household " @ ///
comm_6a_4	" 		4. Other female member of the household " @ ///
comm_6b_1	" 6b In the months of June and July 2021, who from your household decided on the animal products or by-products that were sold? : 1. You " @ ///
comm_6b_2	" 	 2. Husband " @ ///
comm_6b_3	" 	 3. Other male member if the household " @ ///
comm_6b_4	" 	 4. Other female member of the household " @ ///
comm_11_1	"11. In June and July 2021, why didn't the household sell its crops or animal products? 1. Harvested for home consumption only" @ ///
comm_11_2	"2. The price was not good" @ ///
comm_11_3	"3. The harvest was spoiled" @ ///
comm_11_4	"4. No encontró comprador" @ ///
comm_11_999	"999. other (specify)" @ ///
comm_12		"For the rest of this year, do you plan to sell crops? : Yes" @ ///
comm_13a	"In June and July of this year, you? or did a member of your household talk with a buyer of crops or animal products to whom they did not sell? : Yes" @ ///
comm_13b_1	"In June and July of this year, who did you talk to? 1. Coyote /Middlemen/Intermediary (no PAE) " @ ///
comm_13b_2 " 2. Assocition/ Cooperative " @ ///
comm_13b_3 " 3. Someone who sells to the school (PAE provider) " @ ///
comm_13b_4 " 4. Directly to the school" @ ///
comm_13b_5 " 5. Merchant / Warehouse keeper (Specify)" @ ///
comm_13b_6 " 6. Directly to the person (relatives, neighbors, etc.)" @ ///
comm_13b_7 " 7. In the square / market / terminal" @ ///
comm_13b_999 " 999. other" @ ///
comm_13b_1000 " 1000. none" @ ///
) replace 
 


******* Module H4 - HARVEST *************************


 * recode household harvest - yield_2*
 
 gen yield_2_habas = . // Fava bean ++
 replace yield_2_habas = 1 if yield_2_text_997 =="Aba" | yield_2_text_997 =="Abas" | yield_2_text_997 =="Haba" | yield_2_text_997 =="Habas" | yield_2_text_997=="Ava" | yield_2_text_997=="Frijol de haba" | yield_2_text_997=="haba"
 
 replace yield_2_44 =1 if yield_2_habas ==1
 
 local is acelga // Chard ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Acelga" 
 }
 
 replace yield_2_1 =1 if yield_2_acelga ==1
 
    local is banana // banana ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Banano" | yield_2_text_997 =="Bananos" 
 }
 
 replace yield_2_48 =1 if yield_2_banana ==1
 
 
 
     local is brocoli // brocoli ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Brocoli" | yield_2_text_997 =="Brócoli" 
 }
 
 replace yield_2_6 =1 if yield_2_brocoli ==1
 
     local is beetroot // Beetroot ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Remolach" | yield_2_text_997 =="Remolacha" | yield_2_text_997 =="Remolacha,coliflor,durazno" | yield_2_text_997 =="Remolachas"
 } 
 
 replace yield_2_49 =1 if yield_2_beetroot ==1
  
      local is coffee // coffee ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Cafe" | yield_2_text_997 =="Cafe,guineo" | yield_2_text_997 =="Café" 
 } 
 
 replace yield_2_47 =1 if yield_2_coffee ==1
 
     local is chipilin // chipillin  ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chipilin" | yield_2_text_997 =="Chipilin , ayote, rambutanes" 
 } 
 
 replace yield_2_46 =1 if yield_2_chipilin ==1
 
      local is cauliflower // Cauliflower  ++
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Coliflor"  
 } 
 
 replace yield_2_45 =1 if yield_2_cauliflower ==1
 
  local is aguacate // avocado
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Aguacate" | yield_2_text_997 =="Aguacate  jas" | yield_2_text_997 =="Aguacate Grande" | yield_2_text_997 =="Aguacate y limón" | yield_2_text_997 =="Aguacates" | yield_2_text_997 =="Aguacates milpa y platano" 
 }
 
 
   local is alverja // pee
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Alberga" | yield_2_text_997 =="Alberge" | yield_2_text_997 =="Alberja" | yield_2_text_997 =="Alberja y ejote" | yield_2_text_997 =="Alberja, rabano" | yield_2_text_997 =="Alberjas" | yield_2_text_997 =="Arbeja" | yield_2_text_997 =="Arveja" | yield_2_text_997 =="Arverja" 
 }
 
 
    local is chile // chile
 foreach i of local is {
 gen yield_2_`i' = . 
 replace yield_2_`i' = 1 if yield_2_text_997 =="Chilacayote" | yield_2_text_997 =="Chile" | yield_2_text_997 =="Chile Pimiento" | yield_2_text_997 =="Chile Santo Domingo" | yield_2_text_997 =="Chile chilpete" | yield_2_text_997 =="Chile chiltepe" | yield_2_text_997 =="Chile chocolate" | yield_2_text_997 =="Chile diente de perro" | yield_2_text_997 =="Chile jalapeño" | yield_2_text_997 =="Chile jalapeño, chaya" | yield_2_text_997 =="Chile nance" | yield_2_text_997 =="Chile pimienta" | yield_2_text_997 =="Chile pimiento" | yield_2_text_997 =="Chile pimiento y apio" | yield_2_text_997 =="Chile purun" | yield_2_text_997 =="Chile y aguacate"
 }
 
  * recode household animal products - yield_4*
 
 
 
 *** Balance table *******************************


*======================================================================
*	balance tables : coefficients 
*======================================================================
* 
preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Indicador Module tipo_control tipo_valor value)  using `tablas', replace
		
	*Total
	* 1. no controls 


	local indicadores infor_2 infor_3_1 infor_3_2 infor_3_3 infor_3_4 infor_3_5 infor_3_6 infor_3_999 infor_4 infor_5a infor_5b infor_5c infor_5d infor_6 infor_7_1 infor_7_2 infor_7_3 infor_7_4 infor_7_5 infor_7_6 infor_7_7 infor_7_999 infor_8_1_1 infor_8_1_2 infor_8_1_3 infor_8_1_4 infor_8_1_5 infor_8_1_999 infor_9 infor_9a infor_9b_1 infor_9b_2 infor_9b_3 infor_9b_4 infor_9b_5 infor_9b_6 infor_9b_7 infor_9b_999 infor_12 infor_13 infor_14 infor_15 infor_17a infor_17b  
			foreach indicador of local indicadores {
				reg `indicador' treatment_1
	
				
				mat tables=r(table)
				local beta = tables[1,1]
				local se = tables[2,1]
				
				post `ptablas' ("`indicador'") ("PAE") ("sin controles") ("beta") ("`beta'") 
				post `ptablas' ("`indicador'") ("PAE") ("sin controles") ("se") ("[`se']")
	
			}
			
local indicadores comm_3_1 comm_3_2 comm_3_3 comm_3_4 comm_3_5 comm_3_6 comm_3_7 comm_3_999 comm_3_1000 comm_6a_1 comm_6a_2 comm_6a_3 comm_6a_4 comm_6b_1 comm_6b_2 comm_6b_3 comm_6b_4 comm_11_1 comm_11_2 comm_11_3 comm_11_4 comm_11_999 comm_12 comm_13a comm_13b_1 comm_13b_2 comm_13b_3 comm_13b_4 comm_13b_5 comm_13b_6 comm_13b_7 comm_13b_999 comm_13b_1000 
			foreach indicador of local indicadores {
				reg `indicador' treatment_1 
	
				
				mat tables=r(table)
				local beta = tables[1,1]
				local se = tables[2,1]
				
				post `ptablas' ("`indicador'") ("SALES") ("sin controles") ("beta") ("`beta'") 
				post `ptablas' ("`indicador'") ("SALES") ("sin controles") ("se") ("[`se']")
	
			}		

postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "${output}/balance_tables_digitagro.xlsx", sh("regresiones", replace)  firstrow(var)

restore














