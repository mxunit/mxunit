<cfcomponent name="mxunit.framework.ComponentUtils" output="true" hint="Internal component not generally used outside the framework">

	<cfset sep = getSeparator()>

  <cffunction name="ComponentUtils" returnType="ComponentUtils" hint="Constructor">
   <cfreturn this />
  </cffunction>

	<cffunction name="isFrameworkTemplate" returntype="boolean" hint="whether the passed in template is part of the mxunit framework">
		<cfargument name="template" type="string" required="true">
		<cfset var isIt = false>
		<!--- braindead simple.... is anything more than this necessary? --->
		<cfif refindNoCase("mxunit[/\\](trunk[/\\])?(framework|tests)",template)>
			<cfset isIt = true>
		</cfif>
		<cfreturn isIt>
	</cffunction>

	<cffunction name="getSeparator" returntype="string" hint="Returns file.separator as seen by OS.">
		<cfreturn createObject("java","java.lang.System").getProperty("file.separator")>
	</cffunction>

	<cffunction name="getLineSeparator" returntype="string" hint="Returns file.separator as seen by OS.">
		<cfreturn createObject("java","java.lang.System").getProperty("line.separator")>
	</cffunction>

	 <cffunction name="getInstallRoot" returnType="string" access="public">
	 <cfargument name="fullPath" type="string" required="false" default="" hint="Used for testing, really." />
	  <cfscript>
		    var i = 1;//loop index
		    var sep = "/";
		    var package = arrayNew(1); //list
		    var installRoot = "";
		    //We know THIS will always be in mxunit.framework.ComponentUtils
		    var md = getMetaData(this);
		    var name = md.name ;
		    if(len(arguments.fullPath)) {
		      name = arguments.fullPath;
		    }
		    package = listToArray(name,".");
		    //Use the getContextPath to support J2EE apps
		    installRoot = getPageContext().getRequest().getContextPath() & sep;
		     for(i; i lte arrayLen(package)-2; i = i + 1){
		      installRoot = installRoot & package[i] & sep;
		     }
		    return installRoot;
		  </cfscript>
	</cffunction>



	<cffunction name="getComponentRoot" returnType="string" access="public">
	 <cfargument name="fullPath" type="string" required="false" default="" hint="Test Hook." />
	 	 <cfscript>
		    // Use the mxunit-config.xml to handle install location in case of weird behavior
		    // or if user wants custom configuration
		    var cm = createObject("component","ConfigManager").ConfigManager();
		    var userConfig = cm.getConfigElement("userConfig","componentRoot");
		    var mxUnitRoot = userConfig[1].xmlAttributes["value"];
		    var override = userConfig[1].xmlAttributes["override"];

		    var i = 1;//loop index
		    var sep = ".";
		    var package = arrayNew(1); //list
		    var installRoot = "";
		    //We know THIS "should" always be in mxunt.framework.ComponentUtils
		    var md = getMetaData(this);
		    var name = md.name;

		    //Inject fullPath argument for testing
		    if(len(arguments.fullPath)) {
		      name = arguments.fullPath;
		    }

		    //Workaround for Mac/Apache configs that do not return
		    //fully qualified names for getMetaData()
		    if(name is "ComponentUtils" OR name is "" OR name is "."){
		    	//use the userConfig/componentRoot element value in mxunit-config.xml
		    	return(mxunitRoot);
		    }

		    //If user needs to override default install location.
		    // Note name is "override" is an injected test hook.
		    if(name is "override" OR override){
		      return(mxunitRoot);
		    }

		    package = listToArray(name,".");
		    for(i; i lte arrayLen(package)-2; i = i + 1){
		      installRoot = installRoot & package[i] & sep;
		     }
		    return left(installRoot, len(installRoot)-1);
		  </cfscript>
	</cffunction>

	<cffunction name="dump">
	 <cfargument name="o">
	 <cfdump var="#arguments.o#">
	</cffunction>

	<cffunction name="hasJ2EEContext">
	 <cfscript>
	  return(getContextRootPath() is not "");
	 </cfscript>
	</cffunction>


	<cffunction name="getContextRootComponent">
	 <cfset var rootComponent = "" />
     <cfset var ctx = getContextRootPath() />
	 <cfif hasJ2EEContext()>
	   <!--- This last  "." worries me. Under what circumstance will this not be true? --->
	   <cfset rootComponent = right(ctx,len(ctx)-1) &  "."/>
	 </cfif>
	 <cfreturn  rootComponent />
	</cffunction>


	<cffunction name="getContextRootPath">
	 <cfset var ctx= "">
	 <cfset ctx = getPageContext().getRequest().getContextPath() />
	 <cfreturn ctx />
	</cffunction>


<cffunction name="isCfc" hint="Determines whether or not the given object is a ColdFusion component; Author: Nathan Dintenfass ">
 <cfargument name="objectToCheck" />
 <cfscript>
    //get the meta data of the object we're inspecting
    var metaData = getMetaData(arguments.objectToCheck);
    //if it's an object, let's try getting the meta Data
    if(isObject(arguments.objectToCheck)){
        //if it has a type, and that type is "component", then it's a component
        if(structKeyExists(metaData,"type") AND metaData.type is "component"){
            return true;
        }
    }
    //if we've gotten here, it must not have been a contentObject
    return false;
 </cfscript>
</cffunction>

</cfcomponent>

