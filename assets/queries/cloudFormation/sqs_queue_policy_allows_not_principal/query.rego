package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]

	document.Resources[queuePolicyName].Type == "AWS::SQS::QueuePolicy"
	queuePolicy := document.Resources[queuePolicyName]

	policy := queuePolicy.Properties.PolicyDocument
	st := common_lib.get_statement(common_lib.get_policy(policy))
	statement := st[_]

	common_lib.is_allow_effect(statement)
	common_lib.valid_key(statement, "NotPrincipal")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [queuePolicyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.NotPrincipal should never be used when Effect=Allow", [queuePolicyName]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.NotPrincipal is set and Effect=Allow", [queuePolicyName]),
		"searchLine": common_lib.build_search_line(["Resource", queuePolicyName, "Properties", "PolicyDocument"], []),
	}
}
