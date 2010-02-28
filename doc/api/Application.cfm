<cfsetting showdebugoutput="false">

<cfapplication name="cfcdocumenter_1">

<cfparam name="application.queryStore" default="#structNew()#">

<cfparam name="application.initialized" default="false">

<cfif isDefined('url.refresh')>
	<cfset application.initialized = false>
</cfif>

<cfif server.os.name contains "windows">
	<cfset directorySeparator = "\">
<cfelse>
	<cfset directorySeparator = "/">
</cfif>

<cfif not application.initialized>
	<cfset application.basePath = expandPath('./')>
	<cfif structKeyExists(url,"baseRemove")>
		<cfset application.basePath = replaceNoCase(application.basePath,url.baseRemove,"")>
	</cfif>
	<cflock name="#application.basePath#config/config.xml" timeout="30" type="Exclusive">
		<cffile action="read" file="#application.basePath#config/config.xml" variable="config">
	</cflock>	
	<cfset  configXML = xmlParse(config)>
	<cfset application.lazyLoad = trim(configXML.config.lazyLoad.xmlText)>
	<cfset application.revealCode = trim(configXML.config.revealCode.xmlText)>
	<cfset application.apptitle = configXML.config.pageTitle.xmlText>
	<cfif isDefined("configXML.config.revealCFCCode.xmlText")>
		<cfset application.revealCFCCode = trim(configXML.config.revealCFCCode.xmlText) />
	<cfelse>
		<cfset application.revealCFCCode = application.revealCode />
	</cfif>
	<cfif isDefined("configXML.config.startPage.xmlText")>
		<cfset application.startPage = trim(configXML.config.startPage.xmlText) />
	<cfelse>
		<cfset application.startPage = "../readme.cfm" />
	</cfif>

	<cfset application.hidePrivateMethods = trim(configXML.config.hidePrivateMethods.xmlText)>
	<cfset application.showRootPath = false>
<!--- 	<cfset application.showRootPath = trim(configXML.config.showRootPath.xmlText)> --->
	<cfset application.paths = arrayNew(1)>
	
	<cfset currentHost = createObject("java", "java.net.InetAddress").localhost.getHostName() />
	<cfset hostsRoots = XmlSearch(configXML, "/config/host")>
	<cfset allRoots =   XmlSearch(configXML, "/config/root")>
	
	<cfif arrayLen(allRoots) GT 0>
		<cfloop from="1" to="#arrayLen(configXML.config.root)#" index="i">
			<cfset package = structNew()>
			<cfset package.prefix = trim(configXML.config.root[i].prefix.xmltext)>
			<cfset path = trim(configXML.config.root[i].path.xmltext)>
			<cfif left(path,1) is '.'>
				<cfset package.path = expandPath(path)>
			<cfelse>
				<cfset package.path = path>
			</cfif>
			<cfset arrayAppend(application.paths,package)>
		</cfloop>
	</cfif>
	<cfif arrayLen(hostsRoots) GT 0>
		<cfloop from="1" to="#arrayLen(hostsRoots)#" index="j">
			<cfif hostsRoots[j].xmlAttributes.name EQ currentHost>
				<cfloop from="1" to="#arrayLen(hostsRoots[j].root)#" index="i">
					<cfset package = structNew()>
					<cfset package.prefix = trim(hostsRoots[j].root[i].prefix.xmltext)>
					<cfset path = trim(hostsRoots[j].root[i].path.xmltext)>
					<cfif left(path,1) is '.'>
						<cfset package.path = expandPath(path)>
					<cfelse>
						<cfset package.path = path>
					</cfif>
					<cfset arrayAppend(application.paths,package)>
				</cfloop>
			</cfif> 
		</cfloop>
	</cfif>	
	
	<cfset application.constructorNames = "" />
	<cfloop from="1" to="#arrayLen(configXML.config.constructorname)#" index="i">
		<cfset application.constructorNames = listAppend(application.constructorNames, trim(configXML.config.constructorname[i].xmltext)) />
	</cfloop>
	<cfset application.templates = "templates/">
	<cfset application.cfcDocVersion = "0.42"> 
	<cfset application.initialized = true>
	
</cfif>

<cfset lazyLoad = application.lazyLoad>
<cfset templates = application.templates>
<cfset cfcDocVersion = application.cfcDocVersion> 
<cfset revealCode = application.revealCode>
<cfset revealCFCCode = application.revealCFCCode />
<cfset showRootPath = application.showRootPath>


<cfset paths = application.paths>

<cfparam name="application.pathindex" default="1">

<cfif isDefined('url.pathindex')
	AND isNumeric(url.pathIndex)
	AND url.pathIndex GT 0
	AND url.pathIndex LTE arrayLen(paths	)>

	<cfset application.pathIndex = url.pathindex>

</cfif>

<cfif application.pathIndex GT arrayLen(paths)>
	<cfset application.pathIndex = 1>
</cfif>

<cfset rootpath = paths[application.pathIndex].path>

<cfif isDefined('url.refresh')>
	<cfset structDelete(application.querystore,rootpath)>
</cfif>

<cfloop from="1" to="#arrayLen(paths)#" index="i">
  <cfset currentpath = paths[i].path>
  <cfif not structKeyExists(application.queryStore,currentpath)>
  	<cfset application.queryStore[currentpath] = structNew()>
  </cfif>
</cfloop>

<cfset packageRoot = listLast(rootpath,'/\')>


<cfif not structKeyExists(application.queryStore[rootpath],'filequery')>
	<cfloop from="1" to="#arrayLen(paths)#" index="i">
		<cfif paths[i].path EQ rootPath>
			<cfset pathInfo = paths[i] />
			<cfbreak />
		</cfif>
	</cfloop>

  <cfset fso = createObject('component','components.FileSystemObject').init(rootpath,directorySeparator)>
  <cfset fso.setLazyLoad(lazyLoad)>	
  <cfset application.queryStore[rootpath].fileQuery = fso.list(true,'*.cfc',pathInfo.prefix)>
</cfif>

<cfset filequery = application.queryStore[rootpath].filequery>


<cfquery dbtype="query" name="orderedQuery">
SELECT *, LOWER(name) AS lname
FROM fileQuery
ORDER BY lname ASC
</cfquery>

<cfset util = createObject('component','components.Util').init(rootpath,packageroot,directorySeparator,paths)>

<cfset util.setRootPath(rootpath)>
