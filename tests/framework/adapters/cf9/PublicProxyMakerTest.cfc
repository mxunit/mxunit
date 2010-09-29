<cfcomponent extends="mxunit.tests.framework.PublicProxyMakerTest">

	<cffunction name="setup">
		<cfset this.maker = createObject("component","mxunit.framework.adapters.cf9.PublicProxyMaker")>
		<cfset this.objectWithPrivateMethod = createObject("component","mxunit.tests.framework.fixture.ComponentWithPrivateMethods")>
	</cffunction>
</cfcomponent>
