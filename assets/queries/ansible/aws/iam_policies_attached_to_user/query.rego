package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	awsApiGateway := task["community.aws.iam_managed_policy"]
	ansLib.checkState(awsApiGateway)

	lower(awsApiGateway.iam_type) == "user"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.iam_type", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.iam_type should be configured with group or role",
		"keyActualValue": "community.aws.iam_managed_policy.iam_type is configured with user",
	}
}
