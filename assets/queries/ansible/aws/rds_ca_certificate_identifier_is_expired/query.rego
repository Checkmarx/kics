package Cx

import data.generic.ansible as ansLib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	object.get(rds_instance, "ca_certificate_identifier", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rds_instance.ca_certificate_identifier should be defined",
		"keyActualValue": "rds_instance.ca_certificate_identifier is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	rds_instance.ca_certificate_identifier != "rds-ca-2019"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ca_certificate_identifier", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.ca_certificate_identifier is equal to 'rds-ca-2019'",
		"keyActualValue": "rds_instance.ca_certificate_identifier is not equal to 'rds-ca-2019'",
	}
}
