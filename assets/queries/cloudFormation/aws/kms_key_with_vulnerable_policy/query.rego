package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resources := input.document[i].Resources[name]
	resources.Type == "AWS::KMS::Key"
	policy := resources.Properties.KeyPolicy
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	not common_lib.valid_key(statement, "Condition")
	common_lib.has_wildcard(statement, "kms:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("Resources.%s.Properties.KeyPolicy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement does not have wildcard in 'Action' and 'Principal'", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.KeyPolicy.Statement has wildcard in 'Action' and 'Principal'", [name]),
		"searchLine": common_lib.build_search_line(["Resource", name, "Properties", "KeyPolicy"], []),
	}
}
