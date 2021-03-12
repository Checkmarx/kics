package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	document.kind == "Pod"
	metadata.annotations[key]
	expectedKey := "container.apparmor.security.beta.kubernetes.io"
	not startswith(key, expectedKey)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.annotations", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name[%s].annotations should contain key: '%s'", [metadata.name, expectedKey]),
		"keyActualValue": sprintf("metadata.name[%s].annotations doesn't contain key: '%s'", [metadata.name, expectedKey]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	document.kind == "Pod"
	expectedKey := "container.apparmor.security.beta.kubernetes.io"
	metadata.annotations == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.annotations", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name[%s].annotations should contain AppArmor profile config: '%s'", [metadata.name, expectedKey]),
		"keyActualValue": sprintf("metadata.name[%s].annotations doesn't contain AppArmor profile config: '%s'", [metadata.name, expectedKey]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	not metadata.annotations

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s", [metadata.name]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("metadata.name[%s] should include annotations for AppArmor profile config", [metadata.name]),
		"keyActualValue": sprintf("metadata.name[%s] doesn't contain AppArmor profile config in annotations", [metadata.name]),
	}
}
