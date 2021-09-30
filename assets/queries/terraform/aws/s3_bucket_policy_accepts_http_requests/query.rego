package Cx

import data.generic.common as common_lib

resources := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := resources[r]
	resource := input.document[i].resource[resourceType][name]

	not deny_http_requests(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy does not accept HTTP Requests", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy accepts HTTP Requests", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceType := resources[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	policy := module[keyToCheck]

	not deny_http_requests(policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy' does not accept HTTP Requests",
		"keyActualValue": "'policy' accepts HTTP Requests",
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

validActions := {"*", "s3:*", "s3:GetObject"}

check_action(action) {
	is_string(action)
	action == validActions[x]
} else {
	action[a] == validActions[x]
}

deny_http_requests(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	statement := policy.Statement[s]
	check_action(statement.Action)
	statement.Effect == "Deny"
	statement.Condition.Bool["aws:SecureTransport"] == "false"
}
