<cfparam name="url.output" default="extjs" />
<cfset pathBase = '../' />
<cfset title = 'Samples' />

<cfinclude template="../resources/theme/header.cfm" />

<div class="grid_12">
	<h2>Samples</h2>
	
	<p>
		Note that these samples assume installation of MXUnit <strong>directly under the web root</strong>.
		The MXUnit Framework and Eclipse Plugin will still work, but the samples will not. You can also
		change the <code>extends="mxunit.framework.TestCase"</code> to the path of your installation and
		the samples will run correctly.
	</p>
	
	
	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#" name="samples" />
	
	<h4>Unit Testing</h4>
	<ul>
		<cfoutput query="samples">
			<cfset excludes = ".svn,.,MyComponent.cfc,samples.cfm,ScheduledRun.cfm,tests,mocking,RemoteFacadeTester.cfm" >
			
			<cfif not listfind(excludes,name)>
				<cfset isCfc = find(".cfc",name) />
				<cfset u = iif(isCfc, de("#name#?method=runtestremote"),de("#name#")) />
				
				<li><a href="#u#" target="_blank">#name#</a></li>
			</cfif>
		</cfoutput>
		

		
	</ul>
	
	<cfdirectory action="list" directory="#getDirectoryFromPath(getCurrentTemplatePath())#/mocking" name="msamples" />
	<h4>Mocking</h4>
	<ul>
		<cfoutput query="msamples">
			<cfset excludes = ".svn,.,querysim.cfm,TheComponent.cfc,TheCollaborator.cfc" >
			
			<cfif not listfind(excludes,name)>
				<cfset isCfc = find(".cfc",name) />
				<cfset u = iif(isCfc, de("#name#?method=runtestremote"),de("#name#")) />
				
				<li><a href="mocking/#u#" target="_blank">#name#</a></li>
			</cfif>
		</cfoutput>
		
		
	</ul>
	
	<h4>Miscellaneous</h4>
	<ul>
		<li><a href="../runner/index.cfm">Web-based HTML Runner	</a></li>
		<li><a href="../tests/run.cfm">Run all MXUnit framework tests</a></li>	
     </ul>


<p></p>
<p>
	Visit the <a href="http://wiki.mxunit.org">MXUnit Wiki</a> for more examples and detailed documentation.
	</p>
</div>

<cfinclude template="../resources/theme/footer.cfm" />