<cfcomponent  extends="mxunit.framework.TestCase">

<cfscript>
  htmlTestResult = createobject("component",'mxunit.framework.HtmlTestResult');
</cfscript>

<cffunction name="testContainsTitleTag">
	<cfset expectedTitle = "TEST TITLE"/>
  <cfsavecontent variable="headers"><cfoutput>#htmlTestResult.printResources("/mxunit", expectedTitle)#</cfoutput></cfsavecontent>
  <cfset assertTrue(findNoCase("<title>#expectedTitle#</title>", headers), "The HTML title tag is missing or incorrect.") />
</cffunction>

<cffunction name="testContainsAtLeastOneScript">
	<cfset expectedRootPath = "#getContextRoot()#/mxunit"/>
  <cfsavecontent variable="headers"><cfoutput>#htmlTestResult.printResources(expectedRootPath)#</cfoutput></cfsavecontent>
  <cfset assertTrue(findNoCase('<script type="text/javascript" src="#expectedRootPath#/resources', headers), "The HTML script tags are missing or incorrect.") />
</cffunction>

<cffunction name="testContainsAtLeastOneStylesheet">
	<cfset expectedRootPath = "#getContextRoot()#/mxunit"/>
  <cfsavecontent variable="headers"><cfoutput>#htmlTestResult.printResources(expectedRootPath)#</cfoutput></cfsavecontent>
  <cfset assertTrue(findNoCase('<link rel="stylesheet" type="text/css" href="#expectedRootPath#/resources', headers), "The HTML link tags are missing or incorrect.") />
</cffunction>

</cfcomponent>
