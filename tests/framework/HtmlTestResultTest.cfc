<cfcomponent  extends="mxunit.framework.TestCase">

<cfscript>
  htmlTestResult = createobject("component",'mxunit.framework.HtmlTestResult');
</cfscript>

<cffunction name="testPrintResources">
  <cfsavecontent variable="headers"><cfoutput>#htmlTestResult.printResources()#</cfoutput></cfsavecontent>
  <cfset debug( hash(headers)) />
  <cfset assertEquals("99727c519c66a21251ccf6b4c20163bd",hash(headers) , "Hash changed. Maybe something (even small) changed in the printResources method?") />
</cffunction>
</cfcomponent>
