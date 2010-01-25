<cfcomponent name="QueryTestResultTest" extends="mxunit.framework.TestCase">


 <cffunction name="testGetQueryResults" returntype="void" access="public">
  <cfscript> 
   //debug(q.getQueryResults());
   assertIsQuery(q.getQueryResults());
   assertEquals(q.getQueryResults().recordcount,4,"Should return 21 rows - but should use something more static that AssertTest");
  </cfscript>		
</cffunction>

<cffunction name="testMetaData">
 <cfscript> 
   //debug(q);
   assertEquals(q.testRuns, 4,"Should return 4 rows");
   assertEquals(q.successes, 3,"Should 3 successes");
   assertEquals(q.failures, 1,"Should 1 failure");
  </cfscript>		
</cffunction>
  
  
  
<cffunction name="setUp" returntype="void" access="public">
  <cfscript>
   suite = createObject("component","mxunit.framework.TestSuite").TestSuite();
   suite.addAll("mxunit.tests.framework.fixture.fixturetests.SomeRandomTest");
   results = suite.run();
   q = createObject("component","mxunit.framework.QueryTestResult").QueryTestResult(results);
  </cfscript>
</cffunction>

<cffunction name="tearDown" returntype="void" access="public"></cffunction>

</cfcomponent>