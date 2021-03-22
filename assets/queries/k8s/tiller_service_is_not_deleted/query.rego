package Cx

CxPolicy[result] {
	document := input.document[i]
	keyword := "tiller"

	metadata := document.metadata
	contains(metadata.name, keyword)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "metadata.name does not contain 'tiller'",
		"keyActualValue": "metadata.name contains 'tiller'",
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
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "metadata.labels does not have values that contain 'tiller'",
		"keyActualValue": sprintf("metadata.labels.%s contains 'tiller'", [j]),
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
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector.%s", [metadata.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.selector does not have values that contain 'tiller'",
		"keyActualValue": sprintf("spec.selector.%s contains 'tiller'", [j]),
	}
}
