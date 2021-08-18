package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.kinesis_stream", "kinesis_stream"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kinesis_stream := task[modules[m]]
	ansLib.checkState(kinesis_stream)

	not common_lib.valid_key(kinesis_stream, "encryption_type")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kinesis_stream.encryption_type is set",
		"keyActualValue": "kinesis_stream.encryption_type is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kinesis_stream := task[modules[m]]
	ansLib.checkState(kinesis_stream)

	not common_lib.valid_key(kinesis_stream, "encryption_state")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kinesis_stream.encryption_state is set",
		"keyActualValue": "kinesis_stream.encryption_state is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kinesis_stream := task[modules[m]]
	ansLib.checkState(kinesis_stream)

	kinesis_stream.encryption_state != "enabled"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encryption_state", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "kinesis_stream.encryption_state is set to enabled",
		"keyActualValue": "kinesis_stream.encryption_state is not set to enabled",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kinesis_stream := task[modules[m]]
	ansLib.checkState(kinesis_stream)

	kinesis_stream.encryption_type == "NONE"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encryption_type", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "kinesis_stream.encryption_type is set and not NONE",
		"keyActualValue": "kinesis_stream.encryption_type is set but NONE",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	kinesis_stream := task[modules[m]]
	ansLib.checkState(kinesis_stream)

	kinesis_stream.encryption_type == "KMS"
	not common_lib.valid_key(kinesis_stream, "key_id")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "kinesis_stream.key_id is set",
		"keyActualValue": "kinesis_stream.key_id is undefined",
	}
}
