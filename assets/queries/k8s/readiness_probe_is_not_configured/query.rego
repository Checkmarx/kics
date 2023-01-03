package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	listKinds := ["Job", "CronJob"]
	not k8sLib.checkKind(document.kind, listKinds)

	container := specInfo.spec.containers[_]
	not common_lib.valid_key(container, "readinessProbe")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}}", [metadata.name, specInfo.path, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}}.readinessProbe should be defined", [metadata.name, specInfo.path, container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}}.readinessProbe is undefined", [metadata.name, specInfo.path, container.name]),
	}
}
