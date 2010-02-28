<cfcomponent extends="mxunit.framework.TestCase">
	<cffunction name="setUp" output="false" access="public" returntype="void" hint="">
		
	</cffunction>
	
	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">
		
	</cffunction>
	
	<cffunction name="testOne" output="false" access="public" returntype="void" hint="">
		<cfset assertTrue(true,"true")>
	</cffunction>
	
	<cffunction name="testPrivate" output="false" access="private" returntype="any" hint="">
		
	</cffunction>
	
	<cffunction name="testPackage" output="false" access="package" returntype="any" hint="">
		
	</cffunction>
</cfcomponent>