package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[name]
	resource.Type == "AWS::ECR::Repository"
	policy := resource.Properties.RepositoryPolicyText
	st := common_lib.get_statement(common_lib.get_policy(policy))
	some statement in st

	common_lib.is_allow_effect(statement)
	contains(statement.Principal, "*")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.RepositoryPolicyText", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal shouldn't contain '*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.RepositoryPolicyText.Statement.Principal contains '*'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "RepositoryPolicyTexts"], []),
	}
}
