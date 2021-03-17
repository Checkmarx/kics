package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sns_topic", "sns_topic"}
	snsTopicCommunity := task[modules[m]]
	ansLib.checkState(snsTopicCommunity)

	object.get(snsTopicCommunity, "subscriptions", "undefined") != "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sns_topic.subscriptions should be undefined",
		"keyActualValue": "sns_topic.subscriptions is defined",
	}
}
