
 * Paper style tables estimation 
global path "C:\Users\WB585318\WBG\Javier Romero - GTM - IE DIGITAGRO\Analisis cuantitativo"
global el	"${path}\07 Endline"
global bl   "${path}\06 Baseline"

global data_el 	"${el}\07 01 Data"
global data_bl 	"${bl}\06 01 Data"
global clean_el	"${el}\07 4 Clean Data"
global clean_bl	"${bl}\06 4 Clean Data"
global output_f "${el}\07 3 Docs\Digitagro" 
global output	"${output_f}\Individual tables"
*global dos 		"C:\Users\lopez\OneDrive - Universidad de los Andes\WB\Git_repositories\2. Digitago_endline"
    
cd "${output}"
do "$el\07 2 Do-files\digitagro_el_bl_outcomes.do"

*===============================================================================
*  HARVEST MODULE
*===============================================================================
	
global controlsh n_chidren n_members adult_men adult_women head_self head_parnter head_parent age_18_29 age_30_39 age_40_49 age_50_mas e_ninguno e_primaria e_secundaria pareja p_fertilizantes p_pesticidas p_semillas_mejoradas p_sistema_riego p_maquinaria terreno_cuerdas_mayor0_1 terreno_cuerdas_1_2 terreno_cuerdas_2_3 terreno_cuerdas_6_10 terreno_cuerdas_10mas land_owner zc_fria zc_caliente zc_ambas ciclo_corto ciclo_perenne ciclo_nd
	
	
*** Covid PAE products  
  local module harvest1

   reg harvested treatment_el_1 i.stratum, vce(cluster village)
   outreg2 using Reg_`module'.xlm, replace ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.1; **p<0.05; ***p<0.01)
   
   reg harvested treatment_el_1 $controlsh i.stratum, vce(cluster village) 
   outreg2 using Reg_`module'.xlm, append ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons 
      
* with outcome bl control
	
   local outcomes harvested_pae_covid1 harvested_no_pae_covid harvested_pae_covid_agri harvested_no_pae_covid_agri 
	 foreach outcome of local outcomes {
			
			if "`outcome'"=="harvested_pae_covid1"	 | "`outcome'"=="harvested_pae_covid_agri"		 local outcome_bl pae_covid_agri_bl
			if "`outcome'"=="harvested_no_pae_covid" | "`outcome'"=="harvested_no_pae_covid_agri"  	 local outcome_bl no_pae_covid_agri_bl
			
		reg `outcome' treatment_el_1  i.stratum, vce(cluster village)
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum, vce(cluster village) 
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	
	}
	
* with no outcome bl control	
   local outcomes harvested_pae_covid_anim harvested_no_pae_covid_anim 
	 foreach outcome of local outcomes {

		reg `outcome' treatment_el_1 i.stratum, vce(cluster village)
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh i.stratum, vce(cluster village) 
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	
	}	

