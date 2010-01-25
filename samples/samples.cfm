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
	
	<ul>
		<cfoutput query="samples">
			<cfset excludes = ".svn,.,MyComponent.cfc,samples.cfm,ScheduledRun.cfm,tests" >
			
			<cfif not listfind(excludes,name)>
				<cfset isCfc = find(".cfc",name) />
				<cfset u = iif(isCfc, de("#name#?method=runtestremote&output=extjs"),de("#name#")) />
				
				<li><a href="#u#" target="_blank">#name#</li>
			</cfif>
		</cfoutput>
	</ul>
</div>

<cfinclude template="../resources/theme/footer.cfm" />