package Cx

CxPolicy [ result ] {
   
  resource := input.document[i].services[serviceName]
  
  not CheckAdd(resource)

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("services[%s]", [serviceName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("services[%s].cap_add is defined", [serviceName]),
                "keyActualValue": 	sprintf("services[%s].cap_add is undefined", [serviceName])
            }
}

CxPolicy [ result ] {
   
  resource := input.document[i].services[serviceName]
  
  not CheckDrop(resource)

  result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("services[%s]", [serviceName]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("services[%s].cap_drop is defined or Allow use of RAW and PACKET sockets.", [serviceName]),
                "keyActualValue": 	sprintf("services[%s].cap_drop is undefined", [serviceName])
            }
}

CheckAdd(resource){
	resource.cap_add != null
}

CheckDrop(resource) = true {
	resource.cap_drop != null 

}