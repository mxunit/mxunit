<cfcomponent hint="A arbitrary component used for testing">


<cffunction name="add" access="public" returntype="numeric">
 <cfargument name="num1">
 <cfargument name="num2">
 <cfreturn num1+num2>
</cffunction>


<cffunction name="append" access="public" returntype="string">
 <cfargument name="val">
 <cfreturn "MY VALUE  ... " & val >
</cffunction>





</cfcomponent>