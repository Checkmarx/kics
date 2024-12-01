package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.resource.aws_sqs_queue_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	some statement in st

	common_lib.is_allow_effect(statement)
	check_principal(statement.Principal, "*")
	tf_lib.anyPrincipal(statement)

	result := {
		"documentId": doc.id,
		"resourceType": "aws_sqs_queue_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' should not equal '*'",
		"keyActualValue": "'policy.Statement.Principal.AWS' is equal '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name, "policy"], []),
	}
}

check_principal(field, value) {
	is_object(field)
	some i
	val := [x | x := field[i]; common_lib.containsOrInArrayContains(x, value)]
	count(val) > 0
} else {
	common_lib.containsOrInArrayContains(field, "*")
}
