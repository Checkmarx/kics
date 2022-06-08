package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

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
		"resourceType": document.Resources[queuePolicyName],
		"resourceName": cf_lib.get_resource_name(document.Resources[queuePolicyName], queuePolicyName),
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument", [queuePolicyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.NotPrincipal should never be used when Effect=Allow", [queuePolicyName]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement.NotPrincipal is set and Effect=Allow", [queuePolicyName]),
		"searchLine": common_lib.build_search_line(["Resource", queuePolicyName, "Properties", "PolicyDocument"], []),
	}
}
