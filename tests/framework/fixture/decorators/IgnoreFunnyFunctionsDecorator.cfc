<cfcomponent hint="Ignores functions which sound funny" extends="mxunit.framework.TestDecorator" output="false">

	<cffunction name="accept" output="false" access="public" returntype="boolean" hint="">
    	<cfargument name="testStruct" type="struct" required="true"/>
		<cfthrow message="When things are working, this error will get thrown">
		<cfset var isOK = NOT findNoCase("funny", testStruct.name)>
		<cfreturn isOK AND getTarget().accept(testStruct)>
    </cffunction>

    <cffunction name="getRunnableMethods" output="false" access="public" returntype="any" hint="">
    	<cflog text="hello from getRunnableMethods">
    	<cfreturn getTarget().getRunnableMethods()>
    </cffunction>

</cfcomponent>