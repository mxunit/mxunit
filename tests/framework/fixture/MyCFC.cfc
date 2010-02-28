<cfcomponent displayname="MyCFC">
 	<cfproperty name="temp1" type="string">
	<cfproperty name="temp2" type="string">
	
	<cffunction name="init" returntype="MyCFC">
		<cfset VARIABLES.temp1 = 3>
		<cfset VARIABLES.temp2 = 2>
		<cfreturn THIS>
	</cffunction>
	
	<cffunction name="add" returntype="numeric">
			<cfreturn (VARIABLES.temp1 + VARIABLES.temp2)>
	</cffunction>
	
	<cffunction name="sub" returntype="numeric">
			<cfreturn (VARIABLES.temp1 - VARIABLES.temp2)>
	</cffunction>
</cfcomponent>
