<cfcomponent extends="mxunit.framework.TestDecorator" output="false" hint="Only returns methods on 'Spec' components for CF Engines that support closures">

	<cffunction name="getRunnableMethods" output="false" access="public" returntype="any" hint="">
		<cflog text="INSIDE!!!">
		
		<cfset var componentUtils = createObject("component", "mxunit.framework.ComponentUtils")>
		<cfset var isSpec = componentUtils.objectIsTypeOf( getTarget(), "mxunit.framework.Spec")>
		<cfset var supportsClosures = false>
		<cfif structKeyExists(getFunctionList(), "isClosure")>
			<cfset supportsClosures = true>
		</cfif>
		
		<cfif NOT isSpec
			OR ( isSpec AND supportsClosures )>
			<cfreturn getTarget().getRunnableMethods()>
		</cfif>
		<cfreturn arrayNew(1)>    	
    </cffunction>

</cfcomponent>