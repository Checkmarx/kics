package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	modules := {"google.cloud.gcp_bigquery_dataset", "gcp_bigquery_dataset"}
	bigquery_dataset := task[modules[m]]
	ansLib.checkState(bigquery_dataset)

	access := bigquery_dataset.access
	lower(access[_].special_group) == "allauthenticatedusers"

	result := {
		"documentId": id,
		"resourceType": modules[m],
		"resourceName": task.name,
		"searchKey": sprintf("name={{%s}}.{{%s}}.access", [task.name, modules[m]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "gcp_bigquery_dataset.access.special_group should not equal to 'allAuthenticatedUsers'",
		"keyActualValue": "gcp_bigquery_dataset.access.special_group is equal to 'allAuthenticatedUsers'",
	}
}
