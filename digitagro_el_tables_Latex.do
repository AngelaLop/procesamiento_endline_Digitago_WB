/*==================================================
project:       
Author:        Angela Lopez 
E-email:       ar.lopez@uniandes.edu.co/alopezsanchez@worldbank.org
url:           
Dependencies:  
----------------------------------------------------
Creation Date:    12 Ago 2021 - 12:37:59
Modification Date:  april 04 2022 
Do-file version:    01
References:          
Output:             Balance tables
==================================================*/

global path     "C:\Users\WB585318\WBG\Javier Romero - GTM - IE DIGITAGRO"
global el 		"${path}\Analisis cuantitativo\07 Endline"
global data_bl  "${path}\Analisis cuantitativo\06 Baseline\06 4 Clean Data"
global data_el  "${path}\Analisis cuantitativo\07 Endline\07 01 Data"
global output   "${path}\Drafts\Paper\02 results"
global data 	"${path}\07 01 Data"

use "${data_bl}\datos_limpios_strata_updated", clear
include "C:\Users\WB585318\WBG\Javier Romero - GTM - IE DIGITAGRO\Analisis cuantitativo\06 Baseline\06 2 Do-files\gen_outcome_vars_baseline.do"
include "C:\Users\WB585318\OneDrive - WBG\github_repositories\procesamiento_endline_Digitago_WB\variables_bl.do"

	g recived_training = 0
	replace recived_training = 1 if inlist(mark_train_1,1,2,3,4,5)
	
	g no_recived_training = 0 
	replace no_recived_training = 1 if mark_train_1 ==6
gen complete_controls = 1 
replace complete_controls = 0 if muestra_3 ==1

* ------------------------- VARIABLES -----------------

******** Balance table ************************************
******* Module BASELINE Table 1 *******************************
* clustered - stratum  + fixed effects - unconditional  
iebaltab edad_nacimiento primaria_mas primaria_mas_p n_members terreno_cuerdas ag_prod_sold_bl pae_tradiontal_prod pae_traditional_sold_bl  regist_HH_bl know_pae_bl p_pesticidas centro altiplano costa, pt grpvar(treatment) savetex("$output\balance_table_bl.tex") stdev vce(cluster village) order(1) grplabels("1 Treatment @ 0 Control") total totallabel(Overall) fix(stratum) ///
rowlabels( ///
edad_nacimiento 		"Interviewee age" @ ///
primaria_mas			"Interviewee completed primary education" @ ///
primaria_mas_p			"Household head completed primary education" @ ///
n_members				"Number of household members" @ ///
terreno_cuerdas			"Cultivated land in cuerdas" @ ///
ag_prod_sold_bl			"Household harvested and sold their products in the past 12 months " @ ///
pae_tradiontal_prod		"Household harvested traditional SPF crops in the past 12 months " @ ///
pae_traditional_sold_bl	"Household sold traditional SPF crops in the past 12 months" @ ///
regist_HH_bl			"Any household member is registered as SFP provider" @ ///
know_pae_bl				"Interviewee knows of the existence of the SFP" @ ///
p_pesticidas			"Household used chemical pesticides/herbicides in the last 12 months" @ ///
centro					"Climatic zone: Central" @ ///
altiplano				"Climatic zone: Plateau" @ ///
costa					"Climatic zone: Coastal" @ ///
) replace 



preserve
					
	tempfile tablas
	tempname ptablas
	 
     postfile `ptablas' str50(Prueba Linea Outcome) valorB SE F PValue using `tablas', replace
	 
** additional regressions 
*1. Regression of the treatment assignment on the set of covariates at the baseline 

**# Bookmark #1
reg treatment edad_nacimiento primaria_mas primaria_mas_p n_members terreno_cuerdas ag_prod_sold_bl pae_tradiontal_prod pae_traditional_sold_bl  regist_HH_bl know_pae_bl p_pesticidas centro altiplano costa i.stratum, vce(cluster village) 
test edad_nacimiento primaria_mas primaria_mas_p n_members terreno_cuerdas ag_prod_sold_bl pae_tradiontal_prod pae_traditional_sold_bl  regist_HH_bl know_pae_bl p_pesticidas centro altiplano costa
local F = `r(F)'
local Pv = `r(p)'

