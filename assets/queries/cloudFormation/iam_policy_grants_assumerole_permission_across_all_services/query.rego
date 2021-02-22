package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	statements := resource.Properties.PolicyDocument.Statement

	contains(statements[_].Action[_], "sts:AssumeRole")

	contains(statements[_].Resource, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.Properties.PolicyDocument.Statement' with AssumeRole action does not grant access in all services ('*')", [name]),
		"keyActualValue": sprintf("'Resources.%s.Properties.PolicyDocument.Statement' with AssumeRole action is granting access in all services ('*')", [name]),
	}
}
