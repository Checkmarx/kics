package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	module := ["redshift", "community.aws.redshift"]
	redshiftCluster := task[module[m]]

	redshiftCluster.command == "create"
	object.get(redshiftCluster, "encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{%s}}", [task.name, module[m]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "redshift.encrypted should be set to true",
		"keyActualValue": "redshift.encrypted is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	tasks := ansLib.getTasks(document)
	task := tasks[t]
	module := ["redshift", "community.aws.redshift"]
	redshiftCluster := task[module[m]]

	createOrModify(redshiftCluster.command)
	not ansLib.isAnsibleTrue(redshiftCluster.encrypted)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypted", [task.name, module[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.encrypted should be set to true",
		"keyActualValue": "redshift.encrypted is set to false",
	}
}

createOrModify("create") = true

createOrModify("modify") = true
