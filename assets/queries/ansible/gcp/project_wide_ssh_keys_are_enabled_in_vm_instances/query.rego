package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	metadata := instance.metadata
	ansLib.checkState(instance)

	common_lib.valid_key(metadata, "block-project-ssh-keys")
	not ansLib.isAnsibleTrue(metadata["block-project-ssh-keys"])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.metadata.block-project-ssh-keys", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_compute_instance.metadata.block-project-ssh-keys is true",
		"keyActualValue": "gcp_compute_instance.metadata.block-project-ssh-keys is false",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not common_lib.valid_key(instance.metadata, "block-project-ssh-keys")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.metadata", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_instance.metadata.block-project-ssh-keys is set and is true",
		"keyActualValue": "gcp_compute_instance.metadata.block-project-ssh-keys is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	not common_lib.valid_key(instance, "metadata")

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_instance.metadata is set",
		"keyActualValue": "gcp_compute_instance.metadata is undefined",
	}
}
