<cfcomponent output="false">
  <cfscript>
  theCollaborator = createObject('component','TheCollaborator');

  function init(){
   return this;
  }


  function setCollaborator(collaborator){
   theCollaborator = collaborator;
  }

  function callLoggerALot(){
   var i = 1;
   var arbitrary = 0;
   for(i; i <= 25; i++){
     arbitrary = hash(i);
     theCollaborator.logStuff();
   }
  }

  function getUserAsStruct(id){
   var temp = theCollaborator.getUser(id);
   var user = {};
   user['id'] = temp.id;
   user['name'] = temp.name;
   user['email'] = temp.email;
   return user;
  }

  </cfscript>

</cfcomponent>