package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_cloudwatch_log_destination_policy[name]

	policy := common_lib.json_unmarshal(resource.access_policy)
	statement := policy.Statement
	terra_lib.has_wildcard(statement[_], "logs:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_cloudwatch_log_destination_policy[%s].access_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ws_cloudwatch_log_destination_policy[%s].access_policy does not have wildcard in 'principals' and 'actions'", [name]),
		"keyActualValue": sprintf("ws_cloudwatch_log_destination_policy[%s].access_policy has wildcard in 'principals' or 'actions'", [name]),
	}
}
