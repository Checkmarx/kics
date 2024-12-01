package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	labels := metadata.labels

	value := labels[key]
	regex.match(`^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$`, value) == false

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.labels.%s", [metadata.name, key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'metadata.labels.{{%s}}' has valid label %s", [key, value]),
		"keyActualValue": sprintf("'metadata.labels.{{%s}}' has invalid label %s", [key, value]),
	}
}
