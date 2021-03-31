package Cx

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	metadata := resource[name].metadata
	metadata.annotations[key]
	expectedKey := "container.apparmor.security.beta.kubernetes.io"
	not startswith(key, expectedKey)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].metadata.annotations", [resourceType, name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].metadata.annotations should contain AppArmor profile config: '%s'", [resourceType, name, expectedKey]),
		"keyActualValue": sprintf("%s[%s].metadata.annotations doesn't contain AppArmor profile config: '%s'", [resourceType, name, expectedKey]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]
	metadata := resource[name].metadata
	not metadata.annotations

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s[%s].metadata", [resourceType, name]),
		"issueType": "MissingValue",
		"keyExpectedValue": sprintf("%s[%s].metadata should include annotations for AppArmor profile config", [resourceType, name]),
		"keyActualValue": sprintf("%s[%s].metadata doesn't contain AppArmor profile config in annotations", [resourceType, name]),
	}
}
