package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_storage_bucket[name]
	object.get(resource,"logging","undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_storage_bucket[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'google_storage_bucket.logging' is set",
		"keyActualValue": "'google_storage_bucket.logging' is undefined",
	}
}
