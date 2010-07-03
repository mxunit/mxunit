<cfcomponent output="false">

  <cfscript>
  function double(param1){
    return param1 * 2;
  }

  function queryEcho(q) {
      return q.recordCount;
  }
  </cfscript>



<cf_querysim>
q
col1,col2,col3,col4
1|1.2|1.3|1.4
2|2.2|2.3|2.4
3|3.2|3.3|3.4
</cf_querysim>

</cfcomponent>