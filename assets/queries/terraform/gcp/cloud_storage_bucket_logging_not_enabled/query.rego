package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]
	not resource.logging

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'resource.logging' is set",
		"keyActualValue": "'resource.logging' is undefined",
	}
}
