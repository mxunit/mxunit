<cfcomponent extends="mxunit.framework.TestCase">

	<cfset maker = "">
	<cfset objectWithPrivateMethod = "">

	<cffunction name="setup">
		<cfset this.maker = createObject("component","mxunit.framework.PublicProxyMaker")>
		<cfset this.objectWithPrivateMethod = createObject("component","mxunit.tests.framework.fixture.ComponentWithPrivateMethods")>
	</cffunction>

	<cffunction name="testSanity" mxunit:expectedException="Application">
		<cfset var str = this.objectWithPrivateMethod.aPrivateMethod()>
	</cffunction>


	<!--- here's how to use  the object returned by the proxy maker to invoke
	the method with the exact method name under test; under the hood, this creates
	a new component that extends the object under test and adds a public version
	of the private method. it simply calls super.Whatever(args....)

	The primary disadvantage is that you lose anything you've done to the object in setUp()
	or any other initialization prior to running the function since you're now working with a new object

	see testMakePublicObjectWithInit for how to overcome this disadvantage

	--->
	<cffunction name="testMakePublicObject">
		<cfset var proxy = this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethod")>
		
		<cfset ret = proxy.aPrivateMethod("one","two","++")>
		<cfset assertEquals("one++two",ret)>
	</cffunction>

	<cffunction name="testMakePublicObjectNoArg">
		<cfset var proxy = this.maker.makePublic(this.objectWithPrivateMethod,"aNoArgPrivateMethod")>
		<!--- if it doesn't fail, all is OK --->
		<cfset ret = proxy.aNoArgPrivateMethod()>
		<cfset assertEquals("boo",ret)>
	</cffunction>

	<cffunction name="testMakePublicObjectWithInit">
		<!--- so that you don't lose any of the initialization you'd do in setup, you can perform
		that initialization inside the object itself AFTER making the public proxy --->
		<cfset var ret = "" />
		<cfset var proxy = this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethod","aPrivateMethod")>
		<!---  just an example:
		<cfset proxy.init(blah,blah)>
		<cfset proxy.setSomethingOrOther(foo)>

		--->
		<cfset ret = proxy.aPrivateMethod("one","two","()")>
	</cffunction>

	<cffunction name="testMakePublicObjectVoid">
		<cfset var proxy = this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateVoid","aPrivateVoid")>
		<cfset var ret = proxy.aPrivateVoid()>
		<cfset assertEquals(5,proxy.x)>
	</cffunction>


	<!---
	here's how to use the proxy method created and injected into the existing object under test.

	the primary benefit of this version over the "proxy object" version is that you retain any
	object modification done prior to invoking the method.

	--->


	<cffunction name="testMakePublicNamedArgsAndNamedPublicMethod">
		<cfset var result = "" />
		<!--- this is the only test that uses the optional 3rd argument --->
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethod","_aPrivateMethod")>
		<cfset result = this.objectWithPrivateMethod._aPrivateMethod(arg1="one",arg2="two")>
		<cfset assertEquals("one_two",result)>

		<cfset result = this.objectWithPrivateMethod._aPrivateMethod(arg1="one",arg2="two",sep="~~")>
		<cfset assertEquals("one~~two",result)>
	</cffunction>

	<cffunction name="testMakePublicNonNamedArgs">
		<cfset var result = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethod")>
		<cfset result = this.objectWithPrivateMethod.aPrivateMethod("one","two","+")>
		<cfset assertEquals("one+two",result)>
		<cfset result = this.objectWithPrivateMethod.aPrivateMethod("one","two","_")>
		<cfset assertEquals("one_two",result)>

		<cfset result = this.objectWithPrivateMethod.aPrivateMethod("one","two")>
		<cfset assertEquals("one_two",result)>
	</cffunction>

	<cffunction name="testMakePublicNonExistentMethod" mxunit:expectedException="Application">
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodThatDoesNotExist")>
	</cffunction>

	<cffunction name="testMakePublicNoThirdArg">
		<cfset var result = "" />
		<!--- we're simply testing here that the name of the resultant public method to use exists and doesn't fail --->
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethod")>
		<cfset result = this.objectWithPrivateMethod.aPrivateMethod(arg1="one",arg2="two")>
		<cfset assertEquals("one_two",result)>
	</cffunction>
	
	<cffunction name="testMakePublicAddInts" returntype="void">    
    	<cfset var result = "">
    	<cfset this.maker.makePublic(this.objectWithPrivateMethod, "privateAddition")>
    	<cfset result = this.objectWithPrivateMethod.privateAddition(2, 5)>
    	<cfset assertEquals( 7, result )>
    </cffunction>
    
	<cffunction name="testMakePublicComplexArgsWithDefaults" returntype="void">    
    	<cfset var result = "">
    	<cfset var expected = {array=[]}>
    	<cfset this.maker.makePublic(this.objectWithPrivateMethod, "privateStructAndArrayArgs")>
    	<cfset result = this.objectWithPrivateMethod.privateStructAndArrayArgs()>
    	<cfset assertEquals( expected, result )>
    </cffunction>

	<cffunction name="testMakePublicNoArgMethod">
		<cfset var ret = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aNoArgPrivateMethod")>
		<!--- simply test that it doesn't error --->
		<cfset ret = this.objectWithPrivateMethod.aNoArgPrivateMethod()>
		<cfset assertEquals("boo",ret)>
	</cffunction>

	<cffunction name="testMakePublicVoid">
		<cfset var ret = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateVoid")>
		<cfset ret = this.objectWithPrivateMethod.aPrivateVoid()>
		<cfset assertEquals(5,this.objectWithPrivateMethod.x)>
	</cffunction>

	<cffunction name="testMakePublicNoReturnType">
		<cfset var ret = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodNoRT")>
		<cfset ret = this.objectWithPrivateMethod.aPrivateMethodNoRT()>
		
		<cfset assertTrue(len(ret) GT 0)>
	</cffunction>

	<cffunction name="testMakePublicArray">
		<cfset var ret = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodReturnArray")>
		<cfset ret = this.objectWithPrivateMethod.aPrivateMethodReturnArray()>
		<cfset assertTrue(isArray(ret),"returned value should be an array")>
	</cffunction>

	<cffunction name="testMakePublicArray2">
		<cfset var ret = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodReturnArray2")>
		<cfset ret = this.objectWithPrivateMethod.aPrivateMethodReturnArray2()>
		<cfset assertTrue(isArray(ret),"returned value should be an array")>
	</cffunction>

	<cffunction name="testMakePublicSuperClassMethod">
		<cfset var result = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aParentPrivateMethod")>
		<cfset result = this.objectWithPrivateMethod.aParentPrivateMethod()>
		<cfset assertEquals("boo",result)>
	</cffunction>

	<cffunction name="testMakePublicSuperClassPackageMethod">
		<cfset var result = "" />
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aParentPackageMethod")>
		<cfset result = this.objectWithPrivateMethod.aParentPackageMethod()>
		<cfset assertEquals("foo",result)>
	</cffunction>

	<cffunction name="testMakePublicSuperClassMethodWithSubclassWithNoFunctions">
		<cfset var result = "" />
		<!--- this subclass has no functions, but it extends a superclass that does have a private function --->
		<cfset var obj = createObject("component","mxunit.tests.framework.fixture.fixturetests.SubClassWithNoMethodsTest")>
		<cfset this.maker.makePublic(obj,"aPrivateMethod")>
		<cfset result = obj.aPrivateMethod()>
		<cfset assertTrue(result)>
	</cffunction>
	
	
	<!--- Test combinations of arguments passed, to ensure proxy method preserves arguments and properties of proxied method... --->
	
	<cffunction name="testMakePublicAllArgsPassed">
		<cfset var actual = "">
		<cfset var expected = structNew()>
		
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodVariedArguments")>
		
		<cfset expected.arg1 = "arg1_val">
		<cfset expected.arg2 = "arg2_val">
		<cfset expected.arg3 = "arg3_val">
		
		<cfset actual = this.objectWithPrivateMethod.aPrivateMethodVariedArguments("arg1_val", "arg2_val", "arg3_val")>
		
		<cfset assertEquals(expected,actual)>
	</cffunction>
	
	<cffunction name="testMakePublicArgDefault" hint="Test not passing arg2 argument, which has a default attribute.">
		<cfset var actual = "">
		<cfset var expected = structNew()>
		
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodVariedArguments")>
		
		<cfset expected.arg1 = "arg1_val">
		<cfset expected.arg2 = "arg2_val">
		<cfset expected.arg3 = "arg3_val">
		
		<cfset actual = this.objectWithPrivateMethod.aPrivateMethodVariedArguments(arg1="arg1_val", arg3="arg3_val")>
		
		<cfset assertEquals(expected,actual)>
	</cffunction>
	
	<cffunction name="testMakePublicMissingRequiredArg" mxunit:expectedException="Application">
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodVariedArguments")>
		<cfset this.objectWithPrivateMethod.aPrivateMethodVariedArguments()>
	</cffunction>
	
	<cffunction name="testMakePublicRequiredArgOnly">
		<cfset var actual = "">
		<cfset var expected = structNew()>
		
		<cfset this.maker.makePublic(this.objectWithPrivateMethod,"aPrivateMethodVariedArguments")>
		
		<cfset expected.arg1 = "arg1_val">
		<cfset expected.arg2 = "arg2_val">
		
		<cfset actual = this.objectWithPrivateMethod.aPrivateMethodVariedArguments("arg1_val")>
		
		<cfset assertEquals(expected,actual)>
	</cffunction>
	
</cfcomponent>