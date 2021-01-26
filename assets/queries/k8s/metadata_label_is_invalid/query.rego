package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	labels := metadata.labels

	some key
	value := labels[key]
	regex.match("^(([A-Za-z0-9][-A-Za-z0-9_.]*)?[A-Za-z0-9])?$", value) == false
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.labels.%s", [metadata.name, key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'metadata.labels.%s' has valid label %s", [key, value]),
		"keyActualValue": sprintf("'metadata.labels.%s' has invalid label %s", [key, value]),
	}
}
