package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Resource == "*"
	cloudFormationLib.checkAction(statement.Action[k], "delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow a 'Delete' action from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows a 'Delete' action from all principals", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::S3::BucketPolicy"
	statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Resource == "*"
	cloudFormationLib.checkAction(statement.Action, "delete")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow a 'Delete' action from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows a 'Delete' action from all principals", [name]),
	}
}
