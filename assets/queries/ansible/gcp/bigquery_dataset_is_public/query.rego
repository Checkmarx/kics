package Cx

import data.generic.ansible as ansLib

CxPolicy[result] {
	document := input.document[i]
	task := ansLib.getTasks(document)[t]
	task["google.cloud.gcp_bigquery_dataset"].state == "present"
	access := task["google.cloud.gcp_bigquery_dataset"].access
	lower(access[_].special_group) == "allauthenticatedusers"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("name=%s.{{google.cloud.gcp_bigquery_dataset}}.access", [task.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access.special_group' is not equal to 'allAuthenticatedUsers'",
		"keyActualValue": "'access.special_group' is equal to 'allAuthenticatedUsers'",
	}
}
