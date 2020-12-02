package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource[j]
  resource.Cmd == "env" 
  checkSecret(resource) == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("ENV=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Dockerfile doesn't contain secrets",
                "keyActualValue": 	"Dockerfile contains secrets"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource[j]
  resource.Cmd == "label"
  checkSecret(resource) == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("LABEL=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Dockerfile doesn't contain secrets",
                "keyActualValue": 	"Dockerfile contains secrets"
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