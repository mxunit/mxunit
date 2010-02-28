<cfcomponent hint="Contains non-sensical assertions to test dynamic creation" output="false">


	<cffunction name="assertFoo" access="public" output="false" returntype="boolean">
		<!--- Note that we are not testing the assertion. We
          are only asserting that this method was called    
     --->
    <cfreturn true />
	</cffunction>

	<cffunction name="assertBar" access="public" output="false" returntype="boolean">
			<!--- Note that we are not testing the assertion. We
          are only asserting that this method was called    
     --->
    <cfreturn false />
	</cffunction>
</cfcomponent>