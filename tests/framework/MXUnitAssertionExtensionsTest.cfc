<cfcomponent generatedOn="12-04-2007 9:29:57 PM EST" extends="mxunit.framework.TestCase">

	<cffunction name="assertIsTypeOfPassesForCompleteAncestry" returntype="void" access="public">
		<cfscript>
			//itself
			assertIsTypeOf(this,"mxunit.tests.framework.MXUnitAssertionExtensionsTest");
			//immediate parent
			assertIsTypeOf(this,"mxunit.framework.TestCase");
			// grandparent
			assertIsTypeOf(this,"mxunit.framework.Assert");
			//last of the mohicans
			assertIsTypeOf(this,"WEB-INF.cftags.component");
		</cfscript>
	</cffunction>

	<cffunction name="assertIsTypeOfFailsForIncorrectType" returntype="void" access="public">
		<cfscript>
			//itself
			assertIsTypeOf(this.MXUnitAssertionExtensions,"mxunit.framework.MXUnitAssertionExtensions");
			assertIsTypeOf(this.MXUnitAssertionExtensions,"mxunit.framework.MXUnitAssertionExtensions");
			try{
				assertIsTypeOf(this.MXUnitAssertionExtensions,"mxunit.framework.TestCase");
			} catch(mxunit.exception.AssertionFailedError e){
				//no worries
			}
		</cfscript>
	</cffunction>

	<cffunction name="assertIsTypeOfFailsForBogusType" returntype="void" access="public">
		<cfscript>
			var webinf = createObject("component","WEB-INF.cftags.component");
			//guard - thanks Marc!
			assertIsTypeOf(webinf,"WEB-INF.cftags.component");
			try{
				assertIsTypeOf(webinf,"mxunit.bogus.cfc.package.I'm not here");
			} catch(mxunit.exception.AssertionFailedError e){

			}
		</cfscript>
	</cffunction>

	<cffunction name="assertIsExactTypePassesForExactType" output="false" access="public" returntype="any" hint="">
		<cfset var thisType = getMetadata(this).name>
		<cfset assertIsExactTypeOf(this,thisType)>
	</cffunction>

	<cffunction name="assertIsExactTypeOfFailsForSuperclass" output="false" access="public" returntype="any" hint="">
		<cftry>

			<cfset assertIsExactTypeOf(this,"any")>

			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset debug(cfcatch)>
			</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="testAssertIsEmptyStruct">

		<cfscript>
			var s = structNew();
			var actual = "";
			s.foo = "bar";
		</cfscript>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyStruct" returnVariable="actual">
				<cfinvokeargument name="struct" value="#s#" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

		<cfset StructClear(s)>
		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyStruct" returnVariable="actual">
			<cfinvokeargument name="struct" value="#s#" />
		</cfinvoke>

	</cffunction>

	<cffunction name="testAssertIsStruct">

		<cfset var actual = "" />

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsStruct" returnVariable="actual">

		<cfinvokeargument name="struct" value="#structNew()#" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsStruct" returnVariable="actual">
				<cfinvokeargument name="struct" value="a string and not a struct" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsEmpty">

		<cfset var actual = "" />

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmpty" returnVariable="actual">
			<cfinvokeargument name="o" value="" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmpty" returnVariable="actual">
				<cfinvokeargument name="o" value="asd" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsDefined">

		<cfset var actual = "" />

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsDefined" returnVariable="actual">
			<cfinvokeargument name="o" value="url" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsDefined" returnVariable="actual">
				<cfinvokeargument name="o" value="zxcasdqweoiuqweoiquweqiowueqwieuqwjekjbq" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsArray">

		<cfset var a = arrayNew(1) />
		<cfset var actual = "" />
		<cfset a[1] = 1 />

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsArray" returnVariable="actual">
			<cfinvokeargument name="a" value="#a#" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsArray" returnVariable="actual">
				<cfinvokeargument name="a" value="a string not an array" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsEmptyArray">

		<cfset var a = arrayNew(1) />
		<cfset var a2 = arrayNew(1) />
		<cfset var actual = "" />
		<cfset a[1] = "" />

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyArray" returnVariable="actual">
			<cfinvokeargument name="a" value="#a2#" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyArray" returnVariable="actual">
				<cfinvokeargument name="a" value="#a#" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset debug(cfcatch)>
			</cfcatch>
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsTypeOf">

		<cfset var actual = "" />

		<!---Tests if THIS is the correct type (mxunit.tests.framework.MXUnitAssertionExtensionsTest) --->

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsTypeOf" returnVariable="actual">
			<cfinvokeargument name="o" value="#this#" />
			<cfinvokeargument name="type" value="mxunit.tests.framework.MXUnitAssertionExtensionsTest" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsTypeOf" returnVariable="actual">
				<cfinvokeargument name="o" value="#this#" />
				<cfinvokeargument name="type" value="some.bogus.ass.component.name.that.should.fail.no.matter.what" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset debug(cfcatch)>
			</cfcatch>
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsQuery">

		<cfscript>
			var q = queryNew("foo");
			var actual = "";
			queryAddRow(q,1);
			querySetCell(q, "foo","bar");
		</cfscript>

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsQuery" returnVariable="actual">
			<cfinvokeargument name="q" value="#q#" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsQuery" returnVariable="actual">
				<cfinvokeargument name="q" value="foo" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="testAssertIsEmptyQuery">
		<cfscript>
			var q2 = queryNew("foo");
			var q = queryNew("foo");
			var actual = "";
			queryAddRow(q,1);
			querySetCell(q, "foo","bar");
		</cfscript>

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyQuery" returnVariable="actual">
			<cfinvokeargument name="q" value="#q2#" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsEmptyQuery" returnVariable="actual">
				<cfinvokeargument name="q" value="#q#" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset debug(cfcatch)>
			</cfcatch>
			<!--- no worries. we want this to fail --->
		</cftry>
	</cffunction>

	<cffunction name="testAssertIsXMLDoc">

		<cfscript>
			var xml1 = xmlNew();
			var actual = "";
		</cfscript>

		<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsXMLDoc" returnVariable="actual">
			<cfinvokeargument name="xml" value="#xml1#" />
			<cfinvokeargument name="message" value="This is not an XML Dom Object" />
		</cfinvoke>

		<cftry>

			<cfinvoke component="#this.MXUnitAssertionExtensions#"  method="assertIsXMLDoc" returnVariable="actual">
				<cfinvokeargument name="xml" value="a string is not XML and should fail" />
				<cfinvokeargument name="message" value="This is not an XML Dom Object" />
			</cfinvoke>

			<cfcatch type="mxunit.exception.AssertionFailedError" />
			<!--- no worries. we want this to fail --->
		</cftry>

	</cffunction>

	<cffunction name="assertIsTypeOfPassesForInterfaces" returntype="void">

		<cfset var component = createObject("component","fixture.interfaces.AComponent")>

		<cfset assertIsTypeOf( component, "mxunit.tests.framework.fixture.interfaces.AnInterface" )>
		<cfset assertIsTypeOf( component, "mxunit.tests.framework.fixture.interfaces.OtherInterface" )>
		<cfset assertIsTypeOf( component, "mxunit.tests.framework.fixture.interfaces.SubInterface" )>

	</cffunction>

	<cffunction name="testAssertEqualsWithTolerance">
		<!--- should pass all the same tests as testAssertEqualsNumbers with a tolerance of zero --->
		<cfset assertEqualsWithTolerance(1,1,0,"boo") />
		<cfset assertEqualsWithTolerance(1.0,1,0) />
		<cfset assertEqualsWithTolerance(1000000000000.0,1000000000000,0) />
		<cfset assertEqualsWithTolerance(-5,-5.0,0) />
		<cfset assertEqualsWithTolerance(-100.222,-100.222,0) />
		<cfset assertEqualsWithTolerance("1",1,0) />
		<cfset assertEqualsWithTolerance(2,"2",0) />
		<cfset assertEqualsWithTolerance("2.222",2.222,0) />

		<cfset assertEqualsWithTolerance(1/3,1/3+1-1,0.01) />

		<cftry>

			<cfset assertEqualsWithTolerance(1/3,1/3+1-1,0.00000000000000005) />

			<cfthrow type="failure" message="this code should never be reached.">

			<cfcatch type="mxunit.exception.AssertionFailedError">
				<cfset assertTrue(true) />
			</cfcatch>
			<cfcatch type="failure">
				<cfset fail("testAssertEqualsWithTolerance should have failed when tolerance was really small.") >
			</cfcatch>
		</cftry>
	</cffunction>

	<!--- Override these methods as needed. Note that the call to setUp() is Required if using a this-scoped instance--->

	<cffunction name="setUp">
		<!--- Assumption: Instantiate an instance of the component we want to test --->
		<cfset this.MXUnitAssertionExtensions = createObject("component","mxunit.framework.MXUnitAssertionExtensions") />
		<!--- Add additional set up code here--->
	</cffunction>

	<cffunction name="tearDown">
	</cffunction>

</cfcomponent>
