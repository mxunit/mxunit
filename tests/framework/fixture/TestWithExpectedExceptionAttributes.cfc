<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="a_shouldFailBecauseExpectedExceptionNotThrown" mxunit:expectedException="Database">
		<cfset x = 5/0>
	</cffunction>
	
	<cffunction name="b_shouldFailBecauseExpectedExceptionListNotThrown" mxunit:expectedException="Database,Application">
		<cfset x = 5/0>
	</cffunction>
	
	<cffunction name="c_shouldPassBecauseExpectedExceptionThrown" mxunit:expectedException="Expression">
		<cfset x = 5/0>
	</cffunction>
	

</cfcomponent>