* Traditional PAE products  
  
  local module harvest2
  
    reg harvested treatment_el_1 i.stratum, vce(cluster village)
   outreg2 using Reg_`module'.xlm, replace ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg harvested treatment_el_1 $controlsh i.stratum, vce(cluster village) 
   outreg2 using Reg_`module'.xlm, append ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons 
   
      local outcomes harvested_pae_traditional1 harvested_no_pae_traditional harvested_pae_traditional_agri harvested_no_pae_tradi_agri
	 foreach outcome of local outcomes {
			
			if "`outcome'"=="harvested_pae_traditional1" 	|	"`outcome'"=="harvested_pae_traditional_agri"	local outcome_bl pae_traditional_agri_bl
			if "`outcome'"=="harvested_no_pae_traditional"	|	"`outcome'"=="harvested_no_pae_tradi_agri"		local outcome_bl no_pae_traditional_agri_bl			
			
		reg `outcome' treatment_el_1  i.stratum, vce(cluster village)
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum, vce(cluster village) 
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	
	}	
      
   local outcomes harvested_pae_traditional_anim harvested_no_pae_tradi_anim 
	 foreach outcome of local outcomes {

		reg `outcome' treatment_el_1 i.stratum, vce(cluster village)
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh i.stratum, vce(cluster village) 
		outreg2 using Reg_`module'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	
	}
	
	
*===============================================================================
*  PAE MODULE
*===============================================================================	

*1.	Know about PAE market
*2.	If knows 
* a.  Knows through MAGA or Videos&SMS
 *a.i.	Knows through MAGA
 

 *** efectos heterogeneos 
 local efectos regist_HH_bl no_regis_bl 
 
 
 foreach efecto of local efectos {
     
 local iff "if complete_controls==1 & `efecto'==1"
  
 
  local module PAE
  
  		reg  infor_2 treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(infor_2) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg infor_2 treatment_el_1 $controlsh know_pae_bl  i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(infor_2) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
  
  
  
  local outcomes maga_sms infor_3_1 
    
	foreach outcome of local outcomes {
		
		if "`outcome'"=="maga_sms" | "`outcome'"=="infor_3_1" 	local outcome_bl maga_pae_bl
		
		reg  `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   
   }
   
 *a.ii. Knows through Videos&SMS
   
    reg  infor_3_5 treatment_el_1 i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(infor_3_5) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg infor_3_5 treatment_el_1 $controlsh i.stratum `iff', vce(cluster village)  
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(infor_3_5) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab  
   
 * b.	Knows through other sources: MINEDUC campaign, another farmer, school/teacher/OPF, friends/relatives/neighbors/others. 
  *3. Is the household registered to sell crops to the SFP?  
  
  local outcomes infor_3_4 other_sources register 
  
	foreach outcome of local outcomes {
		
		if "`outcome'"=="other_sources" 	local outcome_bl other_sources_bl
		if "`outcome'"=="infor_3_4" 		local outcome_bl school_opf_bl
		if "`outcome'"=="register"			local outcome_bl regist_HH_bl	
		
		cap reg  `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	  cap  outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   cap reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   
   }
   
* 4.	If not registered
	*a.	Knows SFP can buy products (5a)
	*b.	Knows that can register as SFP (5b)
	*c.	Knows the steps to register (5c, but input 5c = 0 if 5b!=yes, to get rid of the 0s)

local outcomes know_sfp_buy know_sfp_register steps easy_register
	foreach outcome of local outcomes {

   cap reg `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   cap reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village)  
   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab   
 }  
   
 *  5.	Interested in registering (6, but replace 6 = 0 if 5a!=yes and 5b!=yes)
 *  6.	Sold crops a registered SFP provider (9)? (me parece que esta debería ser incondicional a las otras preguntas?)
 *  7.	Plans to sell to a registered SFP provider (9c) - NO ESTA EN LA BASE 
 *  8.	Plans to speak to a registered SFP provider (12, but replace answer as in 6)

 
    local outcomes registro infor_9 plan
  
	foreach outcome of local outcomes {
		
		if `outcome'== registro 	local outcome_bl registro_bl
		if `outcome'== infor_9	local outcome_bl sold_pae_prov_bl	
		if `outcome'== plan 		local outcome_bl talked_pae_prov_bl
		
		cap reg  `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   cap reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   
   } 
   
 *  9.	Questions 13, 14, 15.
 *10.	Knows SFP product quality standards (=1 if 17a==2&17b==1)
 
   local outcomes infor_13 infor_14 infor_15 quality quality_1 quality_2
	 foreach outcome of local outcomes {
		
	   cap reg `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   cap reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village)  
	   cap outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab  
	}		

	      
*===============================================================================
*  AGRICULTURAL PRACTICES
*===============================================================================		
	  local module agri_pract
	  
* 1.	Stores harvest in dry and clean places	
   reg mark_2_1 treatment_el_1 i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(mark_2_1) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg mark_2_1 treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(mark_2_1) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab
   
* 2.	Correct material used to pack eggs 
	reg correct_material_eggs treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(correct_material_eggs) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab
   
   reg correct_material_eggs treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(correct_material_eggs) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab
	 
	
*===============================================================================
*  PERCEPTION
*===============================================================================	
*1.	Trust in Maga 
*2.	Trust in Mineduc 
*3.	Trust in SAT 
  local module perception
  
  		reg  inst_2a_2 treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(inst_2a_2) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg inst_2a_2 treatment_el_1 $controlsh trust_MAGA_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(inst_2a_2) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
  
  
  local outcomes inst_2b_2 inst_2c_2
  
	foreach outcome of local outcomes {
		
		if "`outcome'"=="inst_2b_2"		local outcome_bl trust_MINEDUC_bl
		if "`outcome'"=="inst_2c_2"		local outcome_bl trust_SAT_bl
		
		reg  `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   
   }  


*===============================================================================
*  MARKETING
*===============================================================================	
  
  local module marketing
	
		reg  taxin treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(taxin) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg taxin treatment_el_1 $controlsh nit_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(taxin) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
		
		
		reg  invoice treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(invoice) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg invoice treatment_el_1 $controlsh inv_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(invoice) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   


 *===============================================================================
*  SALES - TYPES OF PRODUCTS
*===============================================================================	
	
	local module sales1

*** Covid PAE products  
  
   reg sale treatment_el_1 i.stratum `iff', vce(cluster village)
   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg sale treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons 
      
* with outcome bl control
	
   local outcomes sale_pae_covid1 sale_no_pae_covid sale_pae_covid_agri sale_no_pae_covid_agri
	 foreach outcome of local outcomes {
			
			if "`outcome'"=="sale_pae_covid1"	 | "`outcome'"=="sale_pae_covid_agri"		 local outcome_bl pae_covid_sold_bl
			if "`outcome'"=="sale_no_pae_covid"  | "`outcome'"=="sale_no_pae_covid_agri"  	 local outcome_bl no_pae_covid_sold_bl
			
		reg `outcome' treatment_el_1  i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	
	}
	
	
	
* with no outcome bl control	
   local outcomes sale_pae_covid_anim sale_no_pae_covid_anim
	 foreach outcome of local outcomes {

		reg `outcome' treatment_el_1 i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	
	}	

* Traditional PAE products  
  
	local module sales2
	
    reg sale treatment_el_1 i.stratum `iff', vce(cluster village)
   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg sale treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons 
   
      local outcomes sale_pae_traditional1 sale_no_pae_traditional sale_pae_traditional_agri sale_no_pae_tradi_agri
	 foreach outcome of local outcomes {
			
			if "`outcome'"=="sale_pae_traditional1" 	|	"`outcome'"=="sale_pae_traditional_agri"	local outcome_bl pae_traditional_sold_bl
			if "`outcome'"=="sale_no_pae_traditional"	|	"`outcome'"=="sale_no_pae_tradi_agri"		local outcome_bl no_pae_traditional_sold_bl			
			
		reg `outcome' treatment_el_1  i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	
	}	
      
   local outcomes sale_pae_traditional_anim sale_no_pae_tradi_anim 
	 foreach outcome of local outcomes {

		reg `outcome' treatment_el_1 i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	
	}

* traditional b = desagregada 

	local module sales2b
	
    reg sale_pae_traditional_agri treatment_el_1 i.stratum `iff', vce(cluster village)
   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   
   reg sale_pae_traditional_agri treatment_el_1 $controlsh pae_traditional_sold_bl i.stratum `iff', vce(cluster village) 
   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(Any agricultural-animal product) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons 
   
      local outcomes sale_maiz_pae sale_zanahoria_pae sale_frijol_pae sale_papa_pae sale_other_pae_agri
	 foreach outcome of local outcomes {
			
			if "`outcome'"=="sale_papa_pae"		  local outcome_bl sold_bl_papa
 			if "`outcome'"=="sale_maiz_pae"		  local outcome_bl sold_bl_maiz
			if "`outcome'"=="sale_zanahoria_pae"  local outcome_bl sold_bl_zanahoria
			if "`outcome'"=="sale_frijol_pae"	  local outcome_bl sold_bl_frijol
			if "`outcome'"=="sale_other_pae_agri" local outcome_bl sold_bl_otros
			
		reg `outcome' treatment_el_1  i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	
	}	
      
   local outcomes sale_pae_traditional_anim  sale_huevo_pae sale_vaca_pae sale_pollo_pae sale_queso_pae
	 foreach outcome of local outcomes {

		reg `outcome' treatment_el_1 i.stratum `iff', vce(cluster village)
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
		
		reg `outcome'  treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
		outreg2 using Reg_`module'`efecto'.xlm, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	
	} 

*===============================================================================
*  SALES - TYPES OF SELLERS
*===============================================================================	

	local module sales3
	
	reg  no_pae_provider treatment_el_1 i.stratum `iff', vce(cluster village) 
	outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(pae_provider) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	
  	reg no_pae_provider treatment_el_1 $controlsh no_pae_provider_bl  i.stratum `iff', vce(cluster village)  
	outreg2 using Reg_`module'`efecto'.xlm, append ctitle(pae_provider) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
  
  
  local outcomes association pae_provider school merchant person square sold_others	
  
	foreach outcome of local outcomes {
		
		if "`outcome'"=="association"	local outcome_bl association_bl
		if "`outcome'"=="pae_provider"	local outcome_bl pae_provider_bl
		if "`outcome'"=="school"		local outcome_bl sold_school_bl
		if "`outcome'"=="merchant"		local outcome_bl merchant_bl
		if "`outcome'"=="person"		local outcome_bl person_bl
		if "`outcome'"=="square"		local outcome_bl square_bl
		if "`outcome'"=="sold_others"	local outcome_bl sold_school_bl
		
		reg  `outcome' treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
	   
   }  
  	
*===============================================================================
*  SALES - DECISION MAKING
*===============================================================================	

	  local module sales4  
	
		reg  desition_agri_1 treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg desition_agri_1 treatment_el_1 $controlsh wom_dec_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, YES) keep(treatment_el_1) nocons lab 
		
		
		reg  desition_ani_1 treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg desition_ani_1 treatment_el_1 $controlsh inv_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab 
   


    	
*===============================================================================
*   SALES - NEW OTCOMES - PRODUCTS, PRICES AND SELLS 
*===============================================================================	

	  local module sales5  
	
		reg  sum_prod treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg sum_prod treatment_el_1 $controlsh sum_prod_bl i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, SI) keep(treatment_el_1) nocons lab 
		
		
		reg sum_buyers treatment_el_1 i.stratum `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg sum_buyers treatment_el_1 $controlsh sum_buyers_bl  i.stratum `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, SI) keep(treatment_el_1) nocons lab 
	    
 }
/*
 use "$data_el\digitagro_clean_outcomes_ventas_rsh.dta"
 
 local module ventas
 local efectos  register no_register costa altiplano centro menos_primaria primaria_mas pareja nopareja terreno_bajo_media terreno_sobre_mayor_media total 
 
 
 foreach efecto of local efectos {
 local iff "if complete_controls==1 & `efecto'==1"
 
	   	reg log_precio_venta treatment_el_1 i.stratum i.unidad_venta i.product `iff', vce(cluster village) 
	   outreg2 using Reg_`module'`efecto'.xlm, replace ctitle(log_precio_venta) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO, Outcome control at BL, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   reg log_precio_venta treatment_el_1 $controlsh i.stratum i.unidad_venta i.product `iff', vce(cluster village)  
	   outreg2 using Reg_`module'`efecto'.xlm, append ctitle(comm_6b_1) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES, Outcome control at BL, NO) keep(treatment_el_1) nocons lab 
  
  }
 */
