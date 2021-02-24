package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	snsTopicCommunity := task["community.aws.sns_topic"]

	object.get(snsTopicCommunity, "subscriptions", "undefined") != "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.sns_topic}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.sns_topic.subscriptions should be undefined",
		"keyActualValue": "community.aws.sns_topic.subscriptions is defined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	snsTopic := task.sns_topic

	object.get(snsTopic, "subscriptions", "undefined") != "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{sns_topic}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sns_topic.subscriptions should be undefined",
		"keyActualValue": "sns_topic.subscriptions is defined",
	}
}
