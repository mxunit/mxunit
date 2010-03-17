<cfcomponent>    
  
  <cffunction name="setDataProviderHandler">         
    <cfargument name="dph" />
    <cfset variables.dataProviderHandler = arguments.dph />
  </cffunction>

  <cffunction name="setMockingFramework">         
     <cfargument name="mf" />
     <cfset variables.mockingFramework = arguments.mf />
   </cffunction>
  
	<cffunction name="run" returntype="WEB-INF.cftags.component" access="public" output="true" hint="Primary method for running TestSuites and individual tests.">
		<cfargument name="allSuites" hint="a structure corresponding to the key/componentName"/>
		<cfargument name="results" hint="The TestResult collecting parameter." required="no" type="TestResult" default="#createObject("component","TestResult").TestResult()#" />
		<cfargument name="testMethod" hint="A single test method to run." type="string" required="no" default="">
		<cfargument name="requestScopeDebuggingEnabled" />  
		       
		<cfset var methods = ArrayNew(1)>
		<cfset var testCase = "">
		<cfset var tickCountAtStart = 0>
		<cfset var componentIndex = 0>
		<cfset var methodIndex = 0>
		<cfset var methodName = "">
		<cfset var expectedExceptionType = "" />
		<cfset var outputOfTest = "" />    
		<cfset var currentTestSuiteName = "" />
		<!--- top-level exception is always event name / expression for Application.cfc (but not fusebox5.cfm) --->
		<cfset var caughtException = "" />
		
		<cfloop collection="#allSuites#" item="currentTestSuiteName">
	
			<cfset currentSuite = allSuites[currentTestSuiteName] />
			
			<cfif len(arguments.testMethod)>
				<cfset methods[1] = arguments.testMethod />
			<cfelse>
				<cfset methods = currentSuite["methods"] />
			</cfif>
			
			<cfset componentObject = currentSuite.ComponentObject />
			
			<cfif isSimpleValue(componentObject)>
				<cfset testCase = createObject("component", currentTestSuiteName).TestCase(componentObject) />
			<cfelse>
				<cfset testCase = componentObject.TestCase(componentObject) />
			</cfif>
			
			<!--- set the MockingFramework if one has been set for the TestSuite --->
			<cfif len(variables.MockingFramework)>
				<cfset testCase.setMockingFramework(variables.MockingFramework) />
			</cfif>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfset testCase.beforeTests() />
			
			<cfloop from="1" to="#arrayLen(methods)#" index="methodIndex">
				<cfset methodName = methods[methodIndex] />
				<cfset outputOfTest = "">
				<cfset  tickCountAtStart = getTickCount() />
				
				<cfset expectedExceptionType = testCase.getAnnotation(methodName,"expectedException") />
				
				<cftry>
					<cfset  results.startTest(methodName,currentTestSuiteName) />
					
					<cfset testCase.clearClassVariables() />
					<cfset testCase.initDebug() />
					<cfif requestScopeDebuggingEnabled OR structKeyExists(url,"requestdebugenable")>
						<cfset testCase.createRequestScopeDebug() />
					</cfif>
					
					<cfset testCase.setUp()/>
					                                                       
					<!--- 
						ATTENTION: This is where the test method is run. The following line is the center of the MXUnit universe.
					--->
					<cfset outputOfTest = runTest(testCase, methodName) />
					            
					<cfset assertExpectedExceptionTypeWasThrown(expectedExceptionType) />
	
	 				<cfset  results.addSuccess('Passed') />
					<!--- Add the trace message from the TestCase instance --->
					<cfset  results.addContent(outputOfTest) /> 
  			
					<cfcatch type="mxunit.exception.AssertionFailedError">
						<cfset addFailureToResults(results=results,expected=expectedExceptionType,actual=testCase.actual,exception=cfcatch,content=outputOfTest)>
					</cfcatch>
					
					<cfcatch type="any">
						<cfset handleCaughtException(rootOfException(cfcatch), expectedExceptionType, results, outputOfTest, testCase)>
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset testCase.tearDown() />
					
					<cfcatch type="any">
						<cfset results.addError(cfcatch)>
					</cfcatch>
				</cftry>
				
				<!--- add the deubg array to the test result item --->
				<cfset results.setDebug( testCase.getDebug() ) />
				
				<!---  make sure the debug buffer is reset for the next text method  --->
				<cfset testCase.clearDebug()  />
				
				<!--- reset the trace message.Bill 6.10.07 --->
				<cfset testCase.traceMessage="" />
				<cfset results.addProcessingTime(getTickCount()-tickCountAtStart) />
				<cfset results.endTest(methodName) />
			</cfloop>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfset testCase.afterTests()>
		</cfloop>
		
		<cfset results.closeResults() /><!--- Get correct time run for suite --->
		
		<cfreturn results />
	</cffunction>   
	                  
	<cffunction name="runTest" access="private">
		<cfargument name="testCase" /> 
		<cfargument name="methodName"/>
		<cfset var outputOfTest = "" />       
		<cfset var dpName = "" />
		<cfsavecontent variable="outputOfTest">
				<cfset dpName = testCase.getAnnotation(methodName,"dataprovider") />
				
				<cfif len(dpName) gt 0>
					<cfset testCase._$snif = _$snif />
					<cfset dataProviderHandler.init(testCase._$snif()) />
					<cfset dataProviderHandler.runDataProvider(testCase,methodName,dpName)>
				<cfelse>
					<cfinvoke component="#testCase#" method="#methodName#">
				</cfif>
		</cfsavecontent>
		<cfreturn outputOfTest />
		
	</cffunction>     
	
	
	<cffunction name="assertExpectedExceptionTypeWasThrown">
		<cfargument name="expectedExceptionType"/>
		<cfif expectedExceptionType NEQ "">
			<cfthrow type="mxunit.exception.AssertionFailedError" message="Exception: #expectedExceptionType# expected but no exception was thrown" /> 
		</cfif>
	</cffunction>
	
	
	<cffunction name="rootOfException" access="private">
		<cfargument name="caughtException"/>
		<cfif structKeyExists(caughtException,"rootcause")>
			<cfreturn caughtException.rootcause />
		</cfif>        
		<cfreturn caughtException />		
	</cffunction>
	
	<cffunction name="addFailureToResults" access="private">
		<cfargument name="results" required="true" hint="the results object">
		<cfargument name="expected" required="true">
		<cfargument name="actual" required="true">
		<cfargument name="exception" required="true" hint="the cfcatch struct">
		<cfargument name="content" required="true">
		
		<cfset results.addFailure(exception) />
		<cfset results.addExpected(expected)>
		<cfset results.addActual(actual)>
		<cfset results.addContent(content) />
		
		<cflog file="mxunit" type="error" application="false" text="#exception.message#::#exception.detail#">
	</cffunction>   
	
	<cffunction name="_$snif" access="private" hint="Door into another component's variables scope">
		<cfreturn variables />
	</cffunction>                   
	
	
	<cffunction name="handleCaughtException" access="private">      
		 <cfargument name="caughtException"/>     
		 <cfargument name="expectedExceptionType"/>    
		 <cfargument name="results" />
		 <cfargument name="outputOfTest" />      
		 <cfargument name="testCase" />
		 <cfif exceptionMatchesType(cfcatch, expectedExceptionType)>
				<cfset  results.addSuccess('Passed') />
				<cfset  results.addContent(outputOfTest) />
				<cfset  testCase.debug(caughtException) />
			<cfelseif expectedExceptionType NEQ "">
				<cfset testCase.debug(caughtException) />
				<cftry>
					<cfthrow message="Exception: #expectedExceptionType# expected but #cfcatch.type# was thrown">
					<cfcatch>
						<cfset addFailureToResults(results=results,expected=expectedExceptionType,actual=cfcatch.type,exception=cfcatch,content=outputOfTest)>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset testCase.debug(caughtException) />
				<cfset results.addError(caughtException) />
				<cfset results.addContent(outputOfTest) />
				
				<cflog file="mxunit" type="error" application="false" text="#cfcatch.message#::#cfcatch.detail#" />
			</cfif>
		
	</cffunction>
	
	
	<cffunction name="exceptionMatchesType" access="private">
		<cfargument name="actualException">
		<cfargument name="expectedExceptionType"/>   
		<cfif expectedExceptionType eq "">
			<cfreturn false/>
		</cfif>          

		<cfreturn listFindNoCase(expectedExceptionType, actualException.type) OR listFindNoCase(expectedExceptionType, getMetaData(actualException).getName())>
	</cffunction>

</cfcomponent>