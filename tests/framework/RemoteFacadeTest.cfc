<cfcomponent extends="mxunit.framework.TestCase">
	<cfset rf = createObject("component","mxunit.framework.RemoteFacade")>

	<cffunction name="testPing" returntype="void" hint="">
		<cfset var b = rf.ping()>
		<cfset assertTrue(b,"should be true")>
	</cffunction>

	<cffunction name="testGetComponentMethods">
		<cfset var a_methods = rf.getComponentMethods("mxunit.PluginDemoTests.EmptyTest")>
		<cfset assertEquals(0,ArrayLen(a_methods),"should be 0 runnable methods in EmptyTest")>
		<cfset a_methods = rf.getComponentMethods("mxunit.PluginDemoTests.SingleMethodTest")>
		<cfset assertEquals(1,ArrayLen(a_methods),"should be one runnable method in SingleMethodTest")>
		<cfset a_methods = rf.getComponentMethods("mxunit.PluginDemoTests.DoubleMethodTest")>
		<cfset assertEquals(2,ArrayLen(a_methods),"should be 2 runnable methods in DoubleMethodTest")>
	</cffunction>


	<cffunction name="testExecuteTestCase" returntype="void" hint="">
		<cfset var name = "mxunit.PluginDemoTests.DoubleMethodTest">
		<cfset var methods = "">
		<cfset var results = "">

		<cfset results = rf.executeTestCase(name,methods,"")>
		<cfset assertExpectedKeysArePresent(results)>
		<cfset methods = rf.getComponentMethods(name)>
		<cfset assertTrue(isStruct(results),"results should be struct")>
		<cfset assertEquals(ArrayLen(methods),ArrayLen(StructKeyArray(results[name])),"")>
	</cffunction>

	<cffunction name="testExecuteTestCaseWithFailure" returntype="void" hint="">
		<cfset var name = "mxunit.PluginDemoTests.SingleFailureTest">
		<cfset var methods = "">
		<cfset var results = "">

		<cfset results = rf.executeTestCase(name,methods,"")>
		<cfset assertExpectedKeysArePresent(results)>
		<cfset methods = rf.getComponentMethods(name)>
		<cfset assertTrue(isStruct(results),"results should be struct")>
		<cfset assertEquals(ArrayLen(methods),ArrayLen(StructKeyArray(results[name])),"")>
		<cfset assertTrue(StructKeyExists(results[name]["testFail"],"EXCEPTION"))>
		<cfset assertTrue(StructKeyExists(results[name]["testFail"],"TAGCONTEXT"))>

		<cfset isArray(results["mxunit.PluginDemoTests.SingleFailureTest"]["testFail"]["TAGCONTEXT"])>
	</cffunction>

	<cffunction name="testExecuteTestCaseWithComplexErrorTypeError">
		<cfset var name = "mxunit.PluginDemoTests.ComplexExceptionTypeErrorTest">
		<cfset var method = "willThrowFunkyNonArrayException">
		<cfset var results = "">

		<cfset results = rf.executeTestCase(name,"","")>
		<cfset assertTrue(isSimpleValue(results[name][method]["EXCEPTION"]))>
		<cfset assertTrue( findNoCase("complex",  results[name][method]["EXCEPTION"]),"mxunit should convert the complex exception value into a string and prefix it with 'complexvalue' but didn't: #results[name][method]['EXCEPTION']#" )>
		<cfset assertTrue(StructKeyExists(results[name][method],"TAGCONTEXT"))>
		<cfset isArray(results[name][method]["TAGCONTEXT"])>
	</cffunction>

	<cffunction name="startTestRunShouldReturnKey">
		<cfset var key = rf.startTestRun()>
		<cfset assertTrue(len(key) GT 0)>
	</cffunction>

	<cffunction name="testGetServerType">
		<cfset var type = rf.getServerType()>
		<cfset assertTrue(  len(type) GT 0  )>
	</cffunction>

	<cffunction name="getFrameworkVersionShouldReturnVersion">
		<cfset var version = rf.getFrameworkVersion()>
		<cfset assertEquals(3, listLen(version,".")  )>
	</cffunction>

	<cffunction name="getFrameworkDateShouldReturnDateAndNotTime">
		<cfset var dt = rf.getFrameworkDate()>
		<cfset assertTrue(isDate(dt))>
	</cffunction>

	<cffunction name="assertExpectedKeysArePresent" access="private">
		<cfargument name="TestResult" type="struct" required="true"/>
		<cfset var basicKeys = "actual,expected,message,output,result,time">

		<cfloop collection="#TestResult#" item="componentName">
			<cfloop collection="#TestResult[componentName]#" item="methodName">
				<cfset methodStruct = TestResult[componentName][methodName]>
				<cfloop list="#basicKeys#" index="keyName">
					<cfset assertTrue( StructKeyExists(methodStruct,keyName),"expected keyName [#keyName#] in method struct for #componentName#.#methodName#(). Keys were #StructKeyList(methodStruct)#" )>
				</cfloop>
			</cfloop>
		</cfloop>


	</cffunction>

<!---	<cffunction name="hey">
		<cfset var beans = rf.getComponentMethodsRich2()>
		<cfdump var="#beans#">
	</cffunction>--->

</cfcomponent>
