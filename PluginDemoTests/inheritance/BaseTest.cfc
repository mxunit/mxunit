<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="testSomethingSimple">
		<cfset assertTrue(true)>
	</cffunction>
	
	<cffunction name="testSomethingThatWillFail">
		<cfset fail("failing in BaseTest")>
	</cffunction>

</cfcomponent>