<!---

 The implements attribute is essentially ignored by CFMX 7 and 8, but
 this class does implement run(), the main contract in Test.cfc.
--->
<cfcomponent displayname="TestCase" extends="Assert" hint="Composite parent of all TestCases. Extend this class to build and run tests within the MXUnit framework.">

	<!--- constructor --->
	<cfset initProperties()>


	<!--- initialization --->
	<cffunction name="initProperties" access="private" output="false">
			<!--- How can we enforce creating a name? --->
			<cfparam name="this.name" type="string" default="" />
			<cfparam name="this.traceMessage" type="string" default="" />
			<cfparam name="this.result" type="any" default="#createObject("component","TestResult")#" />
			<cfparam name="this.metadata" type="struct" default="#getMetaData(this)#" />
			<cfparam name="this.package" type="string" default="" />
			<cfset initDebug()>
	</cffunction>

	<cffunction name="initDebug" access="public" output="false">
		<cfparam name="debugArrayWrapper" type="struct" default="#StructNew()#">
		<cfparam name="debugArray" type="array" default="#arrayNew(1)#" />
		<cfset debugArrayWrapper.debugArray = debugArray>
		<cfreturn debugArrayWrapper>
	</cffunction>

	<cffunction name="createRequestScopeDebug" access="public" output="false">
		<cfset request.debug = debug><!--- mixin the function --->
		<cfset request.debugArrayWrapper = StructNew()>
		<cfset request.debugArrayWrapper.debugArray = ArrayNew(1)>
	</cffunction>

	<cffunction name="stopRequestScopeDebug" access="public" output="false">
		<cfset structDelete(request,"debug")>
		<cfset structDelete(request,"debugArrayWrapper")>
	</cffunction>

	<!--- get on with the show --->
	<cffunction name="TestCase" returntype="any" access="remote">
	  <cfargument name="aTestCase" type="TestCase" required="yes" />
	   <cfscript>
	   var utils = "";
	   this.metadata = getMetaData(aTestCase);
	   utils = createObject("component","ComponentUtils");
	   this.installRoot = utils.getComponentRoot();
	   super.init();
	  </cfscript>
	  <cfreturn this />
	</cffunction>

	<cffunction name="toStringValue" access="public" returntype="string" hint="Returns the name of this TestCase">
		<cfreturn this.name />
	</cffunction>

	<cffunction name="createResult" access="private" returntype="TestResult">
		<cfscript>
		this.result = createObject("component","TestResult").TestResult();
		return this.result;
		</cfscript>
	</cffunction>

	<cffunction name="run" returntype="any" access="remote" hint="Main run method used by the Eclipse Plugin">">
	 <cfargument name="testResult" type="any" required="no"
	             default="#createObject("component","TestResult")#" />
	    <cfscript>
	     TestCase(this);
	     testResult.startTest(this);
	    </cfscript>
	</cffunction>
<!--- By default. Run the current TestCase and print the results as HTML --->
<!---
  Note: This will fail if test suite is built using the add() method instead
  of the addAll() method. If add() is used, override this method.
--->
<cffunction name="runTest" returntype="TestResult" access="remote" output="true">
  <cfargument name="suite" type="any" required="no" default="#createObject("component","TestSuite").addAll(this.metadata.name)#" />
  <cfif isDefined("url.testMethod")>
    <!--- Maybe get from the URL? --->
    <cfparam name="testMethod" type="string" default="#url.testMethod#" />
    <cfset this.result = suite.run(this.result,url.testMethod)/>
  <cfelse>
    <cfset this.result = suite.run()/>
  </cfif>
 <cfreturn this.result />

</cffunction>

<cffunction name="runBare" returntype="void" access="public" hint="Not really used">
<cfscript>
    TestCase(this);
    setUp();
    try {
      runTest();
    }
    catch (exception e){/*do nothing*/
    }
    tearDown();
  </cfscript>
</cffunction>

<!--- Wrapper to add tracing --->
<cffunction name="addTrace" returntype="void" access="public" hint="Adds a single string to the test result. Consider using debug() instead, especially for complex objects.">
  <cfargument name="message" type="string" required="false" default="" />
 <cfscript>
   this.traceMessage = arguments.message;
  </cfscript>
</cffunction>

<cffunction name="getTrace" returntype="string" access="public">
 <cfset var retVal = duplicate(this.traceMessage) />
 <cfset this.traceMessage = "" />
 <cfreturn retVal />
</cffunction>

<cffunction name="setUp" returntype="void" access="public" hint="Override in your testcase"></cffunction>

<cffunction name="tearDown" returntype="void" access="public" hint="Override in your testcase"></cffunction>

