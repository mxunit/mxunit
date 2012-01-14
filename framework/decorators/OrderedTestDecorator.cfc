<cfcomponent extends="mxunit.framework.TestDecorator" output="false" hint="Orders tests by an attribute">

	<cffunction name="getRunnableMethods" output="false" access="public" returntype="any" hint="">
    	<cfscript>
    		var methods = getTarget().getRunnableMethods();
    		var i = 1; 
    		var order = 0;
    		var tests = [];
    		var test = "";
    		var BubbleSort = createObject("Component","mxunit.utils.BubbleSort");
    		var sortedTests = [];
    		var returnArray = [];

    		for(i = 1; i LTE arrayLen(methods); i++){
    			test = {};
    			test.order = getAnnotation(methods[i],"order");
    			test.name = methods[i];

    			arrayAppend(tests,test);
    		}

    		sortedTests = BubbleSort.sortArrayOfStructs(tests,"order",true);

    		for(i = 1; i LTE arrayLen(sortedTests); i = i + 1){
    			arrayAppend(returnArray,sortedTests[i].name);
    		}
    	
    		return returnArray;
    	</cfscript>
    </cffunction>

</cfcomponent>