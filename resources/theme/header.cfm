<cfparam name="title" default="Unit Test Framework and Eclipse Plugin for CFML engines" />
<cfparam name="pathBase" default="./" />

<cfset context = getDirectoryFromPath(expandPath(pathBase)) />

<!--- Find out the version of MXUnit --->
<cfset fileStream = createObject('java', 'java.io.FileInputStream') />
<cfset resourceBundle = createObject('java', 'java.util.PropertyResourceBundle') />
<cfset fileStream.init(context & 'buildprops/version.properties') />
<cfset resourceBundle.init(fileStream) />

<cfset version = resourceBundle.handleGetObject('build.major') & '.' />
<cfset version = version & resourceBundle.handleGetObject('build.minor') & '.' />
<cfset version = version & resourceBundle.handleGetObject('build.buildnum') />

<cfset fileStream.close() />

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<title><cfoutput>#title#</cfoutput> - MXUnit</title>
	
	<meta name="keywords" value="coldfusion unit testing test cfml cfmx xunit developer framework quality assurance open source community free" />
	
	<link rel="stylesheet" type="text/css" href="<cfoutput>#pathBase#</cfoutput>resources/ExtStart.css">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#pathBase#</cfoutput>resources/theme/960.css">
	<link rel="stylesheet" type="text/css" href="<cfoutput>#pathBase#</cfoutput>resources/theme/styles.css">
</head>
<body>
	<div class="container_12">
		<div class="header">
			<div class="grid_3">
				<a href="<cfoutput>#pathBase#</cfoutput>index.cfm">
					<img src="<cfoutput>#pathBase#</cfoutput>images/MXUnit-Small.png" alt="Get rid of those pesky bugs.">
				</a>
			</div>
			
			<div class="grid_9">
				<ul class="nav horizontal">
					<li><a href="<cfoutput>#pathBase#</cfoutput>doc/api/index.cfm" title="Local API Documentation">API</a></li>
					<li><a href="http://mxunit.org/doc/index.cfm" title="Documentation, Tutorials, etc...">Docs</a></li>
					<li><a href="<cfoutput>#pathBase#</cfoutput>samples/samples.cfm">Samples</a></li>
					<li><a href="http://mxunit.org/blog">Blog</a></li>
					<li><a href="<cfoutput>#pathBase#</cfoutput>runner/index.cfm" title="Simple HTML Test Runner">Test Runner</a></li>
					<li><a href="<cfoutput>#pathBase#</cfoutput>generator/index.cfm" title="Alpha">Stub Generator</a></li>
					<li><a href="http://groups.google.com/group/mxunit/topics">Help</a></li>
				</ul>
			</div>
			
			<div class="clear"><!-- clear --></div>
		</div>
		
		<div id="content">