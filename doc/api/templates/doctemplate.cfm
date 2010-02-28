<script type="text/javascript">
	titleBar_setSubTitle("<cfoutput>#IIF(stComponent.isInterface,de("Interface"),de("Component"))# #stComponent.name#</cfoutput>"); 
</script>

<cfscript>
	function generateArgumentList(thisMethod) {
		var result = createObject("java", "java.lang.StringBuffer").init();
		var i = "";
		var argCount = arrayLen(thisMethod.arguments);
		for (i = 1; i LTE argCount; i = i + 1) {
			result.append(generateArgument(thisMethod.arguments[i]));
			if (i LT argCount)
				result.append(",&nbsp;");
		}
		return result.toString();
	}
	function generateArgument(argument) {
		var result = createObject("java", "java.lang.StringBuffer").init();
		if (NOT argument.required)
			result.append("[");
		result.append('<a href="#util.getDetailURL(argument.type,stComponent.path)#">#listLast(argument.type, '.')#</a> #argument.name#');
		if (NOT argument.required) {
			result.append(JavaCast("string","]"));
		}
		return result.toString();
	}
</cfscript>
<cfset HINT_INDENT = 10 />

<!-- ======== START OF CLASS DATA ======== -->

<cfoutput>
<div class="MainContent">
<table cellspacing="0" cellpadding="0" class="classHeaderTable">
	<tr>
		<td class="classHeaderTableLabel">Package</td><td><a href="components.cfm?package=#stComponent.package#&pathindex=#stComponent.pathindex#" target="components">#stComponent.package#</a></td>
	</tr>
	<tr>
		<td class="classHeaderTableLabel">#IIF(stComponent.isInterface,de("Interface"),de("Component"))#</td><td class="classSignature">#stComponent.name#</td>
	</tr>
	<cfif not stComponent.isInterface>
	<tr>
		<td class="classHeaderTableLabel">Implements</td><td class="classSignature">
		<cfsetting enablecfoutputonly="true">
		<cfif arrayIsEmpty(stComponent.implements)>
			<cfoutput>-</cfoutput>
		<cfelse>
			<cfloop from="1" to="#arrayLen(stComponent.implements)#" index="i">
			   <cfset theObject = getMetaData(stComponent.implements[i]) />
		       <cfif theObject.name IS "java.lang.String" >
			   		<cfoutput>#IIF(i GT 1,de(","),de(""))# #stComponent.implements[i]#</cfoutput>
			   <cfelse>    
				<cfoutput>#IIF(i GT 1,de(","),de(""))#
				<A HREF="#util.getDetailURL(stComponent.implements[i].package & '.' & stComponent.implements[i].name, '')#" title="">#util.getPackageDisplayPrefix(stComponent.implements[i].package)##stComponent.implements[i].name#</A><br>
				</cfoutput>
				</cfif>
			</cfloop>
		</cfif>		
		<cfsetting enablecfoutputonly="false">
	</tr>
	
	</cfif>
	<tr>
		<td class="classHeaderTableLabel">Inheritance</td><td class="inheritanceList"><cfsetting enablecfoutputonly="true">
		
		<cfscript>
			temp = stComponent;
			components = arrayNew(1);
			s = structNew();
			s.package = temp.package;
			s.name = temp.name;
			arrayPrepend(components, s);
			while (structKeyExists(temp, "superComponent")) {
				temp = temp.superComponent;
				s = structNew();
				if (getMetaData(temp).name IS "java.lang.String") {
					s.name = temp;
					s.resolvable = false;
					arrayPrepend(components, s);
					break;				
				}
				s.resolvable = true;
				s.package = temp.package;
				s.name = temp.name;
				arrayPrepend(components, s);
			}
		</cfscript>
		<cfif (arrayLen(components) - 1) GT 0>
			<cfloop from="1" to="#arrayLen(components) - 1#" index="i">
				<cfif components[i].resolvable>
					<cfoutput><A HREF="#util.getDetailURL(components[i].package & '.' & components[i].name, '')#" title="">#util.getPackageDisplayPrefix(components[i].package)##components[i].name#</A><br></cfoutput>
				<cfelse>
					<cfoutput>#components[i].name# <br></cfoutput>	
				</cfif>
				<cfoutput><img src="../images/blank.gif" height="16" width="#(20*i)#"><img class="inheritArrow" alt="Inheritance" title="Inheritance" src="../images/inherit.jpg"></cfoutput>
			</cfloop>
			<cfoutput>#util.getPackageDisplayPrefix(stComponent.package)##stComponent.name#</cfoutput>
		<cfelse>
			<cfoutput>-</cfoutput>
		</cfif>		
		<cfsetting enablecfoutputonly="false">
		</td>	
	</tr>
	
