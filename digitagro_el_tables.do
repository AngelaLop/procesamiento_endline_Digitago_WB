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
Output:             Balance tables
==================================================*/

global path "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\07 Endline"
global path "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\07 Endline"
global data 	"${path}\07 01 Data"

use "${data}/gua_digitagro_el_09082021.dta", clear

******** Balance table ************************************
******* Module H3 - LAND *******************************

iebaltab terreno_cuerdas land_owner, pt grpvar(treatment_el_1) save("$output\land_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
terreno_cuerdas 	"Mean of the length of land used by the household for agriculture (cuerdas)" @ ///
land_owner	"Do you own any of the lands you cultivate? : Yes" @ ///
) replace 


******** Balance table ************************************
******* Module H4 - HARVEST *******************************
 
iebaltab yield_2_1 yield_2_6 yield_2_9 yield_2_13 yield_2_15 yield_2_16 yield_2_20 yield_2_21 yield_2_31 yield_2_34 yield_2_35 yield_2_37 yield_2_40 yield_2_42 yield_2_43 yield_2_44 yield_2_45 yield_2_46 yield_2_47 yield_2_48 yield_2_49 yield_2_50 yield_2_997 yield_2_998 yield_2_999 yield_2_1000 yield_3_1 yield_3_2 yield_3_3 yield_3_4 yield_3_5 yield_3_999 , pt grpvar(treatment_el_1) save("$output\harvest_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
yield_2_1 	"In June and July 2021, what did the household harvest?   1. Chard" @ ///
yield_2_6	"    6. Broccoli" @ ///
yield_2_9	"    9. Onion" @ ///
yield_2_13	"   13. Cilantro" @ ///
yield_2_15	"   15. Spinach" @ ///
yield_2_16	"   16. Black bean" @ /// 
yield_2_20	"   20. Limes" @ ///
yield_2_21	"   21. Corn" @ ///
yield_2_31	"   31. Potato" @ ///
yield_2_34	"   34. Plantain" @ ///
yield_2_35	"   35. Cabbage" @ ///
yield_2_37	"   37. Tomato" @ ///
yield_2_40	"   40. Carrots" @ ///
yield_2_42	"   42. Radish" @ ///
yield_2_43	"   43. Cucumber" @ ///
yield_2_44	"   44. Fava bean" @ ///
yield_2_45	"   45. Cauliflower" @ ///
yield_2_46	"   46. Chipilín" @ ///
yield_2_47	"   47. Coffee" @ ///
yield_2_48	"   48. Banana" @ ///
yield_2_49	"   49. Beetroot" @ ///
yield_2_50	"   50. Lettuce" @ ///
yield_2_997	"  997. Other1" @ ///
yield_2_998	"  998. Other2" @ ///
yield_2_999	"  999. Other3" @ ///
yield_2_1000 "1000. None" @ ///
yield_3_1	"In June and July 2021, why didn't the household partake in a harvest?    1. It's not the season " @ ///
yield_3_2	"    2. Lack of manpower" @ ///
yield_3_3	"    3. There is no where to sell" @ ///
yield_3_4	"    4. Dedicated to other work" @ ///
yield_3_5	"    5. Low prices" @ ///
yield_3_999	"  999. Other (Specify)" @ ///
) replace 
 
* pendientes  yield_2_51 yield_2_52 yield_2_53 yield_2_54 yield_2_55 yield_2_56 yield_2_57 yield_2_58 yield_2_59 yield_2_60 yield_2_61 yield_2_62 yield_2_63 yield_2_64 yield_2_994 yield_2_995 yield_2_996 yield_2_997 yield_2_998 yield_2_999 yield_2_1000
*pendiente yield_4 / esperando aclaracion 
 
******* Balance table ***********************************
******* Module H5 - SALES *******************************

