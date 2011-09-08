<cfcomponent extends="mxunit.framework.TestCase">
<cfset cu = createObject("component","mxunit.framework.ComponentUtils")>


<cffunction name="testThatGetComponentRootImplementsOverrideOfMxunitConfigXml">
  <cfscript>
   var root = cu.getComponentRoot("override");
   assertEquals("mxunit",root);
  </cfscript>
</cffunction>


<cffunction name="testGetComponentRootWhenGetMetaDataNameIsDot">
  <cfscript>
   var root = cu.getComponentRoot(".");
   assertEquals("mxunit",root);
  </cfscript>
</cffunction>

<cffunction name="testGetComponentRootWhenGetMetaDataNameIsComponentUtils">
    <cfscript>
     var root = cu.getComponentRoot("ComponentUtils");
     assertEquals("mxunit",root);
    </cfscript>
  </cffunction>

  <cffunction name="testGetComponentRootWhenGetMetaDataNameIsNull">
    <cfscript>
     var root = cu.getComponentRoot("");
     assertEquals("mxunit",root);
    </cfscript>
  </cffunction>

	<cffunction name="testGetSeparator">
		<cfset var sep = cu.getSeparator()>

		<cfif findNoCase("Windows",server.OS.Name)>
			<cfset assertEquals("\",sep)>
		<cfelse>
			<cfset assertEquals("/",sep)>
		</cfif>
	</cffunction>

	<cffunction name="testIsFrameworkTemplate">
		<cfset var sep = cu.getSeparator()>
		<cfset var root = expandPath("/mxunit")>

		<cfset var template = "#root##sep#framework#sep#SomeFile.cfc">
		<cfset assertTrue(cu.isFrameworkTemplate(template),"#template# should be framework template")>

		<cfset template = replace(template,".cfc",".cfm","one")>
		<cfset assertTrue(cu.isFrameworkTemplate(template),"#template# should be framework template")>

		<cfset template = "c:/bluedragon/wwwroot/mxunit/framework/TestCase.cfc">
		<cfset assertTrue(cu.isFrameworkTemplate(template),"blue-dragon style should be framework template")>

		<cfset template = "#root#PluginDemoTests#sep#SomeFile.cfc">
		<cfset assertFalse(cu.isFrameworkTemplate(template),"#template# should not be framework template")>

		<cfset template = "#root#PluginDemoTests#sep#SomeFile.cfc">
		<cfset assertFalse(cu.isFrameworkTemplate(template),"#template# should not be framework template")>

		<!--- denny valient's bug --->
		<cfset template="#root#workspace/ormtests/SomeTest.cfc">
		<cfset assertFalse(cu.isFrameworkTemplate(template),"#template# should not be framework template")>

		<cfset template="#root#workspace/tests/SomeTest.cfc">
		<cfset assertFalse(cu.isFrameworkTemplate(template),"#template# should not be framework template")>

		<!--- James Buckingham's bug --->
		<cfset template = "C:\Inetpub\common\MXUnit\v2.0.2 (vendor)\framework\Assert.cfc.">
		<cfset assertTrue(cu.isFrameworkTemplate(template), "#template# should be a framework template")>
	</cffunction>


	<cffunction name="testSomethingPrivate" access="private">
	</cffunction>
	<cffunction name="testSomethingPackage" access="package">
	</cffunction>



  <!---

  To Do:

  Obviously there is some good refactoring opportunities here in the next two
  methods.

  bill - 3.13.08

  <cffunction name="testGetRoot">
    <cfscript>
     var rootWithDots;
    </cfscript>
  </cffunction>
  --->
  <cffunction name="testGetInstallRoot">
  <cfscript>
   root = cu.getInstallRoot();
   assertEquals("#getContextRoot()#/mxunit",root);
  </cfscript>
</cffunction>


<cffunction name="testGetComponentRoot">
  <cfscript>
  //@pre metadata will always be dot delimitted list
  //     web path separator will always be '/'
  //     method will be used by framework only
  //@post
   var root = cu.getComponentRoot("foo.bar.nanoo.mxunit.framework.TestResult");
   assertEquals("foo.bar.nanoo.mxunit", root);


   root = cu.getComponentRoot("mxunit.framework.TestResult");
   assertEquals("mxunit", root);


   root = cu.getComponentRoot("");
   assertEquals("mxunit", root);

   root = cu.getComponentRoot("mxunit.framework.Assert");
   assertEquals("mxunit", root);

   root = cu.getComponentRoot("mxunit.framework.ComponentUtils");
   assertEquals("mxunit.MXunitInstallTest", root & ".MXunitInstallTest");

  </cfscript>
</cffunction>


<cffunction name="testHasJ2EEContext">
 <cfscript>
  ctx = getPageContext().getRequest().getContextPath();
  try{
   assertTrue(cu.hasJ2EEContext() ,"Expect a failure on non-j2ee server configs.");
  }
  catch (any e){
   if(cu.hasJ2EEContext()){
     throwwrapper(e);
   }
  }

 </cfscript>
</cffunction>


<cffunction name="testGetContextRootComponent">
<cfset var ctx = "" />
<cfoutput>
 <cfset ctx = getPageContext().getRequest().getContextPath() />
 <cfset addtrace(cu.getContextRootComponent()) />
</cfoutput>
</cffunction>

<cffunction name="testGetContextRootPath">
<cfset var ctx = "" />
<cfoutput>
 <cfset ctx = getPageContext().getRequest().getContextPath() />
 <cfset addtrace(cu.getContextRootPath()) />
</cfoutput>
</cffunction>


<cffunction name="hasJ2EEContext" access="private">
 <cfscript>
  return(getContextRootPath() is not "");
 </cfscript>
</cffunction>


<cffunction name="getContextRootComponent" access="private">
 <cfset var ctx = getPageContext().getRequest().getContextPath() />
 <cfset var rootComponent = "" />
 <cfif hasJ2EEContext()>
   <!--- This last  "." worries me. Under what circumstance will this not be true? --->
   <cfset rootComponent = right(ctx,len(ctx)-1) &  "."/>
 </cfif>
 <cfreturn  rootComponent />
</cffunction>


<cffunction name="getContextRootPath" access="private">
 <cfset var ctx = getPageContext().getRequest().getContextPath() />
 <cfreturn ctx />
</cffunction>



<cffunction name="testIsCfc" hint="Determines whether or not the given object is a ColdFusion component; Author: Nathan Dintenfass ">
 <cfscript>
  var objs = arrayNew(1);
  objs[1] = createObject("component","mxunit.framework.Assert");
  objs[2] = this;
  objs[3] = createObject("java","java.util.List");
  //assertions
  assertTrue( cu.isCfc(objs[1]) , "mxunit.framework.Assert failed");
  assertTrue( cu.isCfc(objs[2]) , " THIS failed");
  assertFalse( cu.isCfc(objs[3]) , " Java List? failed");
  assertFalse( cu.isCfc("") , " empty string failed");
  assertFalse( cu.isCfc(arrayNew(1)) , " empty array failed");
  assertFalse( cu.isCfc(structNew()) , " empty struct failed");
  assertFalse( cu.isCfc(-3213213213213213211222222222222222222222222222222222222222222222221) , " int failed");
  assertFalse( cu.isCfc(10002234234234234232.1789789789789789789236654) , " float failed");
  assertFalse( cu.isCfc(queryNew("asd")) , " query failed");
 </cfscript>
</cffunction>


<cffunction name="getMockFactoryInfoReturnsMMInfoAsDefault">
<cfscript>
	info = cu.getMockFactoryInfo();
	assertEquals("MightyMock.Mockfactory",info.factoryPath);
	assertEquals("createMock",info.createMockMethodName);
	assertEquals("mocked",info.createMockStringArgumentName);
	assertEquals("mocked",info.createMockObjectArgumentName);
	assertEquals("init",info.constructorName);
	assertEquals(0,StructCount(info.constructorArgs));
</cfscript>
</cffunction>

<cffunction name="getMockFactoryInfoReturnsExplicitFactorInfo">
<cfscript>
	info = cu.getMockFactoryInfo("newFramework");
	assertEquals("mxunit.tests.framework.fixture.MockFactory",info.factoryPath);
	assertEquals("createMeAMock",info.createMockMethodName);
	assertEquals("componentName",info.createMockStringArgumentName);
	assertEquals("object",info.createMockObjectArgumentName);
	assertEquals("initMethod",info.constructorName);
	assertEquals(1,StructCount(info.constructorArgs));
	assertEquals("constructorArg1",info.constructorArgs.arg1);
</cfscript>
</cffunction>


	<cffunction name="setUp">

	</cffunction>

	<cffunction name="tearDown">

	</cffunction>
</cfcomponent>