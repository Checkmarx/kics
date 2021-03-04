package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.cloudtrail"]

	not instance.sns_topic_name

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudtrail}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is undefined", [task.name]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task["community.aws.cloudtrail"]

	instance.sns_topic_name == null

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [task.name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is empty", [task.name]),
	}
}
