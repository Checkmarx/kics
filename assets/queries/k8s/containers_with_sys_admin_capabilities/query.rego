package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]

	containers[index].securityContext.capabilities.add[_] == "SYS_ADMIN"

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
