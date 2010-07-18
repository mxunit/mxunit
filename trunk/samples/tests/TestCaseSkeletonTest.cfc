
<cfcomponent name="TestCaseSkeletonTest" extends="mxunit.framework.TestCase">
	<!--- Begin specific tests --->
	
	<cffunction name="testsetUp" access="public" returnType="void">
		
		<cfset fail("Test testsetUp not implemented")>
		
	</cffunction>		
	
	<cffunction name="testtearDown" access="public" returnType="void">
		
		<cfset fail("Test testtearDown not implemented")>
		
	</cffunction>		
	
	<cffunction name="testtestXXX" access="public" returnType="void">
		
		<cfset fail("Test testtestXXX not implemented")>
		
	</cffunction>		
	

	<!--- setup and teardown --->
	
	<cffunction name="setUp" returntype="void" access="public">
		
		<cfset this.myComp = createObject("component","mxunit.samples.TestCaseSkeleton")>	
		
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">
		<!--- Any code needed to return your environment to normal goes here --->
	</cffunction>

</cfcomponent>

