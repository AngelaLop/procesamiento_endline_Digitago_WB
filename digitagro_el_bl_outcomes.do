
global path "C:\Users\WB585318\WBG\Javier Romero - GTM - IE DIGITAGRO\Analisis cuantitativo"
global el	"${path}\07 Endline"
global bl   "${path}\06 Baseline"

global data_el 	"${el}\07 01 Data"
global data_bl 	"${bl}\06 01 Data"
global clean_el	"${el}\07 4 Clean Data"
global clean_bl	"${bl}\06 4 Clean Data"
global output_f "${el}\07 3 Docs\Digitagro" 
global output	"${output_f}\Individual tables"

use "$data_el\digitagro_clean.dta", replace

*==================================================================
*		  Outcomes de analisis
*==================================================================



*==================================================================
*		  HARVEST
*==================================================================


* a.	Harvested any agricultural (animal) product 

	  g harvested = 0 if muestra_2 ==1
replace harvested = 1 if yield_2_1000 ==0 | yield_4_1000 ==0
label var harvested "Any agricultural-animal product"

* b.	Harvested any COVID-19 PAE agricultural or animal product 

	  g harvested_pae_covid1 = 0 if muestra_2 ==1 
replace harvested_pae_covid1 = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_ejote==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_37==1 | yield_2_yuca | yield_2_40_t ==1 | yield_2_43_t==1 | yield_2_48_t==1 | yield_4_56==1) & muestra_2 ==1 

	
* c.	Harvested any COVID-19 non-PAE agricultural or animal product 

	  g harvested_no_pae_covid = 0 if muestra_2 ==1 
replace harvested_no_pae_covid = 1 if (yield_2_1_t==1 | yield_2_13==1 | yield_2_15==1| yield_2_34==1| yield_2_35==1| yield_2_42_t==1| yield_2_44_t==1| yield_2_45_t==1| yield_2_46_t==1| yield_2_47_t==1| yield_2_49_t==1| yield_2_50_t==1| yield_4_51==1 | yield_4_52==1 | yield_4_53==1 | yield_4_54==1 | yield_4_55==1 | yield_4_57==1 | yield_4_58==1 | yield_4_59==1 | yield_4_60==1 | yield_4_61==1 | yield_4_62==1 | yield_4_63==1 | yield_4_64==1) & muestra_2 ==1

* d.	Harvested any COVID-19 PAE agricultural product  

	  g harvested_pae_covid_agri = 0  if muestra_2 ==1 
	  replace harvested_pae_covid_agri = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_ejote==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_37==1 | yield_2_yuca | yield_2_40_t ==1 | yield_2_43_t==1 | yield_2_48_t==1 ) & muestra_2 ==1
	  

* e.	Harvested any COVID-19 non-PAE agricultural product  
		  g harvested_no_pae_covid_agri = 0 if muestra_2 ==1 
	replace harvested_no_pae_covid_agri = 1 if (yield_2_1_t==1 | yield_2_13==1 | yield_2_15==1| yield_2_34==1| yield_2_35==1| yield_2_42_t==1| yield_2_44_t==1| yield_2_45_t==1| yield_2_46_t==1| yield_2_47_t==1| yield_2_49_t==1| yield_2_50_t==1) & muestra_2 ==1

* f.	Harvested any COVID-19 PAE animal product  
	  g harvested_pae_covid_anim = 0 if muestra_2 ==1 
	  replace harvested_pae_covid_anim = 1 if yield_4_56==1 & muestra_2 ==1

* g.	Harvested any COVID-19 non-PAE animal product  
	  g harvested_no_pae_covid_anim = 0 if muestra_2 ==1 
	  replace harvested_no_pae_covid_anim = 1 if (yield_4_51==1 | yield_4_52==1 | yield_4_53==1 | yield_4_54==1 | yield_4_55==1 | yield_4_57==1 | yield_4_58==1 | yield_4_59==1 | yield_4_60==1 | yield_4_61==1 | yield_4_62==1 | yield_4_63==1 | yield_4_64==1) & muestra_2 ==1


*Traditional PAE products 


* a.	Harvested any traditional PAE agricultural or animal product 

	  g harvested_pae_traditional1 = 0 if muestra_2 ==1 
replace harvested_pae_traditional1 = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_13==1 | yield_2_ejote==1 | yield_2_15==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_34==1 | yield_2_35==1 | yield_2_37==1 | yield_2_40_t ==1 | yield_2_46_t==1  | yield_4_53==1 |  yield_4_56==1| yield_4_62==1 | yield_4_63==1) & muestra_2 ==1
	
