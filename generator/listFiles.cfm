<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" href="main.css" rel="stylesheet" />
<title>MXUnit Test Generator</title>

<cfscript>
	// take care of checkboxes
	cfparam( "form.recurse" , "false" );
	cfparam( "form.overwrite" , "false" );
	
	// fix paths
	form.rootDirectory = replace(form.rootDirectory,"\","/","ALL");
	form.testDirectory = replace(form.testDirectory,"\","/","ALL");
	
	// Update parameters
	setProfileString( getProfilePath() , "blaster" , "rootdirectory" , form.rootDirectory );
	setProfileString( getProfilePath() , "blaster" , "rootSignature" , form.rootSignature );
	setProfileString( getProfilePath() , "blaster" , "testdirectory" , form.testDirectory );
	setProfileString( getProfilePath() , "blaster" , "testSignature" , form.testSignature );
	setProfileString( getProfilePath() , "blaster" , "recurse" , form.recurse );
	setProfileString( getProfilePath() , "blaster" , "overwrite" , form.overwrite );
	setProfileString( getProfilePath() , "blaster" , "template" , form.template );
 	
	// Get previous file list
	lastFileList = getProfileString( getProfilePath() , "blaster" , "file" );
</cfscript>
<script type="text/javascript">
	function selectAll(chkAll)
	{
		var frm = chkAll.form;
		for (var i=0; i < frm.elements.length; i++)
		{
			if (frm.elements[i].type == "checkbox")
			{
				frm.elements[i].checked = chkAll.checked;
			}
		}
	}
	
	function selectDirectory( chkDirectory )
	{
		var frm = chkDirectory.form;
		var re = new RegExp("^" + chkDirectory.value + "$");
		var testPath = new String;
		for (var i=0; i < frm.elements.length; i++)
		{
			if (frm.elements[i].type == "checkbox" && frm.elements[i].name == "file")
			{
				testPath = frm.elements[i].value;
				testPath = testPath.substring(0,testPath.lastIndexOf("/"));
				if (re.test(testPath))
				{
					frm.elements[i].checked = chkDirectory.checked;
				}
			}
		}
	}
</script>
<cfdirectory action="list" directory="#form.rootdirectory#" name="fileQuery" recurse="#form.recurse#" filter="*.cfc">

<!--- remove test directory and test files --->
<cfquery name="fileList" dbtype="query">
	SELECT	directory, name
	FROM	fileQuery
	WHERE	name NOT like('%Test.cfc')
	<cfif len( form.testdirectory )>
	  AND	directory NOT like('#form.testdirectory#%')
	</cfif>
</cfquery>



</head>
<body>
<H1>MXUnit Test Generator</H1>
<h2>Component Selection</h2>
<form name="frmFiles" action="generate.cfm" method="post">
	<table>
		<thead>
			<tr>
				<th colspan="3" style="text-align:right;">
					<input type="button" name="back" class="button" value="&laquo; Back" onclick="history.back();">
					<input type="submit" name="submitFiles" class="button" value="Generate &raquo;"/>
				</th>
			</tr>
			<tr>
				<th>
					<input type="checkbox" name="all" onclick="selectAll(this)"/>
				</th>
				<th colspan="2">Select Files</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="fileList" group="directory">
				<tr>
					<th>
						<input type="checkbox" name="dirctory" value="#replace(directory,'\','/','ALL')#" onclick="selectDirectory(this)"/>
					</th>
					<th colspan="2">#replace(directory,"\","/","ALL")#</td>
				</tr>
				<cfoutput>
					<tr>
						<td>&nbsp;</td>
						<td>
							<cfset thisFileName = replace(directory,"\","/","ALL") & "/" & name />
							<input type="checkbox" name="file" value="#thisFileName#" #checked(listFindNoCase(lastFileList,thisFileName))#/></td>
						<td>#name#</td>
					</tr>
				</cfoutput>
			</cfoutput>
		</tbody>
		<tfoot>
			<tr>
				<th colspan="3" style="text-align:right;">
					<input type="button" name="back" class="button" value="&laquo; Back" onclick="history.back();">
					<input type="submit" name="submitFiles" class="button" value="Generate &raquo;"/>
				</th>
			</tr>
		</tfoot>
	</table>
</form>
</body>
</html>