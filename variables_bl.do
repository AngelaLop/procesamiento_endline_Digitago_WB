*===============================================================================
* variables creation _baseline 
*===============================================================================

*
gen wom_selling=0
replace wom_selling=1 if q2_7==1
order wom_selling, a(q2_7)

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
	g menos_primaria = e_ninguno
	g primaria_mas = e_primaria==1 | e_secundaria==1 | e_terciaria==1
	
	tab home_16, generate(educa_men)
	
	g e_ninguno_p = inlist(home_16,1,2,3)
	g e_primaria_p = inlist(home_16,4,5,6,7)
	g e_secundaria_p = inlist(home_16,8)
	g e_terciaria_p = inlist(home_16,9,10,11)

	g primaria_mas_p = e_primaria_p==1 | e_secundaria_p==1 | e_terciaria_p==1

	
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
	
*** terreno abajo y sobre la media
	g terreno_bajo_media = terreno_cuerdas < 4
	g terreno_sobre_mayor_media = terreno_cuerdas >= 4
	
	** log terreno_cuerdas
	g terreno_cuerdas_log =log(terreno_cuerdas)
	
	
	g terreno_hectareas = terreno_cuerdas*0.3930395625 // equivalencia en hectareas 
*** land ownership 
	*g land_owner = (farm_4==1)

	
****
	*% of women with at least one PAE product 
	*-------------------------------------------------------------------------------
	*Analyse products and find those demanded by the PAE
	*split yield_2, p(" ")
	

	*Create a dummy (pae_prod) for women producing a PAE product
	
	gen pae_tradiontal_prod =0
	local cos 21 22 23 24 25 26 27 28 29 210 211 212 213 214
	foreach co of local cos {
	
	replace pae_tradiontal_prod=1 if inlist(yield_`co'n, 2,5,9,10,11,12,13,14,15,16,17,20,21,31,34,35,37,40,46)
	} 
	
	gen pae_prod=0
		*consider the products with code
	replace pae_prod=1 if inlist(yield_21n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_22n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_23n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_24n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_25n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_26n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_27n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_28n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_29n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_210n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_211n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_212n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_213n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)
	replace pae_prod=1 if inlist(yield_214n, 2,3,4,5,7,8,9,10,11,12,13,14,15,16,17,18,20,21,23,24,26,27,28,29,31,32,33,34,35,36,37,39,40,41)

		*consider women responding only with 'other' (i.e. yield_2==997|998|999), but producing at least one PAE product
	replace pae_prod=1 if yield_2_text_997=="Pepino" | yield_2_text_997=="Pepino, rabano"

	replace pae_prod=1 if yield_2_text_998=="Acelga" | yield_2_text_998=="Canela, pimienta" | yield_2_text_998=="Chile pimiento" | yield_2_text_998=="Guineo" | yield_2_text_998=="Miltomate" | yield_2_text_998=="Tomate"

	replace pae_prod=1 if yield_2_text_999=="Nance, banano" | yield_2_text_999=="Papaya"

	replace pae_prod=1 if inlist(yield_2_text_997, "Banano","Bananos" ,"Banano de seda")
	replace pae_prod=1 if inlist(yield_2_text_997, "Chiplin", "Chipilin" ,"Bledo, Chipilin, Cilantro","Espinaca"	,"Platano",	"Plátano", "Platano y banano")	

	replace pae_prod=1 if inlist(yield_2_text_998, "Banano","Bananos" ,"Banano de seda")
	replace pae_prod=1 if inlist(yield_2_text_998, "Chiplin", "Chipilin" ,"Bledo, Chipilin, Cilantro","Espinaca"	,"Platano",	"Plátano", "Platano y banano")	

	replace pae_prod=1 if inlist(yield_2_text_999, "Banano","Bananos" ,"Banano de seda")
	replace pae_prod=1 if inlist(yield_2_text_999, "Chiplin", "Chipilin" ,"Bledo, Chipilin, Cilantro","Espinaca"	,"Platano",	"Plátano", "Platano y banano")	 




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
	gen p_abonos_fertilizantes = p_abonos==1 | p_fertilizantes==1
	
	gen centro=0
	replace centro=1 if municipality=="SAN MARCOS" | municipality=="ESQUIPULAS PALO GORDO" |municipality=="SAN ANTONIO SACATEPEQUEZ" |municipality=="SAN CRISTOBAL CUCHO" |municipality=="RIO BLANCO" |municipality=="SAN LORENZO"|municipality=="SAN PEDRO SACATEPEQUEZ"

	gen altiplano=0
	replace altiplano=1 if municipality=="SAN JOSE OJETENAM"|municipality=="SAN MIGUEL IXTAHUACAN"|municipality=="SIBINAL"|municipality=="SIPACAPA"|municipality=="TACANA"|municipality=="TAJUMULCO"|municipality=="TEJUTLA"|municipality=="COMITANCILLO"|municipality=="CONCEPCION TUTUAPA"|municipality=="IXCHIGUAN"

	gen costa=0
**# Bookmark #1
	replace costa=1 if municipality=="AYUTLA"|municipality=="CATARINA"|municipality=="EL QUETZAL"|municipality=="EL RODEO"|municipality=="EL TUMBADOR"|municipality=="LA BLANCA"|municipality=="SAN RAFAEL PIE DE LA CUESTA"|municipality=="LA REFORMA"|municipality=="MALACATAN"|municipality=="NUEVO PROGRESO"|municipality=="OCOS"|municipality=="PAJAPITA"|municipality=="SAN PABLO"
	
	destring treatment, replace