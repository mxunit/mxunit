<cfparam name="URL.output" default="extjs">
<cfparam name="URL.quiet" default="false">

<cfset dir = expandPath("../PluginDemoTests")>
<!--- <cfset dir = expandPath(".")> --->
<cfoutput><h1>#dir#</h1></cfoutput>

<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>
<cfset excludes = "InvalidMarkupTest,FiveSecondTest">
<cfinvoke component="#DTS#"
  method="run"
  directory="#dir#"
  recurse="true"
  excludes="#excludes#"
  returnvariable="Results"
  componentPath="mxunit.PluginDemoTests" />

<cfif NOT URL.quiet>
  <cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
    <cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
  </cfif>

  <cfsetting showdebugoutput="true">
  <cfoutput>#results.getResultsOutput(URL.output)#</cfoutput>
</cfif>


<!--- SOME OTHER THINGS YOU COULD DO --->
<!--- <cffile action="write" file="#getDirectoryFromPath(getCurrentTemplatePath())#\JunitXMLResults.xml" output="#results.getJUnitXMLResults()#">
 --->


<!---
<cfdump var="#results.getResults()#" expand="false">
<cfdump var="#results.getResultsAsStruct()#" expand="false">
<cfdump var="#results.getDebug()#"> --->