</table>

<cfif len(trim(stComponent.attributes.hint))>
	<br>
	<img src="../images/lightbulb.jpg" align="absmiddle" border="0"> #stComponent.attributes.hint#
</cfif>
	<p/>
	<hr />
</cfoutput>
</div>

<cfoutput>
	
<!-- ========== PROPERTY SUMMARY =========== -->
<cfset propertyNameSet = createObject("java", "java.util.HashSet").init() />
<a name="propertySummary"></a>
<cfif structCount(stComponent.properties)>
	<div class="summarySection">
	<div class="summaryTableTitle">Property summary</div>
	<table id="summaryTableProperty" class="summaryTable " cellpadding="3" cellspacing="0" >
		<tr>
			<th></th><th colspan="2">Property</th>
		</tr>
		<cfset aNames = structKeyArray(stComponent.properties)>
		<cfset arraySort(aNames,'textnocase')>
		<cfloop from="1" to="#arrayLen(aNames)#" index="i">
		<cfset thisProperty = stComponent.properties[aNames[i]]>
		<cfset propertyNameSet.add(thisProperty.name) />
		<tr class="">
			<td class="summaryTablePaddingCol">&nbsp;</td>
			<td>
				<a class="signatureLink" href="##propertydetail_#thisproperty.name#">#thisProperty.name#</A> type: <a href="#util.getDetailURL(thisProperty.type,stComponent.path)#">#thisProperty.type#</a></code>
				<cfif len(trim(thisProperty.hint))> 
					<div class="summaryTableDescription">
  						#repeatString("&nbsp;", HINT_INDENT)##thisProperty.hint#
  					</div>
				</cfif>
			</td>
		</TR>
	</cfloop>
	</table>
	</div>
</cfif>
<cfset thisComponent = stComponent />
<cfloop condition="structKeyExists(thisComponent, 'superComponent')">
	<cfset thisComponent = thisComponent.superComponent />
	<cfif getMetaData(thisComponent).name IS NOT "java.lang.String">
		<cfset propertyNames = structKeyArray(thisComponent.properties) />
		<cfset inheritedPropertyNames = arrayNew(1) />
		<cfloop from="1" to="#arrayLen(propertyNames)#" index="i">
			<cfif propertyNameSet.add(propertyNames[i])>
				<cfset arrayAppend(inheritedPropertyNames, propertyNames[i]) />
			</cfif>
		</cfloop>
		<cfif arrayLen(inheritedPropertyNames) GT 0>
		<div class="summarySection">
			<table class="summaryTable " cellpadding="3" cellspacing="0">
			<tr>
				<th class="summaryTablePaddingCol">&nbsp;</th><th colspan="3" class="summaryTableSignatureCol">Inherited properties  from #util.getPackageDisplayPrefix(thisComponent.package)#<a href="#util.getDetailURL(thisComponent.package & '.' & thisComponent.name, '')#">#thisComponent.name#</a></th>
			</tr>
				<td>&nbsp;</td>	
				<td>
				<cfset count = arrayLen(inheritedPropertyNames) />
				<cfloop from="1" to="#count#" index="i">
					<a href="#util.getDetailURL(thisComponent.package & '.' & thisComponent.name, '')###propertydetail_#inheritedPropertyNames[i]#">#inheritedPropertyNames[i]#</a><cfif i LT count>, </cfif>
				</cfloop>
				</td>
			</tr>
			</table>
		</div>	
		</cfif>
	<cfelse>
		<cfbreak>	
	</cfif>	
</cfloop>

</cfoutput>

