package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	some x in types
	containers := specInfo.spec[x]

	"SYS_ADMIN" in containers[index].securityContext.capabilities.add

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.add", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s should not use CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s uses CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
	}
}
