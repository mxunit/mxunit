<cfset cfc = "mxunit.PluginDemoTests.HodgePodgeTest">

<!--- the plugin first invokes this for all selected tests; the "tree" reflects all current calls to this method --->
<cfinvoke component="mxunit.framework.RemoteFacade" method="getComponentMethods" returnVariable="methods" componentName="#cfc#">

<cfdump var="#methods#">

<!--- when a user selects tests in the tree and then hits the 'run' button, startTestRun is invoked to get a "testRunKey"
this key is passed for all subsequent function calls throughout the test run. This doesn't affect plugin behavior;
rather, it affects cache behavior in the mxunit framework on the server
 --->
<cfinvoke component="mxunit.framework.RemoteFacade" method="startTestRun" returnvariable="testRunKey">


<!--- the plugin then loops through all selections in the tree and creates a collection of TestCases and the selected TestMethods;
For each selected TestCase, it runs the selected TestMethods. Here's what it would look like if the CFC set above (HodgePodgeTest)
were selected in the tree and all its methods run
 --->
<cfloop from="1" to="#ArrayLen(methods)#" index="test">
	<cfinvoke component="mxunit.framework.RemoteFacade" method="executeTestCase" returnvariable="testResult" 
		componentName="#cfc#"
		methodNames="#methods[test]#"
		testRunKey="#testRunKey#">
	<h2><cfoutput>#methods[test]# -- #testResult[cfc][methods[test]]["result"]#</cfoutput></h2>
	<cfdump var="#testResult#" expand="false" label="#methods[test]# -- result"><p></p>
</cfloop>

<!--- after all tests are run, invoke the endTestRun method so that the cache is cleared on the server side --->
<cfinvoke component="mxunit.framework.RemoteFacade" method="endTestRun" testRunKey="#testrunKey#">