<cfcomponent hint="stores the current test method name and arguments in the request.test scope." extends="mxunit.framework.TestDecorator" output="false">

	<cffunction name="invokeTestMethod"	access="public" returntype="string" output="false" >
		<cfargument name="methodName" hint="the name of the method to invoke" type="string" required="Yes">
		<cfargument name="args" hint="Optional set of arguments" type="struct" required="No" default="#StructNew()#">

		<cfscript>
			request.test = arguments;
	    </cfscript>

		<cfreturn getTarget().invokeTestMethod(arguments.methodName, arguments.args) />
	</cffunction>

</cfcomponent>