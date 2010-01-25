*************
WHAT
*************
These tests are designed to showcase the mxunit plugin. 
Many of them fail or error in order to demonstrate that behavior. 
One of them, InvalidMarkupTest.cfc, is a bad file and as such 
will generate an eclipse Error prompt when you load the component. 
This is expected and designed to show you what happens when 
you try to run a test that contains invalid CFML.

*************
INSTALLING THE PLUGIN
*************
In Eclipse:

1) Help -- Software Updates -- Find and Install
2) Select the "Search for new features" radio button. Click Next
3) click the "New Remote Site" button. Add the url "http://mxunit.org/update". give it any name.
4) Click through. It'll download the plugin and install it. It will prompt you to restart eclipse.
5) When eclipse is installed, the MXUnit view will be available in Window -- Show View -- Other -- MXUnit


*************
HOW TO RUN
*************
1) Open the MXUnit View
2) Click the "Search" icon (or hit CTRL-F)
3) type "PluginDemoTests". Click OK
4) It'll take a few seconds to start up if this is the first time running the
tests. 
	a) You'll then get an eclipse Error. This is expected, 
because InvalidMarkupTest.cfc is a bad file.
	b) Click OK on the error message.
	c) Each of the test cases in the entire directory of tests will load
	 into the tree. It does not run the tests.
5) Click the green "Play" button (or hit Enter)
6) The tests will run. 
7) To see any output from the tests, right click in the tree and select 
"Open test case results in browser". or hit "F8". or hit "b".
8) To run all tests again, hit the green play arrow
9) To run just the failures, hit the red play arrow
10) To clear all results, click the "refresh" icon or hit "F5"

