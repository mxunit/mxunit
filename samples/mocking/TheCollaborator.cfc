<cfcomponent output="false">

<cffunction name="logStuff" returntype="void">
  <cflog application="false" file="MightyMockExampleLog"
         type="information" text="I was called" />

</cffunction>


<cffunction name="getUser" returntype="query">
 <cfargument name="id" />
 <cfset  qData = getSomeData() />
 <cfquery name="q" dbtype="query">
   select *
   from qData
   where id = #arguments.id#
  </cfquery>
  <cfreturn q />
</cffunction>

<cffunction name="getSomeData" access="private"
            hint="Pretend for a moment this is a real database query.">
  <cf_querysim>
   data
   id,name,email
   1|bill|bill@bill.com
   2|marc|marc@marc.com
   3|ted|ted@ted.com
   4|joe|joe@joe.com
  </cf_querysim>
  <cfreturn data />
</cffunction>
</cfcomponent>