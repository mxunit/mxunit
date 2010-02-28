<cfcomponent output="false">

<cffunction name="printTrace" returntype="any">
  <cftrace abort="false" inline="true" text="Example Trace inside cfc">
  <cfreturn this>
</cffunction>

</cfcomponent>