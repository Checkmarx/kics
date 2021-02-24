package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	object.get(task["community.aws.rds_instance"], "ca_certificate_identifier", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "RDS instance ca_certificate_identifier should be defined",
		"keyActualValue": "RDS instance ca_certificate_identifier is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]

	task["community.aws.rds_instance"].ca_certificate_identifier != "rds-ca-2019"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.ca_certificate_identifier", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": ".publicly_accessible is false",
		"keyActualValue": "aws_redshift_cluster.publicly_accessible is true",
	}
}
