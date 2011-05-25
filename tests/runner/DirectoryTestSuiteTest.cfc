<cfcomponent generatedOn="12-12-2007 4:35:37 AM EST" extends="mxunit.framework.TestCase">


<cffunction name="testGetDirectoryQuery">
			<cfset var actual = "" />
			<cfset var q_thisdir = "" />

  Tests that the given directory retuns a query of the components contained therein
	<cfset makePublic(this.directoryTestSuite,"getDirectoryQuery","_getDirectoryQuery")>
  <cfinvoke component="#this.directoryTestSuite#"  method="_getDirectoryQuery" returnVariable="actual">
    <cfinvokeargument name="directory" value="#testDir#" />
    <cfinvokeargument name="recurse" value="true" />
  </cfinvoke>
  <cfdirectory directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="q_thisdir" filter="*.cfc">
  <cfset debug(actual) />
  <cfset assertIsQuery(actual) />
  <cfset assertEquals(actual.recordCount,q_thisdir.recordcount) />

</cffunction>

<cffunction name="getDirectoryQueryRecurseShouldRecurse">
	<cfset var targetDir = "" />
	<cfset var resultsNoRecurse = "" />
	<cfset var resultsWithRecurse = "" />
		<cfset makePublic(this.directoryTestSuite,"getDirectoryQuery","_getDirectoryQuery")>
		<cfset targetDir = rootDir & "/PluginDemoTests">
		<cfset resultsNoRecurse = this.directoryTestSuite._getDirectoryQuery(targetDir,false)>
		<cfset resultsWithRecurse = this.directoryTestSuite._getDirectoryQuery(targetDir,true)>
		<cfset assertTrue(resultsWithRecurse.RecordCount GT resultsNoRecurse.RecordCount,"recurse results [#ResultsWithRecurse.RecordCount#] should be greater than no-recurse results [#ResultsNoRecurse.RecordCount#]")>

</cffunction>

<cffunction name="testAccept">
	<cfset makePublic(this.directoryTestSuite,"accept","_accept")>
	<cfset assertTrue(this.directoryTestSuite._accept("TestSomething",""))>
	<cfset assertTrue(this.directoryTestSuite._accept("SomethingTest",""))>
	<cfset assertFalse(this.directoryTestSuite._accept("TstSomething",""))>
	<cfset assertFalse(this.directoryTestSuite._accept("SomethingTst",""))>
</cffunction>

<cffunction name="testAcceptExcludes">
	<cfset makePublic(this.directoryTestSuite,"accept","_accept")>
	<cfset assertFalse(this.directoryTestSuite._accept("TestSomething","TestSomething"))>
	<cfset assertTrue(this.directoryTestSuite._accept("TestSomething","TstSomething"))>
	<cfset assertFalse(this.directoryTestSuite._accept("SomethingTest","SomethingTest,TestSomething"))>
	<cfset assertFalse(this.directoryTestSuite._accept("SomethingTest","TestSomething,SomethingTest"))>
	<cfset assertTrue(this.directoryTestSuite._accept("SomethingTest","TestSomething,SomethingTst"))>
</cffunction>

<cffunction name="testAcceptExcludesDirectory">
	<cfset makePublic(this.directoryTestSuite,"accept","_accept")>
	<cfset assertTrue(this.directoryTestSuite._accept("runner.TestSomething","some.dir"))>
	<cfset assertFalse(this.directoryTestSuite._accept("runner.some.dir.TestSomething","some"))>
	<cfset assertFalse(this.directoryTestSuite._accept("runner.some.dir.TestSomething","dir"))>
	<cfset assertFalse(this.directoryTestSuite._accept("runner.some.dir.TestSomething","runner"))>
</cffunction>

<cffunction name="testAcceptExcludesCompoundDirectory">
	<cfset makePublic(this.directoryTestSuite,"accept","_accept")>
	<cfset assertFalse(this.directoryTestSuite._accept("runner.some.dir.TestSomething","some/dir"))>
	<cfset assertFalse(this.directoryTestSuite._accept("tests.business.library.TestSomething","business/library,business/attachments"))>
	<cfset assertTrue(this.directoryTestSuite._accept("tests.interface.library.TestSomething","business/library,business\attachments"))>
	<cfset assertFalse(this.directoryTestSuite._accept("tests.interface.library.TestSomething","business/library,business\attachments,library"))>
</cffunction>

