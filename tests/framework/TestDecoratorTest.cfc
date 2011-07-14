<cfcomponent extends="mxunit.framework.TestCase" output="false" mxunit:decorators="mxunit.tests.framework.fixture.decorators.StoreTestNameDecorator">

<cffunction name="testDecoratorWrappingTest" hint="test to see if the decorator gets called and places the name of the test in the request scope"
			access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(StructKeyExists(request, "test"), "Why is there no 'test' in the request scope?");

		assertEquals("testDecoratorWrappingTest", request.test.methodName);

		assertTrue(StructIsEmpty(request.test.args), "How does args have data in it?");
    </cfscript>
</cffunction>

</cfcomponent>