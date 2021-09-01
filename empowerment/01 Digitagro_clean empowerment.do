********************************************************************************
**	DIGITAGRO-Empoderamiento
**	AUTHOR: Rosa Rojas
**	FECHA: 30-07-2021
** Last modification: Angela Lopez email: ar.lopez@uniandes.edu.co

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

use "${data}/gua_digitagro_el_09082021.dta", clear

*ELIMINO observaciones antes del 26 de julio
*drop if survey_start_date_full<="2021-07-26"
*drop if users=="prueba" |users=="rrojas"|users=="jorozco" | users=="csaavedra"

*Encuestas completas 

drop if key=="uuid:dddc4166-defb-498c-8533-8ab94974d7bf" // 5105 no aplica
drop if key=="uuid:790c8894-fa5e-4c13-9308-647109a2d24c" //1500 aperez
drop if key=="uuid:4c2814e3-659b-48c1-b16b-0cd82e0f3c97" // 749 sarana
drop if key=="uuid:1618f12a-5c1c-452f-a4c2-fac2ab5806da" //870  sarana
drop if key=="uuid:8a244901-d10c-4e9b-a5d4-827ad040f3bb" //5492 
replace call_status=7 if caseid=="5260"
replace call_status=7 if caseid=="5049"
replace call_status=7 if caseid=="6119"
replace call_status=7 if caseid=="5218"
replace call_status=7 if caseid=="5311"
replace call_status=7 if caseid=="5900"

*ENCUESTAS EMPODERAMIENTO


gen muestra_1= inlist(call_status,1,2) if consentimiento ==1
gen muestra_2= (consentimiento==1) & (call_status ==1) // completados en una sola llamada 
gen muestra_3= (call_status ==1) & (consentimiento ==.) & (last_call_status =="Llamada reprogramada")
gen muestra = (muestra_2==1) | (muestra_3==1)



*encuesta1: encuesta completa de una sola
gen encuesta1= (call_status==1 & consentimiento ==1 & empoderamiento_completo==1) | (call_status==1 & consentimiento ==1 & interrupt_alguien!="0")
*encuesta2: encuesta completa en una segunda llamada por reprogramarse empower
gen encuesta2= (call_status==1 & empowerment_reprograma2=="1")
*encuesta3: encuesta reprogramada por empoderamiento
gen encuesta3= call_status==2 & consentimiento ==1 & empowerment_reprograma2=="1"

	*ENCUESTAS EMPODERAMIENTO A ANALIZAR
gen encuesta_empower= encuesta1==1 | encuesta2==1 | encuesta3==1
keep if encuesta_empower==1

	*Duplicados reprogramada-completa: drop programada porque se completó en una segunda llamada
drop if key=="uuid:cbf50fe4-4d29-49bf-96ed-1c9bd44d98e1"
drop if key=="uuid:cfc34a4d-33e7-412a-a9b0-7103823cf923"
drop if key=="uuid:7ccac58f-923c-4c88-b5b4-d52e2742888f"
drop if key=="uuid:ec27a3e4-1360-463e-8256-52acbba4d933"
drop if key=="uuid:f80dbad7-3cbc-4655-863b-dd7282481d54"
drop if key=="uuid:d3e33022-7948-4f0c-b564-493b90697e8b"
drop if key=="uuid:d50f30e1-504e-4c77-b8e1-47038c670bf1"
drop if key=="uuid:a817a2ec-8f95-4aba-9f2f-47675079b3d7"
drop if key=="uuid:f4ed8b17-8cd1-4d2b-bc00-c30a538bea30"
drop if key=="uuid:911b4c8f-dcf7-48dd-bcf9-dcca0bd9ce6f"
drop if key=="uuid:e743b127-08e9-4eeb-a0c9-83d88a354d3c"
drop if key=="uuid:749a8dd0-8466-42a3-9e18-a97cd62eb517"
drop if key=="uuid:4411f380-6b3a-43cb-81d5-00f98c688054"
drop if key=="uuid:1dfa276b-1684-44dd-a759-e951895beec0"
drop if key=="uuid:ed3c65a7-120d-477e-964f-7e772b581411"
drop if key=="uuid:1d344c9d-6c3c-4000-abbc-c0fb95c84d0a"
drop if key=="uuid:533d7730-5e84-4fdb-b92d-1934db64d748"
drop if key=="uuid:f48ff5b4-ba1c-4a1d-a246-4f25c39714a6"
drop if key=="uuid:1fcb09dd-0648-4c58-8264-6aee24735a97"

drop if key=="uuid:c02f35c9-3755-45ff-b53f-429a8e6d4bdf"
drop if key=="uuid:777656d5-c92b-42d5-8b41-2f00df4639cb"
drop if key=="uuid:aeb69124-c51c-4565-b370-a27e235e0503"
drop if key=="uuid:a8084437-7be3-4b5d-b976-910dcecf3970"
drop if key=="uuid:7d9584ec-443c-490e-bd2e-b5b62c7d922b"
drop if key=="uuid:fa9d90e3-d020-46a1-adc1-0b8f8cc73d92"
drop if key=="uuid:09f7e55e-ee30-45ce-802a-67b98745a1c6"
drop if key=="uuid:de574ab4-57e2-4b40-8261-8cba63a1b70f"
drop if key=="uuid:3f9ff994-f890-42bf-bdee-f4c187dde336"
drop if key=="uuid:d41fe9f8-00e6-420b-9acf-2b6463ffd337"
drop if key=="uuid:64cba3a9-b64a-48fe-ba5a-3d9f3df39942"
drop if key=="uuid:9b674ce9-1e66-437f-9584-ccbe7c8acc09"
drop if key=="uuid:1f65446c-5879-4481-b329-ab5f2c35ffb6"
drop if key=="uuid:b885d397-0f6f-4b8f-bcbf-78344d00d2df"

