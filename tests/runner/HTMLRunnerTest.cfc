<cfcomponent  extends="mxunit.framework.TestCase">

  <cffunction name="testRunTestCase" access="public" returntype="void">
	<cfset var content = "" />
   	<!--- just don't fail! --->
 	<cfscript>
      runner.run(test="mxunit.tests.framework.AssertTest",output="html");
    </cfscript>
  </cffunction>


  <cffunction name="testRunTestSuite" access="public" returntype="void">
	  <cfscript>
      assertIsTypeOf(runner,"mxunit.runner.HtmlRunner");
    </cfscript>
  </cffunction>


 <cffunction name="testRunDirectory" access="public" returntype="void">
	  <cfscript>
      //fail("not implemented");
    </cfscript>
  </cffunction>



	<cffunction name="setUp" access="public" returntype="void">
	  <cfscript>
      runner = createObject("component","mxunit.runner.HtmlRunner").HtmlRunner();
     </cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
        <cfscript>

        </cfscript>
	</cffunction>


</cfcomponent>
