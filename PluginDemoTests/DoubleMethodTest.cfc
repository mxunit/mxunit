<cfcomponent extends="mxunit.framework.TestCase">
	<cfset blah = "hi mom">
	<cffunction name="setUp" output="false" access="public" returntype="void" hint="">


	</cffunction>

	<cffunction name="tearDown" output="false" access="public" returntype="void" hint="">

	</cffunction>

	<cffunction name="testOne"  access="public" returntype="void" hint="">
		<cfset var scopes = getpagecontext().getCFScopes()>

		<cfdump var="#scopes#">
		<cfset assertTrue(true,"true")>
	</cffunction>
	
	<cffunction name="testTwo"  returntype="void" hint="">
		<cfset var q = QueryNew("one,two")>
		<cfset debug("#StructNew()#")>
		<cfset assertTrue(true,"true")>
		<cfoutput>#blah#</cfoutput>
		<cfset assertTrue(true,"true")>
		<cfoutput>doublemethodtest </cfoutput>
		<cfdump var="#structnew()#">

		<cfset QueryAddRow(q)>
		<cfset QuerySetCell(q,"one","one")>
		<cfset QuerySetCell(q,"two","two")>
		<cfdump var="#q#">
	</cffunction>


	<cffunction name="testPrivate" output="false" access="private" returntype="any" hint="">

	</cffunction>

	<cffunction name="testPackage" output="false" access="package" returntype="any" hint="">

	</cffunction>
</cfcomponent>
