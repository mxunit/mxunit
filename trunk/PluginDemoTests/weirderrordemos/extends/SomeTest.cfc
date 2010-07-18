<cfcomponent extends="Extends">

	<cffunction name="thisShouldWorkAllTheTime" returntype="void" access="public">
		<cfset mxunit = "cool">
		<cfset debug(mxunit)>
	</cffunction>
	
</cfcomponent>