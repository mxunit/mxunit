<cfcomponent>
	<cffunction name="throwError">
		<cfthrow message="this is an error">
	</cffunction>
	
	<cffunction name="throwError2">
		<cfset throwError()>
	</cffunction>
</cfcomponent>