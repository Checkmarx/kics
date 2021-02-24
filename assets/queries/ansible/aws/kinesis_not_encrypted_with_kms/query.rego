package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.kinesis_stream"], "encryption_type", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.kinesis_stream}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.kinesis_stream.encryption_type is set",
		"keyActualValue": "community.aws.kinesis_stream.encryption_type is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.kinesis_stream"], "encryption_state", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.kinesis_stream}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.kinesis_stream.encryption_state is set",
		"keyActualValue": "community.aws.kinesis_stream.encryption_state is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.kinesis_stream"].encryption_state != "enabled"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.kinesis_stream}}.encryption_state", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.kinesis_stream.encryption_state is set to enabled",
		"keyActualValue": "community.aws.kinesis_stream.encryption_state is not set to enabled",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.kinesis_stream"].encryption_type == "NONE"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.kinesis_stream}}.encryption_type", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "community.aws.kinesis_stream.encryption_type is set and not NONE",
		"keyActualValue": "community.aws.kinesis_stream.encryption_type is set but NONE",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.kinesis_stream"].encryption_type == "KMS"
	object.get(task["community.aws.kinesis_stream"], "key_id", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{community.aws.kinesis_stream}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "community.aws.kinesis_stream.key_id is set",
		"keyActualValue": "community.aws.kinesis_stream.key_id is undefined",
	}
}
