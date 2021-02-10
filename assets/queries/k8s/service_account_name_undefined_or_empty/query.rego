package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	metadata := input.document[i].metadata

    kind := input.document[i].kind
    listKinds :=  ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := input.document[i].spec
	object.get(spec, "serviceAccountName", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName is defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is undefined", [metadata.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata

    kind := input.document[i].kind
    listKinds :=  ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := input.document[i].spec
	spec.serviceAccountName == null

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.serviceAccountName", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.serviceAccountName is not null", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.serviceAccountName is null", [metadata.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata

    kind := input.document[i].kind
    listKinds :=  ["Pod"]
	k8sLib.checkKind(kind, listKinds)

	spec := input.document[i].spec
	checkAction(spec.serviceAccountName)

	result := {
		"documentId": input.document[i].id,
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
