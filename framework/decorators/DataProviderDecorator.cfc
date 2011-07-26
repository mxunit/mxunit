<!---
Provides dataprovider functionality to test cases.

Looks at the test method for "mxunit:dataprovider" or "dataprovider" annotation and, if found, runs the test method
for each member of the data provider
 --->
<cfcomponent extends="mxunit.framework.TestDecorator" output="false">

	<cffunction name="invokeTestMethod"	access="public" returntype="string" output="false" >
		<cfargument name="methodName" hint="the name of the method to invoke" type="string" required="Yes">
		<cfargument name="args" hint="Optional set of arguments" type="struct" required="No" >
		<cflog text="inside dataproviderdecorator">
		<cfreturn getTarget().invokeTestMethod(argumentCollection=arguments) />
	</cffunction>

</cfcomponent>