* b.	Harvested any traditional non-PAE agricultural or animal product 

	  g harvested_no_pae_traditional = 0 if muestra_2 ==1 
replace harvested_no_pae_traditional = 1 if (yield_2_1_t==1 | yield_2_yuca==1 | yield_2_42_t==1| yield_2_44_t==1| yield_2_45_t==1 | yield_2_47_t==1| yield_2_49_t==1| yield_2_50_t==1| yield_4_51==1| yield_4_52==1| yield_4_54==1| yield_4_55==1| yield_4_57==1| yield_4_58==1| yield_4_59==1| yield_4_60==1| yield_4_61==1 | yield_4_64==1 ) & muestra_2 ==1

* c.	Harvested any traditional PAE agricultural product  

	 g harvested_pae_traditional_agri = 0  if muestra_2 ==1
 replace harvested_pae_traditional_agri = 1 if (yield_2_aguacate ==1 | yield_2_rice ==1 | yield_2_9==1 | yield_2_chile==1 | yield_2_13==1 | yield_2_ejote==1 | yield_2_15==1 | yield_2_16_t==1 | yield_2_guisquil == 1 | yield_2_20 ==1 | yield_2_21_t==1 | yield_2_31==1 | yield_2_34==1 | yield_2_35==1 | yield_2_37==1 | yield_2_40_t ==1 | yield_2_46_t==1) & muestra_2 ==1

* d.	Harvested any traditional non-PAE agricultural product  
	g harvested_no_pae_tradi_agri = 0 if muestra_2 ==1 
replace harvested_no_pae_tradi_agri = 1 if (yield_2_1_t==1 | yield_2_yuca==1 | yield_2_42_t==1| yield_2_44_t==1| yield_2_45_t==1 | yield_2_47_t==1| yield_2_49_t==1| yield_2_50_t==1) & muestra_2 ==1

* e.	Harvested any traditional PAE animal product  
			g harvested_pae_traditional_anim = 0 if muestra_2 ==1 
	replace harvested_pae_traditional_anim = 1 if (yield_4_53==1 | yield_4_56==1| yield_4_62==1 | yield_4_63==1) & muestra_2 ==1

* f.	Harvested any traditional non-PAE animal product  
		g harvested_no_pae_tradi_anim = 0 if muestra_2 ==1 
	replace harvested_no_pae_tradi_anim = 1 if (yield_4_51==1 | yield_4_52==1 | yield_4_54==1 | yield_4_55==1 | yield_4_57==1 | yield_4_58==1 | yield_4_59==1 | yield_4_60==1 | yield_4_61==1 | yield_4_64==1) 	& muestra_2 ==1
	

*tab1 yield_2_aguacate yield_2_rice yield_2_9 yield_2_chile yield_2_13 yield_2_ejote yield_2_15 yield_2_16_t yield_2_guisquil yield_2_20  yield_2_21_t yield_2_31 yield_2_34 yield_2_35 yield_2_37 yield_2_40_t  yield_2_46_t yield_4_53  yield_4_56 yield_4_62 yield_4_63

	  
***************************** BASELINE OUTCOMES ********************************
  drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(ag_prod pae_covid_agri_bl no_pae_covid_agri_bl pae_traditional_agri_bl no_pae_traditional_agri_bl)
  
*==================================================================
*		  PAE
*==================================================================

*1. Know about PAE market 

	label var infor_2 "Knows about PAE market"
	
* 2. If knows:
*a. Knows through MAGA or Videos&SMS 

	        g maga_sms = 0 if infor_2 ==1
	  replace maga_sms = 1 if infor_3_1==1 | infor_3_5 ==1
	label var maga_sms "Knows through MAGA or Videos&SMS"

*a.i Knows through MAGA 

	label var infor_3_1 "MAGA"

*a. ii Knows through Videos&SMS 

	label var infor_3_5 "Videos&SMS"
	
*b.  School / Teacher / OPF 

    label var infor_3_4 "School/Teacher/OPF"

*c. Knows through other sources: MINEDUC campaign, another farmer, friends/relatives/neighbors/others. 

			g other_sources = 0 if infor_2 ==1
	  replace other_sources = 1 if (infor_3_2==1 | infor_3_3==1 | infor_3_6==1 | infor_3_999==1) & infor_2 ==1
	label var other_sources "Other sources"
 
