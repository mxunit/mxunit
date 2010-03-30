<cfcomponent  extends="mxunit.framework.TestCase">

<cfscript>
  htmlTestResult = createobject("component",'mxunit.framework.HTMLTestResult');
</cfscript>

<cffunction name="testPrintResources">
  <cfsavecontent variable="headers"><cfoutput>#htmlTestResult.printResources()#</cfoutput></cfsavecontent>
  <cfset debug( hash(headers)) />
  <cfset assertEquals("058B7322CA4B620AD8A1E19B0B32CB77",hash(headers) , "Hash changed. Maybe something (even small) changed in the printResources method?") />
</cffunction>
</cfcomponent>
