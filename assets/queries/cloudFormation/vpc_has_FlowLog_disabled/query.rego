package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type = "AWS::EC2::VPC"


  not CheckFlowLogExistance(name)
    
  		
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s has FlowLogs enabled", [name]),
                "keyActualValue": 	sprintf("Resources.%s has FlowLogs disabled", [name])
              }
}

CheckFlowLogExistance (service) = result {
    
	documents := input.document[index].Resources[a]
  documents.Type = "AWS::EC2::FlowLog"
  
	result := documents[_].ResourceId == service

}