*3. Household registered to sell crops to the SFP

	gen register = 0 if infor_4 !=.
	replace register = 0 if (infor_2==1 | infor_2==0) & infor_4 ==.
	replace register = 1 if infor_4==1 
   label var register "HH registered to sell crops to the SFP"
   
   	gen no_register = 0 if register ==1
	replace no_register = 1 if register==0
   label var register "HH registered to sell crops to the SFP"

   


*4. If not registered 

*4.a Knows SFP can buy products (5a) 

	g know_sfp_buy = infor_5a if register ==0
	label var know_sfp_buy "Knows SFP can buy products"

*4.b Knows that can register as SFP (5b) 
	
	g know_sfp_register = infor_5b if register ==0
	label var know_sfp_register "Knows that can register as SFP"

*4.c Knows the steps to register (5c, but input 5c = 0 if 5b!=yes, to get rid of the 0s) 

	  g steps = infor_5c
replace steps = 0 if infor_5b==0
label var steps "Knows the steps to register"

*4.d Le parece sencillo el proceso para registrarse como proveedor

	  g easy_register = infor_5d
replace easy_register = 0 if steps==0 & easy_register ==.
replace easy_register = 0 if steps==1 & easy_register ==.
label var easy_register "Easy to register as provider"

*5. Interested in registering (6, but replace 6 = 0 if 5a!=yes and 5b!=yes) 

	  g registro = infor_6
replace registro = 0 if infor_5b!=1 &  infor_5a!=1 & registro ==0
label var registro "Interested in registering"

*6. Sold crops a registered SFP provider (9)? (me parece que esta debería ser incondicional a las otras preguntas?) 

label var infor_9 "Sold crops to a registered SFP provider"
* 7. Plans to sell to a registered SFP provider (9c)


*8. Plans to speak to a registered SFP provider (12, but replace answer as in 6) 

 g plan = infor_12
  replace plan = 0 if infor_5b==1 | infor_5a==1 
label var plan "Plans to speak to a registered SFP provider"
 
*9. Contact information from a provider 13

label var infor_13 "HH have a provider's contact information"

*9. Knows the type of crops buy for the PAE 14

label var infor_14 "Knows about the crops that the schools buy from the SFP"

*9. 15 have spoken with a specialist from MAGA

label var infor_15 "Has spoken with a specialist from MAGA"

* 10 Knows SFP product quality standards (=1 if 17a==2&17b==1) 

 g quality = infor_17a==0 & infor_17b==1
replace quality =. if infor_17b==.

* 10a Knows SFP product quality standards (=1 if 17a==2&17b==1) 

 g quality_1 = infor_17a==0 
replace quality_1 =. if infor_17a==.

* 10 Knows SFP product quality standards (=1 if 17a==2&17b==1) 

	  g quality_2 = infor_17b==1
replace quality_2 =. if infor_17b==.

***************************** BASELINE OUTCOMES ********************************
  drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(know_pae_bl maga_pae_bl school_opf_bl other_sources_bl regist_HH_bl registro_bl sold_pae_prov_bl talked_pae_prov_bl)
  
   cap g no_regis_bl = 0 if regist_HH_bl == 1
 replace no_regis_bl = 1 if regist_HH_bl ==0
*===============================================================================
*  AGRICULTURAL PRACTICES
*===============================================================================		

*1.	Stores harvest in dry and clean places

  replace mark_2_1 = 1 if inlist(mark_2_text,"Limpio templado","Fresco y limpio","En el refrigerador","En un suelo desinfectado, no tan rese..","En un lugar ventilado")
label var mark_2_1 "Stores harvest in dry and clean places"

*2.	Correct material used to pack eggs 

g correct_material_eggs = mark_2_1
replace correct_material_eggs=1 if mark_2_2 ==1 | mark_2_3==1
replace correct_material_eggs=1 if inlist(mark_6_text,"Casillas","Casilleras","Casillero nailon y cartón","Casilleros","Casilleros amarados con una pita","Casilleros caja de carton","Embalados con nailo cartón abajo y ca.. ","En cartón y caja")
label var correct_material_eggs "Correct material used to pack eggs"

***************************** BASELINE OUTCOMES ********************************
*none 

*===============================================================================
*  PERCEPTION
*===============================================================================	

*1.	Trust in Maga (= 1 if == Very Much)
label var inst_2a_2 "Trust in Maga"
*2.	Trust in Mineduc (= 1 if == Very Much)
label var inst_2b_2 "Trust in Mineduc"
*3.	Trust in SAT (= 1 if == Very Much)
label var inst_2c_2 "Trust in SAT"

