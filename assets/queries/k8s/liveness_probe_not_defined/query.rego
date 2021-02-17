package Cx

import data.generic.k8s as k8s

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	metadata := document.metadata
	kind := document.kind
    listKinds := ["Job", "CronJob"]

	not k8s.checkKind(kind, listKinds)

	containers := spec.containers
	object.get(containers[index], "livenessProbe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.containers.name={{%s}}", [metadata.name, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.containers.name={{%s}} is defined", [metadata.name, containers[index].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.containers.name={{%s}} is undefined", [metadata.name, containers[index].name]),
	}
}