post `ptablas'  ("Ftest") ("Baseline") ("Regression of the treatment assignment on the set of covariates") (.) (.) (`F') (`Pv') 

drop _merge
merge m:1 caseid using  "${data_el}\digitagro_clean_outcomes.dta", keepusing(total) 

g attrition=(_merge==1)

*2. attrition 
reg attrition treatment  i.stratum, vce(cluster village) 
	local b1=el(r(table),1,1)
	local se=el(r(table),2,1)
	local pv=el(r(table),4,1)
post `ptablas'  ("AtritionReg") ("Baseline") ("Regression of attrition on the treatment") (`b1') (`se') (.) (`pv') 




postclose `ptablas'
use `tablas', clear
save `tablas', replace 

export excel using "${output}\addregs.xlsx", sh("results", replace)  firstrow(var)

restore

*-------------------------------------------------------------------------------

cd "${output}"

use "${data_el}\digitagro_clean_outcomes.dta", clear
include "$el\07 2 Do-files\inputs\labels_and_bl_outcomes.do"

global controlsh n_chidren n_members adult_men adult_women head_self head_parnter head_parent age_18_29 age_30_39 age_40_49 age_50_mas e_ninguno e_primaria e_secundaria pareja p_fertilizantes p_pesticidas p_semillas_mejoradas p_sistema_riego p_maquinaria terreno_cuerdas_mayor0_1 terreno_cuerdas_1_2 terreno_cuerdas_2_3 terreno_cuerdas_6_10 terreno_cuerdas_10mas land_owner zc_fria zc_caliente zc_ambas ciclo_corto ciclo_perenne ciclo_nd


** Table 2 
local efectos total 
 replace infor_2 =0 if infor_2==2
 
 foreach efecto of local efectos {
     
 local iff "if complete_controls==1 & `efecto'==1"
 local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 

  local module PAE
  	   
	   reg infor_2 treatment_el_1 $controlsh know_pae_bl  i.stratum `iff', vce(cluster village) 
	   sum  infor_2 `ifff'
	   outreg2 using Reg_`module'`efecto'.tex, replace ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)', Fixed effects using variable stratum are included in all estimation regression. The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)

   
* 4.	If not registered
	*a.	Knows SFP can buy products (5a)
	*b.	Knows that can register as SFP (5b)
	*c.	Knows the steps to register (5c, but input 5c = 0 if 5b!=yes, to get rid of the 0s)

local outcomes know_sfp_buy know_sfp_register steps infor_13 infor_14 
	foreach outcome of local outcomes {

     
   cap reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   sum `outcome' `ifff'
   cap outreg2 using Reg_`module'`efecto'.tex, append ctitle(`labels') stats(coef se pval) adds(Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab   
	}  
 }
 
	local module PAEt
  	
	local efectos recived_training  
		
* Table 3 	
	foreach efecto of local efectos {

		local iff "if complete_controls==1 & `efecto'==1"
		local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
		
	   reg infor_2 treatment_el_1 $controlsh know_pae_bl  i.stratum `iff', vce(cluster village) 
	   sum  infor_2 `ifff'
	   outreg2 using Reg_`module'.tex, replace ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)', Fixed effects using variable stratum are included in all estimation regression. The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   local outcomes know_sfp_buy know_sfp_register steps
	foreach outcome of local outcomes {

     
   cap reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   sum `outcome' `ifff'
   cap outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval) adds(Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab   
	}  
	   
	   
	}
	
	local efectos  no_recived_training 
  
   	
	foreach efecto of local efectos {
		local iff "if complete_controls==1 & `efecto'==1"
		local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
		
	   reg infor_2 treatment_el_1 $controlsh know_pae_bl  i.stratum `iff', vce(cluster village) 
	   sum  infor_2 `ifff'
	   outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)', Fixed effects using variable stratum are included in all estimation regression. The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
	   local outcomes know_sfp_buy know_sfp_register steps
	foreach outcome of local outcomes {

     
   cap reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
   sum `outcome' `ifff'
   cap outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval) adds(Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab   
	}  
	   	   
	}
	
