package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := {"community.aws.rds_instance", "rds_instance"}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	rds_instance := task[modules[m]]
	ansLib.checkState(rds_instance)

	not common_lib.valid_key(rds_instance, "ca_certificate_identifier")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
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

	allowed := ["rds-ca-2019", "rds-ca-rsa2048-g1", "rds-ca-rsa4096-g1", "rds-ca-ecc384-g1"]
    not common_lib.inArray(allowed, rds_instance.ca_certificate_identifier)

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.ca_certificate_identifier", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rds_instance.ca_certificate_identifier should equal to one provided by Amazon RDS.",
		"keyActualValue": sprintf("'aws_db_instance.ca_cert_identifier' is '%s'", [rds_instance.ca_certificate_identifier]),
	}
}
