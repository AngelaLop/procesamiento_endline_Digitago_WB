


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
global dos 		"C:\Users\lopez\OneDrive - Universidad de los Andes\WB\Git_repositories\2. Digitago_endline"
    
cd "${output}"


preserve
					
	tempfile tablas
	tempname ptablas
	
global controlsh n_chidren n_members adult_men adult_women head_self head_parnter head_parent age_18_29 age_30_39 age_40_49 age_50_mas e_ninguno e_primaria e_secundaria pareja p_fertilizantes p_pesticidas p_semillas_mejoradas p_sistema_riego p_maquinaria terreno_cuerdas_mayor0_1 terreno_cuerdas_1_2 terreno_cuerdas_2_3 terreno_cuerdas_6_10 terreno_cuerdas_10mas land_owner zc_fria zc_caliente zc_ambas ciclo_corto ciclo_perenne ciclo_nd
	

*===============================================================================
*  PAE MODULE
*===============================================================================	

*1.	Know about PAE market
*2.	If knows 
* a.  Knows through MAGA or Videos&SMS
 *a.i.	Knows through MAGA
 
 
 *** efectos heterogeneos 
 *local efectos  register no_register costa altiplano centro menos_primaria primaria_mas pareja nopareja terreno_bajo_media terreno_sobre_mayor_media total
 
     postfile `ptablas' str25(Modulo Group Outcome) Y SE using `tablas', replace

		local iff "if complete_controls==1 &  treatment_el_1==0" 
		
		local module PAE

		local outcomes infor_2 maga_sms infor_3_1 infor_3_5 infor_3_4 know_sfp_buy infor_13 infor_14 know_sfp_register steps easy_register 
	   	
		foreach outcome of local outcomes{
		sum `outcome' `iff'
		local control = `r(mean)'

   
		local ifff "if complete_controls==1 " 
   
		
		if "`outcome'"=="infor_2" 									local outcome_bl know_pae_bl
		if "`outcome'"=="maga_sms"  | "`outcome'"=="infor_3_1" 		local outcome_bl maga_pae_bl
		if "`outcome'"=="infor_3_4" 								local outcome_bl school_opf_bl
		if "`outcome'"=="infor_3_5" | "`outcome'"=="know_sfp_buy" |	 "`outcome'"=="infor_13" |  "`outcome'"=="infor_14" |  "`outcome'"=="know_sfp_register"|  "`outcome'"=="steps" |  "`outcome'"=="easy_register"			local outcome_bl total
		if "`outcome'"=="register"									local outcome_bl regist_HH_bl
		
		
		reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `ifff', vce(cluster village) 
		
		local beta_m = _b[treatment_el_1]
		local tet_m = `control' + `beta_m' 
		
		local se_m = _se[treatment_el_1]
		
		post `ptablas'  ("`module'") ("Control") ("`outcome'") (`control') (.) 
		post `ptablas'  ("`module'") ("Treatment") ("`outcome'") (`tet_m') (`se_m') 
		}
		
		local module Perception

		local outcomes inst_2a_2 inst_2b_2 inst_2c_2
	   	
		foreach outcome of local outcomes {
		sum `outcome' `iff'
		local control = `r(mean)'

   
		local ifff "if complete_controls==1 " 
   
		if "`outcome'"=="inst_2a_2"		local outcome_bl trust_MAGA_bl
		if "`outcome'"=="inst_2b_2"		local outcome_bl trust_MINEDUC_bl
		if "`outcome'"=="inst_2c_2"		local outcome_bl trust_SAT_bl
		
		reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `ifff', vce(cluster village) 
		
		local beta_m = _b[treatment_el_1]
		local tet_m = `control' + `beta_m' 
		
		local se_m = _se[treatment_el_1]
		
		post `ptablas'  ("`module'") ("Control") ("`outcome'") (`control') (.) 
		post `ptablas'  ("`module'") ("Treatment") ("`outcome'") (`tet_m') (`se_m') 
		}
		
		
		local module SALES

		local outcomes sale sale_pae_covid_agri sale_pae_traditional_anim sale_huevo_pae sale_pollo_pae sale_queso_pae sale_vaca_pae
	   	
		foreach outcome of local outcomes {
		sum `outcome' `iff'
		local control = `r(mean)'

   
		local ifff "if complete_controls==1 " 
   
		if "`outcome'"=="sale_pae_covid_agri"		 local outcome_bl pae_covid_sold_bl

		if "`outcome'"=="sale" | "`outcome'"=="sale_pae_traditional_anim" |	 "`outcome'"=="sale_huevo_pae" | "`outcome'"=="sale_pollo_pae" | "`outcome'"=="sale_queso_pae" | "`outcome'"=="sale_vaca_pae" 	local outcome_bl total_nada

		
		
		reg `outcome' treatment_el_1 $controlsh `outcome_bl'  i.stratum `ifff', vce(cluster village) 
		
		local beta_m = _b[treatment_el_1]
		local tet_m = `control' + `beta_m' 
		
		local se_m = _se[treatment_el_1]
		
		post `ptablas'  ("`module'") ("Control") ("`outcome'") (`control') (.) 
		post `ptablas'  ("`module'") ("Treatment") ("`outcome'") (`tet_m') (`se_m') 
		}
				
postclose `ptablas'
use `tablas', clear
*destring value, replace
*recode value 0=.
save `tablas', replace 

export excel using "${output_f}\02. Result_graphs_Digitagro_EL_tmp.xlsx", sh("results", replace)  firstrow(var)

restore
 