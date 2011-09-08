<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="expectedMXUnitFailureShouldNotBeThrownAfterCaughtCustomException" mxunit:expectedException="my.exception.Foo">
		<cfthrow type="my.exception.Foo" message="custom exception thrown" detail="blah blah blah" />

		<cfset fail('This should be caught and exception added to debug') />
	</cffunction>

	<cffunction name="expectedSQLExceptionShouldBeCaught" mxunit:expectedException="Database,java.sql.SQLException">
		<cfquery name="q" datasource="ad">
		</cfquery>
	</cffunction>

	<cffunction name="expectedExpressionExceptionShouldBeCaught" mxunit:expectedException="Expression">
		<cfset foo=bar />
	</cffunction>

	<cffunction name="makeSureFailureHappensAndOldStyleWorks">
		<cftry>
			<cfset foo=bar />

			<cfset fail('should not get here') />

			<cfcatch type="Expression">
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="listOfExpectedExceptionsShouldBeCaught" mxunit:expectedException="Database,Expression">
		<cfset x = foo>
	</cffunction>

	<!--- we need this b/c we can't otherwise test the case where an exception is expected but not thrown --->
	<cffunction name="suiteOfExpectedExceptionsShouldReportFailures">
		<cfset var compName = "mxunit.tests.framework.fixture.TestWithExpectedExceptionAttributes">
		<cfset var result = "">
		<cfset var testSuite = createObject("component","mxunit.framework.TestSuite").TestSuite()>
		<cfset var passed = "">
		<cfset var failed = "">

		<cfset testSuite.addAll(compName)>
		<cfset result = testSuite.run()>
		<cfset resultStruct = result.getResultsAsStruct()>

		<cfset failed = structFindValue(resultStruct,"a_shouldFailBecauseExpectedExceptionNotThrown")>
		<cfset assertEquals("Failed",failed[1].owner.TestStatus)>

		<cfset failed = structFindValue(resultStruct,"b_shouldFailBecauseExpectedExceptionListNotThrown")>
		<cfset assertEquals("Failed",failed[1].owner.TestStatus)>

		<cfset passed = structFindValue(resultStruct,"c_shouldPassBecauseExpectedExceptionThrown")>
		<cfset assertEquals("Passed",passed[1].owner.TestStatus)>
	</cffunction>

	<cffunction name="shouldCatchMissingArgumentException" mxunit:expectedException="coldfusion.runtime.MissingArgumentException">
		<cfthrow type="coldfusion.runtime.MissingArgumentException">

		<cfset throwMissingArgumentException() />
	</cffunction>

	<cffunction name="throwMissingArgumentException" access="private">
		<cfargument name="foo" required="true" />
	</cffunction>

	<cffunction name="testThrowSingleEntryNameExceptionUsingAnnotation" expectedException="MyCustomException">
	   <cfthrow type="MyCustomException">
	</cffunction>

	<cffunction name="testThrowExceptionWithPackageNotationUsingAnnotation" expectedException="com.foo.MyCustomException">
	   <cfthrow type="com.foo.MyCustomException">
	</cffunction>

	<cffunction name="oldSkoolBasicError" expectedException="foo.bar.exception">
		<cftry>
		 <cfthrow type="asd.zxc" />
		<cfcatch type="asd.zxc">
			<cfthrow type="foo.bar.exception" />
		</cfcatch>
		</cftry>

	</cffunction>


	<cfscript>
		function expectedExceptionTestUsingScriptMethodAndSingleName(){
			expectException("Bar");
			_throw("Bar");
		}

		function expectedExceptionTestUsingScriptMethodAndPackageNotation(){
			expectException("com.foo.Bar");
			_throw("com.foo.Bar");
		}

		function expectedExceptionShouldSetPropertyInTestCase(){
			expectException("my.funny.ValantineException");
			assertEquals( "my.funny.ValantineException", this.getExpectedExceptionType() );
			expectException("");
		}

	</cfscript>

	<cffunction name="_throw" access="private">
	  <cfthrow type="#arguments[1]#" message="Custom Exception for unit tests.">
	</cffunction>

</cfcomponent>
