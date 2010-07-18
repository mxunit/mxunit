/**
 * @author bill
 * 
 * This Rhino/JS script invokes doc/build.cfm which generates static html api stuff. 
 * The anonymous function  below is not really necessary, but illustrates
 * how you can structure logic to support Ant tasks. It's also nice to develop OO
 * constructs, iterators, and exception handling.
 * 
 */
importPackage(java.net,java.io);

(function(){
	var inputLine, url;

	print( 'Generating MXUnit API docs.' );
	url = new URL('http://' +  project.getProperty('server') + ':' + project.getProperty('port') + '/mxunit/doc/build.cfm');
	input = new BufferedReader( new InputStreamReader(url.openStream()) );

	while ((inputLine = input.readLine()) != null)
	    print(inputLine);
	input.close();
	
})();

