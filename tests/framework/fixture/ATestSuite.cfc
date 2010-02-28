<cfcomponent output="false" extends="mxunit.framework.TestSuite">
 <cfscript>
    addAll("mxunit.tests.framework.AssertDecoratorTest");
    addAll("mxunit.tests.bugs.fixture.test_with_underscore");  
  </cfscript>
</cfcomponent>