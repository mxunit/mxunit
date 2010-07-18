<cfcomponent output="false" extends="BaseTest">
<cfscript>
matcher = createObject('component','mxunit.framework.mightymock.ArgumentMatcher');


function testType(){
  type = matcher.getArgumentType( 123 );
  assertEquals('{numeric}', type , 'numeric failue');

  type = matcher.getArgumentType( now() );
  assertEquals('{date}', type , 'date failue');

  type = matcher.getArgumentType(testType);
  assertEquals('{udf}', type, 'udf failue');

  type = matcher.getArgumentType( args );
  assertEquals('{struct}', type, 'struct failue');

  type = matcher.getArgumentType( a );
  assertEquals('{array}', type, 'array failue');

  type = matcher.getArgumentType( q );
  assertEquals('{query}', type, 'query failue');

  type = matcher.getArgumentType( x );
  assertEquals('{xml}', type, 'xml failue');

  type = matcher.getArgumentType(true);
  assertEquals('{boolean}', type, 'bool failue');

  type = matcher.getArgumentType(this);
  assertEquals('{object}', type, 'cfc object failue');

  type = matcher.getArgumentType(sys);
  assertEquals('{object}', type, 'java object failue');


 assert (isBinary(toBinary(toBase64(mname))) , 'should be true');
/*
  type = matcher.getArgumentType( toBinary( toBase64(mname)) );
  assertEquals('{binary}', type, 'binary failue');
*/
}


</cfscript>
</cfcomponent>