<cffunction name="testAcceptExcludesCompoundFuzzy">
	<cfset makePublic(this.directoryTestSuite,"accept","_accept")>
	<cfset assertTrue(this.directoryTestSuite._accept("runner.some.dir.TestMyLibrary","library"))>
	<cfset assertFalse(this.directoryTestSuite._accept("runner.some.library.TestMyLibrary","library"))>

</cffunction>



<cffunction name="testGetComponentPath">
	<cfset var actual = "" />
  Tests to see if given directory returns tha component path as seen by CF
  <cfinvoke component="#this.directoryTestSuite#"  method="getComponentPath" returnVariable="actual">
    <cfinvokeargument name="path" value="#testDir#" />
    <cfinvokeargument name="refreshCache" value="true" />
  </cfinvoke>
  <cfset debug(actual) />
  <cfset assertEquals("mxunit.tests.runner",actual,"Should return the package that contains these tests.") />

</cffunction>


<cffunction name="testRun">
	<cfset var sep = cu.getSeparator()>
	<cfset var testResult = "" />
	<cfset var testResult2 = "" />
  <cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
	<!--- make sure it works without trailing slashes --->
    <cfinvokeargument name="directory" value="#rootDir#/PluginDemoTests#sep#SubDir" />
	<cfinvokeargument name="componentPath" value="mxunit.PluginDemoTests.SubDir">
    <cfinvokeargument name="recurse" value="false" />
    <cfinvokeargument name="excludes" value="false" />
    <cfinvokeargument name="refreshCache" value="false" />
  </cfinvoke>
 <!---  <cfset debug(testResult.results) /> --->
  <cfset assertIsTypeOf(testResult,"mxunit.framework.TestResult","Should be a TestResult object") />
	<cfset assertTrue(ArrayLen(testResult.getResults()) GT 0)>
<!--- make sure it works with trailing slashes --->
 <cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult2">
    <cfinvokeargument name="directory" value="#rootDir#/PluginDemoTests#sep#SubDir#sep#" />
	<cfinvokeargument name="componentPath" value="mxunit.PluginDemoTests.SubDir">
    <cfinvokeargument name="recurse" value="false" />
    <cfinvokeargument name="excludes" value="false" />
    <cfinvokeargument name="refreshCache" value="false" />
  </cfinvoke>
  <!---  <cfset debug(testResult.results) />  --->
  <cfset assertIsTypeOf(testResult2,"mxunit.framework.TestResult","Should be a TestResult object") />
	<cfset assertEquals(ArrayLen(testResult.getResults()),ArrayLen(testResult2.getResults()))>


</cffunction>

<cffunction name="testRunWithRelativeDirectoryShouldPass">
	  <cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
		<!--- make sure it works without trailing slashes --->
	    <cfinvokeargument name="directory" value="/mxunit/PluginDemoTests/SubDir" />
		<cfinvokeargument name="componentPath" value="mxunit.PluginDemoTests.SubDir">
	    <cfinvokeargument name="recurse" value="true" />
	    <cfinvokeargument name="refreshCache" value="false" />
	  </cfinvoke>
	  <cfset debug(testResult)>
	   <cfset assertIsTypeOf(testResult,"mxunit.framework.TestResult","Should be a TestResult object") />
	<cfset assertTrue(ArrayLen(testResult.getResults()) GT 0)>
</cffunction>

<cffunction name="testRunWithBadRelativeDirectoryShouldFail">

	 <cftry>

	  <cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
		<!--- make sure it works without trailing slashes --->
	    <cfinvokeargument name="directory" value="/mxunit/PluginDemoTests/SubDirx" />
		<cfinvokeargument name="componentPath" value="mxunit.PluginDemoTests.SubDir">
	    <cfinvokeargument name="recurse" value="true" />
	    <cfinvokeargument name="refreshCache" value="false" />
	  </cfinvoke>

	  <cfthrow type="custom" message="should not throw this error">
	<cfcatch type="custom">
		<cfthrow message="should not have gotten into this catch. instead, should've thrown an error inside the DirectoryTestSuite itself">
	</cfcatch>

	<cfcatch type="any">
	</cfcatch>
	</cftry>

</cffunction>

