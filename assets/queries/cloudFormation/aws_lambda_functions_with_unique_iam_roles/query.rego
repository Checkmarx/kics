package Cx

CxPolicy [ result ] {
 	resources := input.document[i].Resources
  resource := resources[k]
    
  resource.Type == "AWS::Lambda::Function"
 	
  some j
    resources[j].Type == "AWS::Lambda::Function"
    resources[j].Properties.Role == resource.Properties.Role
    k != j
    
	result := {
              "documentId": 		input.document[i].id,
              "searchKey": 	    sprintf("Resources.%s.Properties.Role", [k]),
              "issueType":		"IncorrectValue",  
              "keyExpectedValue": "Each AWS Lambda Function has a unique role",
              "keyActualValue": 	sprintf("Resource.%s.Properties.Role is assigned to another funtion", [k])
            }
}