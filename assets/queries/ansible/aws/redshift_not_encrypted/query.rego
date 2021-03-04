package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	module := ["redshift", "community.aws.redshift"]
	redshiftCluster := task[module[m]]

	redshiftCluster.command == "create"
	object.get(redshiftCluster, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, module[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.encrypted should be set to true", [module[m]]),
		"keyActualValue": sprintf("%s.encrypted is undefined", [module[m]]),
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	module := ["redshift", "community.aws.redshift"]
	redshiftCluster := task[module[m]]

	createOrModify(redshiftCluster.command)
	not ansLib.isAnsibleTrue(redshiftCluster.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypted", [task.name, module[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.encrypted should be set to true", [module[m]]),
		"keyActualValue": sprintf("%s.encrypted is set to false", [module[m]]),
	}
}

createOrModify("create") = true

createOrModify("modify") = true