<cffunction name="componentWithParseErrorShouldBeInTestResult">
	<cfset var s_results = "" />
	<cfset var resultskey = "" />
	<cfset var testResult = "" />
	<cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
		<!--- 122 is the bugID that caused this test --->
	    <cfinvokeargument name="directory" value="#fixturedir#/122/" />
		<cfinvokeargument name="componentPath" value="mxunit.tests.bugs.fixture.122">
	    <cfinvokeargument name="recurse" value="false" />
	    <cfinvokeargument name="excludes" value="false" />
	    <cfinvokeargument name="refreshCache" value="false" />
  	</cfinvoke>
	<cfset s_results = testResult.getResultsAsStruct()>
	<cfset debug(s_results)>

	<cfset assertEquals( 2, StructCount(s_results),  "Should have 2 struct keys: one for the GoodTest and one for the BadTest")>
	<cfset resultskey = s_results["mxunit.tests.bugs.fixture.122.ParseErrorTest"][1]>
	<cfset assertTrue( StructKeyExists(resultskey,"debug") )>
	<cfset assertTrue( StructKeyExists(resultskey,"error") )>
	<cfset assertEquals( "ParseErrorTest",resultskey.testname )>

</cffunction>

<cffunction name="testRunBadDirectory">
	<cfset var testResult = "" />
	<cftry>

	  <cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
	    <cfinvokeargument name="directory" value="#rootDir#NoOneHomePleaseGoAwayNow" />
	    <cfinvokeargument name="componentPath" value="mxunit.tests">
	    <cfinvokeargument name="recurse" value="false" />
	    <cfinvokeargument name="excludes" value="false" />
	    <cfinvokeargument name="refreshCache" value="false" />
	  </cfinvoke>
		<cfthrow type="custom" message="should not throw this error">
	<cfcatch type="custom">
		<cfthrow message="should not have gotten into this catch. instead, should've thrown an error inside the DirectoryTestSuite itself">
	</cfcatch>

	<cfcatch type="any">
	</cfcatch>
	</cftry>
</cffunction>


<cffunction name="testExcludes">
	<cfset var test = "" />
	<cfset var testResult = "" />
	<cfinvoke component="#this.directoryTestSuite#"  method="run" returnVariable="testResult">
		<cfinvokeargument name="directory" value="#rootDir#/PluginDemoTests/inheritance" />
		<cfinvokeargument name="componentPath" value="mxunit.PluginDemoTests.inheritance">
		<cfinvokeargument name="recurse" value="false" />
		<cfinvokeargument name="excludes" value="SomeExtendingTest" />
		<cfinvokeargument name="refreshCache" value="false" />
	</cfinvoke>

	<cfset assertTrue(ArrayLen(testResult.Results) GT 0, "test should have returned results")>
	<cfloop from="1" to="#ArrayLen(testResult.Results)#" index="test">
		<cfif findNoCase("SomeExtendingTest",testResult.Results[test].Component)>
			<cfset fail("found SomeExtendingTest but should not have")>
		</cfif>
	</cfloop>


</cffunction>

<cffunction name="testNormalizeDirectory">
	<cfset var startdir = expandPath("/mxunit")>
	<cfset var dir = "" />
	<cfset var dir2 = "" />
	<cfset debug("startdir is #startdir#")>
	<cfset makePublic(this.DirectoryTestSuite,"normalizeDirectory")>
	<cfset dir = this.directoryTestSuite.normalizeDirectory(startdir)>
	<cfset debug(dir)>
	<cfset assertEquals(startdir & cu.getSeparator(),dir)>
	<cfset dir2 = this.directoryTestSuite.normalizeDirectory(dir)>
	<cfset assertEquals(dir,dir2)>
</cffunction>

<cffunction name="testGetTests">
	<cfset var thisdir = getDirectoryFromPath(getCurrentTemplatePath())>
	<cfset var a_results = "" />
	<cfset var compPath = "mxunit.tests.runner">
	<cfset makePublic(this.directoryTestSuite,"getTests")>
	<!--- this test currently fails in railo b/c of bug https://jira.jboss.org/jira/browse/RAILO-66  --->
	<cfset a_results = this.directoryTestSuite.getTests(thisdir,comppath)>

	<cfset assertTrue( not find("..",a_results[1]),"should not find two periods in a test path"   )>
</cffunction>



<!--- Override these methods as needed. Note that the call to setUp() is Required if using a this-scoped instance--->

<cffunction name="setUp">
<!--- Assumption: Instantiate an instance of the component we want to test --->
<cfset this.directoryTestSuite = createObject("component","mxunit.runner.DirectoryTestSuite") />
<cfset variables.cu = createObject("component","mxunit.framework.ComponentUtils")>

<cfset variables.rootDir = expandPath("/mxunit")>
<cfset variables.testDir = variables.rootDir &  "/tests/runner/"/>
<cfset variables.fixtureDir = variables.rootDir & "/tests/bugs/fixture/">
<cfset debug(variables.rootDir)>
</cffunction>

<cffunction name="tearDown">
</cffunction>


</cfcomponent>
