
<cfcomponent name="MyComponentTest" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<cffunction name="testadd" access="public" returnType="void">
		
		<cfset fail("Test testadd not implemented")>
		
	</cffunction>		
	
	<cffunction name="testappend" access="public" returnType="void">
		
		<cfset fail("Test testappend not implemented")>
		
	</cffunction>		
	

	<!--- setup and teardown --->
	
	<cffunction name="setUp" returntype="void" access="public">
		
		<cfset this.myComp = createObject("component","mxunit.samples.MyComponent")>	
		
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

