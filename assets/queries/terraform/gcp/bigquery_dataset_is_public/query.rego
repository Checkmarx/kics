package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_bigquery_dataset[name]
	access := resource.access
	is_object(access)
	access.special_group == "allAuthenticatedUsers"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_bigquery_dataset[%s].access.special_group", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access.special_group' is not equal 'allAuthenticatedUsers'",
		"keyActualValue": "'access.special_group' is equal 'allAuthenticatedUsers'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_bigquery_dataset[name]
	access := resource.access
	is_array(access)
	access[_].special_group == "allAuthenticatedUsers"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_bigquery_dataset[%s].access.special_group", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'access.special_group' is not equal 'allAuthenticatedUsers'",
		"keyActualValue": "'access.special_group' is equal 'allAuthenticatedUsers'",
	}
}
