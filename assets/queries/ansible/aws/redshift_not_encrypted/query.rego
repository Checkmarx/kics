package Cx

import data.generic.ansible as ansLib

modules := ["redshift", "community.aws.redshift"]

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	redshiftCluster := task[modules[m]]

	redshiftCluster.command == "create"
	object.get(redshiftCluster, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, modules[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "redshift.encrypted should be set to true",
		"keyActualValue": "redshift.encrypted is undefined",
	}
}

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	redshiftCluster := task[modules[m]]

	createOrModify(redshiftCluster.command)
	not ansLib.isAnsibleTrue(redshiftCluster.encrypted)

	result := {
		"documentId": id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.encrypted should be set to true",
		"keyActualValue": "redshift.encrypted is set to false",
	}
}

createOrModify("create") = true

createOrModify("modify") = true