<!-- ========== METHOD SUMMARY =========== -->


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
		<td class="summaryTablePaddingCol">&nbsp;</td><td nowrap class="summaryTablesigCol"><CODE>#thisMethod.access# <a href="#util.getDetailURL(thisMethod.returntype,stComponent.path)#" target="_self">#listLast(thisMethod.returnType, ".")#</a></CODE></td><td class="summaryTableSignatureCol">
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
		<td class="summaryTablePaddingCol" nowrap>&nbsp;</td><td nowrap class="summaryTablesigCol"><CODE>#thisMethod.access# <a href="#util.getDetailURL(thisMethod.returntype,stComponent.path)#" target="_self">#listLast(thisMethod.returnType, ".")#</a></CODE></td><td class="summaryTableSignatureCol">
			<div class="summarySignature">
			<a class="signatureLink" href="###thismethod.name#()">#thisMethod.name#</a>(#generateArgumentList(thisMethod)#)</div>
			<div class="summaryTableDescription">
			<cfif len(trim(thisMethod.hint))>
			#thisMethod.hint#
			<cfif structKeyExists(thisMethod, "deprecated")><br /><strong><img src="../images/exclamation.jpg" border="0" align="absmiddle" > Deprecated.</strong> <em>#thisMethod.deprecated#</em></cfif>
			</cfif>
			</div>
		</td>
	</tr>	
	</cfsavecontent>
</cfif>
</cfloop>

<a name="methodSummary"></a>
<div class="summarySection">
<div class="summaryTableTitle">Methods summary</div>
<cfif constructorContent NEQ "">
	<table class="summaryTable " cellpadding="3" cellspacing="0">
	<tr>
	<th >&nbsp;</th><th colspan="3">Constructors</th>
	</tr>
	#constructorContent#
	</table>
</cfif>	
<table  class="summaryTable " cellpadding="3" cellspacing="0">
<tr>
<th>&nbsp;</th><th colspan="3">Methods</th>
</tr>
#methodContent#
</table>
</div>


<div class="summarySection">
<a name="inheritMethodS"></a>
<cfset thisComponent = stComponent />
<cfloop condition="structKeyExists(thisComponent, 'superComponent')">
	<cfset thisComponent = thisComponent.superComponent />
	<cfif getMetaData(thisComponent).name IS NOT "java.lang.String">
		<cfset methodNames = structKeyArray(thisComponent.methods) />
		<cfset inheritedMethodNames = arrayNew(1) />
		<cfloop from="1" to="#arrayLen(methodNames)#" index="i">
			<cfif methodNameSet.add(methodNames[i])>
				<cfset arrayAppend(inheritedMethodNames, methodNames[i]) />
			</cfif>
		</cfloop>
	
		<cfif arrayLen(inheritedMethodNames) GT 0>
			<table class="summaryTable " cellpadding="3" cellspacing="0">
			<tr>
				<th class="summaryTablePaddingCol">&nbsp;</th><th class="summaryTableSignatureCol">Inherited methods from #util.getPackageDisplayPrefix(thisComponent.package)#<a href="#util.getDetailURL(thisComponent.package & '.' & thisComponent.name, '')#">#thisComponent.name#</a></th>
			</tr>
				<td></td>	
				<td>
				<cfset count = arrayLen(inheritedMethodNames) />
				<cfloop from="1" to="#count#" index="i">
					<a href="#util.getDetailURL(thisComponent.package & '.' & thisComponent.name, '')####inheritedMethodNames[i]#()">#inheritedMethodNames[i]#</a><cfif i LT count>, </cfif>
				</cfloop>
				</td>
			</tr>
			</table>
		</cfif>
	 <cfelse>
	 	<cfbreak>
	 </cfif>				
</cfloop>
&nbsp;
<br>
</cfoutput>
</div>