*==============================================================================	
* CONTROL OUTCOME means (BY MODULE)
*==============================================================================




preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Module Outcome)  Mean1 using `tablas', replace
	

	
	
		* harvest1
				local outcomes harvested harvested_pae_covid1 harvested_no_pae_covid harvested_pae_covid_agri harvested_no_pae_covid_agri harvested_pae_covid_anim harvested_no_pae_covid_anim  
				
				foreach outcome of local outcomes{
					
						sum `outcome' if complete_controls==1 & treatment_el_1==0
						local m = `r(mean)' 
				
						post `ptablas'  ("Harvest1") ("`outcome'") (`m') 	
						post `ptablas'  ("Harvest1") ("`outcome'") (`m') 
				}
			
		* harvest2
				local outcomes harvested harvested_pae_traditional1 harvested_no_pae_traditional harvested_pae_traditional_agri harvested_no_pae_tradi_agri harvested_pae_traditional_anim harvested_no_pae_tradi_anim 
				
				foreach outcome of local outcomes{
					
						sum `outcome' if complete_controls==1 & treatment_el_1==0
				
						post `ptablas'  ("Harvest2") ("`outcome'") (`m') 	
						post `ptablas'  ("Harvest2") ("`outcome'") (`m') 
				}		
		
		
		local efectos regist_HH_bl no_regis_bl  costa costa_centro altiplano centro menos_primaria primaria_mas pareja nopareja terreno_bajo_media terreno_sobre_mayor_media total
		
		foreach efecto of local efectos {
		* PAE
		local ifff "if complete_controls==1 & `efecto'==1 & treatment_el_1==0" 		
				local outcomes infor_2 maga_sms infor_3_1 infor_3_5 infor_3_4 other_sources infor_4 know_sfp_buy know_sfp_register steps easy_register registro infor_9 plan infor_13 infor_14 infor_15 quality quality_1 quality_2
				
				foreach outcome of local outcomes{
					cap sum `outcome' `ifff'
					if `r(N)' >0 {
					local m = `r(mean)'

								
					post `ptablas'  ("PAE_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("PAE_`efecto'") ("`outcome'") (`m') 
					}
					if `r(N)' ==0 {
					post `ptablas'  ("PAE_`efecto'") ("`outcome'") (.) 	
					post `ptablas'  ("PAE_`efecto'") ("`outcome'") (.) 
					}
				}
			
		* agro practices 
				
				local outcomes mark_2_1 correct_material_eggs
				
				foreach outcome of local outcomes{
					cap sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("agri_pract_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("agri_pract_`efecto'") ("`outcome'") (`m') 
				}
				
	* perception 
				
				local outcomes inst_2a_2 inst_2b_2 inst_2c_2
				
				foreach outcome of local outcomes{
					cap sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("perception_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("perception_`efecto'") ("`outcome'") (`m') 
				}				
				
	* marketing 
				
				local outcomes taxin invoice
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("marketing_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("marketing_`efecto'") ("`outcome'") (`m') 
				}				

		* sales1 
				
				local outcomes sale sale_pae_covid1 sale_no_pae_covid sale_pae_covid_agri sale_no_pae_covid_agri sale_pae_covid_anim sale_no_pae_covid_anim	
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales1_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales1_`efecto'") ("`outcome'") (`m') 
				}
    
		* sales2 
				
				local outcomes sale sale_pae_traditional1 sale_no_pae_traditional sale_pae_traditional_agri sale_no_pae_tradi_agri sale_pae_traditional_anim sale_no_pae_tradi_anim 	
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales2_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales2_`efecto'") ("`outcome'") (`m') 
				}  
				
				* sales2b 
				
				local outcomes sale_pae_traditional_agri sale_maiz_pae sale_zanahoria_pae sale_frijol_pae sale_papa_pae sale_other_pae_agri sale_pae_traditional_anim  sale_huevo_pae sale_vaca_pae sale_pollo_pae sale_queso_pae	
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales2b_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales2b_`efecto'") ("`outcome'") (`m') 
				} 
				
		* sales3 
				
				local outcomes no_pae_provider association pae_provider school merchant person square sold_others	
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales3_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales3_`efecto'") ("`outcome'") (`m') 
				}  		
   		
		* sales4 
				
				local outcomes desition_agri_1 desition_ani_1	
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales4_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales4_`efecto'") ("`outcome'") (`m') 
				}
				
				
		* sales5				
				local outcomes sum_prod sum_buyers
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales5_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales5_`efecto'") ("`outcome'") (`m') 
				}	
				

	}
	
				
postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "${output_f}\01. means.xlsx", sh("means", replace)  firstrow(var)

restore


**=====================================================================================================================

preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Module Outcome)  Mean1 using `tablas', replace
	
	use "$data_el\digitagro_clean_outcomes_ventas_rsh.dta"
		
	local efectos register no_register costa altiplano centro menos_primaria primaria_mas pareja nopareja terreno_bajo_media terreno_sobre_mayor_media total
		
		foreach efecto of local efectos {
		
			local ifff "if complete_controls==1 & `efecto'==1 & treatment_el_1==0" 		
			
				local outcomes log_precio_venta
				
				foreach outcome of local outcomes{
					sum `outcome' `ifff'
					local m = `r(mean)'

								
					post `ptablas'  ("sales5b_`efecto'") ("`outcome'") (`m') 	
					post `ptablas'  ("sales5b_`efecto'") ("`outcome'") (`m') 
				}			
			

	}
	
				
postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "${output_f}\01. Result_Tables_Digitagro_EL.xlsx", sh("meansB", replace)  firstrow(var)

restore
