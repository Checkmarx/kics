package Cx

CxPolicy[result] {
	document := input.document[i]
	keyword := "tiller"

	metadata := document.metadata
	contains(metadata.name, keyword)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name of %s should not contain 'tiller'", [document.kind]),
		"keyActualValue": sprintf("metadata.name of %s contains 'tiller'", [document.kind]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	keyword := "tiller"

	metadata := document.metadata
	labels := metadata.labels
	some j
	contains(labels[j], keyword)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.labels of %s should not have values that contain 'tiller'", [document.kind]),
		"keyActualValue": sprintf("metadata.labels.%s of %s contains 'tiller'", [document.kind, j]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	keyword := "tiller"
	metadata := document.metadata
	selector := document.spec.selector

	some j
	is_string(selector[j])
	contains(selector[j], keyword)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.%s", [metadata.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.selector of %s should not have values that contain 'tiller'", [document.kind]),
		"keyActualValue": sprintf("spec.selector.%s of %s contains 'tiller'", [document.kind, j]),
	}
}
