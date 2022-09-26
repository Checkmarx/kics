package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.cloudtrail", "cloudtrail"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not instance.sns_topic_name

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "cloudtrail.sns_topic_name should be set",
		"keyActualValue": "cloudtrail.sns_topic_name is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	instance.sns_topic_name == null

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.sns_topic_name", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "cloudtrail.sns_topic_name should be set",
		"keyActualValue": "cloudtrail.sns_topic_name is empty",
	}
}
