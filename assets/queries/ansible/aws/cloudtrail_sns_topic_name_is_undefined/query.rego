package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	playbooks := ansLib.getTasks(input.document[i])
	redis_cache := playbooks[j]
	instance := redis_cache["community.aws.cloudtrail"]

	not instance.sns_topic_name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudtrail}}", [playbooks[j].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [playbooks[j].name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is undefined", [playbooks[j].name]),
	}
}

CxPolicy[result] {
	playbooks := ansLib.getTasks(input.document[i])
	redis_cache := playbooks[j]
	instance := redis_cache["community.aws.cloudtrail"]

	instance.sns_topic_name == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name", [playbooks[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is set", [playbooks[j].name]),
		"keyActualValue": sprintf("name=%s.{{community.aws.cloudtrail}}.sns_topic_name is empty", [playbooks[j].name]),
	}
}
