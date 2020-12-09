package Cx

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::Role"
  statement := resource.Properties.AssumeRolePolicyDocument.Statement[j]
	statement.Effect == "Allow"
  statement.Principal == "*"
	check_action(statement.Action[k])

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement does not allow a 'Put' or 'Restore' action from all principals", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement allows a 'Put' or 'Restore' action from all principals", [name])
              }
}

CxPolicy [ result ] {
	resource := input.document[i].Resources[name]
  resource.Type == "AWS::IAM::Policy"
  statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
  statement.Resource == "*"
	check_action(statement.Action[k])

    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow a 'Put' or 'Restore' action from all principals", [name]),
                "keyActualValue": 	sprintf("Resources.%s.Properties.PolicyDocument.Statement allows a 'Put' or 'Restore' action from all principals", [name])
              }
}

check_action(action){
	  is_string(action)
    contains(lower(action), "put")
}

check_action(action){
	  is_string(action)
    contains(lower(action), "restore")
}
