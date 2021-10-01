
*==============================================================================
* Zonas 
*==============================================================================

* por municipalidad 

		gen z_centro=0 
		replace centro=1 if municipality=="SAN MARCOS" | municipality=="ESQUIPULAS PALO GORDO" |municipality=="SAN ANTONIO SACATEPEQUEZ" |municipality=="SAN CRISTOBAL CUCHO" |municipality=="RIO BLANCO" |municipality=="SAN LORENZO"| municipality=="SAN PEDRO SACATEPEQUEZ" 

		gen z_altiplano=0 

		replace altiplano=1 if municipality=="SAN JOSE OJETENAM"| municipality=="SAN MIGUEL IXTAHUACAN"|municipality=="SIBINAL"|municipality=="SIPACAPA"|municipality=="TACANA"|municipality=="TAJUMULCO"|municipality=="TEJUTLA"|municipality=="COMITANCILLO"|municipality=="CONCEPCION TUTUAPA"| municipality=="IXCHIGUAN" 

		gen z_costa=0 
		replace costa=1 if municipality=="AYUTLA"|municipality=="CATARINA"|municipality=="EL QUETZAL"| municipality=="EL RODEO"| municipality=="EL TUMBADOR"| municipality=="LA BLANCA"| municipality=="SAN RAFAEL PIE DE LA CUESTA"| municipality=="LA REFORMA"| municipality=="MALACATAN"| municipality=="NUEVO PROGRESO"|municipality=="OCOS"|municipality=="PAJAPITA"|municipality=="SAN PABLO" 

 
  
 
 