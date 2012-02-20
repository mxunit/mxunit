<cfscript>

	test = new AboutSpecsTest();

	specs = test.getSpecs();


	writeDump( test.getRunnableMethods() );
	
	writeDump( test.getSpecs() );

	/*for( spec in test.getRunnableMethods() ){
		test.executeSpec( spec );
	}*/

	//writeDump(test.getIts());

</cfscript>
