package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::KMS::Key"
	policy := resources.Properties.KeyPolicy
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.equalsOrInArray(statement.Principal, "*")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resources.Type,
		"resourceName": cf_lib.get_resource_name(resources, name),
		"searchKey": sprintf("Resources.%s.Properties.KeyPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement should not be '*'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement is '*'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "KeyPolicy"], []),
	}
}
