<cfcomponent hint="makes private methods testable" output="false">

	<cfset cu = createObject("component","ComponentUtils")>
	<cfset blender = createObject("component","ComponentBlender")>
	
	<cfset lineSep = cu.getLineSeparator()>
	<cfset dirSep = cu.getSeparator()>


	<cffunction name="makePublic" access="public" hint="creates a public method proxy for the indicated private method for the passed-in object" returntype="WEB-INF.cftags.component">
		
		<cfargument name="ObjectUnderTest" required="true" type="WEB-INF.cftags.component" hint="an instance of the object with a private method to be proxied">
		<cfargument name="privateMethodName" required="true" type="string" hint="name of the private method to be proxied">
		<cfargument name="proxyMethodName" required="false" type="string" default="" hint="name of the proxy method name to be used; if not passed, defaults to the name of the private method prefixed with an underscore">
		
		<cfset var md = getMetadata(ObjectUnderTest)>
		<cfset var methodStruct = findMethodStruct(md,privateMethodName)>
		<cfset var output = "">
		<cfset var cfcode = "">
		<cfset var file = "">
		<cfset var cfcnotation = "">
		<cfset var dir = getDirectoryFromPath(getCurrentTemplatePath()) & dirSep & "generated" & dirSep>
		<cfset var proxy = "">
		<cfset var s_args = "">
		<cfset var componentReturnTag = "return">
		<cfset var renamedExistingMethod = arguments.privateMethodName & "_mxunitproxy">
		
		<cfif StructIsEmpty(methodStruct)>
			<cfthrow message="Attempting to make public proxy for private method: method named #privateMethodName# did not exist in object of type #md.name#">
		</cfif>
		
		<cfif NOT len(trim(proxyMethodName))>
			<cfset arguments.proxyMethodName = "#privateMethodName#">
		</cfif>
		
		<cfset cfcnotation = arguments.proxyMethodName & "_#createUUID()#">
		<cfset file = cfcnotation & ".cfc">
		<cfif StructKeyExists(methodStruct,"returntype") and methodStruct.returntype eq "void">
			<cfset componentReturnTag = "set">
		</cfif>
		
		<!--- for now, it seems safest to just do this every time, even if it's technically overkill --->
		<cfif not DirectoryExists(dir)>
			<cfdirectory action="create" directory="#dir#">
		</cfif>
		
		<!--- generate a CFC that contains a public method. this method will call the private method we want to call --->
		<cfset s_argTags = constructArgumentsTags(methodStruct)>
		
		<cfoutput>
		<cfsavecontent variable="output">
		<%cfcomponent extends="#md.name#"%>
		
		<%cffunction name="#arguments.proxyMethodName#" access="public"%>
			#s_argTags#
			<%cf#componentReturnTag# #renamedExistingMethod#(argumentCollection=arguments)%>
		<%/cffunction%>
		
		<%/cfcomponent%>
		</cfsavecontent>
		</cfoutput>
		<cfset cfcode = replace(output,"%","","all")>
		<cffile action="write" file="#dir##file#" output="#cfcode#">
		
		<!--- now, create an instance of that generated object --->
		<cfset proxy = createObject("component","mxunit.framework.generated.#cfcnotation#")>
		<!--- NOTE: all of this rejiggering is so that we can call the private method directly rather than having to call a differently-named proxy method! --->
		
		<!--- move the current privateMethod into a newly named method --->
		<cfset blender._mixinAll(arguments.ObjectUnderTest,blender)>
		<cfset arguments.ObjectUnderTest._mixin(renamedExistingMethod,arguments.ObjectUnderTest._getComponentVariable(privateMethodName))>
		<!--- inject that function's proxy method into the object passed in; now we can call this new method, which will call the private method --->
		<cfset arguments.ObjectUnderTest._mixin(arguments.proxyMethodName,proxy[arguments.proxyMethodName])>
		
		<!--- cleanup; i doubt this will be enough so we'll need some way of periodically cleaning out that directory I suspect --->
		<cffile action="delete" file="#dir##file#">
		<cfreturn ObjectUnderTest>
	</cffunction>

	<cffunction name="findMethodStruct" returntype="struct" access="private" hint="returns the metadata struct for a given method name">
		<cfargument name="metadata" required="true" type="struct" hint="a structure returned from getMetadata">
		<cfargument name="methodName" required="true" type="string" hint="the method to search for">

		<cfset var methodStruct = StructNew()>
		<cfset var i = 1>

		<cfif structKeyExists(metadata, "functions")>
			<cfloop from="1" to="#ArrayLen(metadata.functions)#" index="i">
				<cfif metadata.functions[i].name eq arguments.methodName>
					<cfreturn metadata.functions[i]>
				</cfif>
			</cfloop>
			<!--- If we get here, we haven't found the function; check superclasses --->
			<cfif structKeyExists(metadata, "extends")>
				<cfreturn findMethodStruct(metadata.extends, methodName) />
			</cfif>
		<cfelse> <!--- Check superclasses, if any --->
			<cfif structKeyExists(metadata, "extends")>
				<cfreturn findMethodStruct(metadata.extends, methodName) />
			</cfif>
		</cfif>

		<cfreturn methodStruct>

	</cffunction>

	<cffunction name="constructArgumentsTags" returntype="string" access="private" hint="creates the cfargument tags, the method call to the private method, and the return statement for the component">
		<cfargument name="privateMethodStruct" type="struct" hint="the structure of metadata for the private method under consideration">
		<cfset var strArgTags = "">
		<cfset var thisParamString = "">
		<cfset var thisTagString = "">
		<cfset var a_params = privateMethodStruct.Parameters>
		<cfset var p = 1>
		<cfset var pCount = ArrayLen(a_params)>
		
		<cfloop from="1" to="#pCount#" index="p">
			<cfparam name="a_params[p].required" default="false">
			<cfset thisTagString = "<cfargument name='#a_params[p].name#' required='#a_params[p].required#'">
			<cfif structKeyExists(a_params[p], 'default')>
				 <cfset thisTagString = thisTagString & " default='#a_params[p].default#'">
			</cfif>
			<cfset thisTagString = thisTagString & ">">
			<cfset thisParamString = a_params[p].name & " = arguments.#a_params[p].name#">
			<cfset strArgTags = ListAppend(strArgTags, thisTagString, lineSep)>
		</cfloop>
		<cfreturn strArgTags>
	</cffunction>

</cfcomponent>