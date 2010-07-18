<cfcomponent extends="mxunit.framework.TestCase">


	<cffunction name="setUp" returntype="void" access="public" hint="put things here that you want to run before each test">
		<cfset csvutil = createObject("component","mxunit.framework.CSVUtility")>		
		<cfset fixturePath = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public" hint="put things here that you want to run after each test">	
	
	</cffunction>
	
	<cffunction name="readCSV_Should_ReturnQueryWithHeaderRow_WhenHeaderExists" returntype="void" access="public">
		<cfset var csvFile = fixturePath & "SimpleCSV.csv">
		<cfset var result = csvutil.readCSV(filePath=csvFile,hasHeaderRow=true)>
		<cfset assertEquals(5150,result.query.expectedresult[4])>
		<cfset assertEquals(2,result.query.taxrate[3],"")>
	</cffunction>
	
	<cffunction name="readCSV_Should_ReturnQueryWithDerivedHeaderRow_WhenNoHeader" returntype="void">
		<cfset var csvFile = fixturePath & "CSVWithoutHeaders.csv">
		<cfset var result = csvutil.readCSV(filePath=csvFile,hasHeaderRow=false)>
		<cfset assertEquals(5150,result.query.column3[4])>
		<cfset assertEquals(2,result.query.column1[3],"")>
	</cffunction>
	
	<cffunction name="readCSVToArray_Should_Return2DArray" returntype="void">
		<cfset var csvFile = fixturePath & "CSVWithoutHeaders.csv">
		<cfset var result = csvutil.readCSVToArray(filePath=csvFile,hasHeaderRow=false)>
		<cfset assertEquals(5150,result[4][3])>
		<cfset assertEQuals(2,result[3][1])>
	</cffunction>
	

</cfcomponent>