<cfoutput>
<html>
<head>
	<title>#application.apptitle#</title>
</head>
<cfparam name="url.startRoot" default="" type="string">
<cfparam name="url.startPackage" default="" type="string">
<cfparam name="url.startComponent" default="" type="string">
<frameset cols="210,*" border="2" bordercolor="##aaaaaa" framespacing="0" >
	<frame src="#templates#leftbar.cfm?startRoot=#trim(url.startRoot)#&startPackage=#trim(url.startPackage)#&startComponent=#trim(url.startComponent)#" name="leftbar"></frame>
	<frameset bordercolor="##aaaaaa" border="0" rows="80,*">
		<frame scrolling="no" frameborder="0" name="titlebar" src="#templates#titleBar.cfm" />
		<cfif trim(url.startComponent) NEQ "">
			<frame src="#templates#/blank.htm" name="content" />
		<cfelse>
			<frame src="#templates#default.cfm" name="content" />
		</cfif> 
	</frameset>	
</frameset>
</cfoutput>