package Cx

CxPolicy[result] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::ECR::Repository"
	policy := resource.Properties.RepositoryPolicyText
	statement := policy.Statement[_]
	statement.Effect == "Allow"
	contains(statement.Principal, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal doesn't contain '*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal contains '*'", [name]),
	}
}
