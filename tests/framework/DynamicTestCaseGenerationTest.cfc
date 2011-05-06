<cfscript>

component extends="mxunit.framework.TestCase" {

a = [1,2,3,4];



function setUp(){
	
}




/**
  * @dataprovider a
  */
 function testThis(a){
  debug(a);
}


}

</cfscript>