* Table 4 	(appendix)

 local efectos total 
 foreach efecto of local efectos {
     
 local iff "if complete_controls==1 & `efecto'==1"
 local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 

  local module PAEsource 
  	   
	   reg infor_2 treatment_el_1 $controlsh know_pae_bl  i.stratum `iff', vce(cluster village) 
	   sum  infor_2 `ifff'
	   outreg2 using Reg_`module'.tex, replace ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)', Fixed effects using variable stratum are included in all estimation regression. The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
    
  
  local outcomes maga_sms infor_3_1 
    
	foreach outcome of local outcomes {
		
		if "`outcome'"=="maga_sms" | "`outcome'"=="infor_3_1" 	local outcome_bl maga_pae_bl
		   
	   reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   sum  `outcome' `ifff'
	   outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	   
   }
   
 *a.ii. Knows through Videos&SMS
   local outcome infor_3_5
 
   reg `outcome' treatment_el_1 $controlsh i.stratum `iff', vce(cluster village)  
   sum `outcome' `ifff'
   outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes 
   
 * b.	Knows through other sources: MINEDUC campaign, another farmer, school/teacher/OPF, friends/relatives/neighbors/others. 
  *3. Is the household registered to sell crops to the SFP?  
  
  local outcomes infor_3_4 other_sources
  
	foreach outcome of local outcomes {
		
		if "`outcome'"=="other_sources" 	local outcome_bl other_sources_bl
		if "`outcome'"=="infor_3_4" 		local outcome_bl school_opf_bl
		if "`outcome'"=="register"			local outcome_bl regist_HH_bl	
			   
	   cap reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   cap sum  `outcome' `ifff'
	   cap outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes 
	   
   }
 } 
 
 * table 5 
 
 local efectos total 
 foreach efecto of local efectos {
     
	 local module PAEregistro
	 
 local iff "if complete_controls==1 & `efecto'==1"
 local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 


  	   
	   reg register treatment_el_1 $controlsh regist_HH_bl  i.stratum `iff', vce(cluster village) 
	   sum  register `ifff'
	   outreg2 using Reg_`module'`efecto'.tex, replace ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)', Fixed effects using variable stratum are included in all estimation regression. The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
	   
    local outcomes registro infor_9 plan
  
	foreach outcome of local outcomes {
		
		if "`outcome'"== "registro" 	local outcome_bl registro_bl
		if "`outcome'"== "infor_9"	local outcome_bl sold_pae_prov_bl	
		if "`outcome'"== "plan" 		local outcome_bl talked_pae_prov_bl
		
		
	   cap reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `iff', vce(cluster village)  
	   cap sum  `outcome' `ifff'
	   cap outreg2 using Reg_`module'`efecto'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes 
	   
   } 	   
 }
  *  5.	Interested in registering (6, but replace 6 = 0 if 5a!=yes and 5b!=yes)
 *  6.	Sold crops a registered SFP provider (9)? (me parece que esta debería ser incondicional a las otras preguntas?)
 *  7.	Plans to sell to a registered SFP provider (9c) - NO ESTA EN LA BASE 
 *  8.	Plans to speak to a registered SFP provider (12, but replace answer as in 6)

 
local efectos total 
 foreach efecto of local efectos {
     
	local module sales
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
 
 
	local outcome sale
	   
	   reg `outcome' treatment_el_1 $controlsh ag_prod_sold_bl i.stratum `iff', vce(cluster village) 
	   sum `outcome' `ifff'
	   outreg2 using Reg_`module'`efecto'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes
      
	
   local outcomes sale_pae_traditional_agri sale_pae_traditional_anim sale_pae_covid_agri sale_pae_covid_anim 
	foreach outcome of local outcomes {
			 
			if "`outcome'"=="sale_pae_covid1"	    | "`outcome'"=="sale_pae_covid_agri"		 local outcome_bl pae_covid_sold_bl
			if "`outcome'"=="sale_pae_covid_anim"   | "`outcome'"=="sale_pae_traditional_anim"   local outcome_bl total
			if "`outcome'"=="sale_pae_traditional1"	|	"`outcome'"=="sale_pae_traditional_agri" local outcome_bl pae_traditional_sold_bl
	
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		cap sum  `outcome' `ifff'
		outreg2 using Reg_`module'`efecto'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, YES) keep(treatment_el_1) nocons lab nonotes
	
	}
 }	
	