***************************** BASELINE OUTCOMES ********************************
  drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(trust_MAGA_bl trust_MINEDUC_bl trust_SAT_bl)
 
*===============================================================================
*  MARKETING
*===============================================================================	

*1.	Has NIT
label var taxin "Has Tax Identification Number"
*2.	Can issue invoices
label var invoice "Can issue invoices"

***************************** BASELINE OUTCOMES ********************************
drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(nit_bl inv_bl)
  
*===============================================================================
*  SALES - TYPES OF PRODUCTS
*===============================================================================	

*a.	any agricultural (animal) product
	g sale = 0 if muestra_2==1
	replace sale =1 if comm_3_1000==0
	



*b.	any COVID-19 PAE agricultural or animal product 
	forvalues prod =1/64 {
		cap destring comm_4a_`prod'_*, replace
		cap gen comm_prod_`prod' = comm_4a_`prod'_* ==1 if comm_3_1000==0
	}
	
	forvalues prod =88/99 {
		cap destring comm_4a_9`prod'_*, replace
		cap gen comm_prod_9`prod' = comm_4a_9`prod'_* ==1 if comm_3_1000==0
	}

forvalues vent = 1/8{
	
	forvalues prod =1/64 {
		
		*cap drop comm_prod_`prod'
		cap gen comm_prod_`prod' =0 if comm_3_1000==0
		cap replace comm_prod_`prod' =1 if comm_4a_`prod'_`vent' ==1 & comm_3_1000==0
		} 
		
	forvalues prod =88/99 {
		
		*cap drop comm_prod_`prod'
		cap gen comm_prod_9`prod' =0 if comm_3_1000==0
		cap replace comm_prod_9`prod' =1 if comm_4a_9`prod'_`vent' ==1 & comm_3_1000==0
		}
	}	
	
	
	*a1 any agricultural product 

gen sold_agri = 0 if muestra_2==1
replace sold_agri=1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_7==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_14==1 | comm_prod_16 == 1 | comm_prod_17 ==1 | comm_prod_20==1 | comm_prod_21==1 | comm_prod_31==1 | comm_prod_37==1 | comm_prod_39==1 | comm_prod_40 ==1 | comm_prod_43==1 | comm_prod_48==1 | comm_prod_1==1 | comm_prod_3==1 | comm_prod_4==1| comm_prod_6==1| comm_prod_8==1| comm_prod_13==1| comm_prod_15==1| comm_prod_18==1| comm_prod_19==1| comm_prod_22==1| comm_prod_23==1| comm_prod_24==1| comm_prod_25==1 | comm_prod_26==1 | comm_prod_27==1 | comm_prod_28==1 | comm_prod_29==1 | comm_prod_30==1 | comm_prod_32==1 | comm_prod_33==1 | comm_prod_34==1 | comm_prod_35==1 | comm_prod_36==1 | comm_prod_38==1 | comm_prod_41==1 | comm_prod_42==1 | comm_prod_44==1 | comm_prod_45==1 | comm_prod_46==1 | comm_prod_47==1 | comm_prod_49==1 | comm_prod_50==1 | comm_prod_988==1 | comm_prod_989==1 | comm_prod_990==1 | comm_prod_997==1 | comm_prod_998==1 | comm_prod_999==1 ) & muestra_2 ==1

*a2 any animal product 
gen sold_ani = 0 if muestra_2==1
replace sold_ani=1  if (comm_prod_56==1 | comm_prod_51==1 | comm_prod_52==1 | comm_prod_53==1 | comm_prod_54==1 | comm_prod_55==1 | comm_prod_57==1 | comm_prod_58==1 | comm_prod_59==1 | comm_prod_60==1 | comm_prod_61==1 | comm_prod_62==1 | comm_prod_63==1 | comm_prod_64==1 | comm_prod_991==1 | comm_prod_992==1 | comm_prod_993==1 | comm_prod_994==1 | comm_prod_995==1 | comm_prod_996==1 ) & muestra_2 ==1
	  
	  g sale_pae_covid1 = 0 if muestra_2 ==1 
replace sale_pae_covid1 = 1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_7==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_14==1 | comm_prod_16 == 1 | comm_prod_17 ==1 | comm_prod_20==1 | comm_prod_21==1 | comm_prod_31==1 | comm_prod_37==1 | comm_prod_39==1 | comm_prod_40 ==1 | comm_prod_43==1 | comm_prod_48==1 | comm_prod_56==1) & muestra_2 ==1
	label var sale_pae_covid1 "Sold any COVID-19 PAE agricultural or animal product" 
	
