package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	object.get(spec, "hostAliases", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.hostAliases is defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.hostAliases is undefined", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	spec.hostAliases == null

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostAliases", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.hostAliases is not null", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.hostAliases is null", [metadata.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	checkAction(spec.hostAliases)

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostAliases", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.hostAliases is not empty", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.hostAliases is empty", [metadata.name]),
	}
}

checkAction(action) {
	is_array(action)
	count(action) == 0
}
