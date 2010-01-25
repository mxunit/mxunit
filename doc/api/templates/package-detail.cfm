<cfoutput>
<cfif NOT structKeyExists(url, "package")>
	<cfset showPackage="All packages">
<cfelse>
	<cfset showPackage="#util.getPackageDisplayName(url.package)#">
</cfif>

<script type="text/javascript">
	titleBar_setSubTitle("Package #showPackage#"); 
</script>

<cfset components = arrayNew(1)>
<cfset interfaces = arrayNew(1)>
<cfloop query="orderedQuery">
	<cfif NOT structKeyExists(url, "package") OR orderedQuery.package EQ url.package>
		<cfset display = "<a href=""#templates#content.cfm?file=#urlEncodedFormat(orderedQuery.fullpath&directorySeparator&orderedQuery.name)#"">#listFirst(orderedQuery.name,'.')#</a><br>">
		<cfif orderedQuery.interface>
			<cfset arrayAppend(interfaces,display)>
		<cfelse>
			<cfset arrayAppend(components,display)>
		</cfif>	
	</cfif>
</cfloop>
<!--- 
<div class="MainContent">
<cfoutput>
<cfset methodNameSet = createObject("java", "java.util.HashSet").init() />
<cfset aNames = structKeyArray(stComponent.methods)>
<cfset arraySort(aNames,'textnocase')>
<cfset constructorContent = "" />
<cfset methodContent = "" />

<cfloop from="1" to="#arrayLen(aNames)#" index="i">
<cfset thisMethod = stComponent.methods[aNames[i]]>
<cfset methodNameSet.add(thisMethod.name) />
<cfif listFindNoCase(application.constructorNames, thisMethod.name) GT 0>
	<cfsavecontent variable="constructorContent">#constructorContent#
	<tr class="">
		<td class="summaryTablePaddingCol" nowrap>&nbsp;</td><td nowrap class="summaryTableInheritanceCol"><CODE>#thisMethod.access# <a href="#util.getDetailURL(thisMethod.returntype,stComponent.path)#" target="_self">#listLast(thisMethod.returnType, ".")#</a></CODE></td><td class="summaryTableSignatureCol">
			<div class="summarySignature">
			<a class="signatureLink" href="###thismethod.name#()">#thisMethod.name#</a>(#generateArgumentList(thisMethod)#)</div>
			<div class="summaryTableDescription">
			<cfif len(trim(thisMethod.hint))>
				#thisMethod.hint#
			</cfif>
	  		</div>
		</td>
	</tr>	
	</cfsavecontent>
<cfelse>
	<cfsavecontent variable="methodContent">#methodContent#
	<tr class="">
		<td class="summaryTablePaddingCol" nowrap>&nbsp;</td><td nowrap class="summaryTableInheritanceCol"><CODE>#thisMethod.access# <a href="#util.getDetailURL(thisMethod.returntype,stComponent.path)#" target="_self">#listLast(thisMethod.returnType, ".")#</a></CODE></td><td class="summaryTableSignatureCol">
			<div class="summarySignature">
			<a class="signatureLink" href="###thismethod.name#()">#thisMethod.name#</a>(#generateArgumentList(thisMethod)#)</div>
			<div class="summaryTableDescription">
			<cfif len(trim(thisMethod.hint))>
			#thisMethod.hint#
			</div>
			<cfif structKeyExists(thisMethod, "deprecated")><br /><strong><img src="images/exclamation.jpg" border="0" align="absmiddle" > Deprecated.</strong> <em>#thisMethod.deprecated#</em></cfif>
			</cfif>
		</td>
	</tr>	
	</cfsavecontent>
</cfif>
</cfloop>
</div> --->

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
	
	
</cfoutput>