<!--- implemented methods --->
<cfif not stComponent.isInterface>
	<div class="summarySection">
	<a name="implementedMethods"></a>
	<cfset implementedMethodNames = arrayNew(1) />
	<cfif not arrayIsEmpty(stComponent.implements)>
		<cfloop from="1" to="#arrayLen(stComponent.implements)#" index="i">
			   <cfset doContinue = true>
			   <cfset theObject = getMetaData(stComponent.implements[i]) />
			    <cfif theObject.name IS "java.lang.String" >
			   		<cfset doContinue = false> 
			   	</cfif>
			   	<cfif doContinue>
				   	<cfset thisComponent = stComponent.implements[i] />
				   	<cfset superFound=true>
				   	<cfloop condition="superFound">
						<cfset methodNames = structKeyArray(thisComponent.methods) />
						<cfloop from="1" to="#arrayLen(methodNames)#" index="j">
							<cfif NOT ListFindNoCase(arrayToList(implementedMethodNames),methodNames[j])>
								<cfset arrayAppend(implementedMethodNames, methodNames[j]) />
							</cfif>
						</cfloop>
						<cfif not structKeyExists(thisComponent, 'superComponent')>
							<cfset superFound=false>
						<cfelse>
							<cfset thisComponent = thisComponent.superComponent />	
						</cfif>	
					</cfloop>	
				</cfif>
	
		</cfloop>
		<cfif arrayLen(implementedMethodNames) GT 0>
			<table class="summaryTable " cellpadding="3" cellspacing="0">
			<tr>
				<th class="summaryTablePaddingCol">&nbsp;</th><th class="summaryTableSignatureCol">Implemented methods</th>
			</tr>
				<td></td>	
				<td>
				<cfset count = arrayLen(implementedMethodNames) />
				<cfloop from="1" to="#count#" index="i">
					<cfoutput><a href="#util.getDetailURL(thisComponent.package & '.' & thisComponent.name, '')####implementedMethodNames[i]#()">
						<cfif NOT methodNameSet.contains(implementedMethodNames[i])>
								<i>#implementedMethodNames[i]#</i></a> <img src="../images/link_break.jpg" align="absmiddle" class="notImplemented" title="Warning: not found :: Allthough <strong>#implementedMethodNames[i]#</strong> belongs to an interface that is implemented in this CFC, the actual method itself cannot be found here." />
						<cfelse>
								#implementedMethodNames[i]#</a>
						</cfif>
						<cfif i LT count>, </cfif>
					</cfoutput>
				</cfloop>
				</td>
			</tr>
			</table>
		</cfif>
	</cfif>
	</div>
</cfif>

<cfif structCount(stComponent.properties)>

<!-- ============ PROPERTY DETAIL ========== -->

<A NAME="property_detail"><!-- --></A>
<div class="MainContent">
<div class="detailSectionHeader">Properties detail</div>
<cfset aNames = structKeyArray(stComponent.properties)>
<cfset arraySort(aNames,'textnocase')>
<cfoutput>
<cfloop from="1" to="#arrayLen(aNames)#" index="i">
<cfset thisProperty = stComponent.properties[aNames[i]]>
<a name="propertydetail_#thisProperty.name#"></a>
<table cellspacing="0" cellpadding="0" class="detailHeader">
<tr>
	<td class="detailHeaderName">#thisProperty.name#</td>
</tr>
</table>
	<div class="detailBody">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="summaryTableInheritanceCol"></td>
				<td>
					<cfif thisProperty.hint NEQ "">
					<br>
					<img src="../images/lightbulb.jpg" align="absmiddle" border="0"> #thisProperty.hint#
					<cfif NOT thisProperty.required>&nbsp;This property is <strong>not</strong> required.</cfif>
					<br>
					<br>
					</cfif>
					<span class="label">Type</span>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20px"></td>
							<td><code><a href="#util.getDetailURL(thisProperty.type,stComponent.path)#">#thisProperty.type#</a></code>
								<cfif thisProperty.default NEQ "_an_empty_string_">&nbsp;<i>Defaults to <cfif thisProperty.default EQ "">""<cfelse>#thisProperty.default#</i></cfif></cfif></td>
							
							</td>
						</tr>
						<cfif revealCode>
						<tr>
							<td width="20px"></td>
							<td>
							<span class="codeTrigger"><img src="../images/open.jpg" align="absmiddle"> Show code</span>
							<div id="#thismethod.name#" class="codeBlock">
								<pre>#util.ColorCode2(thisproperty.fullTag)#</pre>
							</div>	
							</td>
							</tr>
						</cfif>
						<tr>
							<td colspan="2" class="paramSpacer">&nbsp;</td>
						</tr>
						</table>
					
			&nbsp;</td>
			</tr>
		</table>		
		</div>
</div>
<p>
</cfloop>
</cfoutput>

</cfif>
<!-- ============ METHOD DETAIL ========== -->

