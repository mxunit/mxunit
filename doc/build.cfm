
<cfparam name="pathBase" default="../" />
<cfset context = getDirectoryFromPath(expandPath(pathBase)) />

<cfdump var="#context#">


<!--- Find out the version of MXUnit --->
<cfset fileStream = createObject('java', 'java.io.FileInputStream') />
<cfset resourceBundle = createObject('java', 'java.util.PropertyResourceBundle') />
<cfset fileStream.init(context & 'buildprops/version.properties') />
<cfset resourceBundle.init(fileStream) />
<cfset version = resourceBundle.handleGetObject('build.major') & '.' />
<cfset version = version & resourceBundle.handleGetObject('build.minor') & '.' />
<cfset version = version & resourceBundle.handleGetObject('build.buildnum') />
<cfset fileStream.close() />
<!---

--->
<cfdirectory directory="#expandPath('./api')#" recurse="true" name="d" action="delete">
<cfscript>
	colddoc = createObject("component", "colddoc.ColdDoc").init();

 //To Do: Get version number from properties file
	strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(expandPath("./api"), "MXUnit " & version);
	colddoc.setStrategy(strategy);
	
	docs = [
     {'inputDir'= expandpath('../framework'), 'inputMapping'='mxunit.framework'},
     //{'inputDir'= expandpath('../generator'), 'inputMapping'='mxunit.generator'},
	 {'inputDir'= expandpath('../runner'), 'inputMapping'='mxunit.runner'}
	
	// {'inputDir'='/home/billy/software/jrun4/servers/dev/cfusion.ear/cfusion.war/mxunit/tests/', 'inputMapping'='mxunit.tests'}
	];

	colddoc.generate(docs);
</cfscript>

<h1>MXUnit API Docs Generated!</h1>

<a href="api/index.html">Documentation</a>

<cfdirectory directory="#expandPath('./')#" recurse="true" name="d" action="list">
<cfdump var="#d#">
