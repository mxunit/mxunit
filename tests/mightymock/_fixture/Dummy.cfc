<cfcomponent hint="simple empty component for creating a mock">
<cfscript>
this.bah = 'this.bah';
foo = 'bar';
variables.instance.bah = 'barbar';

 function bar(){
   return foo;
  }
</cfscript>
</cfcomponent>