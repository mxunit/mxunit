 <cfcomponent  extends="mxunit.tests.bugs.105">
 
 <cffunction name="localTest">
  should display two tests
  </cffunction>
 
  <cffunction name="setUp" access="public" returntype="void">
   <cfset debug("in setup")>
  </cffunction>
  
  <cffunction name="tearDown" access="public" returntype="void">
  
  </cffunction>
  

</cfcomponent>
