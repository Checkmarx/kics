package Cx

CxPolicy [ result ] {
   
  resource := input.document[i].services[serviceName]
  
  not resource.security_opt

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("services[%s].security_opt", [serviceName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("services[%s].security_opt is defined", [serviceName]),
                "keyActualValue": 	sprintf("services[%s].security_opt is undefined", [serviceName])
            }
}

