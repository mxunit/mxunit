
1) open <eclipse_home>/plugins/org.cfeclipse.cfml_<version>/dictionary/
2) copy mxunit.xml into that directory
3) open dictionaryconfig.xml
4) underneath the "<grammar location="user.xml"/>" lines, add:

<grammar location="mxunit.xml"/>

5) restart eclipse

Then, inside any test cases, typing the function names for public and package functions from TestCase and the Assert* cfcs will pop up function support. For example, type "assertEquals("

and the argument popups will appear.