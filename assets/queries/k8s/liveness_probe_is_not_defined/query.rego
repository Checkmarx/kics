package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	kind := document.kind
    listKinds := ["Job", "CronJob"]

	not k8sLib.checkKind(kind, listKinds)

	containers := specInfo.spec.containers
	object.get(containers[index], "livenessProbe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}}", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}} is defined", [metadata.name, specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}} is undefined", [metadata.name, specInfo.path, containers[index].name]),
	}
}
