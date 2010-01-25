<cfparam name="url.pathIndex" default="1" />
<cfparam name="url.startRoot" default="" type="string">
<cfparam name="url.startPackage" default="" type="string">
<cfparam name="url.startComponent" default="" type="string">
<cfoutput>
<frameset rows="40%,60%">
	<frame src="packages.cfm?pathIndex=#url.pathIndex#&startPackage=#trim(url.startPackage)#&startRoot=#trim(url.startRoot)#&startComponent=#trim(url.startComponent)#" name="packages"></frame>
	<cfif url.startPackage NEQ "">
		<frame src="blank.htm" name="components"></frame>
	<cfelse>
		<frame src="components.cfm" name="components"></frame>	
	</cfif>
</frameset><noframes></noframes>
</cfoutput>