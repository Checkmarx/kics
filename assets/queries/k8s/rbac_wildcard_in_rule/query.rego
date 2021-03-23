package Cx

import data.generic.k8s as k8s

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
    kind := document.kind
    listKinds := ["Role", "ClusterRole"]
	k8s.checkKind(kind, listKinds)
	metadata.name
	notExpectedKey := "*"
	document.rules[r].apiGroups[j] == notExpectedKey

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].apiGroups shouldn't contain value: '%s'", [metadata.name, r, notExpectedKey]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].apiGroups contains value: '%s'", [metadata.name, r, notExpectedKey]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	kind := document.kind
    listKinds := ["Role", "ClusterRole"]
	k8s.checkKind(kind, listKinds)
	metadata.name
	notExpectedKey := "*"
	document.rules[r].resources[j] == notExpectedKey

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].resources shouldn't contain value: '%s'", [metadata.name, r, notExpectedKey]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].resources contains value: '%s'", [metadata.name, r, notExpectedKey]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	kind := document.kind
    listKinds := ["Role", "ClusterRole"]
	k8s.checkKind(kind, listKinds)
	metadata.name
	notExpectedKey := "*"
	document.rules[r].verbs[j] == notExpectedKey

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.rules", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.rules[%d].verbs shouldn't contain value: '%s'", [metadata.name, r, notExpectedKey]),
		"keyActualValue": sprintf("metadata.name={{%s}}.rules[%d].verbs contains value: '%s'", [metadata.name, r, notExpectedKey]),
	}
}
