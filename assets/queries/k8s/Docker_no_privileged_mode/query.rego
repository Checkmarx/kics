package Cx

CxPolicy [ result ] {
   
  resource := input.document[i].services[serviceName]
  
  not resource.privileged

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("services[%s].privileged", [serviceName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("services[%s].privileged is defined", [serviceName]),
                "keyActualValue": 	sprintf("services[%s].privileged is undefined", [serviceName])
            }
}

