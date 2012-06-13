<cfcomponent>


	<cffunction name="doSomething" output="true">
		<cfdump var="#StructNew()#">
		
		<cfthrow message="you ain't gonna see that struct">
	</cffunction>
	
	<cffunction name="doSomethingThenExitToGetDump" output="false">
		<cfdump var="#StructNew()#">
		
		<cfexit method="exittemplate">
		
		<cfthrow message="you ain't gonna see that struct">
	</cffunction>
	
	<cffunction name="thisWillOnlyWorkInThePlugin">
		<cfset request.debug("coming from SomeObject.cfc")>
		<cfset request.debug("and some more!")>
	</cffunction>
	
	<cffunction name="append">
		<cfargument name="stuff">
		<cfreturn "foo #stuff#">
	</cffunction>
	
	<cffunction name="append2">
		<cfargument name="stuff">
		<cfreturn "foo #stuff#">
	</cffunction>
	
</cfcomponent>