<cfcomponent output="false">
<!---
  fixture for Spy or partial mock implementation.

  NOTE: Mock should also invoke or mock parent methods, too.
        also should be able to accept any init params.
 --->

  <cffunction name="init">
    <cfreturn this />
  </cffunction>

	<cffunction name="parentSpy" access="public" output="false" returntype="Any">
		<cfreturn 'This is a parent method' />
	</cffunction>


</cfcomponent>