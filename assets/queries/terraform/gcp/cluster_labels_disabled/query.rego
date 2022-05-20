package Cx

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.resource_labels

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": primary,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'resource_labels' is defined",
		"keyActualValue": "Attribute 'resource_labels' is undefined",
	}
}
