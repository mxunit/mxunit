<cfsetting showdebugoutput="false" />

<cfparam name="url.test" default="" />
<cfparam name="url.componentPath" default="" />
<cfparam name="url.output" default="extjs" />
<cfset pathBase = '../' />
<cfset title = 'Test Generator' />

<cfinclude template="../resources/theme/header.cfm" />

<cfset scripts = arrayNew(1) />
<cfset arrayAppend(scripts, 'generator.js') />

<cfoutput>
	<cfscript>
		//read ini file 
		dir          = getProfileString( getProfilePath() , "blaster" , "rootDirectory" );
		sig          = getProfileString( getProfilePath() , "blaster" , "rootSignature" );
		testdir      = getProfileString( getProfilePath() , "blaster" , "testDirectory" );
		testsig      = getProfileString( getProfilePath() , "blaster" , "testSignature" );
		overwrite    = getProfileString( getProfilePath() , "blaster" , "overwrite" );
		recurse      = getProfileString( getProfilePath() , "blaster" , "recurse" );
		lastTemplate = getProfileString( getProfilePath() , "blaster" , "template" );
		cfversion    = val( listFirst(server.ColdFusion.ProductVersion) );
		
		if (NOT IsBoolean(recurse)) {
			recurse = false;
		}
		
		if (NOT IsBoolean(overwrite)) {
			overwrite = false;
		}
	</cfscript>
	
	<cfset templateDirectory = getDirectoryFromPath( getCurrentTemplatePath() ) & '/templates' />
	
	<cfdirectory 
		action    = "list" 
		directory = "#templateDirectory#"
		filter    = "*.xslt"
		name      = "templates">

<div class="grid_12">
	<h2>Setup</h2>

	<form 
		name   = "setup" 
		method = "post"
		action = "listFiles.cfm">
		<table>
			<thead>
				<tr>
					<th colspan="2">The following information is needed to generate your components.<br/>  You may also edit /mxunit/generator/setup.ini directly to change the values.</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>Component Directory</td>
					<td>
						<input 
							type  = "text"
							name  = "rootdirectory" 
							value = "#dir#"
							style = "width:400px;"
							onKeyUp = "suggest(this,this.form.testdirectory,'file')">
					</td>
				</tr>
				<tr>
					<td>Component Root Signature</td>
					<td>
						<input 
							type  = "text" 
							name  = "rootsignature" 
							value = "#sig#" 
							style = "width:400px;"
							onKeyUp = "suggest(this,this.form.testsignature,'path');">
					</td>
				</tr>
				<tr>
					<td>Test Directory</td>
					<td>
						<input 
							type  = "text"
							name  = "testdirectory" 
							value = "#testdir#" 
							style = "width:400px;">
					</td>
				</tr>
				<tr>
					<td>Test Signature</td>
					<td>
						<input 
							type  = "text" 
							name  = "testsignature"
							value = "#testsig#" 
							style = "width:400px;">
						<br/>
						Fill in the signature of your test path. If you put your test<br/> 
						directory in your component folder this will be the same as the<br/>
						Component Root Signature with your test directory appended.
					</td>
				</tr>
				<tr>
					<td>Recursive</td>
					<td>
						<input 
							type    = "checkbox" 
							name    = "recurse" 
							#checked( recurse )#
							#disabled( cfversion lt 7 )# 
							value = "true">
						<cfif cfversion lt 7>
							You can only recurse directories with ColdFusion 7 or later.
						</cfif>
					</td>
				</tr>
				<tr>
					<td>Overwrite</td>
					<td>
						<input
							type    = "checkbox"
							name    = "overwrite"
							#checked( overwrite )#
							value   = "true">
					</td>
				</tr>
				<tr>
					<td>Template</td>
					<td>
						<select name="template">
							<cfloop query="templates">
								<option value="#templates.name#" #selected(lastTemplate,templates.name)#>#templates.name#</option>
							</cfloop>
						</select>
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2" style="text-align:right;">
						<input type="submit" name="submitFrm" class="button" value="Continue &raquo;"/>
					</td>
				</tr>
			</tfoot>
		</table>
	</form>
	<!--- Notes --->
	<h2>Notes</h2>
	<ul>
		<li>
			There is no error trapping in this utility.  Hiding errors from developers 
			just seems silly to me.
		</li>
		<li>
			Add as many different test templates as you like to the 
			/mxunit/generator/templates directory. They will appear in the drop 
			down on this page and be used to transform your components into test 
			files.
		</li>
		<li>
			Adding a component root signature will make your tests run significantly 
			faster.  If you see no tests when you run the test suite file, 
			check this entry first.
		</li>
	</ul>	
</div>
</cfoutput>
