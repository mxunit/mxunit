<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">
		<cfset mxunit = cool>
	</cffunction>

	<cffunction name="thisShouldWorkAllTheTime" returntype="void" access="public">
		<cfset mxunit = "cool">
		<cfset debug(mxunit)>
	</cffunction>
	
</cfcomponent>