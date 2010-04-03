		<div class="grid_12 pageFooter">
			<a href="MIT-License.txt" title="MIT License">
				&copy;<cfoutput>#year(now())# MXUnit.org - v<cfoutput>#version#</cfoutput></cfoutput>
			</a>
		</div>
		
		<div class="clear"><!-- clear --></div>
	</div>
	
	<!--- Check if doing js enhancement --->
	<cfif structKeyExists(url, 'print_js_resources') and url.print_js_resources> <!--- just a flag to load resources? --->
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/jquery.min.js') />
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/jquery-ui.min.js') />
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/tablesorter/jquery.tablesorter.js') />
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/jquery.runner.js') />
	</cfif>
	
	<!--- Check for custom scripts --->
	<cfif arrayLen(scripts)>
		<cfoutput>
			<cfloop from="1" to="#arrayLen(scripts)#" index="i">
				<script type="text/javascript" src="#scripts[i]#"></script>
			</cfloop>
		</cfoutput>
	</cfif>
</body>
</html>