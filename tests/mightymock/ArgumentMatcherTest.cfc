<cfcomponent output="false" extends="BaseTest">


<cffunction name="mismatchedArgumentTypesShouldFail" >
 <cfscript>

  var literal = { foo='bar', bar=321654};
  var pattern = { foo='{string}', bar='{numeric}'};
  assert( matcher.match(literal,pattern) );
  //To Do:normalize args!
  debug('To Do: normalize arguments');
  </cfscript>
</cffunction>

<cfscript>

function setUp(){
 matcher = createObject('component','mxunit.framework.mightymock.ArgumentMatcher');
}

function patternContainsStar(){

  var pattern = {1={1='{*}'}};
  ret = matcher.patternContainsWildCard( pattern,'{*}' );
  assert( ret) ;

}

function patternContainsPlus(){
  var pattern = {1={1='{+}'}};
  ret = matcher.patternContainsWildCard( pattern,'{+}' );
  assert( ret) ;
}

function wildCardSmokeTest(){
  var actual = false;
  var incomming = { 1='asd'};
  var existing = { 1='{+}'};
  actual = matcher.match(incomming,existing) ;
  assert(actual,'did not match {*}');

}

function anyShouldMatchAllTypes(){
   var dumb = createObject('component' ,dummy);
   var actual = false;
   var literal = { 1='bar', 2=321654};
   var pattern = { 1='{any}', 2='{any}'};

   literal = { 1='bar', 2=dumb};
   pattern = { 1='{any}', 2='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   s = {1=1};
   literal = { 1='bar', 2=s};
   pattern = { 1='{any}', 2='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=a};
   pattern = { 1='{any}', 2='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=q};
   pattern = { 1='{any}', 2='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this};
   pattern = { 1='{any}', 2='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this, 3=s, 4=a, 5='barbarmcfate'};
   pattern = { 1='{any}', 2='{any}', 3='{any}', 4='{any}', 5='{any}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');
 }

function anyWildCardShouldWork(){
  var literal = { foo='bar', bar=321654};
  var pattern = { foo='{any}', bar='{any}'};
  actual = matcher.match(literal, pattern);
  assert(actual,'did not match #pattern.toString()#');
}

function compareStructKeys() {
  var literal = { foo='bar', bar=321654};
  var pattern = { fOo='{string}', baR='{numeric}'};
  var literalKeys = structKeyArray(literal);
  var patternKeys = structKeyArray(pattern);
  debug(literalKeys );
  debug(patternKeys);
  debug(literalKeys.toString() == patternKeys.toString());
  assertEquals(literalKeys , patternKeys);

}

function dualNamedAndOrderedArgsShouldBeAllowed() {
  var literal1 = { foo='bar', bar=321654};
  var pattern1 = { foo='{string}', bar='{numeric}'};
  var literal2 = { 1='bar', 2=321654};
  var pattern2 = { 1='{string}', 2='{numeric}'};

  actual = matcher.match(literal1,pattern1) ;
  assert(actual,'did not match #pattern1.toString()#');

  actual = matcher.match(literal2,pattern2) ;
  assert(actual,'did not match #pattern2.toString()#');

}

function namedArgumentPatternTest() {
  var literal = { foo='bar', bar=321654};
  var pattern = { foo='{string}', bar='{numeric}'};
  actual = matcher.match(literal,pattern) ;
  assert(actual,'did not match #pattern.toString()#');
}


function findByPatternTestWithNamedArgs(){
  var actual = false;
  var incomming = { foo='bar', bar=321654};
  var existing = { 1='{*}'};
  actual = matcher.match(incomming,existing) ;
  assert(actual,'did not match {*}');

  existing = { 1='{+}'};
  actual = matcher.match(incomming,existing) ;
  assert(actual,'did not match {+}');

  incomming = { 1='bar', 2=321654};
  actual = matcher.match(incomming,existing) ;
  assert(actual,'did not match {+}');
}


function matchLiteralToPatterns(){
   var actual = false;
   var literal = { 1='bar', 2=321654};
   var pattern = { 1='{string}', 2='{numeric}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   s = {1=1};
   literal = { 1='bar', 2=s};
   pattern = { 1='{string}', 2='{struct}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=a};
   pattern = { 1='{string}', 2='{array}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=q};
   pattern = { 1='{string}', 2='{query}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this};
   pattern = { 1='{string}', 2='{object}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

   literal = { 1='bar', 2=this, 3=s, 4=a, 5='barbarmcfate'};
   pattern = { 1='{string}', 2='{object}', 3='{struct}', 4='{array}', 5='{string}'};
   actual = matcher.match(literal,pattern) ;
   assert(actual,'did not match #pattern.toString()#');

}



function argumentMatcherPassesWithWildCards(){
   var actual = false;
   var incomming = { 1='bar', 2=321654};
   var existing = { 1='{*}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual,'did not match {*}');

   existing = { 1='{+}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual,'did not match {+}');
}



function argumentMatcherShouldFailWithUnMatchedNumberOfArgs(){
  var incomming = {1=1,2=2,3=3};
  var existing = {1=1,2=2,3=3,4=4};
  try{
   assert( matcher.match(incomming,existing) );
   fail('should not get here');
  }
  catch(MismatchedArgumentNumberException e){

  }
}

function $matchOrderedArgsShouldWork(){
   var actual = false;
   var incomming = { 1='bar', 2=321654};
   var existing = { 1='{string}', 2='{numeric}'};
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming,3,'asd');
   structInsert(existing, 3,'{string}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 'arbitrary' ,'asd');
   structInsert(existing, 'arbitrary','{string}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 4, a);
   structInsert(existing, 4 ,'{array}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 5, args);
   structInsert(existing, 5 ,'{struct}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 6, sys);
   structInsert(existing, 6 ,'{object}');
   actual = matcher.match(incomming,existing) ;
   assert(actual);

   structInsert(incomming, 7, q);
   structInsert(existing, 7 ,'{query}');

   //debug( matcher.type( incomming['7'] ) );

   actual = matcher.match(incomming,existing) ;

   debug(incomming);
   debug(existing);
   assert(actual);

}

</cfscript>
</cfcomponent>