01-25-08  Using Ant with MXUnit.

Source is available here: http://mxunit.googlecode.com/svn/org.mxunit.ant/

Overview:
Used best for running groups of tests, test suites, and directories of
tests. Writes test results in XML, JUnitXML, or HTML to a specified
location. This is particularly useful for generating JUnit style
reports, using Ant's <junitreport ...> task.

This handles BASIC as well as NTML authentication as well as SSL.

This assumes a basic knowledge of Ant.

---------------------------- To Do --------------------------------
You can also use this Ant task to invoke testcases and arbitrary cf
components using the TCP/IP gateway in the CF server instead of the
default HTTP GET method. This has significant performance benefits and
does not use a CF http thread. However, there needs to be some minor
gateway configuration performed on the CF server _and_ your CF server
needs to support TCP/IP gateways. See the CF product comparison charts
at adobe.com for information on which versions support gateways and to
what extent.

Dependencies: This assumes you have Ant installed. If not, please
download the latest version from http://ant.apache.org/.

The stylesheets in this package are the same as those in JUnit. Just a
few slight modifications/branding were made.

Usage: See sample-build.xml for usage.

Examples:


Enjoy ...




















