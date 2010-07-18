<cfcomponent extends="mxunit.framework.TestCase">

  <cffunction name="testThisComponentCompleteAncestory" returntype="void" access="public">
    <cfscript>
      //itself
      assertIsTypeOf(this,"mxunit.tests.bugs.bug126"); 
      //immediate parent
      assertIsTypeOf(this,"mxunit.framework.TestCase"); 
      // grandparent
      assertIsTypeOf(this,"mxunit.framework.Assert"); 
      //last of the mohicans
      assertIsTypeOf(this,"WEB-INF.cftags.component"); 
    </cfscript>
  </cffunction> 
  
  <cffunction name="testSimpleComponentAncestory" returntype="void" access="public">
    <cfscript>
      //itself
      assertIsTypeOf(c,"mxunit.tests.bugs.fixture.93sample"); 
      assertIsTypeOf(c,"WEB-INF.cftags.component"); 
      try{
       assertIsTypeOf(c,"mxunit.framework.TestCase"); 
      } catch(mxunit.exception.AssertionFailedError e){}
     </cfscript>
  </cffunction> 
  
   <cffunction name="breakIt" returntype="void" access="public">
    <cfscript>
      assertIsTypeOf(webinf,"Web-INF.cftags.component"); 
      try{
       assertIsTypeOf(webinf,"mxunit.bogus.cfc.package.I'm not here"); 
      } catch(mxunit.exception.AssertionFailedError e){
      
      }
     </cfscript>
  </cffunction> 
  
  
<cffunction name="setUp">
  <cfscript>
    c = createObject("component","mxunit.tests.bugs.fixture.93sample");
    webinf = createObject("component","WEB-INF.cftags.component");;
  </cfscript>
</cffunction>

</cfcomponent>