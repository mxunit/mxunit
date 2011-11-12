<cfcomponent hint="Ignores functions which sound funny" extends="mxunit.framework.TestDecorator" output="false">

    <cffunction name="getRunnableMethods" output="false" access="public" returntype="any" hint="">
    	<cfset var methods = []>
    	<cfset var orig = getTarget().getRunnableMethods()>
    	<cfset var method = 1>

    	<cflog text="Inside IgnoreFunnyFunctionsDecorator">

    	<cfloop from="1" to="#arrayLen(orig)#" index="method">
    		<cfif NOT findNoCase("funny", orig[method])>
    			<cfset arrayAppend(methods, orig[method])>
    		</cfif>
    	</cfloop>
    	<cfreturn methods>
    </cffunction>

</cfcomponent>