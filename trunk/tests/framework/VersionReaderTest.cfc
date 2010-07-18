<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset vr = createObject("component","mxunit.framework.VersionReader")>			
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="getVersionInfoShouldReturnStructWithBuildNumberAndDate" returntype="void" access="public">
		<cfset var result = vr.getVersionInfo()>
		<cfset assertTrue(isDate(result.VersionDate))>
		<cfset assertEquals(3,listLen(result.VersionNumber,"."))>
	</cffunction>
	

</cfcomponent>