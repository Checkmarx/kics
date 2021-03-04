package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.logging_service

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'logging_service' is defined",
		"keyActualValue": "Attribute 'logging_service' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.logging_service == "none"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'logging_service' is not 'none'",
		"keyActualValue": "Attribute 'logging_service' is 'none'",
	}
}
