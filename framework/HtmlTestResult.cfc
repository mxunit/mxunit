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
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Returns a HTML representation of the TestResult
	--->
	<cffunction name="getHtmlResults" access="public" returntype="string" output="false">
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
				<div class="mxunitResults">
					<div class="summary">
						<ul class="nav horizontal">
							<li class="failed"><a href="##">#this.failures# Failures</a></li>
							<li class="error"><a href="##">#this.errors# Errors</a></li>
							<li class="passed"><a href="##">#this.successes# Successes</a></li>
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
							<cfset classtesturl = "/" & Replace(this.testResults[i].component, ".", "/", "all") & ".cfc?method=runtestremote&amp;output=html">
							
							<h3><a href="#classtesturl#" title="Run all tests in #this.testResults[i].component#">#this.testResults[i].component#</a></h3>
							
							<table class="results tablesorter #theme#">
								#tableHead#
								<tbody>
						</cfif>
						
						<tr class="#lCase(this.testResults[i].TestStatus)#">
							<td>
								<a href="#classtesturl#&amp;testmethod=#this.testResults[i].TestName#" title="only run the #this.testResults[i].TestName# test">#this.testResults[i].TestName#</a>
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
								<td>      
									<a href="txmt://open/?url=file://#template#&line=#line#">#template# (#line#)</a>
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
