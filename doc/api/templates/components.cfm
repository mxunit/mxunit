<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>All Classes - API Documentation</title>
<base target="content">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">
</head>
<body class="classFrameContent">
<cfparam name="url.startComponent" default="" type="string">
<cfoutput>
<cfif NOT structKeyExists(url, "package")>
	<strong>All packages</strong><br /><br />
<cfelse>
	<strong>#util.getPackageDisplayName(url.package)#</strong><br><br>
</cfif>
<cfset components = arrayNew(1)>
<cfset interfaces = arrayNew(1)>
<cfset showComponent = "">
<cfloop query="orderedQuery">
	<cfif NOT structKeyExists(url, "package") OR orderedQuery.package EQ url.package>
		<cfif #listFirst(orderedQuery.name,'.')# EQ url.startComponent>
			<cfset showComponent = "content.cfm?file=#urlEncodedFormat(orderedQuery.fullpath&directorySeparator&orderedQuery.name)#">
		</cfif>
		<cfset display = "<a href=""content.cfm?file=#urlEncodedFormat(orderedQuery.fullpath&directorySeparator&orderedQuery.name)#"">#listFirst(orderedQuery.name,'.')#</a><br>">
		<cfif orderedQuery.interface>
			<cfset arrayAppend(interfaces,display)>
		<cfelse>
			<cfset arrayAppend(components,display)>
		</cfif>	
	</cfif>
</cfloop>

		
<cfif arrayLen(interfaces) GT 0>
	<strong>Interfaces</strong><br>
	<cfloop from="1" to="#arrayLen(interfaces)#" index="pos">
		#interfaces[pos]#
	</cfloop>
	<br> 
</cfif>
<cfif arrayLen(components) GT 0>
	<strong>Components</strong><br>
	<cfloop from="1" to="#arrayLen(components)#" index="pos">
		#components[pos]#
	</cfloop> 
	<br>
</cfif>

<cfif showComponent neq "">
	<script>
		top.content.location.href='#showComponent#';
	</script>
</cfif>	
</cfoutput>

</body>
</html>