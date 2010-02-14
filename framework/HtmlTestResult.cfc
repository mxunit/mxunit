<!---
Extension of TestResult
--->
<cfcomponent displayname="HTMLTestResult" output="true"	extends="TestResult" hint="Responsible for generating HTML representation of a TestResult">
	
	<cfparam name="this.testResults" type="any" default="">

	<cffunction name="HTMLTestResult" hint="Constructor" access="public" returntype="HTMLTestResult">
		<cfargument name="testResults" type="TestResult" required="false">
		<cfset this.testRuns = arguments.testResults.testRuns>
		<cfset this.failures = arguments.testResults.testFailures>
		<cfset this.errors = arguments.testResults.testErrors>
		<cfset this.successes = arguments.testResults.testSuccesses>
		<cfset this.totalExecutionTime = arguments.testResults.totalExecutionTime>
		<cfset this.testResults = arguments.testResults.results>
		<cfreturn this>
	</cffunction>

	<cffunction name="getHtmlResults" access="public" returntype="string" output="true" hint="Returns a HTML representation of the TestResult">
		<cfargument name="enhancedview" required="false" type="boolean" default="true" hint="I indicate if the HTML should be enhanced with javascript">
		
		<cfset var result = "">
		<cfset var classname = "">
		<cfset var i = "">
		<cfset var k = "">
		<cfset var theme = "testsuccess">
		
		<cfif this.successes neq this.testRuns>
			<cfset theme = "testfailed">
		</cfif>
		
		<cfsavecontent variable="result">
			<cfoutput>
				<html>
					<head>
						<title>MXUnit Test Results - #this.failures# Failures | #this.errors# Errors | #this.successes# Successes</title>
						<style type="text/css"> 
						body  {
							font-family: verdana, arial, helvetica, sans-serif;
							background-color: ##FFFFFF;
							font-size: 12px;
							margin-top: 10px;
							margin-left: 10px;
						}
						h1 {
							color:black;
							font-size:16px;
							border-bottom:2px solid ##D0D0D0;
						}
						table {
							width: 90%;
							border-collapse:collapse;
							margin:10px 0 10px 0;
							font-size:1em;
						}
						td, th {
							padding: 6px;
						}
						tbody td {
							border:1px solid ##D0D0D0;
						}
						th.component{
							text-align:left;
							color:black;
							background-color:##D0D0D0;	
							border-bottom:1px solid ##B0B0B0;						
						}
						a {
							color:black !important;
							text-decoration: underline;
						}
						##result-summary{
							font-size: 10pt; 
							font-family: Verdana; 
							margin: 10px 10px 20px 0px;
						}
						table.tagcontext{
							color:##b0b0b0;
							font-size:1em;
						}
						/* themes */
						table.testsuccess thead{
							background-color:##39892F;
							color:##F8F8F8;
						}
						.passed {
							color:##39892F; 
							font-weight:bold
						}

						table.testfailed thead{
							background-color:##CF0000;
							color:##F8F8F8;
						}
						.failed {
							color:blue; 
							font-weight:bold
						}
						.error {
							color:##CF0000; 
							font-weight:bold
						}
						
						/* buttons */
						.button-state-default {
							background-color: ##fafafa;
							color:##a0a0a0;
						}
						.button-state-active {
							background-color: ##FFFFFF;
							color:black;
						}
						.button-corner-all {
							-moz-border-radius: 10px; 
							-webkit-border-radius: 10px;
							border: 1px solid ##D0D0D0;
							padding: 7px;
						}
						</style>
					</head>
					<body>
						
						<p>(<a href="?method=runTestRemote&output=jq">view as pretty html</a>)</p>

						<div id="result-summary">
							<span class="button-state-active button-corner-all" title="Failed"><span class="failed">#this.failures#</span> Failures</span>
							<span class="button-state-active button-corner-all" title="Error"><span class="error">#this.errors#</span> Errors</span>
							<span class="button-state-active button-corner-all" title="Passed"><span class="passed">#this.successes#</span> Successes</span>
						</div>

						<table class="test-result-table #theme#">
							<thead class="test-result-header">
								<tr>
									<th>Test</th>
									<th>Result</th>
									<th>Error Info</th>
									<th>Speed</th>
									<th>Output</th>
								</tr>
							</thead>
							<tbody class="test-result-content">
						<cfloop from="1" to="#ArrayLen(this.testResults)#" index="i">
							<cfif classname neq this.testResults[i].component>
								<cfset classname = this.testResults[i].component>
								<cfset classtesturl = "/" & Replace(this.testResults[i].component, ".", "/", "all") & ".cfc?method=runtestremote&amp;output=html">
								<tr>
									<th colspan="5" class="component"><a href="#classtesturl#" title="run all tests in #this.testResults[i].component#">#this.testResults[i].component#</a></th>
								</tr>
							</cfif>
								<tr>
									<td><a href="#classtesturl#&amp;testmethod=#this.testResults[i].TestName#" title="only run the #this.testResults[i].TestName# test">#this.testResults[i].TestName#</a></td>
									<td class="#LCase(this.testResults[i].TestStatus)#">#this.testResults[i].TestStatus#</td>
									<td>#renderErrorStruct(this.testResults[i].Error)#</td>
									<td>#this.testResults[i].Time#ms</td>
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

					<!--- stick javascript at the bottom of the page so that it doesn't slow page rendering --->
					<cfif arguments.enhancedview>
						<script type="text/javascript" src="/mxunit/resources/jquery.min.js"></script>
						<script type="text/javascript">
						// <![CDATA[
						$(function(){
							$('##result-summary>span:lt(3)')
								.css({cursor:"pointer"})
								.click(function(){
									var $this = $(this).toggleClass("button-state-active").toggleClass("button-state-default");
									var status = $this.attr("title").split(' ').pop().toLowerCase();
									$resultrows = $("tbody>tr>td." + status).parent().toggle();
								})
								.each(function(){
									$this = $(this);
									$this.attr('title', 'Click to toggle: ' + $this.attr('title') );
								})
								.parent()
								.before('<p>Click a button to filter test results<\/p>');
							});
							
							// make tagcontext info hidden
							$tagcontext = $('table.tagcontext');
							
							if ($tagcontext.size())
							{
								$tagcontext
									.hide()
									.before('<span><br />show info<\/span>')
									.css({cursor:"pointer"})
									.prev()
									.click(function(){
										$(this).next().toggle();
									});
									
								$('##result-summary')
									.append('<span class="button-state-default button-corner-all">Toggle Error Info<\/span>')
									.css({cursor:"pointer"})
									.find('span:last')
									.click(function(){
										if ($tagcontext.find(':hidden').size()==0){
											$tagcontext.hide();
										}
										else{
											$tagcontext.show();
										}
										$(this).toggleClass("button-state-active");
									});
							}
						// ]]>
						</script>
					</cfif>
						
					</body>
				</html>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn Trim(result)>

	</cffunction>
	
	<cffunction name="renderErrorStruct" output="false" returntype="string" access="private" hint="I render a coldfusion error struct as HTML">
		<cfargument name="ErrorCollection" required="true" type="any">
		
		<cfset var result = "">
		<cfset var i = 0>
		
		<cfif NOT IsSimpleValue(arguments.ErrorCollection)>
			<cfsavecontent variable="result">
				<cftry>
				<cfoutput>
					<cfif Left(arguments.ErrorCollection.Message,2) neq "::">
							#Replace(arguments.ErrorCollection.Message,"::","<br />")#
					<cfelse>
							#arguments.ErrorCollection.Message#
					</cfif>
							<table class="tagcontext">
					<cfloop from="1" to="#ArrayLen(arguments.ErrorCollection.TagContext)#" index="i">
								<tr>
									<td>#arguments.ErrorCollection.TagContext[i].line#</td>
									<td>#arguments.ErrorCollection.TagContext[i].template#</td>
								</tr>
					</cfloop>
							</table>
				</cfoutput>
<cfcatch>
				<cfdump var="#arguments#">
				</cfcatch>				
				</cftry>
			</cfsavecontent>
		</cfif>
		<cfreturn result>
	</cffunction>
	
</cfcomponent>