<cfsetting showdebugoutput="false" />

<cfparam name="url.test" default="" />
<cfparam name="url.componentPath" default="" />
<cfparam name="url.output" default="html" />

<cfset pathBase = '../' />
<cfset title = 'Runner' />

<cfinclude template="#pathBase#resources/theme/header.cfm" />


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
			<input type="submit" value="Run Tests" id="btnRun">
			<input type="reset" value="Clear" id="btnClear" />
		</div>
		
		<div class="clear"><!-- clear --></div>
	</form>
</cfoutput>
	
<cfif testToRun NEQ "">
	<cfinvoke component="HtmlRunner" method="run" test="#testToRun#" componentPath="#url.componentPath#" output="#url.output#" />
</cfif>


<div class="grid_12 pageFooter">
	<a href="MIT-License.txt" title="MIT License">
		&copy;<cfoutput>#year(now())# MXUnit.org - v<cfoutput>#version#</cfoutput></cfoutput>
	</a>
</div>

<script type="text/javascript" src="../resources/jquery/jquery.min.js"></script>
<script type="text/javascript" src="runner.js"></script>

<!--- 
<cfinclude template="#pathBase#resources/theme/footer.cfm" />
 --->