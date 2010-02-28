<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="thisShouldFail_BecauseExpectedExceptionIsNotThrown" returntype="void" mxunit:expectedexception="Database">
		<cfthrow type="MyCustomException" message="hi mom!">	
	</cffunction>


</cfcomponent>