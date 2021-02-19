package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
    ansLib.isAnsibleTrue(task["community.aws.sqs_queue"].publicly_accessible)
	sqsPolicy := task["community.aws.sqs_queue"]
	sqsPolicyName := task.name
	contains(sqsPolicy.policy.Statement[_].Action, "*")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement", [sqsPolicyName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement should not contain Action equal to '*'", [sqsPolicyName]),
		"keyActualValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Statement contains Action equal to '*'", [sqsPolicyName]),
	}
}
