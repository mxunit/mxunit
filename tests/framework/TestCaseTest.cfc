<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent  extends="mxunit.framework.TestCase" mxunit:testCaseLevelWithNS="valueWithNS" testCaseLevelWithoutNS="valueWithoutNS"
													overWriteMe="false">

  <cffunction name="getSomeValue" hint="Used by child test for testing inherited tests" returntype="string">
   <cfreturn "Some TestCase Data To Read" />
  </cffunction>

<!--- Begin Specific Test Cases --->
	<cffunction name="testGetRunnableMethodsSimple">
		<!--- Should be 2 --->
    	<cfset var methods = this.getRunnableMethods()>
		<cfset var thesemethods = getMetadata(this)>
		<!--- the 5 is the twos private function plus the setup and teardown functions --->
		<cfset var expectedMethodCount = Arraylen(thesemethods.functions) - 7>
		<cfset assertEquals(ArrayLen(methods),expectedMethodCount,"returned methods should be 7 less than total methods in this test case (excludes setup/teardown/private/package)")>
	</cffunction>

	<cffunction name="testGetRunnableMethodsInheritance">
		<cfset var baseobj = createobject("component","mxunit.PluginDemoTests.inheritance.BaseTest")>
		<cfset var obj1 = createObject("component","mxunit.PluginDemoTests.inheritance.SomeExtendingTest")>
		<cfset var obj2 = createObject("component","mxunit.PluginDemoTests.inheritance.SomeDoublyExtendingTest")>
		<cfset var md = getMetadata(baseobj)>
		<cfset var md2 = getMetadata(obj1)>
		<cfset var md3 = getMetadata(obj1)>
		<cfset var totalMethods = ArrayLen(md.functions) + ArrayLen(md2.functions) + ArrayLen(md.functions)>
		<cfset var methods = obj2.getRunnableMethods()>
		<cfset assertEquals(totalMethods-1,ArrayLen(methods),"count of total returned methods should equal cumulative method count for all 3 objects minus 1, since one of the tests overrides a parent function")>
	</cffunction>

	<cffunction name="testGetRunnableMethodsHyphenInName" output="false" access="public" returntype="void" hint="">
		<cfset var cfcWithHyphen = createObject("component","mxunit.tests.framework.fixture.mxunit-TestCase-Template")>
		<cfset var methods = cfcWithHyphen.getRunnableMethods()>
		<cfset var md = getMetadata(cfcWithHyphen)>
		<cfset assertEquals(arraylen(md.functions)-2,arraylen(methods),"number of runnable methods should be 2 fewer than total number of methods (subtracting out setup and teardown)")>
	</cffunction>


	<cffunction name="setUpAndTearDownAreNotAcceptableTests">
		<cfset var s_test = "" />
		<cfset var result = "" />

		<cfset s_test = structnew()>
		<cfset s_test.name = "setup">
		<cfset s_test.access = "public">
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"setup should not be acceptable")>

		<cfset s_test.name = "teardown">
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"teardown should not be acceptable")>
	</cffunction>

	<cffunction name="privateAndPackageAreNotAcceptableTests">
		<cfset var s_test = "" />
		<cfset var result = "" />
		<!--- <cfset makePublic(this,"accept")> --->

		<cfset s_test = structnew()>
		<cfset s_test.name = "someTestGoesHere">
		<cfset s_test.access = "private">
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"private test not be acceptable")>

		<cfset s_test.access = "package">
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"package test should not be acceptable")>
	</cffunction>

	<cffunction name="falseTestAttribute_IsNotAcceptableTest">
		<cfset var s_test = "" />
		<cfset var result = "" />
		<!--- <cfset makePublic(this,"accept")> --->

		<cfset s_test = structnew()>
		<cfset s_test.name = "someTestGoesHere">
		<cfset s_test.access = "public">
		<cfset s_test.test = false>
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"test=false test should not be acceptable")>
	</cffunction>

	<cffunction name="cfthreadsInTestAreNotAcceptableTests">
		<cfset var s_test = "" />
		<cfset var result = "" />
		<!--- <cfset makePublic(this,"accept")> --->

		<cfset s_test = structnew()>
		<cfset s_test.name = "_cffunccfthread">
		<cfset s_test.access = "public">
		<cfset result = this.accept(s_test)>
		<cfset assertFalse(result,"methods injected into cfcs as a result of cfthread calls are not acceptable")>
	</cffunction>


	<cffunction name="publicFunctionsAreAcceptableTests">
		<cfset var s_test = "" />
		<cfset var result = "" />
		<!--- <cfset makePublic(this,"accept")> --->

		<cfset s_test = structnew()>
		<cfset s_test.name = "ILoveToTestCF">
		<cfset s_test.access = "public">
		<cfset result = this.accept(s_test)>
		<cfset assertTrue(result,"Almost all public functions are testable. This one should be, too")>
	</cffunction>

	<cffunction name="testMakePublicPassthroughSanityCheck" hint="make sure it would fail if we tried calling it directly" mxunit:expectedException="Application">
		<cfset var objWithPrivate = createObject("component",this.fixtureTestPath)>
		<cfset objWithPrivate.doSomethingPrivate()>
	</cffunction>

	<cffunction name="testMakePublicPassthrough" hint="test that the passthrough to PublicProxyMaker is correctly constructed; we're not worried about testing functionality here since that's already tested elsewhere">
		<cfset var objWithPrivate = createObject("component",this.fixtureTestPath)>
		<cfset var proxy = makePublic(objWithPrivate,"doSomethingPrivate","doSomethingPrivate")>
		<!--- simply ensure it doesn't fail --->
		<cfset var ret = proxy.doSomethingPrivate()>
		<cfset assertEquals("poo",ret)>
	</cffunction>

	<cffunction name="testInjectMethodPassthroughSanityCheck" output="false" access="public" returntype="any" hint="" mxunit:expectedException="Application">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset var result = "" />
		<!--- a quick sanity check. be sure that this would fail unless we inject it! --->
		<cfset result = this.doSomething()>
	</cffunction>

	<cffunction name="testInjectMethodPassthrough">
		<cfset var result = "" />
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset injectMethod(this,mycfc,"doSomethingElse")>
		<cfset result = this.doSomethingElse()>
		<cfset assertEquals(result,"boo")>

	</cffunction>

	<cffunction name="testInjectMethodPassthroughOverwriteExisting">
		<cfset var newVal = "" />
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset var orig = mycfc.callDoSomethingPrivate()>

		<cfset injectMethod(mycfc,this,"doSomethingPrivate")>
		<cfset newVal = mycfc.callDoSomethingPrivate()>
		<cfset assertNotEquals(orig,newVal)>
		<cfset assertEquals("himom",newval)>
	</cffunction>

	<cffunction name="testInjectMethodPassthroughOverwriteExistingButDifferentName">
		<cfset var newVal = "" />
		<cfset var result = "" />
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset injectMethod(mycfc,this,"doSomethingPrivateABitDifferently","doSomethingPrivate")>
		<cfset newVal = mycfc.callDoSomethingPrivate()>
		<cfset assertEquals("hidad",newval)>
	</cffunction>

	<cffunction name="testRestoreMethod" output="false" access="public" returntype="any" hint="">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset var orig = mycfc.callDoSomethingPrivate()>
		<cfset debug(orig)>

		<!--- call twice to ensure that the 'original' copy happens only once --->
		<cfset injectMethod(mycfc,this,"doSomethingPrivate")>
		<cfset injectMethod(mycfc,this,"doSomethingPrivate")>

		<cfset newVal = mycfc.callDoSomethingPrivate()>
		<cfset debug(newVal)>
		<cfset restoreMethod(mycfc,"doSomethingPrivate")>
		<cfset backToOrigVal = mycfc.callDoSomethingPrivate()>
		<cfset debug(backToOrigVal)>
		<cfset assertEquals(orig,backToOrigVal,"")>


    </cffunction>


	<cffunction name="testInjectPropertyAlreadyExists">
		<cfset var newVal = "boo">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset var origVal = mycfc.getInternalVar()>
		<cfset assertNotEquals(newVal,origVal)>
		<cfset injectProperty(mycfc,"internalVar",newVal)>
		<cfset assertEquals(newVal,mycfc.getInternalVar())>

		<!--- now do it again --->
		<cfset newVal = "gee">
		<cfset injectProperty(mycfc,"internalVar",newVal)>
		<cfset assertEquals(newVal,mycfc.getInternalVar())>

	</cffunction>

	<cffunction name="testInjectPropertyWithScope">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset injectProperty(mycfc,"heather","wifey","instance")>
		<cfset assertEquals("wifey",mycfc.getInstance().heather)>
	</cffunction>

	<cffunction name="testInjectPropertyWorksForNonExistentMethods">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>

		<cftry>
		<!--- do something here to cause an error --->
			<cfset mycfc.doSomethingPrivate()>
			<cfset fail("Error path test... should not have gotten here")>
		<cfcatch type="mxunit.exception.AssertionFailedError">
			<cfrethrow>
		</cfcatch>
		<cfcatch type="any"></cfcatch>
		</cftry>

		<cfset injectProperty(mycfc,"doSomethingPrivate",variables.doSomethingPrivate)>
		<cfset assertEquals( doSomethingPrivate(), mycfc.doSomethingPrivate()   )>
	</cffunction>

	<cffunction name="testInjectPropertyWorksForMethodsCalledDirectly">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset orig = mycfc.doSomething()>
		<cfset injectProperty(mycfc,"doSomething",variables.doSomethingPrivate)>
		<cfset assertNotEquals(orig,mycfc.doSomething())>
		<cfset assertEquals( doSomethingPrivate(), mycfc.doSomething()   )>
	</cffunction>

	<cffunction name="testInjectPropertyWorksForMethodsCalledIndirectly">
		<cfset var mycfc = createObject("component",this.fixtureTestPath)>
		<cfset orig = mycfc.callDoSomethingPrivate()>
		<cfset injectProperty(mycfc,"doSomethingPrivate",variables.doSomethingPrivateABitDifferently)>
		<cfset assertNotEquals(orig,mycfc.callDoSomethingPrivate())>
		<cfset assertEquals( doSomethingPrivateABitDifferently(), mycfc.callDoSomethingPrivate()   )>
	</cffunction>

	<cffunction name="doSomethingPrivate" access="private">
		<cfreturn "himom">
	</cffunction>

	<cffunction name="doSomethingPrivateABitDifferently" access="private">
		<cfreturn "hidad">
	</cffunction>

	<cfscript>
	// annotation tests

	function getAnnotationReturnsDefaultValueIfNoAnnotationFound() {
		assertEquals("default",getAnnotation("testWithNoAnnotation","myAttribute","default"));
	}

	function getAnnotationReturnsValueUsingMxunitNamespace() {
		assertEquals("mxunitNamespace",getAnnotation("testWithMxunitNamespaceAnnotation","myAttribute","default"));
	}

	function getAnnotationReturnsValueUsingJustName() {
		assertEquals("justName",getAnnotation("testWithJustNameAnnotation","myAttribute","default"));
	}

	function getAnnotationReturnsValueFromTestCaseUsingMxunitNamespace() {
		assertEquals("valueWithNS",getAnnotation(annotationName="testCaseLevelWithNS"));
	}

	function getAnnotationReturnsValueFromTestCaseUsingJustName() {
		assertEquals("valueWithoutNS",getAnnotation(annotationName="testCaseLevelWithoutNS"));
	}

	</cfscript>

	<!--- Testing getAnnotation with dataprovider --->
	<cfset a = [1,2,3,4]>

	<cffunction name="dataproviderShouldAllowNameOnlyAnnotation" dataprovider="a">
	  <cfargument name="arrayItem" />
	  <cfset assert(arrayItem gt 0 ) >
	  <cfset assertEquals(arrayItem,arguments.index ) >
	</cffunction>

	<cffunction name="dataproviderShouldAllowMXUnitNamespacedAnnotation" mxunit:dataprovider="a">
	  <cfargument name="arrayItem" />
	  <cfset assert(arrayItem gt 0 ) >
	  <cfset assertEquals(arrayItem,arguments.index ) >
	</cffunction>

	<cffunction name="expectedExceptionWithJustNameShouldWork" expectedException="testException">
		<cfthrow type="testException" />
	</cffunction>

	<cffunction name="expectedExceptionWithMXUnitNamespaceShouldWork" mxunit:expectedException="testException">
		<cfthrow type="testException" />
	</cffunction>

	<cffunction name="getAnnotationOnNonExistentMethodThrowsExectedException" mxunit:expectedException="mxunit.exception.methodNotFound">
		<cfset getAnnotation("aBadMethodName","myAttribute","default") />
	</cffunction>

	<cffunction name="testWithNoAnnotation" hint="a fixture test used for testing getAnnotation">
	</cffunction>

	<cffunction name="testWithMxunitNamespaceAnnotation" mxunit:myAttribute="mxunitNamespace" hint="a fixture test used for testing getAnnotation">
	</cffunction>

	<cffunction name="testWithJustNameAnnotation" myAttribute="justName" hint="a fixture test used for testing getAnnotation">
	</cffunction>

<cfscript>
	// beforeTest test
	function $invokeBeforeTestsShouldSetSimpleValue(){
		debug(before_tests_expected);
	}
</cfscript>

<!--- End Specific Test Cases --->

	<cffunction name="beforeTests">
		<cfset variables.before_tests_expected = 123456789 />
	</cffunction>

	<cffunction name="afterTests" >
		<!--- not sure how to test this yet. tests have been run prior to this call --->
	</cffunction>

	<cffunction name="setUp" access="public" returntype="void">
		<cfset this.fixtureTestPath = "" />

		<cfset this.fixtureTestPath = "mxunit.tests.framework.fixture.NewCFComponent">

		  <!--- Place additional setUp and initialization code here --->
	    <!--- <cfset debug(getMetadata(this))>   --->

	    <!--- only want to make this public one time!!! Otherwise, on railo, bad things happen --->
	    <cfif not StructKeyExists(this,"accept")>
	    	<cfset makePublic(this,"accept")>
	    </cfif>
		<!--- need to make sure we're starting with no mocking framework set --->
		<cfset setMockingFramework("") />

	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>

	<cffunction name="aPrivateMethod" access="private">
		<cfreturn "foo">
	</cffunction>
</cfcomponent>
