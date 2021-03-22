package Cx

import data.generic.cloudformation as cloudFormationLib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Role"
	statement := resource.Properties.AssumeRolePolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Principal == "*"
	cloudFormationLib.checkAction(statement.Action[k], "restore")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement does not allow a 'Restore' action from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AssumeRolePolicyDocument.Statement allows a 'Restore' action from all principals", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	statement := resource.Properties.PolicyDocument.Statement[j]
	statement.Effect == "Allow"
	statement.Resource == "*"
	cloudFormationLib.checkAction(statement.Action[k], "restore")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement does not allow a 'Restore' action from all principals", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement allows a 'Restore' action from all principals", [name]),
	}
}
