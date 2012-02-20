component extends="mxunit.framework.RemoteFacade" wsversion="1"{
	
	//kill the cache till adobe fixes their cache bug
	remote String function startTestRun(){
		return "";
	}
	
}