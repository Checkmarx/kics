package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	st := common_lib.get_statement(policy)
	statement := st[_]

	common_lib.is_allow_effect(statement)
	check_principal(statement.Principal, "*")
  terraLib.anyPrincipal(statement)


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' is not equal '*'",
		"keyActualValue": "'policy.Statement.Principal.AWS' is equal '*'",
		"searchLine": common_lib.build_search_line(["resource", "aws_sqs_queue_policy", name, "policy"], []),
	}
}

check_principal(field, value) {
	is_object(field)
	some i
	val := [x | x := field[i]; commonLib.containsOrInArrayContains(x, value)]
	count(val) > 0
} else {
	commonLib.containsOrInArrayContains(field, "*")
}
