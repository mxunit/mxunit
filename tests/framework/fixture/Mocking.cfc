<cfcomponent output="false" extends="mxunit.framework.TestCase">

	<cffunction name="mockCalledByTestSuiteShouldReturnColdMockObject">
		<cfscript>
			mymock =  mock("mxunit.framework.Assert");
			assertIsTypeOf(mymock,"mxunit.framework.Assert");
			mymock.mockMethod("getHashCode").returns("Hello!");
			assertEquals("Hello!",mymock.getHashCode(""));
		</cfscript>
	</cffunction>

</cfcomponent>
