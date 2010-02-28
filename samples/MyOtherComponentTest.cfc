<!---
 MXUnit TestCase Template
 @author
 @description
 @history
 --->

<cfcomponent displayname="mxunit.framework.MyComponentTest"  extends="mxunit.framework.TestCase">

<!--- Begin Specific Test Cases --->
	<cffunction name="testAdd4" access="public" returntype="void">
	<cfscript>
   var num = this.mycomp.add(100,100);
   addTrace("num == " & num );
   assertEquals(num,200);
  </cfscript>

	</cffunction>


	<cffunction name="testAdd2" access="public" returntype="void">
	<cfscript>
   var num = this.mycomp.add(0,-0);
   addTrace("num == " & num );
   assertEquals(num,0);
  </cfscript>
	</cffunction>

	<cffunction name="aTestFunctionThatDoesNotBeginWithTest" access="public" returntype="void">
	<cfscript>
   var a1 = arrayNew(1);
   var a2 = arrayNew(1);
   a1[1] = 'foo';
   a2[1] = 'foo';
   assertEquals(a1,a2);
  </cfscript>
	</cffunction>

  	<cffunction name="anotherTestFunctionThatDoesNotBeginWithTest" access="public" returntype="void">
	<cfscript>
   var a1 = arrayNew(1);
   var a2 = arrayNew(1);
   a1[1] = 'foo';
   a2[1] = 'foo';
   assertEquals(a1,a2);
  </cfscript>
	</cffunction>
<!--- End Specific Test Cases --->


	<cffunction name="setUp" access="public" returntype="void">
	<!---   <cfset super.TestCase(this) /> --->
	  <!--- Place additional setUp and initialization code here --->
		<cfscript>
		 this.mycomp = createObject("component" ,"MyComponent");

		</cfscript>
	</cffunction>

	<cffunction name="tearDown" access="public" returntype="void">
	 <!--- Place tearDown/clean up code here --->
	</cffunction>


</cfcomponent>
