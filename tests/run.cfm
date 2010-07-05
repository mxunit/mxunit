<!---
NOTE: these tests take a long time to run. A lot of the time is in a subset of tests that use CF's built-in component explorer, which is a pig. In addition, the EXT output is slower than the HTML output.

--->
<cfsetting requesttimeout="300">


<cfparam name="url.output" default="extjs">
<cfparam name="url.debug" default="false">
<cfparam name="url.quiet" default="false">

<cfset dir = getDirectoryFromPath(getCurrentTemplatePath()) />
<cfset DTS = createObject("component","mxunit.runner.DirectoryTestSuite")>


<cfset excludes = "fixture,samples,install">

<cfinvoke component="#DTS#" 
	method="run"
	directory="#dir#"
	componentpath="mxunit.tests" 
	recurse="true" 
	excludes="#excludes#"
	returnvariable="Results">
	
<cfif not url.quiet>
	
	<cfif NOT StructIsEmpty(DTS.getCatastrophicErrors())>
		<cfdump var="#DTS.getCatastrophicErrors()#" expand="false" label="#StructCount(DTS.getCatastrophicErrors())# Catastrophic Errors">
	</cfif>
	
	<cfsetting showdebugoutput="true">
	<cfoutput>#results.getResultsOutput(url.output)#</cfoutput>
	
	<cfif isBoolean(url.debug) AND url.debug>
		<div class="bodypad">
			<cfdump var="#results.getResults()#" label="Debug">
		</div>
	</cfif>

</cfif>

<!--- 
<cfdump var="#results.getDebug()#"> --->