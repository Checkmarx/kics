package Cx

import data.generic.common as commonLib
import data.generic.terraform as terraLib

CxPolicy[result] {
	resource := input.document[i].resource.aws_sqs_queue_policy[name]

	policy := commonLib.json_unmarshal(resource.policy)
	statement := policy.Statement[_]

	statement.Effect == "Allow"
	check_principal(statement.Principal, "*")
    terraLib.anyPrincipal(statement)


	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_sqs_queue_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'policy.Statement.Principal.AWS' is not equal '*'",
		"keyActualValue": "'policy.Statement.Principal.AWS' is equal '*'",
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
