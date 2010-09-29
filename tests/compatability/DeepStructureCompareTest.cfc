<cfcomponent  extends="mxunit.tests.framework.AssertTest">

	<cfscript>
		function testThatAssertEqualsStructWorks(){
		  assertNotSame(s1,s2,"Should not be the same structs");
		  assertEquals(s1,s2);
		}
		
		/*
		@BeforeTest/@AfterTest
		*/
		
		 function setUp(){
		 	super.setUp();
		 	
		 	s1 = structNew();
		 	s2 = structNew();
		
		 	a1 = arrayNew(1);
		 	a2 = arrayNew(1);
		
		   str1 = "asd asdiakjo ioaus d98a7s daiushd asd89ya s98daioushd 89aysd 98ahsd98ah98shd a9hs98d asd";
		   str2 = "as234diakjo i234aiushd asd89ya s98daiou)($*+_+_:L98ahsd98ah98shd a9hs98d asdfghfgh fgh fgh fgh fgherty e";
		
		   int1 = 123871923123;
		   int2 = -127361823;
		
		 	myComponent1 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
		   myComponent2 = createObject("component","mxunit.tests.framework.fixture.NewCFComponent");
		   //below implement consistent stringValue()
		   myComponent3 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
		   myComponent4 = createObject("component","mxunit.tests.framework.fixture.ComparatorTestData");
		
		   a[1] = myComponent1;
		   a[2] = myComponent2;
		   a[3] = myComponent3;
		   a[4] = myComponent4;
		
		   s1.key1 = str1;
		   s2.key1 = str1;
		
		   s1.key2 = str2;
		   s2.key2 = str2;
		
		   s1.key3 = a;
		   s2.key3 = a;
		
		
		
		 }
		
		function  tearDown(){ }
		
		 
	</cfscript>
 
	<cffunction name="getFiles" access="private">
		<cfargument name="d" />
		<cfdirectory action="list" directory="#arguments.d#" name="dir" />
		<cfreturn dir />
	</cffunction>


</cfcomponent>
