package Cx

CxPolicy[result] {
	document := input.document[i]

	metadata = document.metadata

	object.get(metadata, "namespace", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"keyExpectedValue": sprintf("Namespace is set in document[%d]", [i]),
		"keyActualValue": sprintf("Namespace is not set in document[%d]", [i]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	metadata = document.metadata
	metadata.namespace == "default"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.namespace", [metadata.name]),
		"keyExpectedValue": sprintf("Default namespace is not used in document[%d]", [i]),
		"keyActualValue": sprintf("Default namespace is used in document[%d]", [i]),
	}
}
