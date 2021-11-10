package Cx

import data.generic.common as common_lib
import data.generic.terraform as terra_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_glue_resource_policy[name]

	policy := common_lib.json_unmarshal(resource.policy)
	statement := policy.Statement
	terra_lib.has_wildcard(statement[_], "glue:*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_glue_resource_policy[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_glue_resource_policy[%s].policy does not have wildcard in 'principals' and 'actions'", [name]),
		"keyActualValue": sprintf("aws_glue_resource_policy[%s].policy has wildcard in 'principals' or 'actions'", [name]),
	}
}
