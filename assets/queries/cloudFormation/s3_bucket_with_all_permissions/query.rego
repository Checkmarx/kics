package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Resource == "*"
	check_action(statement.Action[k])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow all actions from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows all actions from all principals", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Resource == "*"
	check_action(statement.Action)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow all actions from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows all actions from all principals", [name]),
	}
}

check_action(action) {
	is_string(action)
	action == "*"
}
