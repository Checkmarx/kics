package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "env" 
  checkSecret(resource) == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.ENV={{%s}}", [name, resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("'%s %s' doesn't exist", [resource.Cmd, resource.Value[0]]),
                "keyActualValue": 	sprintf("'%s %s' exists", [resource.Cmd, resource.Value[0]])
              }
}

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "label"
  checkSecret(resource) == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.LABEL={{%s}}", [name, resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("'%s %s' doesn't exist", [resource.Cmd, resource.Value[0]]),
                "keyActualValue": 	sprintf("'%s %s' exists", [resource.Cmd, resource.Value[0]])
              }
}


checkSecret(cmd) = true {

 secrets = [
    "passwd",
    "password",
    "pass",
    "admin_password",
    "secret",
    "key",
    "access",
    "api_secret",
    "api_key",
    "apikey",
    "token",
    "tkn"
    ]
    
  value := cmd.Value[_]
  contains(lower(value), secrets[_])

}