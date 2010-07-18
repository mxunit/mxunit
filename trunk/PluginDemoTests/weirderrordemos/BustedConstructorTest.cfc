<cfcomponent extends="mxunit.framework.TestCase">

	<cfset mxunit = cool>

	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
	</cffunction>

	<cffunction name="thisShouldWorkAllTheTime" returntype="void" access="public">
		<cfset mxunit = "cool">
		<cfset debug(mxunit)>
	</cffunction>


</cfcomponent>