local efectos pareja  
 foreach efecto of local efectos {
     
	local module salesdes
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
 

	
   local outcomes sale_pae_traditional_anim sale_huevo_pae sale_pollo_pae sale_queso_pae sale_vaca_pae  
	foreach outcome of local outcomes {
			 
			
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		cap sum  `outcome' `ifff'
		outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	
	}
 }	

 local efectos nopareja  
 foreach efecto of local efectos {
     
	local module salesdes
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
 
 
   local outcomes sale_pae_traditional_anim sale_huevo_pae sale_pollo_pae sale_queso_pae sale_vaca_pae  
	foreach outcome of local outcomes {
			 
			
		reg `outcome'  treatment_el_1 $controlsh `outcome_bl' i.stratum `iff', vce(cluster village) 
		cap sum  `outcome' `ifff'
		outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	
	}
 }	
 
 
 local efectos total  
 foreach efecto of local efectos {
     
	local module salesdecision
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
 

	
   local outcomes desition_agri_1 
	foreach outcome of local outcomes {
			 
			
		reg `outcome'  treatment_el_1 $controlsh wom_dec_bl i.stratum `iff', vce(cluster village) 
		cap sum  `outcome' `ifff'
		outreg2 using Reg_`module'.tex, replace ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	}
	
	local outcome desition_ani_1
	
	reg `outcome'  treatment_el_1 $controlsh inv_bl i.stratum `iff', vce(cluster village) 
	cap sum  `outcome' `ifff'
	outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	
	}
 

 local efectos pareja nopareja  
 foreach efecto of local efectos {
     
	local module salesdecision
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
   
     local outcomes desition_agri_1 
	foreach outcome of local outcomes {
			 
			
		reg `outcome'  treatment_el_1 $controlsh wom_dec_bl i.stratum `iff', vce(cluster village) 
		cap sum  `outcome' `ifff'
		outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	}
	
	local outcome desition_ani_1
	
	reg `outcome'  treatment_el_1 $controlsh i.stratum `iff', vce(cluster village) 
	cap sum  `outcome' `ifff'
	outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval)  adds( Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes
	
	}

 local efectos total pareja  
 foreach efecto of local efectos {
	*** IPW
	* total , partnered

	local module salesdecisionipw
	local iff "if complete_controls==1 & `efecto'==1"
	local ifff "if complete_controls==1 &  treatment_el_1==0 & `efecto'==1" 
	local outcome desition_agri_1 desition_ani_1
	foreach outcome of local outcomes {
	teffects ipw (`outcome') (treatment_el_1 $controlsh wom_dec_bl) if `outcome'==1 , vce(cluster village)
	local b1=el(r(table),1,1)
	local se=el(r(table),2,1)
	local pv=el(r(table),4,1)
	
	cap sum  `outcome' `ifff'
	outreg2 using Reg_`module'.tex, append ctitle(`labels') stats(coef se pval) adds( coefficient, `b1', Standard, `se', pv, `pv', Num clusters, `e(N_clust)', Outcome mean in control group, `r(mean)')  addtext(Stratum FE, YES, Controls, YES, Control for outcome at BL, NO) keep(treatment_el_1) nocons lab nonotes	
	}

 }	
	
*****------------------------------------- Take up tables 

 preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Indicador MeanSd Treatment Control)   using `tablas', replace
 
 g recall_otro_1 = 1 if  takeup_2a_text=="Donde se cosechan las verduras" | takeup_2a_text=="De productos y cosechas" | takeup_2a_text=="Llevar los productos a la escuela les beneficia" | takeup_2a_text=="Higiene en los alimentos" | takeup_2a_text=="Sembrar cebolla para vender al programa PAE" | takeup_2a_text=="Vaquita que le da leche a los niños dice en ese video  programa de alimentacion escolar es bueno para los pequeños productores" | takeup_2a_text=="Como facturar los productos que va vender" | takeup_2a_text=="Cómo registrarse como ser un proveedor y como registrarse para ser un proveedor" | takeup_2a_text=="Cómo producir productos y distribución" | takeup_2a_text=="Los beneficios de venderle a un proveedor" | takeup_2a_text=="Cómo contactarse con un proveedor" | takeup_2a_text=="Alimentacion escolar" | takeup_2a_text=="Cómo entrega la cosecha al mineduc" | takeup_2a_text=="Cómo preparar los alimentos, los que estaban proveendo al PAE eran agricultores" | takeup_2a_text=="Superación de personas que venden sus productos a este programa" | takeup_2a_text=="Que cultiva conforme la tierra y los pasos para la SAT" | takeup_2a_text=="Como sacar su NIT" | takeup_2a_text=="Como inscribirse como proveedor"  
 
 g recall_1 = 0 if treatment_el_1 ==1
 replace recall_1 =1  if takeup_2a_1==1 | takeup_2a_2==1 | takeup_2a_3==1 | takeup_2a_4==1 | recall_otro==1
 g dont_recall_1 = (recall_1 ==0)
 
 
 local indicadorts recall_1 takeup_2a_1 takeup_2a_2 takeup_2a_3 takeup_2a_4 dont_recall_1
 
 
 
 sum takeup_1 if  treatment_el_1 ==1
 local meant : di %6.4f `r(mean)'
 local sdt : di %6.4f `r(sd)'
 
 sum takeup_5 if  treatment_el_1 ==0
 local meanc : di %6.4f `r(mean)'
 local sdc : di %6.4f `r(sd)'
 
 post `ptablas' ("takeup_1") ("") ("`meant'") ("`meanc'")  
 post `ptablas' ("takeup_1") ("") ("[`sdt']") ("[`sdc']") 
 
 
 foreach indicadort of local indicadorts {
 sum `indicadort' if  treatment_el_1 ==1
 local mean : di %6.4f `r(mean)'
 local sd : di %6.4f `r(sd)'
 
 post `ptablas' ("`indicadort'") ("") ("`mean'") ("")  
 post `ptablas' ("`indicadort'") ("") ("[`sd']") ("") 
 
 }
 

 
 g recall_otro_4 = 1 if takeup_4a_text=="Recomendar vender productos al gobierno" | takeup_4a_text=="Precio de verduras y granos basicos" | takeup_4a_text=="Inscribirse para convertirse en proveedor" | takeup_4a_text=="Precios y productos que se venden" | takeup_4a_text=="Información de que alimentos necesitaban" | takeup_4a_text=="Los precios que manejan los productos que compran" | takeup_4a_text=="Igual de los productos de las escuelas" | takeup_4a_text=="Precios de la compra al Pae" | takeup_4a_text=="Lo que venden en las escuelas" | takeup_4a_text=="Información de contacto de personas que venden y precio al que venden" | takeup_4a_text=="Precios de los productos que compran" | takeup_4a_text=="Como registrarse para ser proveedor" | takeup_4a_text=="Precios de frutas y verduras" 
 
 g recall_4 = 0 if treatment_el_1==1
 replace recall_4 =1  if takeup_4a_1==1 | takeup_4a_2==1 | takeup_4a_3==1 | takeup_4a_4==1 | recall_otro_4==1
 g dont_recall_4 = (recall_4 ==0) 
 
 local indicadorcs takeup_3 takeup_4a_1 takeup_4a_2 takeup_4a_3 takeup_4a_4 recall_4  dont_recall_4
 
 
 
 foreach indicadorc of local indicadorcs {
 sum `indicadorc' if  treatment_el_1 ==1
 local mean : di %6.4f `r(mean)'
 local sd : di %6.4f `r(sd)'
 
 post `ptablas' ("`indicadorc'") ("") ("`mean'") ("")  
 post `ptablas' ("`indicadorc'") ("") ("[`sd']") ("") 
 
 }
 
 postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "${output}\addregs.xlsx", sh("results_takeup", replace)  firstrow(var)
restore








