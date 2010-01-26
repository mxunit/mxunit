<cfcomponent extends="TestResult">

  <cfset testresult = "">
  <cfset jqgridRoot = "">

  <cffunction name="jqGridTestResult">
    <cfargument name="testResult" type="TestResult" required="true" />
    <cfargument name="jqgridroot" type="string" required="false" default="/mxunit/resources/jquery"/>
    <cfset var arg = "">
    <cfloop collection="#arguments#" item="arg">
      <cfset variables[arg] = arguments[arg]>
    </cfloop>
    <cfreturn this>
  </cffunction>

  <cffunction name="getHTMLResults" returntype="string" output="false">
    <cfargument name="DirectoryName" type="string" required="false"/>
    <cfset var strOutput = "">
    <cfset var headercontent = "">
    <cfset var results = testresult.getResults()>
    <cfset var i = "">
    <cfset var debugcontent = "">
    <cfset var UUID = createUUID()>

    <cfsavecontent variable="headercontent">
    <cfoutput>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.0/jquery.min.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"></script>
	<script type="text/javascript" src="http://jqueryui.com/themeroller/themeswitchertool/"></script>
    
	<script src="#jqgridRoot#/js/jquery.jqgrid.min.js"></script>
	<script type="text/javascript" src="#jqgridRoot#/vtip/vtip-min.js"></script>
    <link rel="stylesheet" type="text/css" href="#jqgridRoot#/vtip/css/vtip.css" />
    
	<link rel="stylesheet" type="text/css" media="screen" href="#jqgridRoot#/css/ui.jqgrid.css" />
	
    </cfoutput>
    </cfsavecontent>
    <cfhtmlhead text="#headercontent#">

    <cfsavecontent variable="strOutput">
    <script language="javascript">
    var a_output = new Array();
    <cfloop from="1" to="#ArrayLen(results)#" index="i">
      <cfoutput>a_output[#i#] = '#stripDump(results[i].content)#'; </cfoutput>
      <cfif ArrayLen(results[i].debug)>
        <cfsavecontent variable="debugcontent">
          <cfdump var="#results[i].debug#" label="Debug Output">
        </cfsavecontent>
        <cfoutput>a_output[#i#] = a_output[#i#] + '#stripDump(debugcontent)#';</cfoutput>
      </cfif>
    </cfloop>
	var allData = [
		<cfoutput>#resultsToJS(testresult.getResults())#</cfoutput>
	];
	
	var problemData = [
		<cfoutput>#resultsToJS(testresult.getResults(),true)#</cfoutput>
	];
	
	showOutput = function (row) {
		$("#<cfoutput>showOutput_#uuid#</cfoutput>")
		.empty()
		.html(a_output[row])
		.dialog("open");
	}
	function renderComponent(val){
      return "<span ext:qtip='"+val+"'>" + val + "</span>";
    }
    function renderResult(val){
      var newVal = val.toLowerCase();
      if(newVal.indexOf("error")>=0){
        return "<span class='error'>" + val + "</span>";
      }else if(newVal.indexOf("fail")>=0){
        return "<span class='failure'>" + val + "</span>";
      }
      return val;
    }
    function renderSpeed(val){
      if(val > 250){
        return "<span style='color:red;font-weight:bold' ext:qtip='This test is slow'>" + val + "</span>";
      }
      return val
    }
	jQuery(function($){
	$("#<cfoutput>showOutput_#uuid#</cfoutput>").dialog({
		autoOpen:false,
		width:800,
		title:'Test Output:'
	})
	$resultgrid = $('<' + 'table>')
		.appendTo('<cfoutput>##testresultsgrid_#UUID#</cfoutput>')
		.jqGrid({
			datatype: 'local',
			width:'900',
			colNames:['Component','Method','Result', 'Error Info', 'Speed (ms)','Output'],
			colModel:[
				{name:'cfc',width:300,index:'cfc',formatter:renderComponent},
				{name:'method',index:'method'},
				{name:'result',index:'result',formatter:renderResult},
				{name:'info',index:'info'},
				{name:'speed',index:'speed',align:'right',sorttype:'int',formatter:renderSpeed},
				{name:'output', width:300,index:'output', sortable:false}
			],
			caption: 'MXUnit Test Results'				
		});
	
	$.each(allData,function (i,val) {
		$resultgrid.jqGrid('addRowData',i+1,val);
	});
	$("#<cfoutput>showErrorsOnly_#uuid#</cfoutput>").click(function () {
		jQuery(".controls a").css('color','083772');
		jQuery(this).css('color','black');
		$resultgrid.clearGridData({clearfooter:true});
		$.each(problemData,function (i,val) {
			$resultgrid.jqGrid('addRowData',i+1,val);
		});
		return false;
	})
	$("#<cfoutput>showAllResults_#uuid#</cfoutput>").click(function () {
		jQuery(".controls a").css('color','blue');
		jQuery(this).css('color','black');
		$resultgrid.clearGridData({clearfooter:true});
		$.each(allData,function (i,val) {
			$resultgrid.jqGrid('addRowData',i+1,val);
		});
		return false;
	})
	$('#filter span').click(function(){
		var $this = $(this);
		var filterby = this.id.replace(/show-/,'');
		$this.siblings().removeClass('ui-state-active').end().addClass('ui-state-active');
		if (filterby=='All') filterby='';
		filterRows(filterby);
	}).hover(
		function(){$(this).addClass('ui-state-hover');}, 
		function(){$(this).removeClass('ui-state-hover');}
	);
	
	var filterRows = function(word){
		var $rows = $('tbody>tr', $resultgrid).show();
		if (word!='')
		{
			$rows
				.find('td:nth-child(3)')
				.not(':contains("'+word+'")')
				.parent()
				.hide();
		}
	};
});
    </script>

    <!--- begin body divs --->
    <cfoutput>
    <div id="modelink_#UUID#" class="modelink">
      (<a href="?#normalizeQueryString(URL,'html')#">view simple html</a>)
    </div>
    
	<script>
	$(function(){
        $('##switcher').themeswitcher({loadTheme:"Smoothness",initialText:'Loading ...'});

	});

	</script>

    <div align="center" id="header_#UUID#" class="header">
    <h1>Test Results</h1>

      <p>Failures: <span class="failure">#testresult.getFailures()#</span> Errors: <span class="error">#testresult.getErrors()#</span> Successes: <span class="success">#testresult.getSuccesses()#</span></p>

    </div>
	<div class="controls">
		<a href="" id="showAllResults_#uuid#">Show All Results</a>
		&nbsp;|&nbsp;
		<a href="" id="showErrorsOnly_#uuid#">Show Failures / Errors Only</a>
	</div>
    <div id="testresultsgrid_#UUID#" class="bodypad"></div>
	<div id="showOutput_#uuid#"></div>
	
	<div id="switcher"></div>
	
    </cfoutput>
    <!--- end body divs --->


    <cfdump var=" "><!--- need this to get the js and css in the page --->
    </cfsavecontent>

    <cfreturn strOutput>
  </cffunction>

  <cffunction name="resultsToJS" access="private" output="false">
    <cfargument name="results" type="array" required="true"/>
    <cfargument name="problemsOnly" type="boolean" required="false" default="false"/>
    <cfset var test = 1>
    <cfset var strJSON = "">
    <cfset var thisJSON = "">
	<cfset var thisResult = []>

    <cfloop from="1" to="#ArrayLen(ARGUMENTS.results)#" index="test">
	  <cfset thisResult = ARGUMENTS.results[test]>
      <cfif NOT problemsOnly OR (problemsOnly AND isProblem(thisResult))>
        <cfset thisJSON = "{'index':#test#,'cfc':'#thisResult.Component#','method':'#addMethodNameJS(thisResult)#','result':'#thisResult.TestStatus#','speed':#thisResult.Time#,'info':'#addErrorJS(thisResult.Error)#','output':'#addOutputLink(test,thisResult)#'}">
        <cfset strJSON = ListAppend(strJSON,thisJSON,",")>
      </cfif>
    </cfloop>
    <cfreturn strJSON>
  </cffunction>

  <cffunction name="isProblem" output="false" access="private" returntype="boolean" hint="">
    <cfargument name="result" type="struct" required="true"/>
    <cfif reFindNoCase("fail|error",result.TestStatus)>
      <cfreturn true>
    </cfif>
    <cfreturn false>
  </cffunction>

  <cffunction name="addMethodNameJS" output="false" access="private" returntype="string">
    <cfargument name="testStruct" required="true" type="struct">
    <cfset var link = "">
    <cfset var cu = createObject("component","ComponentUtils")>

    <cfset var fileURL = "/#replace(testStruct.Component,'.','/','all')#.cfc?testMethod=#testStruct.testname#">
    <cfset link = "<a href='#cu.getContextRootPath()##fileURL#&method=runTestRemote&output=jqgrid'>#testStruct.testname#</a>">

    <cfreturn jsStringFormat(link)>
  </cffunction>


  <cffunction name="addErrorJS" output="false" access="private" returntype="string">
    <cfargument name="error" type="any" required="true"/>
    <cfset var returnStr = "">
    <cfset var qtipTrace = "">
    <cfset var t = 1>
    <cfif isSimpleValue(error)>
      <cfreturn "">
    <cfelse>
      <cfset qtipTrace = "<b>#error.message#: #error.detail#</b><br><br>">
      <cfloop from="1" to="#ArrayLen(error.TagContext)#" index="t">
        <cfset qtipTrace = qtipTrace & "<li>" & "#error.TagContext[t].Template# : #error.TagContext[t].Line#" & "</li>">
      </cfloop>
      <cfset qtipTrace = "<ol>" & qtipTrace & "</ol>">
      <cfset returnStr = '<span style="font-weight:bold" ext:qtip="#qtipTrace#">#error.message#: #error.detail#</span>'>
    </cfif>
    <cfreturn jsStringFormat(returnStr)>
  </cffunction>

  <cffunction name="addOutputLink" access="private" returntype="string" output="false">
    <cfargument name="row" required="true">
    <cfargument name="testStruct" required="true">
    <cfset var newStr = "">
    <cfif len(trim(testStruct.content)) OR ArrayLen(testStruct.debug)>
      <cfset newStr = '<a href="javascript:showOutput(#row#)">View output</a>'>
    </cfif>
    <cfreturn newStr>
  </cffunction>

  <cffunction name="stripDump" output="false" returntype="string" access="private" hint="strips style and script tags from the cfdump output">
    <cfargument name="content" required="true">

    <cfset var returnStr = reReplaceNoCase(content,"<style>(.*)</script>","","one")>
	<cfset returnStr = reReplaceNoCase(returnStr,"<script>(.*)</script>","","one")>
    <cfset returnStr = trim(returnStr)>
    <cfset returnStr = reReplace(returnStr,"\s{1,}"," ", "all")>
    <cfreturn jsStringFormat(returnStr)>
  </cffunction>

</cfcomponent>