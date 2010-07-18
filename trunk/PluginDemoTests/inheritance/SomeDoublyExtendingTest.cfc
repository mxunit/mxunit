<cfcomponent extends="SomeExtendingTest">
	
	<cffunction name="testDoublysOwnThing">
		<cfset assertTrue(true)>
	</cffunction>
	
	<cffunction name="testSomethingSimple">
		<cfset fail("this is my custom test")>
	</cffunction>
	
</cfcomponent>