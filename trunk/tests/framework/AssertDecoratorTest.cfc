
<cfcomponent  extends="mxunit.framework.TestCase">

<cffunction name="testAddAssertionExtensionTemplate">
<cfscript>
 addAssertDecorator("mxunit.framework.ext.AssertionExtensionTemplate");
 try{
   assertSomething('foo','some message');
 }
 catch(mxunit.exception.AssertionFailedError e){
  assertEquals('some message',e.message);
 }

</cfscript>
</cffunction>

<cffunction name="testMXUnitExtensionsAdded">
 Tests to see if the MXUnit Assertion extensions were added successfully
 <cfset var a = arrayNew(1)>
 <cftry>
    <cfset addAssertDecorators() />
    <cfset assertTrue( assertIsEmptyArray(a)) />
  <cfcatch type="any">
    <cfset fail("mxunit assertion extensions not added. failed with message #cfcatch.Message#") />
  </cfcatch>
  </cftry>
</cffunction>

<cffunction name="testaddAssertDecorators">
 Testing to see if assAssertDecorators() is being called. Maybe redundant
 after refactoring ...
 <cftry>
  <cfset addAssertDecorators() />
  <cfcatch type="any">
   <cfset fail("addAssertDecorators() failed with message #cfcatch.Message#") />
  </cfcatch>
  </cftry>
</cffunction>

<cffunction name="testAddHamcrestDecorator">
  Tests to see if Hamcrest assertion package has been added successfully::
  <cfoutput>#assertThis()#</cfoutput>

</cffunction>


<cffunction name="testAddFixtureDecorator">
  Tests to see if bogus assertion package has been added successfully::
  <cfscript>
     addAssertDecorator("mxunit.tests.framework.fixture.TestAssertComponent");
     assertTrue( assertFoo() );
     try{
      assertTrue( assertBar(), "assertBar() returned false" );
     }
     catch(mxunit.exception.AssertionFailedError e){
      //no worries
     }
  </cfscript>

</cffunction>


<cffunction name="setUp">
 <cfset addAssertDecorator("mxunit.framework.HamcrestAssert") />
</cffunction>

</cfcomponent>
