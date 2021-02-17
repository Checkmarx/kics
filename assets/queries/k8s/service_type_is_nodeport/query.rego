package Cx

import data.generic.k8s as k8s

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
    kind := document.kind
    listKinds := ["Service"]
	k8s.checkKind(kind, listKinds)
	spec := document.spec
	lower(spec.type) == "nodeport"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.type", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.type is not 'NodePort'",
		"keyActualValue": "spec.type is 'NodePort'",
	}
}
