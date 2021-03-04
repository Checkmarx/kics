package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	task := ansLib.tasks[id][t]
	bigquery_dataset := task["google.cloud.gcp_bigquery_dataset"]

	ansLib.checkState(bigquery_dataset)
	access := bigquery_dataset.access
	lower(access[_].special_group) == "allauthenticatedusers"

	result := {
		"documentId": id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_bigquery_dataset}}.access", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "{{google.cloud.gcp_bigquery_dataset}}.access.special_group is not equal to 'allAuthenticatedUsers'",
		"keyActualValue": "{{google.cloud.gcp_bigquery_dataset}}.access.special_group is equal to 'allAuthenticatedUsers'",
	}
}