*c.	any COVID-19 non-PAE agricultural or animal product 


	  g sale_no_pae_covid = 0 if muestra_2 ==1 
replace sale_no_pae_covid = 1 if (comm_prod_1==1 | comm_prod_3==1 | comm_prod_4==1| comm_prod_6==1| comm_prod_8==1| comm_prod_13==1| comm_prod_15==1| comm_prod_18==1| comm_prod_19==1| comm_prod_22==1| comm_prod_23==1| comm_prod_24==1| comm_prod_25==1 | comm_prod_26==1 | comm_prod_27==1 | comm_prod_28==1 | comm_prod_29==1 | comm_prod_30==1 | comm_prod_32==1 | comm_prod_33==1 | comm_prod_34==1 | comm_prod_35==1 | comm_prod_36==1 | comm_prod_38==1 | comm_prod_41==1 | comm_prod_42==1 | comm_prod_44==1 | comm_prod_45==1 | comm_prod_46==1 | comm_prod_47==1 | comm_prod_49==1 | comm_prod_50==1 | comm_prod_51==1 | comm_prod_52==1 | comm_prod_53==1 | comm_prod_54==1 | comm_prod_55==1 | comm_prod_57==1 | comm_prod_58==1 | comm_prod_59==1 | comm_prod_60==1 | comm_prod_61==1 | comm_prod_62==1 | comm_prod_63==1 | comm_prod_64==1) & muestra_2 ==1
	label var sale_no_pae_covid "Sold any COVID-19 non-PAE agricultural or animal product" 

*d.	any COVID-19 PAE agricultural product  
	  g sale_pae_covid_agri = 0  if muestra_2 ==1 
	  replace sale_pae_covid_agri = 1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_7==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_14==1 | comm_prod_16 == 1 | comm_prod_17 ==1 | comm_prod_20==1 | comm_prod_21==1 | comm_prod_31==1 | comm_prod_37==1 | comm_prod_39==1 | comm_prod_40 ==1 | comm_prod_43==1 | comm_prod_48==1 ) & muestra_2 ==1
	   label var sale_pae_covid_agri "Sold any COVID-19 PAE agricultural product"

* e.	any COVID-19 non-PAE agricultural product   
		  g sale_no_pae_covid_agri = 0 if muestra_2 ==1 
	replace sale_no_pae_covid_agri = 1 if (comm_prod_1==1 | comm_prod_3==1 | comm_prod_4==1| comm_prod_6==1| comm_prod_8==1| comm_prod_13==1| comm_prod_15==1| comm_prod_18==1| comm_prod_19==1| comm_prod_22==1| comm_prod_23==1| comm_prod_24==1| comm_prod_25==1 | comm_prod_26==1 | comm_prod_27==1 | comm_prod_28==1 | comm_prod_29==1 | comm_prod_30==1 | comm_prod_32==1 | comm_prod_33==1 | comm_prod_34==1 | comm_prod_35==1 | comm_prod_36==1 | comm_prod_38==1 | comm_prod_41==1 | comm_prod_42==1 | comm_prod_44==1 | comm_prod_45==1 | comm_prod_46==1 | comm_prod_47==1 | comm_prod_49==1 | comm_prod_50==1) & muestra_2 ==1
	  label var sale_no_pae_covid_agri "Sold any COVID-19 non-PAE agricultural product"

* f.	sale any COVID-19 PAE animal product  
			g sale_pae_covid_anim = 0 if muestra_2 ==1 
	  replace sale_pae_covid_anim = 1 if comm_prod_56==1 & muestra_2 ==1
	  label var sale_pae_covid_anim "Sold any COVID-19 PAE animal product"

* g.	sale any COVID-19 non-PAE animal product  
	  g sale_no_pae_covid_anim = 0 if muestra_2 ==1 
	  replace sale_no_pae_covid_anim = 1 if (comm_prod_51==1 | comm_prod_52==1 | comm_prod_53==1 | comm_prod_54==1 | comm_prod_55==1 | comm_prod_57==1 | comm_prod_58==1 | comm_prod_59==1 | comm_prod_60==1 | comm_prod_61==1 | comm_prod_62==1 | comm_prod_63==1 | comm_prod_64==1) & muestra_2 ==1
	 label var sale_no_pae_covid_anim "Sold any COVID-19 non-PAE animal product"


*** traditional PAE products
  
   
 *b.	any traditional PAE agricultural or animal product 
  
 g sale_pae_traditional1 = 0 if muestra_2 ==1 
