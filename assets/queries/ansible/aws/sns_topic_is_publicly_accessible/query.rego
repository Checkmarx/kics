package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

notValidToken := {"*", ""}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"community.aws.sns_topic", "sns_topic"}
	snsTopicCommunity := task[modules[m]]
	ansLib.checkState(snsTopicCommunity)
	policies := snsTopicCommunity.policy
	statement := policies.Statement[i]
	statement.Effect == "Allow"
	statement.Principal == notValidToken[_]

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.policy", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "sns_topic.subscriptions should be undefined",
		"keyActualValue": "sns_topic.subscriptions is defined",
	}
}
