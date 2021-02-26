package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task = ansLib.tasks[id][t]
	elasticsearch = task.ec2_elasticsearch

	not ansLib.isAnsibleFalse(elasticsearch.encryption_at_rest_enabled)
	object.get(elasticsearch, "encryption_at_rest_kms_key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.ec2_elasticsearch.{{encryption_at_rest_kms_key_id}}", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_kms_key_id should be defined", [task.name]),
		"keyActualValue": sprintf("name={{%s}}.ec2_elasticsearch.encryption_at_rest_kms_key_id is undefined", [task.name]),
	}
}