replace sale_pae_traditional1 = 1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_13==1 | comm_prod_14==1 | comm_prod_15 == 1 | comm_prod_16 == 1 | comm_prod_17 ==1 | comm_prod_20==1 | comm_prod_21==1 | comm_prod_31==1 | comm_prod_34==1 | comm_prod_35==1  | comm_prod_37==1 | comm_prod_40 ==1 | comm_prod_46==1 |  comm_prod_56==1 | comm_prod_63==1 | comm_prod_62==1 | comm_prod_53==1) & muestra_2 ==1
 label var sale_pae_traditional1 "Sold any traditional PAE agricultural or animal product"

 *c.	any traditional non-PAE agricultural or animal product

 g sale_no_pae_traditional = 0 if muestra_2 ==1 
 replace sale_no_pae_traditional =1 if (comm_prod_1==1 | comm_prod_3==1 | comm_prod_4==1| comm_prod_6==1|  comm_prod_7==1| comm_prod_8==1| comm_prod_18==1| comm_prod_19==1| comm_prod_22==1| comm_prod_23==1| comm_prod_24==1| comm_prod_25==1 | comm_prod_26==1 | comm_prod_27==1 | comm_prod_28==1 | comm_prod_29==1 | comm_prod_30==1 | comm_prod_32==1 | comm_prod_33==1 | comm_prod_36==1 | comm_prod_38==1 | comm_prod_39==1 |comm_prod_41==1 | comm_prod_42==1 | comm_prod_43==1 |comm_prod_44==1 | comm_prod_45==1 | comm_prod_47==1 | comm_prod_48==1 |  comm_prod_49==1 | comm_prod_50==1 | comm_prod_51==1 | comm_prod_52==1 | comm_prod_54==1 | comm_prod_55==1 | comm_prod_57==1 | comm_prod_58==1 | comm_prod_59==1 | comm_prod_60==1 | comm_prod_61==1 |  comm_prod_64==1) & muestra_2 ==1
 label var sale_no_pae_traditional "Sold any traditional non-PAE agricultural or animal product"
 
 *d.	any traditional PAE agricultural product
 
 g sale_pae_traditional_agri = 0 if muestra_2 ==1 
 replace sale_pae_traditional_agri = 1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_13==1 | comm_prod_14==1 | comm_prod_15 == 1 | comm_prod_16 == 1 | comm_prod_17 ==1 | comm_prod_20==1 | comm_prod_21==1 | comm_prod_31==1 | comm_prod_34==1 | comm_prod_35==1  | comm_prod_37==1 | comm_prod_40 ==1 | comm_prod_46==1 ) & muestra_2 ==1
 label var sale_pae_traditional_agri "Sold any traditional PAE agricultural product"
 
 *e.	any traditional non-PAE agricultural product
 
 g sale_no_pae_tradi_agri = 0 if muestra_2 ==1 
 replace sale_no_pae_tradi_agri = 1 if (comm_prod_1==1 | comm_prod_3==1 | comm_prod_4==1| comm_prod_6==1|  comm_prod_7==1| comm_prod_8==1| comm_prod_18==1| comm_prod_19==1| comm_prod_22==1| comm_prod_23==1| comm_prod_24==1| comm_prod_25==1 | comm_prod_26==1 | comm_prod_27==1 | comm_prod_28==1 | comm_prod_29==1 | comm_prod_30==1 | comm_prod_32==1 | comm_prod_33==1 | comm_prod_36==1 | comm_prod_38==1 | comm_prod_39==1 |comm_prod_41==1 | comm_prod_42==1 | comm_prod_43==1 |comm_prod_44==1 | comm_prod_45==1 | comm_prod_47==1 | comm_prod_48==1 |  comm_prod_49==1 | comm_prod_50==1 ) & muestra_2 ==1
 label var sale_no_pae_tradi_agri "Sold any traditional non-PAE agricultural product"
 
 *f.	sale any traditional PAE animal product
 
 g sale_pae_traditional_anim = 0 if muestra_2 ==1 
 replace sale_pae_traditional_anim = 1 if ( comm_prod_56==1 | comm_prod_63==1 | comm_prod_62==1 | comm_prod_53==1) & muestra_2 ==1
 label var sale_pae_traditional_anim "Sold any traditional PAE animal product"
 
 *g.	sale any traditional non-PAE animal product 
	g sale_no_pae_tradi_anim = 0 if muestra_2 ==1 
   replace sale_no_pae_tradi_anim = 1 if (comm_prod_51==1 | comm_prod_52==1 | comm_prod_54==1 | comm_prod_55==1 | comm_prod_57==1 | comm_prod_58==1 | comm_prod_59==1 | comm_prod_60==1 | comm_prod_61==1 |  comm_prod_64==1) & muestra_2 ==1
   label var sale_no_pae_tradi_anim "Sold any traditional non-PAE animal product"
  
