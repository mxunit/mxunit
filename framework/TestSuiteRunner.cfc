<cfcomponent>
	<cffunction name="run" returntype="WEB-INF.cftags.component" access="public" output="true" hint="Primary method for running TestSuites and individual tests.">
		<cfargument name="suite" />
		<cfargument name="results" hint="The TestResult collecting parameter." required="no" type="TestResult" default="#createObject("component","TestResult").TestResult()#" />
		<cfargument name="testMethod" hint="A single test method to run." type="string" required="no" default="">
		<cfargument name="requestScopeDebuggingEnabled" />  
		<cfargument name="mockingFramework"/> 
		<cfargument name="dataproviderHandler"/>  
		       
		<cfset var methods = ArrayNew(1)>
		<cfset var o = "">
		<cfset var tickCountAtStart = 0>
		<cfset var componentIndex = 0>
		<cfset var methodIndex = 0>
		<cfset var methodName = "">
		<cfset var expectedExceptionType = "" />
		<cfset var outputOfTest = "" />    
		<cfset var currentTestSuiteName = "" />
		   
		<!---  Returns a structure corresponding to the key/componentName --->
		<cfset var allSuites = suite.suites() />
		
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
				<cfset o = createObject("component", currentTestSuiteName).TestCase(componentObject) />
			<cfelse>
				<cfset o = componentObject.TestCase(componentObject) />
			</cfif>
			
			<!--- set the MockingFramework if one has been set for the TestSuite --->
			<cfif len(arguments.MockingFramework)>
				<cfset o.setMockingFramework(arguments.MockingFramework) />
			</cfif>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfset o.beforeTests() />
			
			<cfloop from="1" to="#arrayLen(methods)#" index="methodIndex">
				<cfset methodName = methods[methodIndex] />
				<cfset outputOfTest = "">
				<cfset  tickCountAtStart = getTickCount() />
				
				<cfset expectedExceptionType = o.getAnnotation(methodName,"expectedException") />
				
				<cftry>
					<cfset  results.startTest(methodName,currentTestSuiteName) />
					
					<cfset o.clearClassVariables() />
					<cfset o.initDebug() />
					<cfif requestScopeDebuggingEnabled OR structKeyExists(url,"requestdebugenable")>
						<cfset o.createRequestScopeDebug() />
					</cfif>
					
					<cfset o.setUp()/>
					                                                       
					<!--- 
						ATTENTION: This is where the test method is run. The following line is the center of the MXUnit universe.
					--->
					<cfset outputOfTest = runTest(o, methodName, arguments.dataProviderHandler) />
					            
					<cfset assertExpectedExceptionTypeWasThrown(expectedExceptionType) />
	
	 				<cfset  results.addSuccess('Passed') />
					<!--- Add the trace message from the TestCase instance --->
					<cfset  results.addContent(outputOfTest) /> 
  			
					<cfcatch type="mxunit.exception.AssertionFailedError">
						<cfset addFailureToResults(results=results,expected=expectedExceptionType,actual=o.actual,exception=cfcatch,content=outputOfTest)>
					</cfcatch>
					
					<cfcatch type="any">
						<cfset handleCaughtException(rootOfException(cfcatch), expectedExceptionType, results, outputOfTest, o)>
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfset o.tearDown() />
					
					<cfcatch type="any">
						<cfset results.addError(cfcatch)>
					</cfcatch>
				</cftry>
				
				<!--- add the deubg array to the test result item --->
				<cfset  results.setDebug( o.getDebug()) />
				
				<!---  make sure the debug buffer is reset for the next text method  --->
				<cfset  o.clearDebug()  />
				
				<!--- reset the trace message.Bill 6.10.07 --->
				<cfset o.traceMessage="" />
				<cfset results.addProcessingTime(getTickCount()-tickCountAtStart) />
				<cfset results.endTest(methodName) />
			</cfloop>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfset o.afterTests()>
		</cfloop>
		
		<cfset results.closeResults() /><!--- Get correct time run for suite --->
		
		<cfreturn results />
	</cffunction>   
	                  
	<cffunction name="runTest" access="private">
		<cfargument name="o" /> 
		<cfargument name="methodName"/>
		<cfargument name="dataproviderHandler" />
		<cfset var outputOfTest = "" />       
		<cfset var dpName = "" />
		<cfsavecontent variable="outputOfTest">
				<cfset dpName = o.getAnnotation(methodName,"dataprovider") />
				
				<cfif len(dpName) gt 0>
					<cfset o._$snif = _$snif />
					<cfset dataProviderHandler.init(o._$snif()) />
					<cfset dataProviderHandler.runDataProvider(o,methodName,dpName)>
				<cfelse>
					<cfinvoke component="#o#" method="#methodName#">
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
		 <cfargument name="o" />
		 <cfif exceptionMatchesType(cfcatch, expectedExceptionType)>
				<cfset  results.addSuccess('Passed') />
				<cfset  results.addContent(outputOfTest) />
				<cfset  o.debug(caughtException) />
			<cfelseif expectedExceptionType NEQ "">
				<cfset o.debug(caughtException) />
				
				<cftry>
					<cfthrow message="Exception: #expectedExceptionType# expected but #cfcatch.type# was thrown">
					
					<cfcatch>
						<cfset addFailureToResults(results=results,expected=expectedExceptionType,actual=cfcatch.type,exception=cfcatch,content=outputOfTest)>
					</cfcatch>
				</cftry>
			<cfelse>
				<cfset o.debug(caughtException) />
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