<cfcomponent output="false" extends="mxunit.framework.TestCase">




<cfset myStruct = {
        foo='bar',bar='123',bunko='banked'
          }>
<cffunction name="dataproviderShouldAcceptStructs" mxunit:dataprovider="myStruct">
  <cfargument name="theData">
  <cfset debug(theData)	>

  	<cfset assertEquals( 1, structCount(theData), "This is a struct with 3 keys, so each iteration should contains a single key" )>

</cffunction>


<!--- Just run this test 100 times --->
<cffunction name="dataproviderShouldAcceptSimpleValueForNumericLoops" mxunit:dataprovider="201">
  <cfargument name="cnt">
  <cfset debug(cnt)>
  <cfset r=randrange(cnt,1000+cnt)>
</cffunction>

<cfset simple=111>
<!--- Just run this test 100 times --->
<cffunction name="dataproviderShouldAcceptSimpleNumericVariablesForLoops" mxunit:dataprovider="simple">
  <cfargument name="cnt">
  <cfset debug(cnt)>
  <cfset r=randrange(cnt,1000+cnt)>
  <cfset assert(r) >
</cffunction>

<cfset _2dA = [
                [1,2,3,4],
                ['a','quick','brown','fox']
              ]>

<cffunction name="dataproviderShouldAccept2DArrays" mxunit:dataprovider="_2dA">
  <cfargument name="myArray" />
  <cfscript>

		debug(myArray);
	  if(arguments.index == 1){
	   	assertEquals( myarray[1] , _2dA[1][1] );
	  	assertEquals( myarray[2] , _2dA[1][2] );
	  	assertEquals( myarray[3] , _2dA[1][3] );
	  	assertEquals( myarray[4] , _2dA[1][4] );
	  }
	  else {
	  	assertEquals( myarray[1] , _2dA[2][1] );
	  	assertEquals( myarray[2] , _2dA[2][2] );
	  	assertEquals( myarray[3] , _2dA[2][3] );
	  	assertEquals( myarray[4] , _2dA[2][4] );
	  }
  </cfscript>

</cffunction>


<cfset a = [1,2,3,4]>

<cffunction name="dataproviderShouldAcceptArrays" mxunit:dataprovider="a">
  <cfargument name="arrayItem" />
  <cfdump var="#arrayItem#">
  <cfset assert(arrayItem gt 0 ) >
  <cfset assertEquals(arrayItem,arguments.index ) >
</cffunction>


<cfset strArray = ['a','quick','brown','fox']>

<cffunction name="dataproviderShouldIterateOverStringArray" mxunit:dataprovider="strArray">
  <cfargument name="item" />

  <cfdump var="#item#">
  <cfswitch expression="#arguments.index#">
   <cfcase value="1">
      <cfset assertEquals(item, 'a') >
   </cfcase>
   <cfcase value="2">
      <cfset assertEquals(item, 'quick') >
   </cfcase>
   <cfcase value="3">
      <cfset assertEquals(item, 'brown') >
   </cfcase>
   <cfcase value="4">
      <cfset assertEquals(item, 'fox') >
   </cfcase>
  </cfswitch>
</cffunction>


<cfset aList = 'a/quick/brown/fox'>

<cffunction name="dataproviderShouldIterateOverList" mxunit:dataprovider="aList">
  <cfargument name="myListItem" />
   <cfdump var="in testcase: #myListItem#.  ">
   <cfset assert( isSimpleValue(myListItem) )>
</cffunction>



<!---
FILE-BASED DATAPROVIDERS
 --->

<!--- Excel: --->
<!--- I consider this the typical case: an excel file with a header row; so we want mxunit to convert it to a query and run our test once per row --->
<cfset simpleExcel = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/SimpleExcel.xls">
<cffunction name="dataProviderShouldRunExcelFileAsQuery" mxunit:dataprovider="simpleExcel">
	<cfargument name="myQuery">
	<cfset taxPercent = myQuery.TaxRate/100>
	<cfset assertEquals(myQuery.ExpectedResult, (myQuery.ItemCost*1) + (myQuery.ItemCost*taxPercent) )>
</cffunction>

<!--- I consider this the 2nd preferred way of dealing with excel: no headers, so treat as a 2D Array --->
<!--- this function uses the POIUtility that comes with MXUnit (via the incomparable Ben Nadel) to do custom ExcelToQuery stuff --->
<cffunction name="createArrayFromHeaderlessExcel" access="private">
	<cfscript>
	var headerlessExcel = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/ExcelWithoutHeaders.xls";
	var poi = createObject("component","mxunit.framework.POIUtility").init();
	return poi.readExcelToArray(filepath=headerlessExcel,hasheaderrow=false,sheetindex=0);
	</cfscript>
</cffunction>

<!--- and this test uses that function above --->
<cfset ExcelToArrayWithoutColumns = createArrayFromHeaderlessExcel()>
<cffunction name="ExcelToArray_Should_Create2DArrayForDataProvider" returntype="void" mxunit:dataprovider="ExcelToArrayWithoutColumns">
	 <cfargument name="myArray" />
	<cfset taxPercent = myArray[1]/100>
	<cfset assertEquals(myArray[3], (myArray[2]*1) + (myArray[2]*taxPercent) )>
</cffunction>


