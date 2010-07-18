<cfcomponent output="false">
	
	<cfset internalVar = "foo">
	<cfset internalVar2 = "bar">
	
	<cfset variables.instance = StructNew()>

  <cffunction name="init">
   <cfreturn this />
  </cffunction>
    <cffunction name="doSomething">
     <cfreturn "foo" />

    </cffunction>
	
	<cffunction name="doSomethingElse">
		<cfreturn "boo">
	</cffunction>
	
	<cffunction name="doSomethingPrivate" access="private">
		<cfreturn "poo">
	</cffunction>
	
	<cffunction name="doSomethingPackage" access="package">
		<cfreturn "goo">
	</cffunction>
	
	<cffunction name="callDoSomethingPrivate">
		<cfreturn doSomethingPrivate()>
	</cffunction>
	
	<cffunction name="getInternalVar">
		<cfreturn internalVar>
	</cffunction>
	
	<cffunction name="getInstance">
		<cfreturn variables.instance>
	</cffunction>

</cfcomponent>