<A NAME="method_detail"><!-- --></A>
<div class="MainContent">
<cfset aNames = structKeyArray(stComponent.methods)>
<cfset arraySort(aNames,'textnocase')>
<cfoutput>
<div class="detailSectionHeader">Methods detail</div>	
<cfloop from="1" to="#arrayLen(aNames)#" index="i">
<cfset thisMethod = stComponent.methods[aNames[i]]>
<a name="#thismethod.name#()"></a>
<table cellspacing="0" cellpadding="0" class="detailHeader">
<tr>
<td class="detailHeaderName">#thismethod.name#</td>
</tr>
</table>
<p>
	<div class="detailBody">
		<cfif structKeyExists(thisMethod, "deprecated")>
			<span class="label"><img src="../images/exclamation.jpg" border="0" align="absmiddle" > <strong>DEPRECATED</strong></span>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20px"></td>
					<td><em>#thisMethod.deprecated#</em></td>
				</tr>
				<tr>
					<td colspan="2" class="paramSpacer">&nbsp;</td>
				</tr>
			</table>
			<br>	
		</cfif>
		#thisMethod.access# <A HREF="#util.getDetailURL(thisMethod.returntype,stComponent.path)#" title="">#thisMethod.returnType#</A> <B>#thisMethod.name#</B>(#generateArgumentList(thisMethod)#)
		<br>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td class="summaryTableInheritanceCol"><img src="../images/blank.gif" width="20px"></td>
				<td>
					<cfif thisMethod.hint NEQ "">
					<br>
					<div class="hintBox">
					<img src="../images/lightbulb.jpg" align="absmiddle" border="0"> #thisMethod.hint#
					</div>
					<br>
					</cfif>
					<cfif arrayLen(thisMethod.arguments) GT 0>
					<br>
					<span class="label">Parameters</span>
					<table border="0" cellspacing="0" cellpadding="0">
						<cfloop from="1" to="#arrayLen(thisMethod.arguments)#" index="j">
						<tr>
							<td width="20px"></td>
							<td><code>#generateArgument(thisMethod.arguments[j])#</code> &nbsp;</td>
							<td><cfif len(trim(thisMethod.arguments[j].hint))>#thisMethod.arguments[j].hint#</cfif>
								<cfif NOT thisMethod.arguments[j].required>&nbsp;<i>Not required.</i></cfif>
								<cfif thisMethod.arguments[j].default NEQ "_an_empty_string_">&nbsp;<i>Defaults to <cfif thisMethod.arguments[j].default EQ "">""<cfelse>#thisMethod.arguments[j].default#</i></cfif></cfif>
							</td>
						</tr>
						<tr>
							<td colspan="3" class="paramSpacer">&nbsp;</td>
						</tr>
						</cfloop>
					</table>
					<cfelse>
					<br>
					</cfif>
					<span class="label">Returns</span>
					<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20px"></td>
							<td><code><a href="#util.getDetailURL(thisMethod.returnType,stComponent.path)#">#thisMethod.returnType#</a></code></td>
						</tr>
						<tr>
							<td colspan="2" class="paramSpacer">&nbsp;</td>
						</tr>
						</table>
					<cfif structKeyExists(thisMethod, "throws")>
	
					<span class="label">Throws</span>
						<cfloop list="#thisMethod.throws#" index="j">
						<table border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td width="20px"></td>
							<td><code>#j#</code></td>
						</tr>
						<tr>
							<td colspan="2" class="paramSpacer">&nbsp;</td>
						</tr>
						</table>
						</cfloop>
					</cfif>
					
			&nbsp;</td>
			</tr>
			<cfif revealCode>
					<tr>
						<td class="summaryTableInheritanceCol"></td>
						<td><span class="codeTrigger"><img src="../images/open.jpg" align="absmiddle"> Show code</span>
						<div id="#thismethod.name#" class="codeBlock">
							<pre>#util.ColorCode2(thismethod.fullTag)#</pre>
						</div>
						</td>
					</tr>	
			</cfif>
	
		</table>		
		</div>

<hr>
</cfloop>
</div>
</cfoutput>

<cfif revealCFCCode>
<DL>
  <DT><B>Full Component Code:</B></DT>
  <DD>
	<cfoutput>#util.ColorCode2(stComponent.code)#</cfoutput>
  </DD>
</DL>
<HR>
</cfif>
