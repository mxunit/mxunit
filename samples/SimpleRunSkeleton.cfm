<cfparam name="URL.output" default="extjs">

<cfset dir = expandPath(".")> 
<cfoutput><h1>#dir#</h1></cfoutput>

<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>
<cfset excludes = "">
<cfinvoke component="#DTS#" 
	method="run"
	directory="#dir#" 
	recurse="true" 
	excludes="#excludes#"
	returnvariable="Results"
	componentpath="????.????"> <!---  <-- Fill this in! This is the root component path for your tests. if your tests are at {webroot}/app1/test, then your componentpath will be app1.test   --->

	
<cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
	<cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
</cfif>

<cfsetting showdebugoutput="true">
<cfoutput>#results.getResultsOutput(URL.output)#</cfoutput> 