<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" href="main.css" rel="stylesheet" />
<title>Generate tests</title>

<cfparam name="form.file" default="" />

<!--- Store file list --->
<cfset setProfileString( getProfilePath() , "blaster" , "file" , "#form.file#" )>

<!--- Read from ini file --->
<cfscript>
	rootDir   = getProfileString( getProfilePath() , "blaster" , "rootDirectory" );
	rootSig   = getProfileString( getProfilePath() , "blaster" , "rootSignature" );
	template  = getProfileString( getProfilePath() , "blaster" , "template" );
	testDir   = getProfileString( getProfilePath() , "blaster" , "testDirectory" );
	testSig   = getProfileString( getProfilePath() , "blaster" , "testSignature" );
	overwrite = getProfileString( getProfilePath() , "blaster" , "overwrite" );
 	
	componentArray = arraynew( 1 );
</cfscript>

</head>
<body>
	<cfoutput>
		<h1>MXUnit Test Generator</h1>
		<h2>Generating Tests</h2>
		<table>
			<tbody>
				<tr>
					<td>
						<cfif NOT listLen(form.file)>
							<p>No files selected for test generation.</p>
						</cfif>
						<cfloop list="#form.file#" index="currentComponent">
							<cfscript>
								// build the component signature
								class = replaceNoCase( currentComponent , rootDir , rootSig );
								class = removeChars( class , len(class) - 3 , 4 );
								class = replaceNoCase( class , "/" , "." , "all" );
								
								// invoke it so we can read metadata
								obj = createObject( "component" , class ); // note that we don't invoke any methods
								md = getMetaData( obj );
								md.path = replace(md.path,"\","/","All");								
							</cfscript>					
<cfxml variable="comp">
<root>
	<component path="#listDeleteAt(md.name,listLen(md.name,"."),".")#" name="#listLast(md.name,".")#" fullname="#md.name#">
	<cfif IsDefined("md.functions")>
	<cfloop index="method" from="1" to="#arrayLen(md.functions)#">
		<method name="#md.functions[method].name#" 
			<cfif structKeyExists(md.functions[method],"access")>
				access="#md.functions[method].access#"
			</cfif>
			<cfif structKeyExists(md.functions[method],"output")>
				output="#md.functions[method].output#"
			</cfif>
			<cfif structKeyExists(md.functions[method],"returntype")>
				returntype="#md.functions[method].returntype#"
			</cfif>
		>
			<name>#md.functions[method].name#</name>
		<cfloop index="argument" from="1" to="#arrayLen(md.functions[method].parameters)#">
			<parameter name="#md.functions[method].parameters[argument].name#" 
		 	<cfif structKeyExists(md.functions[method].parameters[argument],"required")>
				required="#md.functions[method].parameters[argument].required#"
			</cfif>
			<cfif structKeyExists(md.functions[method].parameters[argument],"type")>
				type="#md.functions[method].parameters[argument].type#"
			</cfif>
			<cfif structKeyExists(md.functions[method].parameters[argument],"default")>
				default="#md.functions[method].parameters[argument].default#"
			</cfif>
			/></cfloop>
		</method>
	</cfloop>
	</cfif>
	</component>
</root>
</cfxml>
							<!--- store the xml for troubleshooting purposes --->
							<cffile action="write" file="#getDirectoryFromPath(getCurrentTemplatePath())  & '/temp.xml'#" output="#comp#">	
							<!--- read the template file --->
							<cffile action="read" file="#getDirectoryFromPath(getCurrentTemplatePath()) & '/templates/' & template#" variable="xmlTransform">
							<cfset newFile = xmlTransform(comp,xmlTransform) />
				
							<!--- Build test path --->
							<cfset name = listLast(md.name,".") & "Test.cfc">
							<cfif len(testDir)>
								<cfset testFile = replaceNoCase(md.path,rootDir,testDir)>
								<cfset testPath = listDeleteAt(testFile,listLen(testFile,"/"),"/") & "/">
								<!--- Create directory if needed --->
								<cfif NOT directoryExists(testPath)>
									<cfdirectory action="create" directory="#testPath#">
								</cfif>			
							<cfelse>					
								<cfset testPath = listDeleteAt(md.path,listLen(md.path,"/"),"/") & "/"/>
							</cfif>
							
							<!--- Write the test file --->
							<cfif overwrite OR NOT fileExists(testPath & name)>
								<cffile action="write" file="#testPath & name#" output="#newFile#" >
								<p>#testPath##name# generated.</p>
							<cfelse>
								<p style="color:##ff0000">#testPath##name# already exists.</p>
							</cfif>
						</cfloop>
					</td>
				</tr>
				<tr>
					<td style="text-align:right;">
						<input type="button" name="back" value="&laquo; Back" class="button" onClick="history.back();">
						<input type="button" name="start" value="&laquo;&laquo; Start Again" class="button" onclick="location.href='index.cfm';">
					</td>
				</tr>
			</tbody>
		</table>
	</cfoutput>
		
		<!--- Create test suite --->
<cfif len(testDir)>
	<cfset testSuite = '<cfparam name="URL.output" default="html">

<cfscript>
	DTS = createObject("component","mxunit.runner.DirectoryTestSuite");
	excludes = "";
	results = DTS.run(
				directory     = "#testDir#/",
				componentPath = "#trim(testSig)#",
				recurse       = "true",
				excludes      = "##excludes##"
				);
</cfscript>
 
<cfoutput>##results.getResultsOutput(URL.output)##</cfoutput>  			
	'>
	<cfoutput>
		<cffile action="write" file="#testDir#/myTestSuite.cfm" output="#testSuite#">
	</cfoutput>
</cfif>
</body>
</html>