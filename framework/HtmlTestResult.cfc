<!---
	Extension of TestResult
--->
<cfcomponent displayname="HTMLTestResult" output="true"	extends="TestResult" hint="Responsible for generating HTML representation of a TestResult">
	<cfparam name="this.testResults" type="any" default="" />
		
	<cffunction name="HTMLTestResult" hint="Constructor" access="public" returntype="HTMLTestResult">
		<cfargument name="testResults" type="TestResult" required="false" />
		<cfset this.testRuns = arguments.testResults.testRuns />
		<cfset this.failures = arguments.testResults.testFailures />
		<cfset this.errors = arguments.testResults.testErrors />
		<cfset this.successes = arguments.testResults.testSuccesses />
		<cfset this.totalExecutionTime = arguments.testResults.totalExecutionTime />
		<cfset this.testResults = arguments.testResults.results />
		<cfset this.installRoot = createObject("component","ComponentUtils").getComponentRoot() />
		<cfreturn this />
	</cffunction>
	
	

	<!--- bill : 3.7.10
			
			Todo: Make sure it works with no external CSS or JavaScript. Maybe redirect to old XMLResult if JS is not enabled?
			Todo: Filter should work with components. That is, when filtering results of a TestSuite, if suite
			      doesn't contain filter items (empty) it should not display.
			
   --->

	<cffunction name="printResources" access="public" output="true" hint="Prints CSS and JavaScript refs for stylizing">
 		<cfargument name="mxunit_root" required="no" default="mxunit" hint="Location in the webroot where MXUnit is installed." />
		<cfargument name="test_title" required="false" default="MXUnit Test Results" hint="An HTML title to display for this test" />
			<link rel="stylesheet" type="text/css" href="/#mxunit_root#/resources/theme/styles.css">
			<link rel="stylesheet" type="text/css" href="/#mxunit_root#/resources/jquery/tablesorter/green/style.css">
			<link rel="stylesheet" type="text/css" href="/#mxunit_root#/resources/theme/results.css">
			<script type="text/javascript" src="/#mxunit_root#/resources/jquery/jquery.min.js"></script>
			<script type="text/javascript" src="/#mxunit_root#/resources/jquery/jquery-ui.min.js"></script>
			<script type="text/javascript" src="/#mxunit_root#/resources/jquery/tablesorter/jquery.tablesorter.js"></script>
			<script type="text/javascript" src="/#mxunit_root#/resources/jquery/jquery.runner.js"></script>
			<script type="text/javascript" src="/#mxunit_root#/resources/jquery/tipsy/javascripts/jquery.tipsy.js"></script>
			<link rel="stylesheet" type="text/css" href="/#mxunit_root#/resources/jquery/tipsy/stylesheets/tipsy.css" />
			<title>#test_title#</title>
	</cffunction>



	<cffunction name="printNoScript" access="public" output="true" hint="Prints noscript JS alternative">
 	 &nbsp;<noscript>
		 <h2 align="center">If you enable JavaScript, many more UI features will be available.</h2>
	  </noscript>
	</cffunction>


   <cffunction name="getHtmlResults" access="public" returntype="string" output="false" hint="Returns a stylized HTML representation of the TestResult">
 		<cfargument name="mxunit_root" required="no" default="#this.installRoot#" hint="Location in the webroot where MXUnit is installed." />
        <cfargument name="test_title" required="false" default="MXUnit Test Results" hint="An HTML title to display for this test">
		<cfset var result = "" />
		<cfset var temp = "" />
		<cfsavecontent variable="result">
			<cfset printResources(mxunit_root,test_title) />
			<cfset printNoScript() />
			<cfset temp = trim(getRawHtmlResults(mxunit_root))>
			<cfoutput>#temp#</cfoutput>
		</cfsavecontent>
		<cfreturn result>
   </cffunction>


	<cffunction name="getRawHtmlResults" access="public" returntype="string" output="false" hint="Returns a _raw_ HTML representation of the TestResult">
		<cfset var result = "" />
		<cfset var classname = "" />
		<cfset var i = "" />
		<cfset var k = "" />
		<cfset var isNewComponent = false />
		<cfset var tableHead = '' />
		<cfset var theme = "pass" />
		
		<cfif this.successes neq this.testRuns>
			<cfset theme = "fail" />
		</cfif>
		
		<cfsavecontent variable="tableHead">
			<thead>
				<tr>
					<th>Test</th>
					<th>Result</th>
					<th>Error Info</th>
					<th>Speed</th>
					<th>Output</th>
				</tr>
			</thead>
		</cfsavecontent>
		
		<cfsavecontent variable="result">
			<cfoutput>
			
				<div class="mxunitResults" style="padding:20px">
					
							<div class="summary">
								<ul class="nav horizontal">
									<li class="failed"><a rel="tipsy" href="##" title="Toggle Failures">#this.failures# Failures</a></li>
									<li class="error"><a rel="tipsy" href="##" title="Toggle Errors">#this.errors# Errors</a></li>
									<li class="passed"><a rel="tipsy" href="##" title="Toggle Successes">#this.successes# Successes</a></li>
								</ul>
								<div class="clear"><!-- clear --></div>
							</div>
							
					<cfloop from="1" to="#ArrayLen(this.testResults)#" index="i">
					
						<!--- Check if we are on a new component --->
						<cfset isNewComponent = classname neq this.testResults[i].component />
						
						<cfif isNewComponent>
							<!--- If this is not the first component close the previous one --->
							<cfif classname neq ''>
									</tbody>
								</table>
							</cfif>
							<cfset classname = this.testResults[i].component>
							<!--- printing incorrect results for MXUnitInstallTest.cfc - could be engine bug --->
							<cfset classtesturl = "/" & Replace(this.testResults[i].component, ".", "/", "all") & ".cfc?method=runtestremote&amp;output=html">
							
							<h3><a href="#classtesturl#" title="Run all tests in #this.testResults[i].component#">#this.testResults[i].component#</a></h3>
							
							<table class="results tablesorter #theme#" cellpadding="0" cellspacing="0">
								#tableHead#
								<tbody>
						</cfif>
						
						
						
						<tr class="#lCase(this.testResults[i].TestStatus)#">
							<td>
								<a class="#lCase(this.testResults[i].TestStatus)#" href="#classtesturl#&amp;testmethod=#this.testResults[i].TestName#" rel="tipsy" title="Run just #this.testResults[i].TestName#">#this.testResults[i].TestName#</a>
							</td>
							<td>
								#this.testResults[i].TestStatus#
							</td>
							<td>
								#renderErrorStruct(this.testResults[i].Error)#
							</td>
							<td>
								#this.testResults[i].Time# ms
							</td>
							<td>
							  <cfif not structKeyExists(url,"toggledebug")>
								<cfif ArrayLen(this.testResults[i].Debug)>
									<cfloop from="1" to="#ArrayLen(this.testResults[i].Debug)#" index="k">
										<cfif IsSimpleValue(this.testResults[i].Debug[k])>
											#this.testResults[i].Debug[k]#<br />
										<cfelseif IsStruct(this.testResults[i].Debug[k]) AND StructKeyExists(this.testResults[i].Debug[k], "TagContext")>
											<!--- error thrown, shown in error info col so hide here
											#renderErrorStruct( this.testResults[i].Debug[k] )#
											--->
										<cfelse>
											<cfdump var="#this.testResults[i].Debug[k]#">
										</cfif>
									</cfloop>
								</cfif>
							</cfif>
							</td>
						</tr>
					</cfloop>
						</tbody>
					</table>
				</div>
				
			</cfoutput>
		</cfsavecontent>
		<cfreturn Trim(result) />
	</cffunction>
	
	
	<cffunction name="renderErrorStruct" output="false" returntype="string" access="private" hint="I render a coldfusion error struct as HTML">
		<cfargument name="ErrorCollection" required="true" type="any">
		
		<cfset var result = "" />
		<cfset var i = 0 />     
		<cfset var template = "" />
		<cfset var line = "" />
		
		<cfif NOT IsSimpleValue(arguments.ErrorCollection)>
			<cfsavecontent variable="result">
				<cfoutput>
					<cfif Left(arguments.ErrorCollection.Message, 2) neq "::">
						<strong>#Replace(arguments.ErrorCollection.Message,"::","<br />")#</strong> <br />
						<pre style="width:100%;">#arguments.ErrorCollection.Detail#</pre>
					<cfelse>
						#arguments.ErrorCollection.Message#
					</cfif>
					
					<table class="tagcontext">
						<cfloop from="1" to="#ArrayLen(arguments.ErrorCollection.TagContext)#" index="i">
							<cfset template = arguments.ErrorCollection.TagContext[i].template /> 
							<cfset line = arguments.ErrorCollection.TagContext[i].line />
							<tr>
								<td  class="stacktrace">      
									#template# (<a href="txmt://open/?url=file://#template#&line=#line#" title="Open this in TextMate">#line#</a>)
								</td>
							</tr>
						</cfloop>
					</table>
				</cfoutput>
			</cfsavecontent>
		</cfif>
		
		<cfreturn result />
	</cffunction>
</cfcomponent>
