package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	isAccessible(task["community.aws.sqs_queue"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal doesn't get the queue publicly accessible", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.sqs_queue}}.policy.Principal does get the queue publicly accessible", [task.name]),
	}
}

isAccessible(task) {
	task.policy.Statement.Principal == "*"
}

isAccessible(task) {
	task.policy.Statement[s].Principal == "*"
}
