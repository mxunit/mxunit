<cfcomponent displayname="TestSuite" extends="Test" hint="Responsible for creating and running groups of Tests.">
	<cfset cu = createObject("component","ComponentUtils") />
	<cfset requestScopeDebuggingEnabled = false />
	
	<cfparam name="this.testSuites" default="#structNew()#" />
	<cfparam name="this.tests" default="#arrayNew(1)#" />
	
	<!--- Generated content from method --->
	<cfparam name="this.c" default="Error occurred. See stack trace." />
	<cfparam name="this.dataProviderHandler" default='#createObject("component","DataproviderHandler")#' />
	<cfparam name="this.MockingFramework" default="" />
	
	<cffunction name="TestSuite" access="public" returntype="TestSuite" hint="Constructor">
		<cfreturn this />
	</cffunction>
	
	<!---
		Should be of Type "Test". Since All TestCases and TestSuites
		are inherited from Test, we should be able to add them here
		
		Also, need to
	--->
	<cffunction name="addTest" access="remote" returntype="void" hint="Adds a single TestCase to the TestSuite.">
		<cfargument name="componentName" type="string" required="yes" />
		<cfargument name="method" type="string" required="yes" />
		<cfargument name="componentObject" type="Any" required="no" default="" />
		
		<cfscript>
			try{
				this.tempStruct = structNew();
				this.tempStruct.ComponentObject = arguments.ComponentObject;
				
				// If the test suite exists get the method array and
				// append the new method name ...
				// update an existing test suite
				if (structKeyExists(this.testSuites, componentName)) {
					this.tempStruct = structFind(this.testSuites, arguments.componentName);
					
					tempArray = structFind(this.tempStruct, "methods");
					arrayAppend(tempArray,arguments.method);
					
					structUpdate(this.tempStruct, "methods", tempArray);
					structUpdate(this.testSuites,arguments.componentName, this.tempStruct);
				} else{
					//Begin a new test Suite
					structInsert(this.testSuites, arguments.componentName, this.tempStruct);
					
					//Grab all the methods that begin with the string 'test' ...
					tests = listToArray(arguments.method);
					structInsert(evaluate("this.testSuites." & arguments.componentName), "methods", tests);
				}
			} catch (Exception e) {
				writeoutput(e.getMessage());
			}
		</cfscript>
	</cffunction>
	
	<!---
		Maybe should be named addList
		Adds a list of methods belonging to a component into a testSuite object
	--->
	<cffunction name="add" access="remote" returntype="void" hint="Adds a list of TestCases to the TestSuite">
		<cfargument name="componentName" type="Any" required="yes" />
		<cfargument name="methods" type="string" required="yes" />
		<cfargument name="componentObject" type="Any" required="no" default="" />
		
		<cfscript>
			try{
				//If the component already has methods, just update the method array
				if ( structKeyExists(this.testSuites,arguments.componentName) ) {
					tests = structFind(this.testSuites, arguments.componentName);
					
					for( i = 1; i lte listLen(arguments.methods); i = i + 1 ) {
						arrayAppend(tests.methods, listGetAt(arguments.methods,i));
					}
					
					return;
				}
				
				//else convert the list of methods to an array and add it to the test suite
				this.tempStruct = structNew();
				this.tempStruct.ComponentObject = arguments.ComponentObject;
				this.tempStruct.methods = listToArray(arguments.methods);
				this.testSuites[arguments.componentName] = this.tempStruct;
			} catch (any e) {
				writeoutput("Error Adding Tests : " & e.getType() & "  " &  e.getMessage() & " " & e.getDetail());
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="addAll" access="remote" returntype="any" output="false" hint="Adds all runnable TestCases to the TestSuite">
		<cfargument name="ComponentName" type="any" required="yes" />
		<cfargument name="ComponentObject" type="any" required="false" default="" />
		
		<cfset var a_methods = "" />
		
		<cfif isSimpleValue(arguments.ComponentObject)>
			<cfset ComponentObject = createObject("component",arguments.ComponentName) />
		</cfif>
		
		<cfset a_methods = ComponentObject.getRunnableMethods() />
		
		<cfset add(arguments.ComponentName,ArrayToList(a_methods),ComponentObject) />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="run" returntype="WEB-INF.cftags.component" access="remote" output="true" hint="Primary method for running TestSuites and individual tests.">
		<cfargument name="results" hint="The TestResult collecting parameter." required="no" type="TestResult" default="#createObject("component","TestResult").TestResult()#" />
		<cfargument name="testMethod" hint="A single test method to run." type="string" required="no" default="">
		
		<cfset var testRunner = createObject("component", "TestSuiteRunner") />    
		<cfset testRunner.setMockingFramework(this.mockingFramework) />
		<cfset testRunner.setDataProviderHandler(this.dataProviderHandler) /> 
		<cfif variables.requestScopeDebuggingEnabled OR structKeyExists(url,"requestdebugenable")>
			<cfset testRunner.enableRequestScopeDebugging() />
		</cfif>                 
		<cfreturn testRunner.run(this.suites(), results, testMethod)>
		<!---  Returns a structure corresponding to the key/componentName --->
		<cfset var temp = this.suites() />
		
		<!--- top-level exception is always event name / expression for Application.cfc (but not fusebox5.cfm) --->
		<cfset var caughtException = "" />
		
		<cfloop from="1" to="#arrayLen(components)#" index="i">
			<cfset this.suites = structFind(temp, components[i] ) />
			
			<cfif len(arguments.testMethod)>
				<cfset methods[1] = arguments.testMethod />
			<cfelse>
				<cfset methods = structFind(this.suites, "methods") />
			</cfif>
			
			<cfset componentObject = structFind(this.suites,"ComponentObject") />
			
			<cfif isSimpleValue(componentObject)>
				<cfset o = createObject("component", components[i]).TestCase(componentObject) />
			<cfelse>
				<cfset o = componentObject.TestCase(componentObject) />
			</cfif>
			
			<!--- set the MockingFramework if one has been set for the TestSuite --->
			<cfif len(this.MockingFramework)>
				<cfset o.setMockingFramework(this.MockingFramework) />
			</cfif>
			
			<!--- Invoke prior to tests. Class-level setUp --->
			<cfinvoke component="#o#" method="beforeTests" />
			
			<cfloop from="1" to="#arrayLen(methods)#" index="j">
				<cfset methodName = methods[j] />
				<cfset this.c = "">
				<cfset  start = getTickCount() />
				
				<!--- what we expect from the method --->
				<cfset exception = o.getAnnotation(methodName,"expectedException") />

				<cftry>
					<cfset  results.startTest(methodName,components[i]) />
					
					<!--- Get start time Execute the test --->
					<cfinvoke component="#o#" method="clearClassVariables" />
					
					<cfset o.initDebug() />
					
					<cfif requestScopeDebuggingEnabled OR structKeyExists(url,"requestdebugenable")>
						<cfset o.createRequestScopeDebug() />
					</cfif>
					
					<cfinvoke component="#o#" method="setUp" />
					
					<cfsavecontent variable="this.c">
						<cfset dpName = o.getAnnotation(methodName,"dataprovider") />
						
						<cfif len(dpName) gt 0>
							<cfset o._$snif = _$snif />
							<cfset this.dataProviderHandler.init(o._$snif()) />
							<cfset this.dataProviderHandler.runDataProvider(o,methodName,dpName)>
						<cfelse>
						  <cftry>
							<cfinvoke component="#o#" method="#methodName#" />
						  <cfcatch type="any">
							  <cfif o.expectedException eq cfcatch.type>
							      <cfset exception = cfcatch.type />
							      <cfset o.expectedException = '' />
								<cfelse>
								   <cfrethrow />
								</cfif>
						  </cfcatch>
						  </cftry>
						</cfif>
					</cfsavecontent>
					
					<!--- Were we expecting an error or not? --->
					<cfif exception eq "">
						<cfset  results.addSuccess('Passed') />
						<!--- Add the trace message from the TestCase instance --->
						<cfset  results.addContent(this.c) />
					<cfelse>
						 <cfthrow type="#exception#" message="Exception: #exception# expected but no exception was thrown" />
					</cfif>
					
					<cfcatch type="any">
						<!--- paranoia --->
						<cfset caughtException = cfcatch />
						<cfif structKeyExists(caughtException,"rootcause")>
							<cfset caughtException = caughtException.rootcause />
						</cfif>
						
						<cfif exception NEQ "" and (listFindNoCase(exception, cfcatch.type) OR listFindNoCase(exception, getMetaData(cfcatch).getName()) )>
							<cfset  results.addSuccess('Passed') />
							<cfset  results.addContent(this.c) />
							<cfset  o.debug(caughtException) />
						<cfelseif exception NEQ "">
							<cfset o.debug(caughtException) />
							<cftry>
								<cfthrow type="mxunit.exception.AssertionFailedError" message="Exception: #exception# expected but #cfcatch.type# was thrown">
								<cfcatch>
									<cfset addFailureToResults(results=results,expected=exception,actual=cfcatch.type,exception=cfcatch,content=this.c)>
								</cfcatch>
							</cftry>
						<cfelse>
							<cfset o.debug(caughtException) />
							<cfset results.addError(caughtException) />
							<cfset results.addContent(this.c) />
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
	
	<cffunction name="runTestRemote" access="remote" output="true">
		<cfargument name="output" type="string" required="false" default="jqgrid" hint="Output format: html,xml,junitxml,jqgrid ">
		<cfargument name="debug" type="boolean" required="false" default="false" hint="Flag to indicate whether or not to dump the test results to the screen.">
		
		<cfscript>
			var result = this.run();
			
			switch(arguments.output){
				case 'html':
				  writeoutput(this.result.getHtmlresults());
				break;
				
				case 'rawhtml':
				  writeoutput(this.result.getHtmlresults());
				break;
				
				case 'xml':
					writeoutput(this.result.getXmlresults());
				break;
				
				case 'junitxml':
					writeoutput(this.result.getJUnitXmlresults());
				break;
				
				case 'json':
					writeoutput(this.result.getJSONResults());
				break;
				
				case 'query':
					dump(this.result.getQueryresults());
				break;
				
				case 'extjs': // TODO deprecated
				 	writeoutput( this.result.getHtmlresults() );
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
			<cfdump var="#result.getResults()#" label="Raw Results Dump">
		</cfif>
	</cffunction>
	
	<cffunction name="suites" access="public" returntype="struct">
		<cfreturn this.testSuites />
	</cffunction>
	
	<cffunction name="stringValue" access="remote" returntype="string">
		<cfreturn this.suites().toString() />
	</cffunction>
	
	<cffunction name="dump">
		<cfargument name="o">
		<cfdump var="#o#">
	</cffunction>
	
	<cffunction name="enableRequestScopeDebugging" access="public" output="false" hint="enables creation of the request.debug function">
		<cfset requestScopeDebuggingEnabled = true>
	</cffunction>
	
	<cffunction name="setMockingFramework" hint="Allows a developer to set the default Mocking Framework for this test suite.">
		<cfargument name="name" type="Any" required="true" hint="The name of the mocking framework to use" />
		<cfset this.MockingFramework = arguments.name />
	</cffunction>
</cfcomponent>
