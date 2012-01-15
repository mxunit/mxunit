<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="beforeTests" access="public" output="false" returntype="void">
		<cfscript>
			variables.oRunner			= createObject("component", "mxunit.runner.HttpAntRunner");
		</cfscript>
	</cffunction>
	
	<cffunction name="testRunWipingOutCfSaveContent" access="public" output="false" returntype="void" hint="">
		<cfscript>
			var sResults				= "";
			var stArgs					= {
				type					= "testcase",
				value					= "mxunit.tests.runner.HttpAntRunnerUtilTest"
			};
			var xResults				= false;
			var nFailures				= 0;
			var nErrors					= 0;
		</cfscript>
		<cfsavecontent variable="sResults">
			<cfset variables.oRunner.run(argumentCollection = stArgs)>
		</cfsavecontent>
		<cfscript>
			assertTrue(isXml(sResults), "HttpAntRunner.run() should return an xml string");
			xResults					= xmlParse(sResults);
			nFailures					= xResults.testsuite.xmlAttributes.failures;
			nErrors						= xResults.testsuite.xmlAttributes.errors;
			assertEquals(0, nFailures, "There should be 0 failures");
			assertEquals(0, nErrors, "There should be 0 errors");
		</cfscript>
	</cffunction>
</cfcomponent>