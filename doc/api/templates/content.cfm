<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Package List - API Documentation</title>
<base target="content">
<link rel="stylesheet" href="../css/style.css" type="text/css" media="screen">
<script language="javascript" type="text/javascript" src="../js/mootools.js"></script>
<script language="javascript" type="text/javascript" src="../js/cfcdoc.js"></script>
</head>
<body>
<cfparam name="url.file" default="#orderedQuery.fullpath##directorySeparator##orderedQuery.name#">
<cfset showtemplate = false>
<cfset pathAllowed = false>
	<cfloop from="1" to="#arrayLen(paths)#" index="i">
	  <cfif left(url.file,len(paths[i].path)) EQ paths[i].path>
	    <cfset pathAllowed = true>
	  </cfif>
	</cfloop>
	<cfif listLast(url.file,'.') is 'cfc' 
		AND pathAllowed
		AND fileExists(url.file)>
		<cfset stComponent = util.getCFCInformation(url.file) />
		<cfif application.hidePrivateMethods>
			<cfloop collection="#stComponent.methods#" item="i">
				<cfif stComponent.methods[i].access EQ "private">
					<cfset structDelete(stComponent.methods, i) />
				</cfif>
			</cfloop>
		</cfif>
		<cfset showTemplate = structKeyExists(stComponent, "name") />
	</cfif>
	<cfif showTemplate>
		<cfinclude template="doctemplate.cfm">
	<cfelse>
	  <cfinclude template="unknowncomponent.cfm">
	</cfif>
</body>
</html>
