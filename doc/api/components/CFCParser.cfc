
<cfcomponent hint="The CFCParser component provides methods to parse a ColdFusion Component.">

	<cffunction name="init" access="public" returntype="CFCParser" output="false" hint="The init method currently does nothing.">
		<cfreturn this>
	</cffunction>
	
	
	
	<cffunction name="findTags" access="private" returntype="array" output="true" hint="The findTags method searches the document for the given startTag and endTag. It returns an array of structures containing the locations in the document of the start and end position of each tag, and the full contents of the tag itself.">
		<cfargument name="document" type="string" required="yes">
		<cfargument name="startTag" type="string" required="yes">
		<cfargument name="endTag" type="string" required="yes">
		
		<!--- Find and remove comments --->
		<cfset var tagLocations = arrayNew(1)>
		<cfset var nestingLevel = 1>
		<cfset var searchMode = "start">
		<cfset var position = 1>
		<cfset var i = 0>
		<cfset var j = 0>
		<cfset var tagBegin = 0>
		<cfset var tagEnd = 0>
		<cfset var tagBlock = "">
		<cfset var tmpPosition = 0>
		<cfset var nestCount = 0>
		<cfset var padding = "">
		<cfset var lastReturn = "">
		<cfset var lastSpace = "">
		
		<cfloop from="1" to="#len(document)#" index="i">
			
			<cfif searchMode is "start">
			
				<cfset tagBegin = findNoCase(startTag,document,position)>
				
				<cfif tagBegin>
					<cfset position = tagBegin + len(startTag)>
					<cfset searchMode = "end">
					<!--- <cfoutput>Start Tag found at character #tagBegin#<br></cfoutput> --->
				<cfelse>
					<cfbreak>
				</cfif>
			
			<cfelse>	
			
				<cfset tagEnd = find(endTag,document,position)>
				
				<cfif tagEnd>
					<cfset tagEnd = tagEnd + len(endTag)>
					<cfset position = tagEnd>
					<!--- <cfoutput>End Tag found at character #tagEnd#<br></cfoutput> --->
				<cfelse>
					<cfbreak>
				</cfif>
				
				<cfset tagBlock = mid(document,tagBegin,tagEnd-tagBegin)>
				
				<cfset tmpPosition = 1>
				<cfset nestCount = 0>
				<cfloop from="1" to="#len(tagBlock)#" index="j">
					<cfif findNoCase(startTag,tagBlock,tmpPosition)>
						<cfset tmpPosition = findNoCase(startTag,tagBlock,tmpPosition) + len(startTag)>
						<cfset nestCount = nestCount + 1>
					<cfelse>
						<cfbreak>
					</cfif>
					<!--- <cfoutput>TmpPosition: #tmpPosition#(#htmlEditFormat(mid(tagBlock,tmpPosition,len(tagBlock)))#)<br></cfoutput> --->
				</cfloop>
				
				<!--- <cfoutput>count - #nestCount# :: Level - #nestingLevel#<br></cfoutput> --->
				<cfif nestCount EQ nestingLevel>
					
					<cfset lastSpace = reFindNoCase('[#chr(32)##chr(9)#][^#chr(32)##chr(9)#]+$',tagBlock)>
					<cfset lastReturn = reFindNoCase('[#chr(10)##chr(13)#][^#chr(10)##chr(13)#]+$',tagBlock)>
					
					<cfset padding = "">
					
					<cfif lastReturn AND lastSpace AND lastReturn LT lastSpace>
						<cfset padding = mid(tagBlock,lastReturn+1,lastSpace-lastReturn)>
					</cfif>
				
					
					<cfset stTag = structNew()>
					<cfset stTag.start = tagBegin>
					<cfset stTag.end = tagEnd>
					<cfset stTag.tagBlock = padding & tagBlock>
					<cfset arrayAppend(tagLocations,stTag)>
					<cfset searchMode = "start">
				<cfelse>
					<cfset nestingLevel = nestingLevel + 1>
				</cfif>
				
			</cfif>
			
		</cfloop>
		<cfreturn tagLocations>
	</cffunction>
	
	
	<cffunction name="removeComments" access="private" output="false" returntype="string" hint="Strips the comments from a document so that code inside comments gets ignored by the findTags method">
		<cfargument name="document" type="string" required="yes">
		
		<cfset var tagLocations = findTags(document,"<!---","--->")>
		
		<cfset var offset = 0>
		<cfset var i = 0>
		
		<cfset var start = 0>
		<cfset var count = 0>
		
		<cfloop from="1" to="#arrayLen(tagLocations)#" index="i">
			<cfset start = tagLocations[i].start - offset>
			<cfset count = tagLocations[i].end - tagLocations[i].start>
			<cfset document = removeChars(document,start,count)>
			<cfset offset = offset + count>
		</cfloop>
		
		<cfreturn document>
		
	</cffunction>
	
	
	<cffunction name="getMethods" access="private" returntype="array" output="false" hint="Calls the findTags method to retrieve all cffunction tags in the given document.">
		<cfargument name="document" type="string" required="true">
		<cfreturn findTags(document,"<cf"&"function ","</cf"&"function>") />
		
	</cffunction>
	
	
	<cffunction name="getProperties" access="private" returntype="array" output="false" hint="Calls the findTags method to retrieve all cffunction tags in the given document.">
		<cfargument name="document" type="string" required="true">
		<cfreturn findTags(document,"<cf"&"property ",">")>
		
	</cffunction>
	
	
	<cffunction name="getArguments" access="private" returntype="array" output="false" hint="Calls the findTags method to retrieve all cfarguments tags in the given document. This method should be passed the body of a cffunction tag as the document argument.">
		<cfargument name="document" type="string" required="true">
		<cfreturn findTags(document,"<cf"&"argument ",">")>
		
	</cffunction>
	
	
	<cffunction name="getTagAttributes" access="private" returntype="struct" output="false" hint="Parses the attributes out of the given document for the first occurrence of the tag specified and returns a structure containing name value pairs for the tag attributes.">
		<cfargument name="document" type="string" required="true">
		<cfargument name="tagname" type="string" required="true">
		
		<cfset var startTag = "">
		<cfset var stAttributes = structNew()>
		<cfset var aTmp = reFindNoCase('<#arguments.tagname#[^>]*>',document,1,true)>
		<cfset var i = 1>
		<cfset var position = 1>
		<cfset var regex = '[[:space:]][^=]+="[^"]*"' >
		
		<cfif NOT aTmp.pos[1]>
			<cfreturn stAttributes>
		</cfif>
		
		<cfset startTag = mid(document,aTmp.pos[1],aTmp.len[1])>

		<cfloop from="1" to="#len(startTag)#" index="i">
			<cfif reFindNoCase(regex,startTag,position)>
				<cfset aTmp = reFindNoCase(regex,startTag,position,true)>
				<cfset attribute = trim(mid(startTag,aTmp.pos[1],aTmp.len[1]))>
				<cfset stAttributes[listFirst(attribute,'=')] = mid(listLast(attribute,'='),2,len(listLast(attribute,'='))-2)>
				<cfset position = aTmp.pos[1] + aTmp.len[1]>
			</cfif>
		</cfloop>
		
		<cfset stAttributes.fullTag = startTag>

		<cfreturn stAttributes>
		
		
	</cffunction>
	
	
	<cffunction name="parse" access="public" returntype="struct" output="false" hint="Provides the public interface to the CFC parser. This method should be passed the contents of a full ColdFusion component file.">
		<cfargument name="document" type="string" required="true">
		
		<cfset var cleanDocument = "">
		<cfset var stComponent = "">
		<cfset var aMethods = "">
		<cfset var i = "">
		<cfset var j = "">
		<cfset var stMethod = "">
		<cfset var stArgument = "">
		<cfset var attribStruct = structNew()>
		
				
		<cfset cleanDocument = removeComments(document)>
		
		<cfset stComponent = structNew()>
		<cfset stComponent.isInterface = false>
		<cfset stComponent.attributes = structNew()>
		<cfset stComponent.attributes.hint = "">
		<cfset stComponent.attributes.extends = "cfcomponent">
		<cfset stComponent.attributes.implements = "cfinterface">
		<cfset stComponent.attributes.displayname = "">
		<cfset stComponent.attributes.output = "">
		
		<!--- check to see if it is a component --->
		<cfset attribStruct = getTagAttributes(cleanDocument,'cfcomponent')>
		<cfif structIsEmpty(attribStruct)>
			<!--- if no attribs found, it might be an interface --->
			<cfset attribStruct = getTagAttributes(cleanDocument,'cfinterface')>
			<cfif NOT structIsEmpty(attribStruct)>
				<cfset stComponent.isInterface = true>
			</cfif>	
		</cfif>	
		<cfset structAppend(stComponent.attributes,attribStruct,true)>
		
		<cfset stComponent.properties = structNew()>
		
		<cfset aProperties = getProperties(cleanDocument)>
    
    <cfloop from="1" to="#arrayLen(aProperties)#" index="j">
				<cfset stProperty = structNew()>
				<cfset stProperty.name = "">
				<cfset stProperty.type = "any">
				<cfset stProperty.required = "false">
				<cfset stProperty.default = "_an_empty_string_">
				<cfset stProperty.displayName = "">
				<cfset stProperty.hint = "">
				<cfset structAppend(stProperty,getTagAttributes(aProperties[j].tagBlock,'cfproperty'),true)>
				<cfset stComponent.properties[stProperty.name] = stProperty>
			</cfloop>
    
		<cfset stComponent.methods = structNew()>
		
		<cfset aMethods = getMethods(cleanDocument)>
		
		
		<cfloop from="1" to="#arrayLen(aMethods)#" index="i">
		
			<cfset stMethod = structNew()>
			<cfset stMethod.name = "">
			<cfset stMethod.access = "public">
			<cfset stMethod.returnType = "any">
			<cfset stMethod.roles = "">
			<cfset stMethod.output = "">
			<cfset stMethod.displayname = "">
			<cfset stMethod.hint = "">
			<cfset structAppend(stMethod,getTagAttributes(aMethods[i].tagblock,'cffunction'),true)>
			<cfset stMethod.fullTag = aMethods[i].tagBlock>
			<cfset stComponent.methods[stMethod.name] = stMethod>
			
			<cfset stMethod.arguments = arrayNew(1)>
			<cfset aArguments = getArguments(aMethods[i].tagBlock)>
			
			<cfloop from="1" to="#arrayLen(aArguments)#" index="j">
				<cfset stArgument = structNew()>
				<cfset stArgument.name = "">
				<cfset stArgument.type = "any">
				<cfset stArgument.required = "false">
				<cfset stArgument.displayName = "">
				<cfset stArgument.hint = "">
				<cfset stArgument.default = "_an_empty_string_">
				<cfset structAppend(stArgument,getTagAttributes(aArguments[j].tagBlock,'cfargument'),true)>
				<cfset arrayAppend(stMethod.arguments,stArgument)>
			</cfloop>
			
			
		</cfloop>
		
		<cfreturn stComponent>
	</cffunction>

</cfcomponent>