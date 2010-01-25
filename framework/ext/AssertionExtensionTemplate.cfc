<!---
 Usage: Use this as a starting point for building repetive or complex assertions.
        Place anywhere, but we recommend in mxunit.framework.ext.*
        Once built and tested, call
        addAssertDecorator("mxunit.framework.ext.MyCoolAssertions") in
        your test cases; e.g.,
         setUp() {
          addAssertDecorator(...)
         }
         Or add it to /mxunit/mxunit-config.xml (see examples there)


 Example Instructions:

 1. Write a test for your new assertion; e.g.,
   <cfcomponent  extends="mxunit.framework.TestCase">

	 <cffunction name="testAddAssertionExtension">
		<cfscript>
		 addAssertDecorator("mxunit.framework.ext.MyWayRadCoolAssertions");
		 try{
		   assertSomething('foo','some message');
		 }
		 catch(mxunit.exception.AssertionFailedError e){
		  assertEquals('some message',e.message);
		 }
	 </cffunction>

   </cfcomponent>
   Naturally, this should fail.

 2. Save this file with another name (MyWayRadCoolAssertions.cfc) to mxunit/framework/ext/
 3. Alter the code to match your assertion logic
 4. Run your tests again until you are in the green
 5. Add addAssertDecorator("mxunit.framework.ext.MyCoolAssertions") to your tests

 --->
<cfcomponent output="false" name="AssertionExtensionTemplate" hint="Template for creating custom assertions.">

  <cffunction name="assertSomething" access="public" returntype="boolean">
    <cfargument name="arg1" required="no" type="any" />
 	  <cfargument name="message" required="no" default="Assertion Failed" type="string" />
     <cfset var assertionFailed = "" />
    <!---
      Note that you may likely want to customize the message below to give
      provide accurate information on the failure details.
     --->
    <cfset assertionFailed = true />
    <cfif assertionFailed>
	    <cfinvoke method="fail">
	      <cfinvokeargument name="message" value="#arguments.message#">
	    </cfinvoke>
    </cfif>

     <cfreturn true />
  </cffunction>



</cfcomponent>