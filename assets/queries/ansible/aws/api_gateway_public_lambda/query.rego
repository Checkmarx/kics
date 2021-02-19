package Cx

import data.generic.ansible as ansLib
CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["lambda.source_arn"].publicly_accessible)
	lambda := task.lambda_policy
	lambdaAction(lambda.action)
	principalAllowAPIGateway(lambda.principal)
	re_match("/\\*/\\*$", lambda.source_arn)
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{lambda_policy}}.source_arn", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "lambda_policy.source_arn should not be equal to '/*/*'",
		"keyActualValue": "lambda_policy.source_arn is equal to '/*/*'",
	}
}

lambdaAction(action) {
	action == "lambda:*"
} else {
	action == "lambda:InvokeFunction"
}

principalAllowAPIGateway(principal) {
	principal == "*"
} else {
	principal == "apigateway.amazonaws.com"
}