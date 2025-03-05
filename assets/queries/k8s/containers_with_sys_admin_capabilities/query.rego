package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	document := input.document[i]

	types = {"initContainers", "containers"}
	specInfo := k8sLib.getSpecInfo(document)
	containers := specInfo.spec[types[x]]

	"SYS_ADMIN" in containers[index].securityContext.capabilities.add
	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.add", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s should not use CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s uses CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
	}
}
