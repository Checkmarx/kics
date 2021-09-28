package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

pl := {"aws_s3_bucket_policy", "aws_s3_bucket"}

CxPolicy[result] {
	resourceType := pl[r]
	resource := input.document[i].resource[resourceType][name]

	access_to_any_principal(resource.policy)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].policy", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].policy.Principal is not equal to, nor does it contain '*'", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].policy.Principal is equal to or contains '*'", [resourceType, name]),
		"searchLine": common_lib.build_search_line(["resource", resourceType, name, "policy"], []),
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]
	resourceType := pl[r]
	keyToCheck := common_lib.get_module_equivalent_key("aws", module.source, resourceType, "policy")

	access_to_any_principal(module[keyToCheck])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("module[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Principal' is not equal to, nor does it contain '*'", 
		"keyActualValue": "'policy.Principal' is equal to or contains '*'", 
		"searchLine": common_lib.build_search_line(["module", name, "policy"], []),
	}
}

access_to_any_principal(policyValue) {
	policy := common_lib.json_unmarshal(policyValue)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	terra_lib.anyPrincipal(statement)
}