<!---
 Convenience method for running tests via URL/Web service invocation
 One less step a developer has to implement
 --->
<cffunction name="runTestRemote" access="remote" returntype="void" hint="Remote method for running tests quickly via Http.">
  <cfargument name="testMethod" type="string" required="no" default="" hint="A single test to run. If not specified, all tests are run." />
  <cfargument name="debug" type="boolean" required="false" default="false" hint="Flag to indicate whether or not to dump the test results to the screen.">
  <cfargument name="output" type="string" required="false" default="extjs" hint="Output format: html,xml,junitxml,extjs "><!--- html,xml,junitxml,extjs --->
  <cfscript>
   TestCase(this);
   this.result = runTest();
   switch(arguments.output){
    case 'html':
      writeoutput(this.result.getHtmlresults());
    break;

    case 'xml':
      writeoutput(this.result.getXmlresults());
    break;

    case 'junitxml':
    writeoutput(this.result.getJUnitXmlresults());
    break;

    case 'query':
    dump(this.result.getQueryresults());
    break;

    case 'extjs':
    writeoutput('<body>#this.result.getEXTresults(this.name)#<div id="testresultsgrid" class="bodypad"></div></body>');
    break;

    case 'text':
    writeoutput( trim(this.result.getTextresults(this.name)));
    break;

    default:
     writeoutput(this.result.getHtmlresults());
    break;
   }

  </cfscript>
  <cfif arguments.debug>
	<p>&nbsp;</p>
    <cfdump var="#this.result.getResults()#" label="Raw Results Dump">
  </cfif>
</cffunction>

<cffunction name="getRunnableMethods" hint="Gets an array of all runnable test methods for this test case. This includes anything in its inheritance hierarchy" access="public" returntype="array" output="false">

	<cfset var a_methods = ArrayNew(1)>
	<cfset var a_parentMethods = ArrayNew(1)>
	<cfset var thisComponentMetadata = getMetadata(this)>
	<cfset var i = "">
	<cfset var tmpParentObj = "">
	<cfset var cu = createObject("component","ComponentUtils")>
	<!--- now get the public methods from the actual component --->
	<cfif StructKeyExists(ThisComponentMetadata,"Functions")>
		<cfloop from="1" to="#ArrayLen(ThisComponentMetadata.Functions)#" index="i">
			<cfparam name="ThisComponentMetadata.Functions[#i#].access" default="public">
			<cfif testIsAcceptable(ThisComponentMetadata.Functions[i])>
				<cfset ArrayAppend(a_methods,ThisComponentMetadata.Functions[i].name)>
			</cfif>
		</cfloop>
	</cfif>

	<!--- climb the parent tree until we hit a framework template (i.e. TestCase) --->
	<cfif NOT cu.isFrameworkTemplate(ThisComponentMetadata.Extends.Path)>
		<cfset tmpParentObj = createObject("component",ThisComponentMetadata.Extends.Name)>
		<cfset a_parentMethods = tmpParentObj.getRunnableMethods()>
		<cfloop from="1" to="#ArrayLen(a_parentMethods)#" index="i">
			<!--- append this method from the parent only if the child didn't already add it --->
			<cfif NOT listFindNoCase( ArrayToList(a_methods), a_parentMethods[i])>
				<cfset ArrayAppend(a_methods,a_parentMethods[i])>
			</cfif>
		</cfloop>
		<cfset tmpParentObj = "">
		<cfset a_parentMethods = ArrayNew(1)>
	</cfif>

	<cfreturn a_methods>
