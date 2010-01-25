<cfcomponent extends="TestResult">

  <cfset testresult = "">
  <cfset extroot = "">
  <cfset cu = createObject("component","ComponentUtils")>

  

  <cffunction name="EXTTestResult">
    <cfargument name="testResult" type="TestResult" required="true" />
    <cfargument name="extroot" type="string" required="false" default="/mxunit/resources/ext2"/>
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
    <script src="#extroot#/adapter/ext/ext-base.js"></script>
    <script src="#extroot#/ext-all.js"></script>
    <link rel="stylesheet" type="text/css" href="#extroot#/resources/css/ext-all.css" />
    <style>
    .failure{font-weight:bold;color:darkblue;}
    .error{font-weight:bold;color:darkred;}
    .success{font-weight:bold;color:darkgreen;}
    .bodypad{padding-left:25px;padding-right:25px;;padding-top:10px;}
    .x-grid3-header-offset{width:auto;}
    .x-grid3-hd-inner{font-weight:bold;}
    .header{padding-bottom: 5px; font-family: Verdana;}
    h1{font-size: 1em; padding: 10px; color:darkblue; font-weight:bold;}
    .modelink{font-size: 10pt; font-family: Verdana; position:relative; padding: 10px;}

    </style>
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

    function showOutput(row){
      win = new Ext.Window(
        {
        autoScroll:true,
        modal:false,
        maximizable:true,
        title:"Debug Output",
        constrain:true,
        html:a_output[row]
        }
      );
      win.show();
    }


    Ext.onReady(function(){
	  contextRootPath = '<cfoutput>#cu.getContextRootPath()#</cfoutput>';
      Ext.BLANK_IMAGE_URL = "<cfoutput>#extroot#</cfoutput>/resources/images/default/s.gif";
      Ext.QuickTips.init();
      Ext.apply(Ext.QuickTips.getQuickTip(), {
          maxWidth: 500,
          minWidth: 100,
          showDelay: 100,
          trackMouse: true
      });

      var allData = [
         <cfoutput>#resultsToJS(testresult.getResults())#</cfoutput>
      ];

      var problemData = [
        <cfoutput>#resultsToJS(testresult.getResults(),true)#</cfoutput>
      ];

        var xg = Ext.grid;

        var reader = new Ext.data.ArrayReader({}, [
           {name: 'num', type: 'float'},
           {name: 'component'},
           {name: 'method'},
           {name: 'result'},
           {name: 'speed'},
           {name: 'errordetails'},
           {name: 'output'}
        ]);

      var ds = new Ext.data.GroupingStore(
        { reader: reader,
                data: allData,
                sortInfo:{field: 'method', direction: "ASC"},
                groupField:'component'
      });

      var view = new Ext.grid.GroupingView({
                forceFit:true,
                groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Tests" : "Test"]})',
                hideGroupedColumn:true
            });

      function toggleProblemView(btn, pressed){
        if(pressed){
          ds.loadData(problemData,false);
        }else{
          ds.loadData(allData,false);
        }
      }

      function toggleExpandCollapse(btn, pressed){
        if(pressed){
          view.collapseAllGroups();
        }else{
          view.expandAllGroups();
        }
      }

        var grid = new xg.GridPanel({
            store: ds,
        view: view,

            columns: [
                <!--- {id:'num',header: "No.", width: 15, sortable: true, dataIndex: 'num', hidden:true} ,  --->
                {header: "Component", width: 100, sortable: true, dataIndex: 'component', renderer:renderComponent},
                {header: "Method", width: 100, sortable: true, dataIndex: 'method', renderer: renderMethod},
                {header: "Result", width: 40, sortable: true, dataIndex: 'result', renderer: renderResult},
                {header: "Error Info", width: 100, sortable: false, dataIndex: 'errordetails'},
                {header: "Speed (ms)", width:30, sortable: true, dataIndex: 'speed', renderer: renderSpeed, align:'right'},
                {header: "Output", width: 40, sortable: false, dataIndex: 'output', align:'center'}
            ],

            frame:true,
            width: 'auto',
            autoHeight: 'true',
            maxHeight: 500,
            autoExpandColumn: 'errordetails',
            collapsible: true,
            animCollapse: true,
            title: 'Test Results: <cfoutput>#jsStringFormat(arguments.DirectoryName)#</cfoutput>',
            renderTo: "testresultsgrid_<cfoutput>#UUID#</cfoutput>",
            tbar: [
              {
              text:'Show Problems Only',
          enableToggle: true,
          pressed: false,
          toggleHandler: toggleProblemView,
          tooltip: "Show failures and errors only"
              },
              '-',
              {
              text: "Collapse All",
              enableToggle: true,
              pressed: false,
              toggleHandler: toggleExpandCollapse,
              tooltip: "Collapse or expand all"
              }
            ]
       });
    });

    function renderComponent(val){
	  //set this into the global scope... we'll use this in renderMethod()
	  pathAsURL = contextRootPath + "/" + val.replace(/\./g,'/') + ".cfc?method=runTestRemote";
      return "<span ext:qtip='"+val+"'><a href='" + pathAsURL + "'>" + val + "</a></span>";
    }
	
	function renderMethod(val){
	  methodAsURL = pathAsURL + "&testMethod=" + val;
      return "<a href='" + methodAsURL + "'>" + val + "</a>";
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

    </script>

    <!--- begin body divs --->
    <cfoutput>
    <div id="modelink_#UUID#" class="modelink">
      (<a href="?#normalizeQueryString(URL,'html')#">view in normal html mode</a>)
    </div>

    <div align="center" id="header_#UUID#" class="header">
    <h1>Test Results</h1>

      <p>Failures: <span class="failure">#testresult.getFailures()#</span> Errors: <span class="error">#testresult.getErrors()#</span> Successes: <span class="success">#testresult.getSuccesses()#</span></p>

    </div>

    <div id="testresultsgrid_#UUID#" class="bodypad"></div>
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

    <cfloop from="1" to="#ArrayLen(results)#" index="test">
      <cfif NOT problemsOnly OR (problemsOnly AND isProblem(results[test]))>
        <cfset thisJSON = "[#test#,'#results[test].Component#','#results[test].TestName#','#results[test].TestStatus#',#results[test].Time#,'#addErrorJS(results[test].Error)#','#addOutputLink(test,results[test])#']">
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