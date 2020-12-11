package Cx

CxPolicy [ result ] {
  resource := input.document[i].Resources[name]
  resource.Type = "AWS::EC2::FlowLog"
    
  not CheckFlowLogExistance(resource)
    
  		
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.ResourceId", [name]),
                "issueType":		"IncorrectValue",  
                "keyExpectedValue": sprintf("Resources.%s has a valid VPC", [name]),
                "keyActualValue": 	sprintf("Resources.%s has a invalid VPC", [name])
              }
}

CheckFlowLogExistance (resource) = result {
    
	documents := input.document[index].Resources[a]
  	documents.Type = "AWS::EC2::VPC"
    
  result := contains(a, resource)
}

contains (string, resource) = true {
	 resource[a].ResourceId == string
}





