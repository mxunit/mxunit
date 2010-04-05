<cfcomponent output="false">
	<cfscript>
    aSimpleVar = 'simple var';
    this.bar = 'bar';
	  collaborator = '';

    helper = createObject('component','Helper');


   function invokeHelper(){
    return helper.helpMe();
   }

   function getInjectedSpyVar(){
     return MYSPYVAR;
   }

	function setCollaborator(col){
	  collaborator = col;
	}

	function dependOnSomething(message){
	  return collaborator.echo(foo());
	}

	function dependOnSomethingWithInstanceData(){
	  return collaborator.getMyVar();
	}

	function dependOnSomethingElse(message){
	  return collaborator.add(1,2);
	}


  function dependOnParams(a){
   return collaborator.echo('asd');
  }

	function getSomeStuff(){
	 return 'stuff';
	}

	</cfscript>
	<cffunction access="private" name="foo">
	 <cfreturn 'bar'>
	</cffunction>

</cfcomponent>