******** Traditional PAE productos - desagregados

  *b.	any traditional PAE agricultural or animal product 
  


 *c.	any traditional non-PAE agricultural or animal product


 
 *d.	any traditional PAE agricultural product
 

 * papa 
	   g sale_papa_pae = 0 if muestra_2 ==1  
 replace sale_papa_pae = 1 if comm_prod_31 ==1
 
 * frijol negro
	   g sale_frijol_pae = 0 if muestra_2 ==1  
 replace sale_frijol_pae = 1 if comm_prod_16 ==1
 
 * zanahoria 
	   g sale_zanahoria_pae = 0 if muestra_2 ==1  
 replace sale_zanahoria_pae = 1 if comm_prod_40 ==1
 
 * maiz

	   g sale_maiz_pae = 0 if muestra_2 ==1  
 replace sale_maiz_pae = 1 if comm_prod_21 ==1 
 
 * otros 
	   g sale_other_pae_agri = 0 if muestra_2==1
 replace sale_other_pae_agri = 1 if (comm_prod_2 ==1 | comm_prod_5 ==1 | comm_prod_9==1 | comm_prod_10==1 | comm_prod_11==1 | comm_prod_12==1 | comm_prod_13==1 | comm_prod_14==1 | comm_prod_15 == 1 | comm_prod_17 == 1 | comm_prod_20 ==1 | comm_prod_34==1 | comm_prod_35==1 | comm_prod_37==1 | comm_prod_46==1 ) & muestra_2 ==1
 label var sale_other_pae_agri "other traditional PAE agricultural products"
 
 
 *f.	sale any traditional PAE animal product 
 
       g sale_huevo_pae = 0 if muestra_2 ==1 
 replace sale_huevo_pae = 1 if comm_prod_56==1 
 
       g sale_vaca_pae = 0 if muestra_2 ==1 
 replace sale_vaca_pae = 1 if comm_prod_62==1  
 
	   g sale_pollo_pae = 0 if muestra_2 ==1 
 replace sale_pollo_pae = 1 if comm_prod_63==1 
 
	   g sale_queso_pae = 0 if muestra_2 ==1 
 replace sale_queso_pae = 1 if comm_prod_53==1 
  	

***************************** BASELINE OUTCOMES ********************************
drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(ag_prod_sold_bl pae_covid_sold_bl no_pae_covid_sold_bl pae_traditional_sold_bl no_pae_traditional_sold_bl sold_bl_papa sold_bl_maiz sold_bl_zanahoria sold_bl_frijol sold_bl_otros)
*===============================================================================
*  SALES - TYPES OF SELLERS
*===============================================================================	


*1.	Sold to Coyote /Middlemen/Intermediary (no PAE)

 g no_pae_provider = 0 if muestra_2==1 
   replace no_pae_provider = 1 if comm_3_1 ==1 
 label var no_pae_provider "Sold to Coyote /Middlemen/Intermediary (no PAE)"

*2.	Sold to Assocition/ Cooperative 

 g association = 0 if muestra_2==1 
   replace association = 1 if comm_3_2 ==1 
 label var association "Sold to Association/ Cooperative"
	
*3.	Sold to PAE provider
	     g pae_provider = 0 if muestra_2==1 
   replace pae_provider = 1 if comm_3_3 ==1 
 label var pae_provider "Sold to PAE provider"
 
*4.	Sold to School

		g school = 0 if muestra_2==1 
  replace school = 1 if comm_3_4 ==1 
 label var school "Sold directly to the school"
 
*5.	Sold to School

		g merchant = 0 if muestra_2==1 
  replace merchant = 1 if comm_3_5 ==1 
 label var merchant "Merchant / Warehouse keeper (Specify)"
 
*6.	Sold directly to the person (relatives, neighbors, etc.)

		g person = 0 if muestra_2==1 
  replace person = 1 if comm_3_6 ==1 
 label var person "Sold directly to the person (relatives, neighbors, etc.)"

*7. In the square / market / terminal

		  g square = 0 if muestra_2==1 
	replace square = 1 if comm_3_7 ==1 
  label var square "Sold in the square / market / terminal"
 
