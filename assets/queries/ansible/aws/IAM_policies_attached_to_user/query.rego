package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.iam_managed_policy"].publicly_accessible)
	awsApiGateway := task["community.aws.iam_managed_policy"]
	checkState(awsApiGateway)
	lower(awsApiGateway.iam_type) == "user"
	clusterName := task.name
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.iam_managed_policy}}.iam_type", [clusterName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.iam_managed_policy.iam_type should be configured with group or role",
		"keyActualValue": "community.aws.iam_managed_policy.iam_type is configured with user",
	}
}

checkState(awsApiGateway) {
	contains(awsApiGateway.state, "present")
} else {
	object.get(awsApiGateway, "state", "undefined") == "undefined"
}