<!--- this function uses the POIUtility that comes with MXUnit (via the incomparable Ben Nadel) to do other custom ExcelToQuery stuff --->
<cffunction name="createQueryFromHeaderlessExcel" access="private">
	<cfscript>
	var headerlessExcel = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/ExcelWithoutHeaders.xls";
	var poi = createObject("component","mxunit.framework.POIUtility").init();
	var poiResult = poi.readExcel(filepath=headerlessExcel,hasheaderrow=false,sheetindex=0);
	return poiResult.Query;
	</cfscript>
</cffunction>

<!--- and this test uses that function above --->
<cfset ExcelQueryWithoutColumns = createQueryFromHeaderlessExcel()>
<cffunction name="poiUtilityShouldBeAccessibleForAllTests" returntype="void" mxunit:dataprovider="ExcelQueryWithoutColumns">
	<cfargument name="myQuery">
	<cfset assertEquals("Column1,Column2,Column3",myQuery.ColumnList,"Without a header column, we expect the default derived column list that POIUtility will create")>
</cffunction>

<!--- CSV --->
<!--- the default case: a csv file with a header row; we want mxunit to convert it to a query and run our test once per row --->
<cfset simpleCSV = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/SimpleCSV.csv">
<cffunction name="dataProviderShouldRunCSVFileAsQuery" mxunit:dataprovider="simpleCSV">
	<cfargument name="myQuery">
	<cfset taxPercent = myQuery.TaxRate/100>
	<cfset assertEquals(myQuery.ExpectedResult, (myQuery.ItemCost*1) + (myQuery.ItemCost*taxPercent) )>
</cffunction>

<!--- 2nd preferred way of dealing with CSV files: no header row, and treat it as a 2D Array --->
<cffunction name="createArrayFromHeaderlessCSV" access="private">
	<cfscript>
	var headerlessCSV = getDirectoryFromPath(getCurrentTemplatePath()) & "/fixture/dataproviders/CSVWithoutHeaders.csv";
	var csvutil = createObject("component","mxunit.framework.CSVUtility");
	var csvResult =csvutil.readCSVToArray(filepath=headerlessCSV,hasheaderrow=false);
	return csvResult;
	</cfscript>
</cffunction>

<cfset CSVToArrayWithoutColumns = createArrayFromHeaderlessCSV()>
<!--- and this test uses that function above --->
<cffunction name="CSVToArray_Should_Create2DArrayForDataProvider" returntype="void" mxunit:dataprovider="CSVToArrayWithoutColumns">
	 <cfargument name="myArray" />
	<cfset taxPercent = myArray[1]/100>
	<cfset assertEquals(myArray[3], (myArray[2]*1) + (myArray[2]*taxPercent) )>
</cffunction>


 <cffunction name="methodPeep">
  <cfscript>
   method = createObject("java","coldfusion.runtime.UDFMethod");
   dump(method);
  </cfscript>
 </cffunction>



 <cffunction name="scopePeeping">
  <cfscript>
   scope1 = createObject("java","coldfusion.runtime.LocalScope");
   dump(scope1);
   scope = createObject("java","coldfusion.runtime.LocalScope").init();
   scope.setScopeType(0);
   scope.put('asd','123');
   scope.bind('asd');
   dump(scope);
  </cfscript>
 </cffunction>


 <cffunction name="threaLocalTest">
  <cfscript>
    var tl = createObject('java', 'java.lang.ThreadLocal').init();
    var m = createObject('java', 'coldfusion.runtime.UDFMethod');
    tl.set(cut.double);
    m = tl.get();
    dump(m);
    r = m(2);
    assertEquals(4,r);
    assertSame(m , cut.double);
  </cfscript>
 </cffunction>

 <!---
   This takes the name of a query in the local  scope.
   Not sure what's happening under the hood with q. q
   by itself appears to be empty, but q.colN returns expected
   data.
  --->
 <cffunction name="shouldIterateOverQueryAndExecCUTDouble" mxunit:dataprovider="q">
   <cfargument name="myQuery" />
   <cfscript>
     retVal = cut.double( myQuery.col1 );
     //i know, we're duplicating production code logic... that's OK. we're just testing the dataprovider stuff
     assertEquals(myQuery.col1*2,retVal);
    </cfscript>
 </cffunction>

 <cffunction name="invalidReferenceShouldThrowException"
             mxunit:expectedException="mxunit.exception.InvalidDataProviderReferenceException"
             mxunit:dataprovider="n">
   <cfargument name="myQuery" />
   <cfthrow type="mxunit.exception.InvalidDataProviderReferenceException" />
  </cffunction>

<cfscript>

  //see what we have to work with
  function peepQueryMD(){
    qmd = createObject('java' , q.getClass().getName());
 }



  function setUp(){
     cut = createObject('component' ,'mxunit.tests.framework.fixture.DataProviderFixture');
     q = getSomeData();
  }


</cfscript>

<cfset n = 'q' />

<!--- Just keep it in variables by default for testing --->
<cf_querysim>
q
col1,col2,col3,col4
1|1.2|1.3|1.4
2|2.2|2.3|2.4
3|3.2|3.3|3.4
</cf_querysim>



<cffunction name="getSomeData" access="private">
    <!--- Pass this name to TestSuite --->
  <cfset var q = '' />
	<cf_querysim>
		<cfoutput>
		q
		col1,col2,col3,col4
		1|1.2|1.3|1.4
		2|2.2|2.3|2.4
		3|3.2|3.3|3.4
		</cfoutput>
	</cf_querysim>
    <cfreturn q />
</cffunction>

</cfcomponent>