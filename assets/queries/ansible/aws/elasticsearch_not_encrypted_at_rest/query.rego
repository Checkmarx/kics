package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	elasticsearch = task.ec2_elasticsearch

	ansLib.isAnsibleFalse(elasticsearch.encryption_at_rest_enabled)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.ec2_elasticsearch.{{encryption_at_rest_enabled}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_enabled should be enabled", [task.name]),
		"keyActualValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_enabled is disabled", [task.name]),
	}
}

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	elasticsearch = task.ec2_elasticsearch

	object.get(elasticsearch, "encryption_at_rest_enabled", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.ec2_elasticsearch", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_enabled should be set and enabled", [task.name]),
		"keyActualValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_enabled is undefined", [task.name]),
	}
}
