component extends="mxunit.framework.TestCase" {

	/**
	* @mxunit:expectedException MyCustomException
	*/
	function thisShouldFail_BecauseExpectedExceptionIsNotThrown(){
		throw("hi mom!", "SomeOtherKindOfException");
	}

	/**
	* @mxunit:expectedException MyCustomException
	*/
	function thisShouldPass_BecauseExpectedExceptionIsThrown(){
		throw("hi mom!", "MyCustomException");
	}

	/**
	* @mxunit:expectedException MyCustom.Exception
	*/
	function thisShouldPass_BecauseExpectedExceptionIsThrown2(){
		throw("hi mom!", "MyCustom.Exception");
	}
}