*8.	Sold to others

		 g sold_others = 0 if muestra_2==1 
   replace sold_others = 1 if comm_3_999==1
 label var sold_others "Sold to all others"
 


***************************** BASELINE OUTCOMES ********************************	
drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(no_pae_provider_bl association_bl pae_provider_bl sold_school_bl merchant_bl person_bl square_bl sold_others_bl)
	
*===============================================================================
*  SALES - DECISION MAKING
*===============================================================================

*1.	Selling decision for Ag product done by interviewed women?

gen desition_agri_1 = comm_6a_1 if sold_agri ==1
label var desition_agri_1 "Selling decision for Agr product done by interviewed women"

*2.	Selling decision for Animal product done by interviewed women?

gen desition_ani_1 = comm_6b_1 if sold_ani ==1
label var desition_ani_1 "Selling decision for Animal product done by interviewed women"

drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(wom_dec_bl) 
  
*===============================================================================
*  SALES - NEW OTCOMES - PRODUCTS, PRICES AND SELLS 
*===============================================================================

*1.	# of products sold

egen sum_prod = rowtotal(comm_prod_1-comm_prod_999) if muestra_2==1
label var sum_prod "number of sold products"

*2.	# of (types) of buyers

egen sum_buyers = rowtotal(no_pae_provider association pae_provider school merchant person square sold_others) if muestra_2==1
label var sum_buyers "number of total buyers"


drop _merge
  merge 1:1 caseid using "$clean_bl\outcomes_bl", keepusing(sum_prod_bl sum_buyers_bl)


 save "$data_el\digitagro_clean_outcomes.dta", replace

*=====================================================================================================

*3.	Total revenue generated in last sale

* genero precios vent por producto 
 forvalues buy = 1/8 {
		forvalues prod =1/64 {
		cap destring comm_5a_`buy'_`prod', replace
		
		cap gen comm_venta_`buy'_`prod' = 0 if comm_3_1000==0
		cap sum comm_5a_`buy'_`prod'
		if _rc ==0{
		replace comm_venta_`buy'_`prod' =1 if comm_5a_`buy'_`prod' !=. & comm_3_1000==0
		}
		if _rc !=0 {
			replace comm_venta_`buy'_`prod' =.			
		}
		}
		forvalues prod =88/99 {
		
		*cap drop comm_prod_`prod'
		cap gen comm_venta_`buy'_9`prod' = 0 if comm_3_1000==0
		cap sum comm_5a_`buy'_`prod'
		if _rc ==0{
		replace comm_venta_`buy'_9`prod' =1 if comm_5a_`buy'_9`prod' !=. & comm_3_1000==0
		}
		if _rc !=0 {
		replace comm_venta_`buy'_9`prod' =.
		}
		}
		}
 

/*
drop comm_venta_* comm_venta_prod_*

	forvalues prod =1/64 {		
		*cap drop comm_prod_`prod'
		egen comm_venta_prod_`prod' = rowmean(comm_venta_1_`prod' - comm_venta_8_`prod') if comm_3_1000==0		
		} 
		
	forvalues prod =88/99 {
		
		*cap drop comm_prod_`prod'
		cap gen comm_prod_9`prod' = mean() if comm_3_1000==0
		cap replace comm_prod_9`prod' =1 if comm_4a_9`prod'_`vent' ==1 & comm_3_1000==0
		}
	}	
*/

/*
* rashape to have the datasaet at sells level 

reshape long comm_venta_1_ comm_venta_2_ comm_venta_3_ comm_venta_4_ comm_venta_5_ comm_venta_6_ comm_venta_7_ comm_venta_8_ , i(caseid) j(product)

forvalues num =1/8{
gen comm_venta_`num' = comm_venta_`num'_
drop comm_venta_`num'_
}

reshape long comm_venta_ , i(caseid product) j(buyer)

drop if comm_venta_==.
sort caseid




* genero precios producto - cpmpardo 

 forvalues buy = 1/8 {
		forvalues prod =1/64 {
			cap gen precio_venta = .
			cap replace precio_venta = comm_5a_`buy'_`prod' if buyer == `buy' & product==`prod'
			
			cap gen unidad_venta = .
			cap replace unidad_venta = comm_5b_`buy'_`prod' if buyer == `buy' & product==`prod'
		}
 }
 
 g log_precio_venta = ln(precio_venta)
 
 br caseid precio_venta buyer product unidad_venta if precio_venta !=.

  save "$data_el\digitagro_clean_outcomes_ventas_rsh.dta", replace
***************************** BASELINE OUTCOMES ********************************
*/
