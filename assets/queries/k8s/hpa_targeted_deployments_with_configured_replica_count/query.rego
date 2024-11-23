package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	replicasCheck := document.spec.replicas
	kindCheck := document.kind
	scaleKindCheck := input.document[j].spec.scaleTargetRef.kind

	metadata.name == input.document[j].spec.scaleTargetRef.name
	kindCheck == "Deployment"
	scaleKindCheck == "Deployment"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.replicas", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.replicas should be undefined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.replicas is defined", [metadata.name]),
	}
}
