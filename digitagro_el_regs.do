
 * Paper style tables estimation 
      
cd "C:\Users\lopez\OneDrive - Universidad de los Andes\WB\GTM - IE DIGITAGRO\07 Endline\07 3 Docs\Digitagro - regs"

*===============================================================================
*  HARVEST MODULE
*===============================================================================
	
global controlsh1 n_chidren n_members adult_men adult_women head_self head_parnter head_parent age_18_29 age_30_39 age_40_49 age_50_mas e_ninguno e_primaria e_secundaria pareja p_fertilizantes p_pesticidas p_semillas_mejoradas p_sistema_riego p_maquinaria terreno_cuerdas_mayor0_1 terreno_cuerdas_1_2 terreno_cuerdas_2_3 terreno_cuerdas_6_10 terreno_cuerdas_10mas land_owner zc_fria zc_caliente zc_ambas
	
	
* regular controls 
  

   reg harvested treatment_el_1 i.stratum, vce(cluster village)
   outreg2 using Results_Model_Digitagro_Harvest1.xlsx, replace ctitle(Any agricultural-animal product) stats(mean coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controls1, *p<.05; **p<.01; ***p<.001)
   reg harvested treatment_el_1 $controlsh1 i.stratum, vce(cluster village) 
   outreg2 using Results_Model_Digitagro_Harvest1.xlsx, append ctitle(Any agricultural-animal product) stats(mean coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons 
      
   local outcomes harvested_pae_covid1 harvested_pae_covid_agri harvested_pae_covid_anim harvested_pae_traditional1 harvested_pae_traditional_agri harvested_pae_traditional_anim 
	 foreach outcome of local outcomes {
	

		 reg `outcome' treatment_el_1 i.stratum, vce(cluster village)
	   outreg2 using Results_Model_Digitagro_Harvest1.xlsx, append ctitle(`tittle') stats(mean coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes 
	   reg `outcome'  treatment_el_1 $controlsh1 i.stratum, vce(cluster village) 
	   outreg2 using Results_Model_Digitagro_Harvest1.xlsx, append ctitle(`tittle') stats(mean coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons lab nonotes 
	}
	

* dividing per crop types

local ciclos total ciclo_corto ciclo_perenne	
foreach ciclo of local ciclos{	
  reg harvested_pae_covid_agri treatment_el_1 i.stratum if `ciclo'==1, vce(cluster village)
   outreg2 using Results_Model_Digitagro_Harvest_`ciclo'.xlsx, replace ctitle(COVID-19 PAE agr product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh1, *p<.05; **p<.01; ***p<.001)
   reg harvested_pae_covid_agri treatment_el_1 $controlsh i.stratum if `ciclo'==1, vce(cluster village) 
   outreg2 using Results_Model_Digitagro_Harvest_`ciclo'.xlsx, append ctitle(COVID-19 PAE agr product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons 
   
    reg harvested_pae_traditional_agri treatment_el_1 i.stratum if `ciclo'==1, vce(cluster village)
   outreg2 using Results_Model_Digitagro_Harvest_`ciclo'.xlsx, append ctitle(Traditional PAE agr product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh1, *p<.05; **p<.01; ***p<.001)
   reg harvested_pae_traditional_agri treatment_el_1 $controlsh i.stratum if `ciclo'==1, vce(cluster village) 
   outreg2 using Results_Model_Digitagro_Harvest_`ciclo'.xlsx, append ctitle(Traditional PAE agr product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons 
   
  }
  	
	
* using crop type as control 

global controlsh n_chidren n_members adult_men adult_women head_self head_parnter head_parent age_18_29 age_30_39 age_40_49 age_50_mas e_ninguno e_primaria e_secundaria pareja p_fertilizantes p_pesticidas p_semillas_mejoradas p_sistema_riego p_maquinaria terreno_cuerdas_mayor0_1 terreno_cuerdas_1_2 terreno_cuerdas_2_3 terreno_cuerdas_6_10 terreno_cuerdas_10mas land_owner zc_fria zc_caliente zc_ambas ciclo_corto ciclo_perenne ciclo_nd

   reg harvested treatment_el_1 i.stratum if complete_controls==1, vce(cluster village)
   outreg2 using Results_Model_Digitagro_Harvest.xlsx, replace ctitle(Any agricultural-animal product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   reg harvested treatment_el_1 $controlsh i.stratum if complete_controls==1, vce(cluster village) 
   outreg2 using Results_Model_Digitagro_Harvest.xlsx, append ctitle(Any agricultural-animal product) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons 
      
   local outcomes harvested_pae_covid1 harvested_pae_covid_agri harvested_pae_covid_anim harvested_pae_traditional1 harvested_pae_traditional_agri harvested_pae_traditional_anim 
	 foreach outcome of local outcomes {
	
		
		 reg `outcome' treatment_el_1 i.stratum if complete_controls==1, vce(cluster village)
	   outreg2 using Results_Model_Digitagro_Harvest.xlsx, append  stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes 
	   reg `outcome'  treatment_el_1 $controlsh i.stratum if complete_controls==1, vce(cluster village) 
	   outreg2 using Results_Model_Digitagro_Harvest.xlsx, append stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons lab nonotes 
	}	
	
*===============================================================================
*  PAE MODULE
*===============================================================================	


   reg infor_2 treatment_el_1 i.stratum if complete_controls==1, vce(cluster village)
   outreg2 using Results_Model_Digitagro_PAE.xls, replace ctitle(infor_2) stats(coef pval se) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes addnote(SE clustered by `e(clustvar)',The covariate variables include $controlsh, *p<.05; **p<.01; ***p<.001)
   reg infor_2 treatment_el_1 $controlsh i.stratum if complete_controls==1, vce(cluster village) 
   outreg2 using Results_Model_Digitagro_PAE.xls, append ctitle(infor_2) stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons lab
      
   local outcomes  maga_sms infor_3_1 infor_3_5 other_sources infor_4 infor_5a infor_5b steps registro infor_9 plan infor_13 infor_14 infor_15 quality
	 foreach outcome of local outcomes {
		
		 reg `outcome' treatment_el_1 i.stratum if complete_controls==1, vce(cluster village)
	   outreg2 using Results_Model_Digitagro_PAE.xls, append ctitle(`outcome') stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, NO) keep(treatment_el_1) nocons lab nonotes 
	   reg `outcome'  treatment_el_1 $controlsh i.stratum if complete_controls==1, vce(cluster village) 
	   outreg2 using Results_Model_Digitagro_PAE.xls, append stats(coef se pval) addtext(Num clusters, `e(N_clust)', Stratum FE, YES, Controls, YES) keep(treatment_el_1) nocons lab nonotes 
	}		
	
*==============================================================================	
* CONTROL OUTCOME means (BY MODULE)
*==============================================================================


preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Module Ciclo Outcome)  Mean1 using `tablas', replace
		
		* harvest
				local outcomes harvested harvested_pae_covid1 harvested_pae_covid_agri harvested_pae_covid_anim harvested_pae_traditional1 harvested_pae_traditional_agri harvested_pae_traditional_anim 
				local ciclos total ciclo_corto ciclo_perenne
				
				foreach outcome of local outcomes{
					foreach ciclo of local ciclos{
						local iff "if complete_controls==1 & treatment_el_1==0 & `ciclo'==1"
						sum `outcome' `iff'
						local m = `r(mean)'
				
						post `ptablas'  ("Harvest") ("`ciclo'") ("`outcome'") (`m') 	
						post `ptablas'  ("Harvest") ("`ciclo'") ("`outcome'") (`m') 
					}
				}
		* PAE
				local ciclo total
				local outcomes infor_2 maga_sms infor_3_1 infor_3_5 other_sources infor_4 infor_5a infor_5b steps registro infor_9 plan infor_13 infor_14 infor_15 quality
				local iff "if complete_controls==1 & treatment_el_1==0" 
				foreach outcome of local outcomes{
					sum `outcome' `iff'
					local m = `r(mean)'

								
					post `ptablas'  ("PAE") ("Total") ("`outcome'") (`m') 	
					post `ptablas'  ("PAE") ("Total") ("`outcome'") (`m') 
				}
						
postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "01. Result_Tables_Digitagro_EL.xlsx", sh("means", replace)  firstrow(var)

restore


