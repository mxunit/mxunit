		<div class="grid_12 pageFooter">
			<a href="MIT-License.txt" title="MIT License">
				&copy;<cfoutput>#year(now())# MXUnit.org - v<cfoutput>#version#</cfoutput></cfoutput>
			</a>
		</div>
		
		<div class="clear"><!-- clear --></div>
	</div>
	
	<!--- Check if doing js enhancement --->
	<cfif structKeyExists(url, 'output') and url.output eq 'js'>
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/tablesorter/jquery.tablesorter.js') />
		<cfset arrayAppend(scripts, pathBase & 'resources/jquery/jquery.runner.js') />
	</cfif>
	
	<!--- Check for custom scripts --->
	<cfif arrayLen(scripts)>
		<cfoutput>
			<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
			<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
			
			<cfloop from="1" to="#arrayLen(scripts)#" index="i">
				<script type="text/javascript" src="#scripts[i]#"></script>
			</cfloop>
		</cfoutput>
	</cfif>
</body>
</html>