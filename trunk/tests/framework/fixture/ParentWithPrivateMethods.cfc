<cfcomponent>
	
	<cffunction name="aParentPrivateMethod" access="private" returntype="string">
		<cfreturn "boo">
	</cffunction>
	
	<cffunction name="aParentPackageMethod" access="package" returntype="string">
		<cfreturn "foo">
	</cffunction>
	
</cfcomponent>