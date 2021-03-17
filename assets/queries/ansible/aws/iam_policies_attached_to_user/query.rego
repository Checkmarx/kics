package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.iam_managed_policy", "iam_managed_policy"}
	awsApiGateway := task[modules[m]]
	ansLib.checkState(awsApiGateway)

	lower(awsApiGateway.iam_type) == "user"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.iam_type", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "iam_managed_policy.iam_type should be configured with group or role",
		"keyActualValue": "iam_managed_policy.iam_type is configured with user",
	}
}
