package Cx
import data.generic.ansible as ansLib

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	rds_instance := tasks[_]
    ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
	rds_instanceBody := rds_instance["community.aws.rds_instance"]
	rds_instanceName := rds_instance.name
	is_disabled(rds_instanceBody.enable_iam_database_authentication)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.enable_iam_database_authentication", [rds_instanceName]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be enabled.", [rds_instanceName]),
		"keyActualValue": sprintf("{{%s}}.enable_iam_database_authentication is disabled", [rds_instanceName]),
	}
}

CxPolicy[result] {
	document = input.document[i]
	tasks := ansLib.getTasks(document)
	rds_instance := tasks[_]
     ansLib.isAnsibleTrue(task["community.aws.rds_instance"].publicly_accessible)
	rds_instanceBody := rds_instance["community.aws.rds_instance"]
	rds_instanceName := rds_instance.name
	object.get(rds_instanceBody, "enable_iam_database_authentication", "undefined") == "undefined"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}", [rds_instanceName]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("{{%s}}.enable_iam_database_authentication should be defined", [rds_instanceName]),
		"keyActualValue": sprintf("{{%s}}.enable_iam_database_authentication is undefined", [rds_instanceName]),
	}
}

is_disabled(value) {
	negativeValue = {"False", false, "false", "No", "no"}
	value == negativeValue[_]
} else = false {
	true
}
