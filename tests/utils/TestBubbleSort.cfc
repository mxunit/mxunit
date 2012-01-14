<cfcomponent  extends="mxunit.framework.TestCase">
	<cffunction name="setUp" returntype="void" access="public" output="false" hint="" >
		<cfscript>
			variables.BubbleSort = createObject("Component", "mxunit.utils.BubbleSort");
		</cfscript>
	</cffunction>

	<cffunction name="TestSortArrayOfStructsNumeric" returntype="void" access="public" output="true" hint="" >
		<cfscript>
			var myStruct1 = structNew();
			myStruct1.value = "apple";
			myStruct1.order="4";

			var myStruct2 = structNew();
			myStruct2.value="banana";
			myStruct2.order="6";

			var myStruct3 = structNew();
			myStruct3.value="grape";
			myStruct3.order="12";

			var myStruct4 = structNew();
			myStruct4.value="orange";
			myStruct4.order="35";

			var myStruct5 = structNew();
			myStruct5.value="pear";
			myStruct5.order="21";

			var myStruct6 = structNew();
			myStruct6.value="mango";
			myStruct6.order="5";

			var myArray = arrayNew(1);

			myArray[1] = myStruct1;
			myArray[2] = myStruct2;
			myArray[3] = myStruct3;
			myArray[4] = myStruct4;
			myArray[5] = myStruct5;
			myArray[6] = myStruct6;

			var actual = BubbleSort.SortArrayOfStructs(myArray,"order",true);

			var expected = arrayNew(1);
			expected[1] = myStruct1;
			expected[2] = myStruct6;
			expected[3] = myStruct2;
			expected[4] = myStruct3;
			expected[5] = myStruct5;
			expected[6] = myStruct4;

			assertEquals(actual,expected);
		</cfscript>
	</cffunction>
</cfcomponent>