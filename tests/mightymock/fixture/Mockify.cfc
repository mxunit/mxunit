<cfcomponent>
<!--- Test changes this object's method behavior to return 'bar' --->
<cfset props = 'props' />
<cfset this.properties = 'properties' />
<cffunction name="foo" access="public">
 <cfreturn 'foo'>
</cffunction>
</cfcomponent>