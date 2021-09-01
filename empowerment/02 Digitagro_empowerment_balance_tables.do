********************************************************************************
*	DIGITAGRO-Empoderamiento
*	AUTHOR: Angela Lopez email: ar.lopez@uniandes.edu.co
*	FECHA: 23-08-2021
*   Export balance table results 
********************************************************************************



clear all
*END LINE start: 26-07-2021
version 17
drop _all
*ssc install ietoolkit

global path 	"C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\07 Endline"
global baseline "C:\Users\ALOP\Inter-American Development Bank Group\Angela - General\WB\GTM - IE DIGITAGRO\06 Baseline\06 4 Clean Data"
global data 	"${path}\07 01 Data"
global clean	"${path}\07 4 Clean Data"
global output	"${path}\07 3 Docs"



use "$clean/clean_data", replace 
*======================================================================
*	control variables 
*====================================================================== 

*** household characteristics
	*members
	*home_2
	*children
	*home_3
	*adult men
	*home_4
	*adult women
	*home_5
	*members older than 65
	*home_6
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
	edad_nacimiento
*======================================================================
*	empowerment two branches (without tone analysis)
*====================================================================== 

g empowerment_1 = (empowerment_1c==1) | (empowerment_1t==1)
g empowerment_2 = (empowerment_2c==0) | (empowerment_2t==0) // so all the 1 mean more empowerment 
g empowerment_3 = (empowerment_3c==1) | (empowerment_3t==1)
g empowerment_4 = (empowerment_4c==1) | (empowerment_4t==1)
g empowerment_5 = (empowerment_5c==1) | (empowerment_5t==1)
g empowerment_6 = (empowerment_6c==1) | (empowerment_6t==1)

tab  empowerment_3, gen(empowerment_3)
tab  empowerment_4, gen(empowerment_4)
tab  empowerment_5, gen(empowerment_5)
tab  empowerment_6, gen(empowerment_6)

destring treatment, replace

g total =1
g pareja = inlist(home_17,1,2)
g nopareja= inlist(home_17,3,4,5,6,7)



*======================================================================
*	balance tables 
*======================================================================
*Total
* 1. no controls 
local estados pareja nopareja total

foreach estado of local estados {

iebaltab empowerment_1 empowerment_2 empowerment_3 empowerment_4 empowerment_5 empowerment_6 if muestra==1 & treatment !=2 & `estado' ==1 , pt grpvar(treatment) save("$output\balance_empowerment_nc_`estado'.xlsx") vce(robust) ft  normdiff  grplabels("1 Treatment_numero @ 3 Control") total totallabel(Overall) ///
rowlabels( ///
empowerment_1	"1. Se le permite ir sola para reunirse con sus amigas y amigos por cualquier razón (conversar, almorzar,etc.)" @ ///
empowerment_2	"2. Compra verduras o frutas; ropa para usted mismo; medicamentos o suministros personales sin pedir permiso?" @ ///
empowerment_3	"3. ¿Quién suele decidir si Usted puede ir a visitar la casa de una amiga o amigo / vecina o vecino? " @ ///
empowerment_4	"4. ¿Quién contribuye más en la decisión de comprar nuevos activos (ejemplo: azadón o bomba de fumigar)?" @ ///
empowerment_5	"5. ¿Quién decide a la hora de dar apoyo a los padres, suegros, hermanos, etc.?" @ ///
empowerment_6	"Cuando se toma decisiones con respecto a la atención en salud de los niños , por lo general ¿quién toma la decisión?" @ /// 
) replace 

return list

* 2. controls 

iebaltab empowerment_1 empowerment_2 empowerment_3 empowerment_4 empowerment_5 empowerment_6 if muestra==1 & treatment !=2 & `estado' ==1,  covarmissok pt grpvar(treatment) save("$output\balance_empowerment_c_`estado'.xlsx") vce(robust) grplabels("1 Treatment_numero @ 3 Control") total totallabel(Overall) cov(home_2 home_3 home_4 home_5 home_6 head_self head_parnter head_parent head_other educa_wmen1 educa_wmen2 educa_wmen3 educa_wmen4 educa_wmen5 educa_wmen6 educa_wmen7 educa_wmen8 educa_wmen9 educa_wmen10 educa_wmen11 marital1 marital2 marital3 marital4 marital5 marital6 marital7) ///
rowlabels( ///
empowerment_1	"1. Se le permite ir sola para reunirse con sus amigas y amigos por cualquier razón (conversar, almorzar,etc.)" @ ///
empowerment_2	"2. Compra verduras o frutas; ropa para usted mismo; medicamentos o suministros personales sin pedir permiso?" @ ///
empowerment_3	"3. ¿Quién suele decidir si Usted puede ir a visitar la casa de una amiga o amigo / vecina o vecino? " @ ///
empowerment_4	"4. ¿Quién contribuye más en la decisión de comprar nuevos activos (ejemplo: azadón o bomba de fumigar)?" @ ///
empowerment_5	"5. ¿Quién decide a la hora de dar apoyo a los padres, suegros, hermanos, etc.?" @ ///
empowerment_6	"Cuando se toma decisiones con respecto a la atención en salud de los niños , por lo general ¿quién toma la decisión?" @ /// 
) replace 

} 




*======================================================================
*	balance tables : coefficients 
*======================================================================
* 
preserve
					
	tempfile tablas
	tempname ptablas
	
	postfile `ptablas' str25(Indicador Estatus tipo_control tipo_valor) value using `tablas', replace
		
	*Total
	* 1. no controls 
		local estados pareja nopareja total

		foreach estado of local estados {
			forvalues i=1/6 {
				reg empowerment_`i' treatment if treatment !=2 & muestra==1 & `estado'==1
				mat tables=r(table)
				local beta = tables[1,1]
				local se = tables[2,1]
				
				post `ptablas' ("empowerment_`i'") ("`estado'") ("sin controles") ("beta") (`beta') 
				post `ptablas' ("empowerment_`i'") ("`estado'") ("sin controles") ("se") (`se')
				
			} // cierro forvalues

	* 2. controls 

	
			forvalues i=1/6 {
				reg empowerment_`i' treatment home_2 home_3 home_4 home_5 home_6 head_self head_parnter head_parent head_other educa_wmen1 educa_wmen2 educa_wmen3 educa_wmen4 educa_wmen5 educa_wmen6 educa_wmen7 educa_wmen8 educa_wmen9 educa_wmen10 educa_wmen11 if treatment !=2 & muestra==1 & `estado'==1
	
				
				mat tables=r(table)
				local beta = tables[1,1]
				local se = tables[2,1]
				
				post `ptablas' ("empowerment_`i'") ("`estado'") ("controles") ("beta") (`beta') 
				post `ptablas' ("empowerment_`i'") ("`estado'") ("controles") ("se") (`se')
	
			}
			
		} // cierro estado

postclose `ptablas'
use `tablas', clear
destring value, replace
recode value 0=.
save `tablas', replace 

export excel using "${output}/balance_tables_empowerment.xlsx", sh("regresiones", replace)  firstrow(var)

restore
