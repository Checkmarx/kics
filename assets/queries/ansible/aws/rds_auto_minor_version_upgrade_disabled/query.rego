package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	ansLib.isAnsibleFalse(task["community.aws.rds_instance"].auto_minor_version_upgrade)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}.auto_minor_version_upgrade", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AWS RDS instance feature auto_minor_version_upgrade should be true",
		"keyActualValue": "AWS RDS instance feature auto_minor_version_upgrade is false",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]

	object.get(task["community.aws.rds_instance"], "auto_minor_version_upgrade", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{community.aws.rds_instance}}", [task.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "AWS RDS instance feature auto_minor_version_upgrade should be true",
		"keyActualValue": "AWS RDS instance feature auto_minor_version_upgrade is false",
	}
}
