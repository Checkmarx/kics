package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]

	some queuePolicyName
	document.Resources[queuePolicyName].Type == "AWS::SQS::QueuePolicy"
	queuePolicy := document.Resources[queuePolicyName]

	some stmt
	isUnsafeStatement(queuePolicy.Properties.PolicyDocument.Statement[stmt])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("Resources.%s.Properties.PolicyDocument.Statement.Effect=Allow.NotPrincipal", [queuePolicyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement[*].NotPrincipal should never be used when Effect=Allow", [queuePolicyName]),
		"keyActualValue": sprintf("Resources.%s.Properties.PolicyDocument.Statement[%s].NotPrincipal is set and Effect=Allow", [queuePolicyName, stmt]),
	}
}

isUnsafeStatement(stmt) {
	stmt.Effect == "Allow"
	common_lib.valid_key(stmt, "NotPrincipal")
}
