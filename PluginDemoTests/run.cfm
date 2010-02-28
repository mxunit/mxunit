<html>

<head></head>
<body>

<cfsetting showdebugoutput="true">
<cfsetting requesttimeout="300">
<cfparam name="url.output" default="extjs">

<cfset dir = expandPath(".")>

<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>

<cfinvoke component="#DTS#" 
	method="run"
	directory="#dir#"
	componentpath="mxunit.PluginDemoTests" 
	recurse="true" 
	excludes="FiveSecondTest"
	returnvariable="Results">
	
<cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
	<cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
</cfif>

<cfsetting showdebugoutput="true">
<cfoutput>#results.getResultsOutput(url.output)#</cfoutput>

<!--- 
<cfdump var="#results.getResults()#">
<cfdump var="#results.getDebug()#"> --->

</body>
</html>