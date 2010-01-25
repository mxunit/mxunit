<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="testFail" returntype="void" hint="">
		<cfoutput>wooopity doo!</cfoutput>
		<cfset debug("blah")>
		<cfset fail("failing intentionally")>
	</cffunction>

</cfcomponent>