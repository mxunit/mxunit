<cfcomponent  extends="mxunit.framework.TestCase">
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.BubbleSort = createObject("Component", "mxunit.utils.BubbleSort");
		</cfscript>
	</cffunction>

	<cffunction name="TestSortArrayOfStructsNumeric" returntype="void" access="public" output="true" hint="" >
		<cfscript>
			var myStruct1 = {value="apple",order="4"};
			var myStruct2 = {value="banana",order="6"};
			var myStruct3 = {value="grape",order="12"};
			var myStruct4 = {value="orange",order="35"};
			var myStruct5 = {value="pear",order="21"};
			var myStruct6 = {value="mango",order="5"};

			var myArray = [myStruct1,myStruct2,myStruct3,myStruct4,myStruct5,myStruct6];

			var actual = BubbleSort.SortArrayOfStructs(myArray,"order",true);

			var expected = [myStruct1,myStruct6,myStruct2,myStruct3,myStruct5,myStruct4];

			assertEquals(actual,expected);
		</cfscript>
	</cffunction>
</cfcomponent>