package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[name]
	types := {"aws_alb", "aws_lb"}
	name == types[x]
	res := resource[m]
	check_load_balancer_type(res, "load_balancer_type")
	res.drop_invalid_header_fields == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[x],
		"resourceName": tf_lib.get_resource_name(res, m),
		"searchKey": sprintf("%s[{{%s}}].drop_invalid_header_fields", [types[x], m]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[{{%s}}].drop_invalid_header_fields should be set to true", [types[x], m]),
		"keyActualValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is set to false", [types[x], m]),
		"searchLine": common_lib.build_search_line(["resource", types[x], m, "drop_invalid_header_fields"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[name]
	types := {"aws_alb", "aws_lb"}
	name == types[x]
	res := resource[m]
	check_load_balancer_type(res, "load_balancer_type")
	not common_lib.valid_key(res, "drop_invalid_header_fields")

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[x],
		"resourceName": tf_lib.get_resource_name(res, m),
		"searchKey": sprintf("%s[{{%s}}]", [types[x], m]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s[{{%s}}].drop_invalid_header_fields should be set to true", [types[x], m]),
		"keyActualValue": sprintf("%s[{{%s}}].drop_invalid_header_fields is missing", [types[x], m]),
		"searchLine": common_lib.build_search_line(["resource", types[x], m], []),
		"remediation": "drop_invalid_header_fields = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	keyToCheckLbt := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "load_balancer_type")
	check_load_balancer_type(module, keyToCheckLbt)

	keyToCheckDihf := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "drop_invalid_header_fields")
	module[keyToCheckDihf] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s].drop_invalid_header_fields", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("module[%s].drop_invalid_header_fields should be set to true", [name]),
		"keyActualValue": sprintf("module[%s].drop_invalid_header_fields is set to false", [name]),
		"searchLine": common_lib.build_search_line(["module", name, keyToCheckDihf], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	module := input.document[i].module[name]

	keyToCheckLbt := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "load_balancer_type")
	check_load_balancer_type(module, keyToCheckLbt)

	keyToCheckDihf := common_lib.get_module_equivalent_key("aws", module.source, "aws_lb", "drop_invalid_header_fields")
	not common_lib.valid_key(module, keyToCheckDihf)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "n/a",
		"resourceName": "n/a",
		"searchKey": sprintf("module[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("module[%s].drop_invalid_header_fields should be set to true", [name]),
		"keyActualValue": sprintf("module[%s].drop_invalid_header_fields is missing", [name]),
		"searchLine": common_lib.build_search_line(["module", name], []),
		"remediation": "drop_invalid_header_fields = true",
		"remediationType": "addition",
	}
}

check_load_balancer_type(res, lbt) {
	res[lbt] == "application"
} else {
	not common_lib.valid_key(res, lbt)
} else = false {
	true
}
