<cfcomponent extends="mxunit.framework.TestCase">

	<cffunction name="thisComponentShouldBeFoundBecauseItStartsWithTest">
		<cfset assertEquals("Marc Is Cool","Marc is Cool")>
	</cffunction>
</cfcomponent>