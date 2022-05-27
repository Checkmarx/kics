package Cx

import data.generic.ansible as ansLib
import data.generic.common as common_lib

modules := ["redshift", "community.aws.redshift"]

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	redshiftCluster := task[modules[m]]

	redshiftCluster.command == "create"
	not common_lib.valid_key(redshiftCluster, "encrypted")

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
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
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.encrypted", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "redshift.encrypted should be set to true",
		"keyActualValue": "redshift.encrypted is set to false",
	}
}

createOrModify("create") = true

createOrModify("modify") = true
