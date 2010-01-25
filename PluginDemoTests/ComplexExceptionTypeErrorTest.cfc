<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
				
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="willThrowFunkyNonArrayException" returntype="void" access="public">
		<!--- hit "b" key in eclipse to see the cfcatch dump. funky, huh?--->
		<cfset s = structnew()>
		<cfset arrayAppend(s,"one")>			
	</cffunction>
	
</cfcomponent>