package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resources := {"aws_s3_bucket_policy", "aws_s3_bucket"}
	resource := input.document[i].resource[resources[r]][name]

	policy := common_lib.json_unmarshal(resource.policy)

	statement := policy.Statement[s]

	not deny_http_requests(statement)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_s3_bucket[%s].policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_s3_bucket[%s].policy does not accept HTTP Requests", [name]),
		"keyActualValue": sprintf("aws_s3_bucket[%s].policy accepts HTTP Requests", [name]),
	}
}

validActions := {"*", "s3:*", "s3:GetObject"}

check_action(action) {
	is_string(action)
	action == validActions[x]
} else {
	action[a] == validActions[x]
}

deny_http_requests(statement) {
	check_action(statement.Action)
	statement.Effect == "Deny"
	statement.Condition.Bool["aws:SecureTransport"] == false
}