</cffunction>

	<cffunction name="testIsAcceptable" access="package" hint="contains the logic for whether a test is a valid runnable method" returntype="boolean">
		<cfargument name="TestStruct" type="struct" required="true" hint="Structure for a function coming from getmetadata"/>
		<cfset var isAcceptable = true>

		<cfif 	ListFindNoCase("package,private",TestStruct.access)
			 OR ListFindNoCase("setUp,tearDown",TestStruct.name)
			 OR reFindNoCase("_cffunccfthread",TestStruct.Name)>

			<cfset isAcceptable = false>
		</cfif>

		<cfreturn isAcceptable>
	</cffunction>

	<cffunction name="makePublic" access="package" hint="makes a testable version of a private method for a given object. This is a convenience pass-through to PublicProxyMaker.makePublic. See documentation on 'testing private methods' at mxunit.org/doc. Or open mxunit/tests/framework/PublicProxyMakerTest.cfc for examples of how to use" returntype="WEB-INF.cftags.component">
		<cfargument name="ObjectUnderTest" required="true" type="WEB-INF.cftags.component" hint="an instance of the object with a private method to be proxied">
		<cfargument name="privateMethodName" required="true" type="string" hint="name of the private method to be proxied">
		<cfargument name="proxyMethodName" required="false" type="string" default="" hint="name of the proxy method name to be used; if not passed, defaults to the name of the private method prefixed with an underscore">
		<cfset var obj = "">
		<cfinvoke component="PublicProxyMaker" method="makePublic" ObjectUnderTest="#ObjectUnderTest#" privateMethodName="#privateMethodName#" proxyMethodName="#proxyMethodName#" returnvariable="obj">
		<cfreturn obj>
	</cffunction>

	<cffunction name="injectMethod" output="false" access="public" returntype="void" hint="injects the method from giver into receiver. This is helpful for quick and dirty mocking">
		<cfargument name="Receiver" type="any" required="true" hint="the object receiving the method"/>
		<cfargument name="Giver" type="any" required="true" hint="the object giving the method"/>
		<cfargument name="functionName" type="string" required="true" hint="the function to be injected from the giver into the receiver"/>
		<cfargument name="functionNameInReceiver" type="string" required="false" default="#arguments.functionName#" hint="the function name that you will call. this is useful when you want to inject giver.someFunctionXXX but have it be called as someFunction in your receiver object">
		<cfset var blender = createObject("component","ComponentBlender")>
		<cfset blender._mixinAll(Receiver,blender,"_mixin")>
		<cfset blender._mixinAll(Giver,blender,"_getComponentVariable")>
		<cfset Receiver._mixin(	propertyName = functionNameInReceiver,
								property = Giver._getComponentVariable(functionName),
								ignoreIfExisting = false )>
	</cffunction>

	<cffunction name="injectProperty" output="false" access="public" returntype="void" hint="injects properties into the receiving object">
		<cfargument name="Receiver" type="any" required="true" hint="the object receiving the method"/>
		<cfargument name="propertyName" type="string" required="true" hint="the property to be overwritten"/>
		<cfargument name="propertyValue" type="any" required="true" hint="the property value to be used">
		<cfargument name="scope" type="string" required="false" default="" hint="the scope in which to set the property. Defaults to variables and this.">
		<cfset var blender = createObject("component","ComponentBlender")>
		<cfset blender._mixinAll(Receiver,blender,"_mixin,_mixinProperty")>
		<cfset Receiver._mixinProperty(propertyName = arguments.propertyName,
								property = arguments.propertyValue,
								scope = arguments.scope)>
	</cffunction>

	<cffunction name="dump" access="public">
		<cfargument name="obj" required="true" type="any">
		<cfargument name="label" required="false" default="MXUNIT Dump" />
		<cfdump var="#arguments.obj#" label="#arguments.label#">
	</cffunction>

	<cffunction name="debug" access="public" returntype="void" hint="Use in your tests to add simple or complex debug data to test results. Used by Eclpise plugin heavily. Beware: adding lots of data, particularly object instances, will probably cause this to hang!">

		<cfargument name="debugData" type="any" required="true" />

		<cfif isDefined("request.debugArrayWrapper")>
			<cfset debugArrayWrapper = request.debugArrayWrapper>
		</cfif>
		<cfset arrayappend(debugArrayWrapper.debugArray, arguments.debugData) />
	</cffunction>

	<cffunction name="clearDebug" access="public" returntype="void" hint="Clears the debug array">
		<cfset arrayClear(debugArrayWrapper.debugArray) />
	</cffunction>

	<cffunction name="getDebug" access="public" returntype="array" hint="Returns the debug array">
		<cfif isDefined("request.debugArrayWrapper")>
			<cfset debugArrayWrapper = request.debugArrayWrapper>
		</cfif>
		<cfreturn debugArrayWrapper.debugArray />
	</cffunction>
	<cffunction name="getDebugWrapper" access="public" returntype="struct" hint="Returns the debug array">
		<cfreturn debugArrayWrapper />
	</cffunction>

	<cffunction name="setDebugWrapper" access="public" returntype="void" hint="">
		<cfargument name="debugArrayWrapper" type="struct" required="true"/>
		<cfset variables.debugArrayWrapper = arguments.debugArrayWrapper>
	</cffunction>


    <cffunction name="print" hint="Wrapper for writeoutout().">
    <cfargument name="message" />
    <cfoutput>#arguments.message#</cfoutput>
    </cffunction>

    <cffunction name="println" hint="Wrapper for writeoutout().">
    <cfargument name="message" />
    <cfoutput>#arguments.message#<br /></cfoutput>
    </cffunction>

</cfcomponent>