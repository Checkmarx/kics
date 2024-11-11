package Cx

import data.generic.k8s
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	kind := document.kind
	listKinds := ["Service"]
	k8s.checkKind(kind, listKinds)
	spec := document.spec
	lower(spec.type) == "nodeport"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.type", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "spec.type should not be 'NodePort'",
		"keyActualValue": "spec.type is 'NodePort'",
	}
}
