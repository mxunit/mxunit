<!--- 
PURPOSE: for help with debugging test cases when things go hairy.

this runs a test directly, through a test suite, and through the RemoteFacade url (how eclipse sends the tests to CF for running)

 --->


<!--- change these as necessary --->
<cfset mycomponent = "mxunit.PluginDemoTests.HodgePodgeTest">
<cfset myfunction = "testNotEquals">
<cfset remoteURL = "http://localhost/mxunit/framework/RemoteFacade.cfc?wsdl">


<!---should be no need to change anything below here --->

<!--- first, make sure we can create the object normally --->
<cfset obj = createObject("component",mycomponent)>

<!--- now run a test in that component --->
<h1>running test directly</h1>

<cftry>
	<cfinvoke component="#obj#" method="#myfunction#">
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>



<!--- now run the test like we'd run it using a TestSuite --->
<h1>running test through test suite</h1>
<cfset obj = createObject("component",mycomponent)>
<cfset testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite()>
<cfset testSuite.add(mycomponent,myfunction,obj)>
<cfset results = testSuite.run()>  
<cfdump var="#results.getResults()#" expand="false" label="results when running through test suite">

<!--- now run that same component using the remote facade --->
<h1>running test through remote facade</h1>
<cfinvoke webservice="#remoteURL#" method="ping" returnvariable="pingResults" refreshwsdl="true">
<cfoutput>Ping result: #pingResults#</cfoutput><br>

<cfinvoke webservice="#remoteURL#" method="getServerType" returnvariable="serverTypeResults">
<cfoutput>Server Type: #serverTypeResults#</cfoutput><br>



<cfinvoke   webservice="#remoteURL#" method="executeTestCase" componentName="#mycomponent#" methodNames="#myfunction#" TestRunKey="" returnvariable="remoteRunResults">

<cfdump var="#remoteRunResults#" label="remoteRunResults" expand="false">