<cfcomponent hint="The util component provides utility methods for the rest of the application">

	<cfset variables.rootpath = "">
	<cfset variables.packageroot = "">
	<cfset variables.directorySeparator = "">
	<cfset variables.nativetypes = "any,array,binary,boolean,date,guid,numeric,query,string,struct,uuid,variablename,void">
	<cfset variables.paths = "">
	
	<cffunction name="init" access="public" returntype="Util" output="false" hint="Initializes the component and sets up the variables that the other methods in the component need.">
		<cfargument name="rootpath" type="string" required="yes">
		<cfargument name="packageRoot" type="string" required="yes">
		<cfargument name="directorySeparator" type="string" required="yes">
    <cfargument name="paths" type="array" required="true">
		
		<cfset variables.rootpath = arguments.rootpath>
		<cfset variables.packageRoot = arguments.packageRoot>
		<cfset variables.directorySeparator = arguments.directorySeparator>
    <cfset variables.paths = arguments.paths>
    
		<cfreturn this>
	
	</cffunction>
	
  <cffunction name="setRootPath" access="public" returntype="void">
    <cfargument name="rootpath" required="true" type="string">
    <cfset variables.rootpath = arguments.rootpath>
  </cffunction>
  


	<cffunction name="getDetailURL" access="public" returntype="string" output="false" hint="Figures out whether or not the passed string is a component in the current package. If so it generates the appropriate URL to view the documentation for that component. If not it returns a non-functioning URL.">
		<cfargument name="str" type="string" required="true" hint="Any string to be turned into a detail link">
		<cfargument name="currentpath" type="string" required="true" hint="The path to the directory containing the current component">
		<cfset result = "" />
		<cftry>
			<cfset result =  "content.cfm?file=#getFilePath(str, currentpath)#" />
			<cfcatch type="UnknownComponentException">
				<cfset result =  "unknowncomponent.cfm" />
			</cfcatch>
			<cfcatch type="NativeTypeException">
				<cfset result =  "nativetypes.cfm##detail_#cfcatch.detail#" />
			</cfcatch>
		</cftry>
		<cfreturn result />
	</cffunction>


	<cffunction name="getFilePath" access="public" returntype="string" output="true" hint="Figures out whether or not the passed string is a component in the current package. If so it generates the appropriate file path to that component. If not it throws an exception." throws="UnknownComponentException,NativeTypeException">
		<cfargument name="str" type="string" required="true" hint="Any string to be turned into a detail link">
		<cfargument name="currentpath" type="string" required="true" hint="The path to the directory containing the current component">
		
		<cfset var path = "">
		<cfset var filePath = "">
		<cfset var matches = structNew()>
		<cfset var prefix = "">
	    <cfset var newpath = "">
	    <cfset var subPath = "">
    
		<cfif listFirst(str,'./') eq variables.packageRoot>
			<cfset filePath = variables.rootpath & variables.directorySeparator & listChangeDelims(listRest(arguments.str,'./'),variables.directorySeparator,'.') & '.cfc'>
    
    	<cfelseif reFind("[/\.]",str)>
      
	      <cfset str = listChangeDelims(str,'.','./')>

	      <cfloop from="1" to="#arrayLen(variables.paths)#" index="i">
	        <cfif findNoCase(variables.paths[i].prefix,str)>
	          <cfset path = variables.paths[i].path>
	          <cfset prefix = variables.paths[i].prefix>
	        </cfif>
	      </cfloop>
		  
		  <cfif path EQ variables.rootpath>
			<cfset str = listRest(str, "/.") />
			<cfset path = "" />
		  </cfif>
      
	      <cfif len(path) GT 0>
	        <cfset str = listChangeDelims(str,variables.directorySeparator,'/.')>
			<cfset str = listRest(str, variables.directorySeparator) />
	        
			<cfloop list="#path#" index="i" delimiters="#variables.directorySeparator#">
			  <cfset newpath = listAppend(newPath,i,variables.directorySeparator)>
			  <cfset subPath = replaceNoCase(path,newPath & variables.directorySeparator,"")>
			  <cfif len(subPath) AND left(str,len(subPath)) EQ subPath>
				<cfbreak>
			  </cfif>
			</cfloop>
			<cfset filePath = newpath>
			<cfset filePath = filePath & variables.directorySeparator & str & '.cfc'>
		  <cfelse>
	        <cfset str = listChangeDelims(str, variables.directorySeparator, "/.") />
		  	<cfset filePath = variables.rootpath & variables.directorySeparator & str & ".cfc" />
	      </cfif>
        
		<cfelseif not listFindNoCase(variables.nativetypes,str)>
	
		  <cfset path = arguments.currentpath &  arguments.str & '.cfc'>
		  <cflock type="READONLY" name="cfcdocfileaccess" timeout="5">
			  
			<cfif fileExists(path)>
			  <cfset filePath = path />
			<cfelse>
			  <cfthrow type="UnknownComponentException" />
			</cfif>
		  </cflock>
		<cfelse>
			<cfthrow type="NativeTypeException"
		   		detail="#str#" />
		</cfif>

		<cfreturn filePath>
	</cffunction>
	
	
	<cffunction name="getPackageFromPath" access="public" returntype="string" output="false" hint="The getPackageFromPath method gets the package path for any given directory under the root path.">
		<cfargument name="path">
		
		<cfset var prefix = "">
		<cfset var subPath = "">
		<cfset var package = "">
    <cfset var matches = structNew()>
    <cfset var packagepath = "">
    

    <cfloop from="1" to="#arrayLen(variables.paths)#" index="i">
      <cfif findNoCase("#variables.paths[i].path#",path)>
        <cfset packagepath = variables.paths[i].path>
        <cfset prefix = variables.paths[i].prefix>
      </cfif>
    </cfloop>


    <cfif len(packagepath)>
  		<cfset subPath = prefix & variables.directorySeparator & replaceNoCase(arguments.path,packagepath,'')>
  		<cfif listLast(subPath,'.') is 'cfc'>
  			<cfset subPath = listDeleteAt(subPath,listLen(subPath,'/\'),'/\')>
  		</cfif>
  		
  		<cfset package = listChangeDelims(subPath,'.','/\')>
    <cfelse>
      <cfset package = "Unknown package">
		</cfif>
		
		<cfreturn package>
	</cffunction>
	
	
	
	<cffunction name="getPackageDisplayName" access="public" output="true" returntype="string"
		hint="I take a full package name and return the proper display string to represent it">
		<cfargument name="package" type="string" required="true" hint="The package name to translate for display" />
		<cfset package = getPackagePathFromRoot(package) />
		<cfif len(trim(package)) EQ 0>
			<cfset package = "<em>default package</em>" />
		</cfif>
		<cfreturn package />
	</cffunction>
	
	
	
	<cffunction name="getPackageDisplayPrefix" access="public" output="false" returntype="string"
		hint="I take a full package name and return the proper display string to represent it as a prefix for a fully qualified CFC name">
		<cfargument name="package" type="string" required="true" hint="The package name to translate for display" />
		<cfset package = getPackagePathFromRoot(package) />
		<cfif len(trim(package)) GT 0>
			<cfset package = package & "." />
		</cfif>
		<cfreturn package />
	</cffunction>
	
	
	
	<cffunction name="getPackagePathFromRoot" access="private" output="false" returntype="string"
		hint="I take a full package name, and return the relative path from the root">
		<cfargument name="package" type="string" required="true" hint="The package name to translate" />
		
		<cfset var i = "" />
		
		<cfloop from="1" to="#arrayLen(variables.paths)#" index="i">
			<cfif left(package, len(variables.paths[i].prefix)) EQ variables.paths[i].prefix>
				<cfset package = removeChars(package, 1, len(variables.paths[i].prefix)) />
				<cfif len(trim(package)) NEQ 0>
					<!--- kill the leading period --->
					<cfset package = removeChars(package, 1, 1) />
				</cfif>
				<cfreturn package />
			</cfif>
		</cfloop>
		
		<cfthrow type="UnknownPackageRootException"
			message="The package root from the full package path was not recognized" />
	</cffunction>
	
	
	
	<cffunction name="getCFCInformation" access="public" output="false" returntype="struct"
		hint="I create complete CFC information for the specified CFC, including information about all it's superclasses">
		<cfargument name="file" type="string" required="true" hint="the file to generate information about" />

		<cfset var fileContents = "" />
		<cfset var parser = "" />
		<cfset var stComponent = structNew() />
		<cfset var tmpComponent = structNew() />
		<cfset var filename = "" />
		<cfset var filepath = "" />
		<cfset var i = "" />

		<cftry>
			<cffile action="read" file="#file#"  variable="fileContents">
			<cfcatch type="any">
				<cfreturn stComponent />
			</cfcatch>
		</cftry>
		<cfif len(trim(filecontents))>
			<cfset parser = createObject('component','CFCParser')>
			<cfset parser.init()>
			
			<cfset stComponent = parser.parse(fileContents)>
			<cfset filename = listLast(file,'/\')>
			<cfset filepath = replace(file,filename,'')>
			<cfset stComponent.name = listFirst(filename,'.')>
			<cfset stComponent.path = filepath>
			<cfset stComponent.package = getPackageFromPath(file)>
			<cfset stComponent.pathindex = 1>
			<cfloop from="1" to="#arrayLen(paths)#" index="i">
				<cfif findNoCase(paths[i].path,file)>
					<cfset stComponent.pathindex = i>
					<cfbreak>
				</cfif>
			</cfloop> 
			<cfset stComponent.code = fileContents>
			
			<cfset variables.objectCache[file] = stComponent />
			
			<!--- duplicate to definitively sever from the cache --->
			<cfset stComponent = duplicate(stComponent) />
			
			<cfif stComponent.attributes.extends NEQ "cfcomponent">
				<cfset stComponent.superComponent = getCFCInformation(getFilePath(stComponent.attributes.extends, stComponent.path)) />
				<cfif structIsEmpty(stComponent.superComponent)>
					<cfset stComponent.superComponent = stComponent.attributes.extends>
				</cfif>
			</cfif>
			
			<cfset stComponent.implements = arrayNew(1)>
			<!--- treat interfaces a little different, since a CFC can implement more than one --->
			<cfif stComponent.attributes.implements NEQ "cfinterface">
				<cfloop list="#stComponent.attributes.implements#" index="pos" delimiters=",">
					<cfset tmpComponent = getCFCInformation(getFilePath(pos, stComponent.path))>
					<!--- if this returns an empty structuire, the interface could not be found on disk, therefore only insert the name --->
					<cfif structIsEmpty(tmpComponent)>
						<cfset arrayAppend(stComponent.implements,pos)>
					<cfelse>
						<cfset arrayAppend(stComponent.implements,tmpComponent)>
					</cfif>		
				</cfloop>	
			</cfif>
		</cfif>
		
		<cfreturn stComponent />
	</cffunction>




<cffunction name="colorCode2" access="public" output="false" returntype="String" hint="Does color coding of source">
<!--- Initialize attribute values --->
<cfargument name="data" required="true" type="String" hint="The source that needs color coding"> 

<CFSCRIPT>
	/* Pointer to Attributes.Data */
	this = arguments.Data;

	/* Convert special characters so they do not get interpreted literally; italicize and boldface */
	this = REReplaceNoCase(this, "&([[:alpha:]]{2,});", "«B»«I»&amp;\1;«/I»«/B»", "ALL");

	/* Convert many standalone (not within quotes) numbers to blue, ie. myValue = 0 */
	this = REReplaceNoCase(this, "(gt|lt|eq|is|,|\(|\))([[:space:]]?[0-9]{1,})", "\1«FONT COLOR=BLUE»\2«/FONT»", "ALL");

	/* Convert normal tags to navy blue */
	this = REReplaceNoCase(this, "<(/?)((!d|b|c(e|i|od|om)|d|e|f(r|o)|h|i|k|l|m|n|o|p|q|r|s|t(e|i|t)|u|v|w|x)[^>]*)>", "«FONT COLOR=NAVY»<\1\2>«/FONT»", "ALL");

	/* Convert all table-related tags to teal */
	this = REReplaceNoCase(this, "<(/?)(t(a|r|d|b|f|h)([^>]*)|c(ap|ol)([^>]*))>", "«FONT COLOR=TEAL»<\1\2>«/FONT»", "ALL");

	/* Convert all form-related tags to orange */
	this = REReplaceNoCase(this, "<(/?)((bu|f(i|or)|i(n|s)|l(a|e)|se|op|te)([^>]*))>", "«FONT COLOR=FF8000»<\1\2>«/FONT»", "ALL");

	/* Convert all tags starting with 'a' to green, since the others aren't used much and we get a speed gain */
	this = REReplaceNoCase(this, "<(/?)(a[^>]*)>", "«FONT COLOR=GREEN»<\1\2>«/FONT»", "ALL");

	/* Convert all image and style tags to purple */
	this = REReplaceNoCase(this, "<(/?)((im[^>]*)|(sty[^>]*))>", "«FONT COLOR=PURPLE»<\1\2>«/FONT»", "ALL");

	/* Convert all ColdFusion, SCRIPT and WDDX tags to maroon */
	this = REReplaceNoCase(this, "<(/?)((cf[^>]*)|(sc[^>]*)|(wddx[^>]*))>", "«FONT COLOR=MAROON»<\1\2>«/FONT»", "ALL");

	/* Convert all inline "//" comments to gray (revised) */
	this = REReplaceNoCase(this, "([^:/]\/{2,2})([^[:cntrl:]]+)($|[[:cntrl:]])", "«FONT COLOR=GRAY»«I»\1\2«/I»«/FONT»", "ALL");

	/* Convert all multi-line script comments to gray */
	this = REReplaceNoCase(this, "(\/\*[^\*]*\*\/)", "«FONT COLOR=GRAY»«I»\1«/I»«/FONT»", "ALL");

	/* Convert all HTML and ColdFusion comments to gray */	
	/* The next 10 lines of code can be replaced with the commented-out line following them, if you do care whether HTML and CFML 
	   comments contain colored markup. */
	EOF = 0; BOF = 1;
	while(NOT EOF) {
		Match = REFindNoCase("<!-"&"--?([^-]*)-?-"&"->", this, BOF, True);
		if (Match.pos[1]) {
			Orig = Mid(this, Match.pos[1], Match.len[1]);
			Chunk = REReplaceNoCase(Orig, "«(/?[^»]*)»", "", "ALL");
			BOF = ((Match.pos[1] + Len(Chunk)) + 31); // 31 is the length of the FONT tags in the next line
			this = Replace(this, Orig, "«FONT COLOR=GRAY»«I»#Chunk#«/I»«/FONT»");
		} else EOF = 1;
	}

	// Use this next line of code instead of the last 10 lines if you want (faster)
	// this = REReplaceNoCase(this, "(<!-"&"--?[^-]*-?-"&"->)", "«FONT COLOR=GRAY»«I»\1«/I»«/FONT»", "ALL");

	/* Convert all quoted values to blue */
	this = REReplaceNoCase(this, """([^""]*)""", "«FONT COLOR=BLUE»""\1""«/FONT»", "ALL");

	/* Convert left containers to their ASCII equivalent */
	this = REReplaceNoCase(this, "<", "&lt;", "ALL");

	/* Revert all pseudo-containers back to their real values to be interpreted literally (revised) */
	this = REReplaceNoCase(this, "«([^»]*)»", "<\1>", "ALL");

	/* ***New Feature*** Convert all FILE and UNC paths to active links (i.e, file:///, \\server\, c:\myfile.cfm) */
	this = REReplaceNoCase(this, "(((file:///)|([a-z]:\\)|(\\\\[[:alpha:]]))+(\.?[[:alnum:]\/=^@*|:~`+$%?_##& -])+)", "<A TARGET=""_blank"" HREF=""\1"">\1</A>", "ALL");

	/* Convert all URLs to active links (revised) */
	this = REReplaceNoCase(this, "([[:alnum:]]*://[[:alnum:]\@-]*(\.[[:alnum:]][[:alnum:]-]*[[:alnum:]]\.)?[[:alnum:]]{2,}(\.?[[:alnum:]\/=^@*|:~`+$%?_##&-])+)", "<A TARGET=""_blank"" HREF=""\1"">\1</A>", "ALL");

	/* Convert all email addresses to active mailto's (revised) */
	this = REReplaceNoCase(this, "(([[:alnum:]][[:alnum:]_.-]*)?[[:alnum:]]@[[:alnum:]][[:alnum:].-]*\.[[:alpha:]]{2,})", "<A HREF=""mailto:\1"">\1</A>", "ALL");
</CFSCRIPT>
<cfreturn this>
<!--- Output final result (reverted in this release to 3.0) --->


<!--- If you prefer the previous version (3.1), comment out the previous line of code and un-commment the next 3 lines of code.
	  The next 3 lines of code do not work correctly on UNIX systems.
<DIV STYLE="padding-left : 10px;">
	<CFOUTPUT>#Replace(Replace(this, "#chr(13)##chr(10)##chr(13)##chr(10)#", "<P>", "ALL"), "#chr(13)##chr(10)#", "<br>", "ALL")#</CFOUTPUT>
</DIV>
--->
</cffunction>

</cfcomponent>
