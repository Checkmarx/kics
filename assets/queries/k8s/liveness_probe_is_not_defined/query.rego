package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	kind := document.kind
	listKinds := ["Job", "CronJob"]

	not k8sLib.checkKind(kind, listKinds)

	containers := specInfo.spec.containers
	not common_lib.valid_key(containers[index], "livenessProbe")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.containers.name={{%s}}", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.containers.name={{%s}}.livenessProbe should be defined", [metadata.name, containers[index].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.containers.name={{%s}}.livenessProbe is undefined", [metadata.name, containers[index].name]),
	}
}
