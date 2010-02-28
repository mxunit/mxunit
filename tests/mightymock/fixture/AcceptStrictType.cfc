<cfcomponent output="false">
<cffunction name="echoCFC" access="public">
 <cfargument name="cfc" type="mxunit.tests.mightymock.fixture.Dummy" />
 <cfreturn arguments.cfc />
</cffunction>
</cfcomponent>