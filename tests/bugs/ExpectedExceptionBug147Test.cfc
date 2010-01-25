<cfcomponent extends="mxunit.framework.TestCase">



<!---

 Bug #147. cfcatch.type may be Expression or Application or ?? when developers
are expecting coldfusion.runtime.MissingArgumentException
--->
<cffunction name="$testGetClientInformationNoClient_ID">
   <cfset var strReturn = "" />
   <!--- missing required parameter: no Client_ID --->
   <cftry>
      <cfset stReturn = variables.getClientInformation() />
      <cfset fail("Failed to catch a missing parameter when calling getClientInformation().") />
   <cfcatch type="coldfusion.runtime.MissingArgumentException">
      <!--- expected error, let's not worry about --->
   </cfcatch>
   <cfcatch type="any">
      <cfset fail("Expected to see coldfusion.runtime.MissingArgumentException, but instead saw #cfcatch.type# when calling getClientInformation().") />
   </cfcatch>
   </cftry>
</cffunction>


<cffunction name="testGetClientInformationNoClient_ID" mxunit:expectedException="coldfusion.runtime.MissingArgumentException">
   <cfset var strReturn = "" />
   <!--- missing required parameter: no Client_ID --->
   <cfset stReturn = variables.getClientInformation() />
</cffunction>


<cffunction name="peep">
 <cftry>
   <cfset stReturn = variables.getClientInformation() />
  <cfcatch type="any">
   <cfdump var="#getMetaData(cfcatch).getName()#" />
   <cfdump var="#cfcatch#" />

  </cfcatch>
 </cftry>
</cffunction>


<cffunction name="getClientInformation" access="private">
 <cfargument name="foo" required="true" />
 <cfthrow type="coldfusion.runtime.MissingArgumentException" />
</cffunction>

</cfcomponent>