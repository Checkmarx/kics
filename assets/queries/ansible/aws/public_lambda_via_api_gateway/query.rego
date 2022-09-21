package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.lambda_policy", "lambda_policy"}
	lambda := task[modules[m]]
	ansLib.checkState(lambda)

	lambdaAction(lambda.action)
	principalAllowAPIGateway(lambda.principal)
	re_match("/\\*/\\*$", lambda.source_arn)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.source_arn", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "lambda_policy.source_arn should not equal to '/*/*'",
		"keyActualValue": "lambda_policy.source_arn is equal to '/*/*'",
	}
}

lambdaAction("lambda:*") = true

lambdaAction("lambda:InvokeFunction") = true

principalAllowAPIGateway("*") = true

principalAllowAPIGateway("apigateway.amazonaws.com") = true
