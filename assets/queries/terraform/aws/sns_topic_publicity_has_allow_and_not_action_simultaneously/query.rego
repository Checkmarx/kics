package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	resources := {"aws_sns_topic", "aws_sns_topic_policy"}
	policy := document.resource[resources[r]][name].policy

	validate_json(policy)

	pol := common_lib.json_unmarshal(policy)
	statement := pol.Statement[s]

	statement.Effect == "Allow"
	statement.NotAction

	result := {
		"documentId": document.id,
		"searchKey": sprintf("%s[%s].policy.Sid", [resources[r], name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Sid doesn't have 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
		"keyActualValue": sprintf("%s[%s].policy.Sid has 'Effect: Allow' and 'NotAction' simultaneously", [resources[r], name]),
		"searchLine": common_lib.build_search_line(["resource", name, "policy", "Statement", s, "Sid"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, "aws_sns_topic_policy", "policy")

	policy := module[keyToCheck]

	validate_json(policy)

	pol := common_lib.json_unmarshal(policy)
	statement := pol.Statement[s]

	statement.Effect == "Allow"
	statement.NotAction

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy.Sid", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].policy.Sid doesn't have 'Effect: Allow' and 'NotAction' simultaneously", [name]),
		"keyActualValue": sprintf("module[%s].policy.Sid has 'Effect: Allow' and 'NotAction' simultaneously", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheck, "Statement", s, "Sid"], []),
	}
}

validate_json(string) {
	not startswith(string, "$")
}
