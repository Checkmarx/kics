package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	object.get(spec, "serviceAccountName", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName is defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is undefined", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	spec.serviceAccountName == null

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.serviceAccountName", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName is not null", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is null", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	checkAction(spec.serviceAccountName)

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.serviceAccountName", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName is not empty", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is empty", [metadata.name]),
	}
}

checkAction(action) {
	is_string(action)
	count(action) == 0
}
