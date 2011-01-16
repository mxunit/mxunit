
<cfscript>
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*
*  CF9/ColdDoc script for generating static html MXUnit api docs.
*  ColdDoc is by Mark Mandel and is included in this MXUnit distribtion.
*
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

import mxunit.framework.Assert;
import colddoc.*;
import colddoc.strategy.api.*;


mxunit = new Assert();
out = getPageContext().getOut();
pathBase = '../';
context = getDirectoryFromPath(expandPath(pathBase));
fileSep = createObject('java','java.lang.System').getProperty('file.separator');

//sanity check (guard condition)
//mxunit.assert( ls( context & 'doc/api', '*.html').recordCount > 0, 'Ruh-roh, Raggy. Should be something in ./api! WTF?');


//Info to print in the docs
version = getVersion();
title = 'MXUnit ' & version;
destination = expandPath('./api');

//these are the packages we want to send to ColdDoc
packages = [
    {'inputDir'= expandpath('../framework'), 'inputMapping'='mxunit.framework'},
    {'inputDir'= expandpath('../runner'), 'inputMapping'='mxunit.runner'}
    // printing the tests in the API seems noisy.
    // {'inputDir'='expandpath('../tests')', 'inputMapping'='mxunit.tests'}
];


//clean
each({
    dir=context & 'doc/api',
    recurse=true,
    filter='*.html',
	apply=rm
  });

generateDocs( packages, destination, title );

/* just print some shit ... */
	out.println( '<title>MXUnit API DocGen</h1>' );
	out.println( '<h1>MXUnit #version# API Docs Generated!</h1>' );
	out.println( '<a href="api/index.html">Documentation</a>' );
/*finished '*/



/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*
*  Utility functions
*
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

function rm(fileInfo){
 fileDelete(fileInfo[7] & '/' & fileInfo[1]);
  //writeoutput(fileInfo[7] & '/' & fileInfo[1] & '<br/>');
}



function generateDocs(array docMappings, string destination, string title){
	var colddoc = new ColdDoc();
	var strategy = new HTMLAPIStrategy(destination, title);
	colddoc.setStrategy(strategy);
	colddoc.generate(docMappings);
}


function getVersion(){
	 var fileStream = createObject('java', 'java.io.FileInputStream');
	 var resourceBundle = createObject('java', 'java.util.PropertyResourceBundle');
	 fileStream.init(context & 'buildprops/version.properties');
	 resourceBundle.init(fileStream);
	 var version = resourceBundle.handleGetObject('build.major') & '.';
	 version = version & resourceBundle.handleGetObject('build.minor') & '.';
	 version = version & resourceBundle.handleGetObject('build.buildnum');
	 fileStream.close();
	 return version;
 }


function each(struct properties){
  //set defaults
  var dir = ( structKeyexists(properties,'dir') )? properties.dir : _throw('''each'' needs a directory') ;
  var apply = ( structKeyexists(properties,'apply') )? properties.apply : _throw('Yo, gimme d''func to <em>apply</em> to <em>each</em> file.') ;
  var filter = ( structKeyexists(properties,'filter') )? properties.filter : '*' ;
  var recurse = ( structKeyexists(properties,'recurse') )? properties.recurse : true ;
  var type = ( structKeyexists(properties,'type') )? properties.type : 'file' ;
  var files = '';
  var file = 0;

  files = ls( dir, filter, recurse, type );

  for(file=0; file < files.recordCount; file++){
    // apply for each file, which is a row, but we can get an array of objects
    // that specify the properties in cfdirectory:name,dir,dlm,mode,size, etc.
    apply( files.getRow(file).getRowData() );
  }
} //end each()


</cfscript>

<cffunction name="ls">
  	<cfargument name="dir" type="string" required="true" />
	<cfargument name="filter" required="false" default="*" />
	<cfargument name="recurse" required="false" default="true" />
	<cfargument name="type"  required="false" default="file" />
  <cfdirectory 	action="list"
				directory="#arguments.dir#"
				filter="#arguments.filter#"
				recurse="#arguments.recurse#"
				type="#arguments.type#"
				name="dir_list" />
  <cfreturn dir_list>
</cffunction>

<cffunction name="dump">
 <cfdump var="#arguments#" />
</cffunction>

<cffunction name="_throw">
 <cfthrow message="#arguments[1]#"  />
 <cfreturn />
</cffunction>