*Quedarme solo con encuestas completas
keep if call_status==1

tab treatment no_bl 

*NO EFECTIVAS
replace listo_empowerment=0 if listo_empowerment==.
g reason_no_efectivo=.
*reason_no_efectivo=1 if encuestadora no sabe leer ni escribir
replace reason_no_efectivo=1 if caseid=="9509"
replace reason_no_efectivo=1 if caseid=="9043"
replace reason_no_efectivo=1 if caseid=="6271"
replace reason_no_efectivo=1 if caseid=="1065"
replace reason_no_efectivo=1 if caseid=="7091"
replace reason_no_efectivo=1 if caseid=="2726"
replace reason_no_efectivo=1 if caseid=="10229"
replace reason_no_efectivo=1 if caseid=="2558"
replace reason_no_efectivo=1 if caseid=="1910"

*reason_no_efectivo=2 if pareja de la encuestadora se lo prohibe, esposa cree que no debe ocultar nada a su esposo
replace reason_no_efectivo=2 if caseid=="5866"
replace reason_no_efectivo=2 if caseid=="1104"
replace reason_no_efectivo=2 if caseid=="6410"

*EFECTIVAS
keep if listo_empowerment==1 & interrupt_alguien=="0"

***************************************************************************
*INVÁLIDAS: reasons
***************************************************************************

*reason 1 perdió el audio total
g reason1=.
replace reason1=1 if audit_empowerment==""
replace reason1=1 if caseid=="2485"
replace reason1=1 if caseid=="330"
replace reason1=1 if caseid=="2140"
replace reason1=1 if caseid=="1330"
replace reason1=1 if caseid=="1454" // audit
replace reason1=1 if caseid=="648"
replace reason1=1 if caseid=="5180"
replace reason1=1 if caseid=="5312"
replace reason1=1 if caseid=="5364"
replace reason1=1 if caseid=="5427"
replace reason1=1 if caseid=="5462"
replace reason1=1 if caseid=="5788"
replace reason1=1 if caseid=="5884"
replace reason1=1 if caseid=="5896"

*reason 2 perdió el audio de la entrevistada
g reason2=.
replace reason2=1 if caseid=="1476"
replace reason2=1 if caseid=="2902"
replace reason2=1 if caseid=="554"
replace reason2=1 if caseid=="3003"
replace reason2=1 if caseid=="32" // audit
replace reason2=1 if caseid=="1060" // audit
replace reason2=1 if caseid=="1760" // audit
replace reason2=1 if caseid=="1044" // audit

*reason 3 no lee opciones de respuesta en tipo convencional: mas de 3 opciones
g reason3=.
replace reason3=1 if caseid=="554"
replace reason3=1 if caseid=="2935"
replace reason3=1 if caseid=="956"
replace reason3=1 if caseid=="2116"
replace reason3=1 if caseid=="2975"
replace reason3=1 if caseid=="1057"
replace reason3=1 if caseid=="1128"
replace reason3=1 if caseid=="5341"
replace reason3=1 if caseid=="2383"
replace reason3=1 if caseid=="2640"
replace reason3=1 if caseid=="1437"

*REASON 04 no menciona números como respuesta
g reason4=.
replace reason4=1 if (emp_8==2 & procedure_numbers==0)
replace reason4=1 if caseid=="45"
replace reason4=1 if caseid=="1340"
replace reason4=1 if caseid=="1800"

*reason 5 no se escucha el beep del teclado
g reason5=.
replace reason5=1 if interrupciones_2t_2==1

*reason6 _no_teclado
g reason6=.
replace reason6=1 if caseid=="6146" // no sabe escribir o leer

*reason 7: marca antes de la palabra ahora *SE VALIDARÁN
g reason7=.
replace reason7=1 if ((emp_16==1 | emp_16==2) & procedure_teclado2==0)
replace reason7=1 if caseid=="6113"
replace reason7=1 if caseid=="1427"
replace reason7=1 if caseid=="5471"
replace reason7=1 if caseid=="1146"
replace reason7=1 if caseid=="1247"
replace reason7=1 if caseid=="1669"
replace reason7=1 if caseid=="1787"
replace reason7=1 if caseid=="1879"
replace reason7=1 if caseid=="1669"
replace reason7=1 if caseid=="2633"
replace reason7=1 if caseid=="436"
replace reason7=1 if caseid=="5235"
replace reason7=1 if caseid=="534"
replace reason7=1 if caseid=="5676"
replace reason7=1 if caseid=="7310"
replace reason7=1 if caseid=="7344"
replace reason7=1 if caseid=="7345"
replace reason7=1 if caseid=="759"
replace reason7=1 if caseid=="779"
replace reason7=1 if caseid=="969"
replace reason7=1 if caseid=="7303"

*reason 8 alguien estuvo al costado no siguio protocolo
g reason8=.
replace reason8=1 if caseid=="1493"


joinby caseid using "$baseline\home_c", unmatched(master) update 
save "$clean/clean_data", replace 
