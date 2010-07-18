<cfcomponent output="false" extends="BaseTest">
<cfscript>
 function setUp(){


     q = queryNew('id,type,method,args,invocationCount,returns,throws');
     queryAddRow(q,1);
     querySetCell(q, 'id','1');
     querySetCell(q, 'type','exact');
     querySetCell(q, 'method','foo');
     querySetCell(q, 'args', args);
     querySetCell(q, 'invocationCount', 0);
     querySetCell(q, 'returns', '{undefined}');
     querySetCell(q, 'throws', '{undefined}');

     sArgs = {1='{any}'};
     queryAddRow(q,1);
     querySetCell(q, 'id','2');
     querySetCell(q, 'type','pattern');
     querySetCell(q, 'method','foo');
     querySetCell(q, 'args', sArgs);
     querySetCell(q, 'invocationCount', 0);
     querySetCell(q, 'returns', '{undefined}');
     querySetCell(q, 'throws', '{undefined}');

     sArgs = {1='{string}',2='{numeric}'};
     queryAddRow(q,1);
     querySetCell(q, 'id','3');
     querySetCell(q, 'type','pattern');
     querySetCell(q, 'method','foo');
     querySetCell(q, 'args', sArgs);
     querySetCell(q, 'invocationCount', 0);
     querySetCell(q, 'returns', '{undefined}');
     querySetCell(q, 'throws', '{undefined}');
 }



 function createQueryFromJava(){
  q = createObject('java','coldfusion.sql.QueryTable');
  q.addColumn('asd');
  //debug(q);

 }


  function testCreateAndAlterQuery() {
     querySetCell(q, 'returns', 'foo',1);
    // debug(q);

  }

  function SearchQShouldReturnOnlyPatterns() {
     a = searchQ();
     debug(a);
     debug(a.currentRow);
  }





  function tearDown(){

  }


</cfscript>

<cffunction name="searchQ" access="private">
 <cfquery name="qq" dbtype="query">
  select * from q where type = 'pattern'
 </cfquery>
  <cfreturn qq />
</cffunction>

</cfcomponent>