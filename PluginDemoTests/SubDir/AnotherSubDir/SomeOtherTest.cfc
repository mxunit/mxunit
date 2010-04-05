<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="testSomething" returntype="void" access="public">
		<cfset assertTrue(true,"hi mom!")>
		
	</cffunction>
	
	<cffunction name="thisShouldThrowAnError">
		<cfinvoke component="SomeComponentWithStuff" method="throwError2">
	</cffunction>

</cfcomponent>