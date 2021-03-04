package Cx

CxPolicy[result] {
	document := input.document[i]

	document.kind == "ServiceAccount"

	metadata := document.metadata
	metadata.name == "default"

	object.get(document, "automountServiceAccountToken", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"keyExpectedValue": sprintf("metadata.name=%s has automountServiceAccountToken set", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s has automountServiceAccountToken undefined", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]

	document.kind == "ServiceAccount"

	metadata := document.metadata
	metadata.name == "default"

	document.automountServiceAccountToken == true

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.automountServiceAccountToken", [metadata.name]),
		"keyExpectedValue": sprintf("metadata.name=%s has automountServiceAccountToken set to false", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s has automountServiceAccountToken set to true", [metadata.name]),
	}
}
