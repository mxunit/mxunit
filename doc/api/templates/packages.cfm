<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Package List - API Documentation</title>
<base target="components">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">

</head>
<body class="classFrameContent">

<cfparam name="url.pathIndex" default="1" />
<cfparam name="url.startRoot" default="" type="string">
<cfparam name="url.startPackage" default="" type="string">
<cfparam name="url.startComponent" default="" type="string">

<cfoutput>
<cfset foundStartRoot = false>	
<cfif url.startRoot neq "">
	<cfloop from="1" to="#arrayLen(paths)#" index="i">
			<cfif url.startRoot EQ paths[i].prefix>
				<cfset foundStartRoot = true>
				<cfset url.pathIndex = i>
				<cfbreak>
			</cfif>
	</cfloop>
</cfif>	
	<form style="margin: 0px;">
		Root:
		<select onChange="parent.location='leftbar.cfm?pathIndex='+this.options[this.selectedIndex].value;">
		<cfif foundStartRoot>	
			<cfloop from="1" to="#arrayLen(paths)#" index="i">
				<option value="#i#"<cfif url.startRoot EQ paths[i].prefix> selected="selected"</cfif>>#paths[i].prefix#</option>
			</cfloop>
		<cfelse> 
			<cfloop from="1" to="#arrayLen(paths)#" index="i">
				<option value="#i#"<cfif url.pathIndex EQ i> selected="selected"</cfif>>#paths[i].prefix#</option>
			</cfloop>
		</cfif>	
		</select>
	</form>
	<br>
	<a href="components.cfm" >All Packages</a> <!---&nbsp;|&nbsp;
	 <a href="#cgi.script_name#?refresh=1&baseRemove=#templates#" target="packages">Refresh</a> --->
	<p>
	Packages <br>
	</cfoutput>
	<cfset foundPackage = false>
	<cfset tmpquery = application.queryStore[paths[url.pathIndex].path].filequery>
	<cfoutput query="tmpquery" group="package">
		<cfset displayName = util.getPackageDisplayName(tmpquery.package)> 
		<cfif displayName EQ url.startPackage>
			<cfset foundPackage = true>
			<cfset packageLink = "components.cfm?package=#tmpquery.package#&pathindex=#url.pathIndex#">
		</cfif>			
		<a href="components.cfm?package=#tmpquery.package#&pathindex=#url.pathIndex#" target="components">#displayName#</a><br>
	</cfoutput>
	<cfif foundPackage>
		<script>
			parent.components.location.href='<cfoutput>#packageLink#&startComponent=#url.startComponent#</cfoutput>';
		</script>
	<cfelse>
		<script>
			parent.components.location.href='components.cfm?pathindex=<cfoutput>#url.pathIndex#&startComponent=#url.startComponent#</cfoutput>';
		</script>
	</cfif>
</body>
</html>
