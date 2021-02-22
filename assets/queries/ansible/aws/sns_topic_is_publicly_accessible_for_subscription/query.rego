package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	snsTopicCommunity := task["community.aws.sns_topic"]
	snsTopicName := task.name
	object.get(snsTopicCommunity, "subscriptions", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.sns_topic}}", [snsTopicName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.sns_topic.subscriptions should be undefined",
		"keyActualValue": "community.aws.sns_topic.subscriptions is defined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	snsTopic := task.sns_topic
	snsTopicName := task.name
	object.get(snsTopic, "subscriptions", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{sns_topic}}", [snsTopicName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sns_topic.subscriptions should be undefined",
		"keyActualValue": "sns_topic.subscriptions is defined",
	}
}