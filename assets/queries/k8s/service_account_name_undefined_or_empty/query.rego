package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	kind := document.kind
	listKinds := ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := document.spec
	not common_lib.valid_key(spec, "serviceAccountName")

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName should be defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is undefined", [metadata.name]),
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
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.serviceAccountName", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName should not be empty", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is empty", [metadata.name]),
	}
}

checkAction(action) {
	is_string(action)
	count(action) == 0
}
