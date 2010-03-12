<cfcomponent>
	<cffunction name="run" returntype="WEB-INF.cftags.component" access="remote" output="true" hint="Primary method for running TestSuites and individual tests.">
		<cfargument name="suite" />
		<cfargument name="results" hint="The TestResult collecting parameter." required="no" type="TestResult" default="#createObject("component","TestResult").TestResult()#" />
		<cfargument name="testMethod" hint="A single test method to run." type="string" required="no" default="">
		<cfargument name="requestScopeDebuggingEnabled" />    
		
		<cfset var methods = ArrayNew(1)>
		<cfset var o = "">
		<cfset var start = "">
		<cfset var end = "">
		<cfset var i = "">
		<cfset var j = "">
		<cfset var methodName = "">
		<cfset var expectedException = "" />
		<cfset var dpName = "" />
		<cfset var components = structKeyArray(suite.suites()) />    
		<cfset var outputOfTest = "" />
		
		<!---  Returns a structure corresponding to the key/componentName --->
		<cfset var originalSuites = suite.suites() />
		
		<!--- top-level exception is always event name / expression for Application.cfc (but not fusebox5.cfm) --->
		<cfset var caughtException = "" />
		
		<cfloop from="1" to="#arrayLen(components)#" index="i">
			<cfset suite.suites = structFind(originalSuites, components[i] ) />
			
			<cfif len(arguments.testMethod)>
				<cfset methods[1] = arguments.testMethod />
			<cfelse>
				<cfset methods = structFind(suite.suites, "methods") />
			</cfif>
			
			<cfset componentObject = structFind(suite.suites,"ComponentObject") />
			
			<cfif isSimpleValue(componentObject)>
				<cfset o = createObject("component", components[i]).TestCase(componentObject) />
			<cfelse>
				<cfset o = componentObject.TestCase(componentObject) />
			</cfif>
			
			<!--- set the MockingFramework if one has been set for the TestSuite --->
			<cfif len(suite.MockingFramework)>
				<cfset o.setMockingFramework(suite.MockingFramework) />
			</cfif>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfinvoke component="#o#" method="beforeTests" />
			
			<cfloop from="1" to="#arrayLen(methods)#" index="j">
				<cfset methodName = methods[j] />
				<cfset outputOfTest = "">
				<cfset  start = getTickCount() />
				
				<cfset expectedException = o.getAnnotation(methodName,"expectedException") />
				
				<cftry>
					<cfset  results.startTest(methodName,components[i]) />
					
					<!--- Get start time Execute the test --->
					<cfinvoke component="#o#" method="clearClassVariables" />
					
					<cfset o.initDebug() />
					
					<cfif requestScopeDebuggingEnabled OR structKeyExists(url,"requestdebugenable")>
						<cfset o.createRequestScopeDebug() />
					</cfif>
					
					<cfinvoke component="#o#" method="setUp" />
					
					<cfsavecontent variable="outputOfTest">
						<cfset dpName = o.getAnnotation(methodName,"dataprovider") />
						
						<cfif len(dpName) gt 0>
							<cfset o._$snif = _$snif />
							<cfset suite.dataProviderHandler.init(o._$snif()) />
							<cfset suite.dataProviderHandler.runDataProvider(o,methodName,dpName)>
						<cfelse>
							<cfinvoke component="#o#" method="#methodName#">
						</cfif>
					 </cfsavecontent>
					
					<!--- Were we expecting an error or not? --->
					<cfif expectedException EQ "">
						<cfset  results.addSuccess('Passed') />
						
						<!--- Add the trace message from the TestCase instance --->
						<cfset  results.addContent(outputOfTest) />
					<cfelse>
						 <cfthrow type="mxunit.exception.AssertionFailedError" message="Exception: #expectedException# expected but no exception was thrown" />
					</cfif>
					
					<cfcatch type="mxunit.exception.AssertionFailedError">
						<cfset addFailureToResults(results=results,expected=expectedException,actual=o.actual,exception=cfcatch,content=outputOfTest)>
					</cfcatch>
					
					<cfcatch type="any">
						<!--- paranoia --->
						<cfset caughtException = rootOfException(cfcatch)>
						
						<cfif expectedException NEQ "" and (listFindNoCase(expectedException, cfcatch.type) OR listFindNoCase(expectedException, getMetaData(cfcatch).getName()) )>
							<cfset  results.addSuccess('Passed') />
							<cfset  results.addContent(outputOfTest) />
							<cfset  o.debug(caughtException) />
						<cfelseif expectedException NEQ "">
							<cfset o.debug(caughtException) />
							
							<cftry>
								<cfthrow message="Exception: #expectedException# expected but #cfcatch.type# was thrown">
								
								<cfcatch>
									<cfset addFailureToResults(results=results,expected=expectedException,actual=cfcatch.type,exception=cfcatch,content=outputOfTest)>
								</cfcatch>
							</cftry>
						<cfelse>
							<cfset o.debug(caughtException) />
							<cfset results.addError(caughtException) />
							<cfset results.addContent(outputOfTest) />
							
							<cflog file="mxunit" type="error" application="false" text="#cfcatch.message#::#cfcatch.detail#" />
						</cfif>
					</cfcatch>
				</cftry>
				
				<cftry>
					<cfinvoke component="#o#" method="tearDown">
					
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
				<cfset end = getTickCount() />
				<cfset results.addProcessingTime(end-start) />
				<cfset results.endTest(methodName) />
			</cfloop>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfinvoke component="#o#" method="afterTests">
		</cfloop>
		
		<cfset results.closeResults() /><!--- Get correct time run for suite --->
		
		<cfreturn results />
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

</cfcomponent>