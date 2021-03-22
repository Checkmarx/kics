package Cx

import data.generic.ansible as ansLib

modules := {"google.cloud.gcp_compute_instance", "gcp_compute_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)

	object.get(instance, "shielded_instance_config", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "gcp_compute_instance.shielded_instance_config is defined",
		"keyActualValue": "gcp_compute_instance.shielded_instance_config is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)
	attributes := ["enable_integrity_monitoring", "enable_secure_boot", "enable_vtpm"]

	object.get(instance.shielded_instance_config, attributes[j], "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.shielded_instance_config", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("gcp_compute_instance.shielded_instance_config.%s is defined", [attributes[j]]),
		"keyActualValue": sprintf("gcp_compute_instance.shielded_instance_config.%s is undefined", [attributes[j]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	instance := task[modules[m]]
	ansLib.checkState(instance)
	attributes := ["enable_integrity_monitoring", "enable_secure_boot", "enable_vtpm"]

	ansLib.isAnsibleFalse(instance.shielded_instance_config[attributes[j]])

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.shielded_instance_config.%s", [task.name, modules[m], attributes[j]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("gcp_compute_instance.shielded_instance_config.%s is true", [attributes[j]]),
		"keyActualValue": sprintf("gcp_compute_instance.shielded_instance_config.%s is false", [attributes[j]]),
	}
}
