 <cfcomponent  extends="mxunit.tests.framework.TestCaseTest" hint="Should run if this extends other tests. Should not need to extend mxunit.frameowrk.TestCase"
			 	overWriteMe="true">



  <cffunction name="testThatCallToSuperReturnsCorrectString">
 <cfset assertEquals("Some TestCase Data To Read", super.getSomeValue())>

  </cffunction>
  <cffunction name="testThatThisExtendsTestCaseTest">
  <cfscript>
    assertEquals("mxunit.tests.framework.TestCaseTest",this.md.extends.name);
  </cfscript>
  </cffunction>

  <cffunction name="testGetRunnableMethodsSimple">
   <!---  Need to override this from parent, because this tests
    by counting runnable methods, but in this extended test
    we are adding one, so the actual value is changed. --->
  </cffunction>

<cfscript>
	function getAnnotationReturnsValueFromTestCaseUsingMxunitNamespace() {
		assertEquals("valueWithNS",getAnnotation(annotationName="testCaseLevelWithNS"));
	}

	function getAnnotationReturnsValueFromTestCaseUsingJustName() {
		assertEquals("valueWithoutNS",getAnnotation(annotationName="testCaseLevelWithoutNS"));
	}

	function getOverwrittenAnnotationReturnsValueFromTestCaseUsingJustName() {
		assertTrue(getAnnotation(annotationName="overWriteMe"));
	}
</cfscript>

  <cffunction name="setUp" access="public" returntype="void">
   <!--- Seeing if explicit super.setUp() works, too. Could test
   with var data. --->

   <cfset  super.setUp() />
   <cfset this.md = getMetaData(this)>
  </cffunction>

  <cffunction name="tearDown" access="public" returntype="void">

  </cffunction>


</cfcomponent>
