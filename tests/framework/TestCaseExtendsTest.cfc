 <cfcomponent  extends="mxunit.tests.framework.TestCaseTest" hint="Should run if this extends other tests. Should not need to extend mxunit.frameowrk.TestCase">



  <cffunction name="testThatCallToSuperReturnsCorrectString">
 <cfset debug(super.getSomeValue())>
 <cfset assertEquals("Some TestCase Data To Read", super.getSomeValue())>

  </cffunction>
  <cffunction name="testThatThisExtendsTestCaseTest">
  <cfset debug(this.md)>
  <cfscript>
    assertEquals("mxunit.tests.framework.TestCaseTest",this.md.extends.name);
  </cfscript>
  </cffunction>

  <cffunction name="testGetRunnableMethodsSimple">
   <!---  Need to override this from parent, because this tests
    by counting runnable methods, but in this extended test
    we are adding one, so the actual value is changed. --->
  </cffunction>



  <cffunction name="setUp" access="public" returntype="void">
   <!--- Seeing if explicit super.setUp() works, too. Could test
   with var data. --->

   <cfset  super.setUp() />
   <cfset debug("In TestCaseExtendedTest.setUp()") />
   <cfset this.md = getMetaData(this)>
  </cffunction>

  <cffunction name="tearDown" access="public" returntype="void">

  </cffunction>


</cfcomponent>