iebaltab comm_3_1 comm_3_2 comm_3_3 comm_3_4 comm_3_5 comm_3_6 comm_3_7 comm_3_999 comm_3_1000 comm_6a_1 comm_6a_2 comm_6a_3 comm_6a_4 comm_6b_1 comm_6b_2 comm_6b_3 comm_6b_4 comm_11_1 comm_11_2 comm_11_3 comm_11_4 comm_11_999 comm_12 comm_13a comm_13b_1 comm_13b_2 comm_13b_3 comm_13b_4 comm_13b_5 comm_13b_6 comm_13b_7 comm_13b_999 comm_13b_1000, pt grpvar(treatment_el_1) save("$output\sales_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
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

******* Balance table *********************************
******* Module H6 - PAE *******************************
*gen treatment_1 = (treatment_bl_1==2)

iebaltab infor_2 infor_3_1 infor_3_2 infor_3_3 infor_3_4 infor_3_5 infor_3_6 infor_3_999 infor_4 infor_5a infor_5b infor_5c infor_5d infor_6 infor_7_1 infor_7_2 infor_7_3 infor_7_4 infor_7_5 infor_7_6 infor_7_7 infor_7_999 infor_8_1_1 infor_8_1_2 infor_8_1_3 infor_8_1_4 infor_8_1_5 infor_8_1_999 infor_9 infor_9a infor_9b_1 infor_9b_2 infor_9b_3 infor_9b_4 infor_9b_5 infor_9b_6 infor_9b_7 infor_9b_999 infor_12 infor_13 infor_14 infor_15 infor_17a infor_17b if muestra_1==1 , pt grpvar(treatment_el_1) save("$output\PAE_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
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

******* Balance table ********************************************
******* Module H7 - Agro practices *******************************
 
iebaltab mark_2_1 mark_2_2 mark_2_3 mark_2_4 mark_6_1 mark_6_2 mark_6_3 mark_6_4 mark_6_5, pt grpvar(treatment_el_1) save("$output\agro_practices_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
mark_2_1 	"In the last two months, what material did the household use to pack the eggs for sale? ..... 1. Cardboard" @ ///
mark_2_2	"		2. In clean and humid places " @ ///
mark_2_3	"		3. In other places (Specify) " @ ///
mark_2_4	"		4. I don't know " @ ///
mark_6_1	"		1. Cardboard " @ ///
mark_6_2	"		2. Box " @ ///
mark_6_3	"		3. Baskets " @ ///
mark_6_4	"		4. Bags " @ ///
mark_6_5	"	  999. Other (Specify) " @ ///
) replace 
 
 
 
******* Balance table ********************************************
******* Module H8 - marketing ************************************

iebaltab taxin invoice invoice_interest, pt grpvar(treatment_el_1) save("$output\marketing_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
taxin	"Does anyone in the household have a Tax Identification Number (TIN)?....1. Yes " @ ///
invoice	"Can someone from the household issue invoices?.... 1. Yes " @ ///
invoice_interest	"Are you interested in getting an invoice?.... 1. Yes " @ ///
) replace 


******* Balance table ********************************************
******* Module H10 - perception ********************************** 

iebaltab inst_2a_2 inst_2a_3 inst_2a_4 inst_2a_5 inst_2a_1 inst_2b_2 inst_2b_3 inst_2b_4 inst_2b_5 inst_2b_1  inst_2c_2 inst_2c_3 inst_2c_4 inst_2c_5 inst_2c_1, pt grpvar(treatment_el_1) save("$output\perception_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
inst_2a_2	"Currently, how much confidence do you have in Minitry of Agriculture (MAGA)....1. Very much " @ ///
inst_2a_3	"		2. Somewhat " @ ///
inst_2a_4	"		3. Little " @ ///
inst_2a_5	"		4. None " @ ///
inst_2a_1	"		5. I don't know/ No response " @ ///
inst_2b_2	"Currently, how much confidence do you have in Ministry of Education (MINEDUC)....1. Very much " @ ///
inst_2b_3	"		2. Somewhat " @ ///
inst_2b_4	"		3. Little " @ ///
inst_2b_5	"		4. None " @ ///
inst_2b_1	"		5. I don't know/ No response " @ ///
inst_2c_2	"Currently, how much confidence do you have in Superintendence of Tax Administration (SAT)....1. Very much " @ ///
inst_2c_3	"		2. Somewhat " @ ///
inst_2c_4	"		3. Little " @ ///
inst_2c_5	"		4. None " @ ///
inst_2c_1	"		5. I don't know/ No response " @ ///
) replace 


******* Balance table ********************************************
******* Module H11 - attitudes *********************************** 


iebaltab inst_2a_2 inst_2a_3 inst_2a_4 inst_2a_5 inst_2a_1 inst_2b_2 inst_2b_3 inst_2b_4 inst_2b_5 inst_2b_1  inst_2c_2 inst_2c_3 inst_2c_4 inst_2c_5 inst_2c_1, pt grpvar(treatment_el_1) save("$output\attitudes_table.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
inst_2a_2	"Currently, how much confidence do you have in Minitry of Agriculture (MAGA)	1. Very much " @ ///
inst_2a_3	"		2. Somewhat " @ ///
inst_2a_4	"		3. Little " @ ///
inst_2a_5	"		4. None " @ ///
inst_2a_1	"		5. I don't know/ No response " @ ///
inst_2b_2	"Currently, how much confidence do you have in Ministry of Education (MINEDUC)....1. Very much " @ ///
inst_2b_3	"		2. Somewhat " @ ///
inst_2b_4	"		3. Little " @ ///
inst_2b_5	"		4. None " @ ///
inst_2b_1	"		5. I don't know/ No response " @ ///
inst_2c_2	"Currently, how much confidence do you have in Superintendence of Tax Administration (SAT)....1. Very much " @ ///
inst_2c_3	"		2. Somewhat " @ ///
inst_2c_4	"		3. Little " @ ///
inst_2c_5	"		4. None " @ ///
inst_2c_1	"		5. I don't know/ No response " @ ///
) replace 


******* Balance table ********************************************
******* Module H11A - take-up ************************************ 
 
 ** should be on the postfile tables 
 
iebaltab takeup_1 takeup_2a_1 takeup_2a_2 takeup_2a_3 takeup_2a_4 takeup_2a_999 takeup_2a_1000 takeup_2b_1 takeup_2b_2 takeup_2b_3 takeup_2b_4 takeup_2b_999 takeup_2b_1000 takeup_3 takeup_4a_1 takeup_4a_2 takeup_4a_3 takeup_4a_4 takeup_4a_999 takeup_4a_1000 takeup_4b_1 takeup_4b_2 takeup_4b_3 takeup_4b_4 takeup_4b_999 takeup_4b_1000 takeup_5, pt grpvar(treatment_el_1) save("$output\takeup.xlsx") stdev vce(robust) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) ///
rowlabels( ///
takeup_1	"Currently, how much confidence do you have in Minitry of Agriculture (MAGA)....1. Very much " @ ///
takeup_2a_1	"Which message(s) do you remember the most from the video?....1. What is the PAE " @ ///
takeup_2a_2	"		2. How to sell crops to the PAE " @ ///
takeup_2a_3	"		3. Products purchased by PAE schools " @ ///
takeup_2a_4	"		4. Recommendations on product quality " @ ///
takeup_2a_999	"	999. Other (Specify) " @ ///
takeup_2a_1000	"	1000. None " @ ///
takeup_2b_1	"Which message(s) do you remember the most from the video?....1. The town of Rabinal, Baja Verapaz " @ ///
takeup_2b_2	"		2. Village crafts " @ ///
takeup_2b_3	"		3. Nature / Landscape of the village " @ ///
takeup_2b_4	"		4. Use of natural inputs in the handicrafts of the town " @ ///
takeup_2b_999	"	999. Other (Specify) " @ ///
takeup_2b_1000	"	1000. None " @ ///
takeup_3	"Do you remember receiving text messages about the School Feeding Program / Coronavirus Prevention Program?		1.Yes " @ ///
takeup_4a_1	"What do you remember most about the text messages?.... 1.How to sell crops to PAE" @ ///
takeup_4a_2	"		2. Products purchased by PAE schools " @ ///
takeup_4a_3	"		3. Contact information for MAGA specialists " @ ///Contact information for MAGA specialists
takeup_4a_4	"		4. Contact information for PAE suppliers " @ ///
takeup_4a_999	"	999. Other (Specify) " @ ///
takeup_4a_1000	"	1000. None " @ ///
takeup_4b_1	"What do you remember most about the text messages?.... 1.Coronavirus precautions" @ ///
takeup_4b_2	"		2. Hand washing " @ ///
takeup_4b_3	"	3. Use of mask " @ ///Contact information for MAGA specialists
takeup_4b_4	"	4. Avoid crowds " @ ///
takeup_4b_999	"	999. Other (Specify) " @ ///
takeup_4b_1000	"	1000. None " @ ///
takeup_5 "		Do you remember seeing a video about the School Feeding Program? 		1. Yes " @ ///
) replace  
 
 
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
