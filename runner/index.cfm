<cfsetting showdebugoutput="false" />

<cfparam name="url.test" default="" />
<cfparam name="url.componentPath" default="" />
<cfparam name="url.output" default="extjs" />
<cfset pathBase = '../' />
<cfset title = 'Runner' />

<cfinclude template="../resources/theme/header.cfm" />

<cfset scripts = arrayNew(1) />
<cfset arrayAppend(scripts, 'runner.js') />

<cfset testIsPresent = cgi.path_info is not "" OR url.test is not "" />
<cfset testToRun = iif(cgi.path_info is "", de(url.test), de(cgi.path_info)) />

<cfoutput>
	<form id="runnerForm" action="index.cfm" method="get">
		<div class="grid_8">
			<div>
				<label for="test">
					TestCase, TestSuite, or Directory: <br />
					<input type="text" id="test" name="test" value="#testToRun#" size="60" />
				</label>
			</div>
		</div>
		
		<div class="grid_4">
			<div>
				<label for="componentPath">
					(<code>componentPath</code> if Directory):<br />
					<input type="text" id="componentPath" name="componentPath" value="#url.componentPath#" size="30" />
				</label>
			</div>
		</div>
		
		<div class="grid_12 align-center">
			<input type="submit" value="Run Tests">
			<input type="reset" value="Clear" />
		</div>
		
		<div class="clear"><!-- clear --></div>
	</form>
</cfoutput>
	
<cfif testToRun NEQ "">
	<cfinvoke component="HtmlRunner" method="run" test="#testToRun#" componentPath="#url.componentPath#" output="#url.output#" />
</cfif>

<cfinclude template="../resources/theme/footer.cfm" />