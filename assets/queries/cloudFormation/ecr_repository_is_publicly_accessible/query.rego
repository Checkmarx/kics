package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].Resources[name]
    resource.Type == "AWS::ECR::Repository"
	policy := resource.Properties.RepositoryPolicyText
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	contains(statement.Principal, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.RepositoryPolicyText", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal doesn't contain '*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal contains '*'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "RepositoryPolicyTexts"], []),
	}
}
