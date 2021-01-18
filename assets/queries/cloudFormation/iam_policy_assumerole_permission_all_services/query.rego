package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
	resource.Type == "AWS::IAM::Policy"
	statements := resource.PolicyDocument.Statement

	contains(statements[i].Action[_], "sts:AssumeRole")

	contains(statements[i].Resource, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.PolicyDocument.Statement", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'Resources.%s.PolicyDocument.Statement' with AssumeRole action does not grant access in all services ('*')", [name]),
		"keyActualValue": sprintf("'Resources.%s.PolicyDocument.Statement' with AssumeRole action is granting access in all services ('*')", [name]),
	}
}
