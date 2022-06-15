<cfcomponent>
    <cfset webServiceURL = 'https://tckimlik.nvi.gov.tr/Service/KPSPublicV2.asmx'>
    <cffunction name="tckn_verification" access="remote" returntype="string" returnFormat="json">
        <cfargument  name="ad" type="string"  >
        <cfargument  name="soyad" type="string"  >
        <cfargument  name="tckimlik" type="string"  >
        <cfargument  name="gun" type="string"  >
        <cfargument  name="ay" type="string"  >
        <cfargument  name="yil" type="string"  >
        <cfxml variable="tckn_verification">
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://tckimlik.nvi.gov.tr/WS">
                <soapenv:Body>
                    <ws:KisiVeCuzdanDogrula>
                    <ws:TCKimlikNo><cfoutput>#tckimlik#</cfoutput></ws:TCKimlikNo>
                    <ws:Ad><cfoutput>#ad#</cfoutput></ws:Ad>
                    <ws:Soyad><cfoutput>#soyad#</cfoutput></ws:Soyad>
                    <ws:DogumGun><cfoutput>#gun#</cfoutput></ws:DogumGun>
                    <ws:DogumAy><cfoutput>#ay#</cfoutput></ws:DogumAy>
                    <ws:DogumYil><cfoutput>#yil#</cfoutput></ws:DogumYil>
                    </ws:KisiVeCuzdanDogrula>
                </soapenv:Body>
            </soapenv:Envelope>
        </cfxml>
        <cftry>
            <cfhttp url="#webServiceURL#" method="post" result="httpResponse">
                <cfhttpparam type="header" name="content-type" value="text/xml; charset=utf-8">
                <cfhttpparam type="header" name="content-length" value="#len(trim(tckn_verification))#">
                <cfhttpparam type="header" name="SOAPAction" value="http://tckimlik.nvi.gov.tr/WS/KisiVeCuzdanDogrula">
                <cfhttpparam type="body"  value="#trim(tckn_verification)#">
            </cfhttp>

            <cfset response = xmlParse(httpResponse.filecontent).Envelope.Body.XmlChildren[1].XmlChildren[1]>
            <cfif response.XmlText EQ "true">
                <cfset method.name = response.xmlName>
                <cfset method.status = true>
            <cfelse> 
                <cfset method.status = false>
            </cfif>
        <cfcatch type="any">
            <cfset result.status = false>
            <cfset result.error = cfcatch >
        </cfcatch>
        </cftry>
        <cfreturn Replace(SerializeJSON(method),'//','')>
    </cffunction>
</cfcomponent>