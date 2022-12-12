package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types = {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	common_lib.valid_key(container.securityContext.capabilities, "add")
	container.securityContext.capabilities.add[_] != "NET_BIND_SERVICE"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.add", [metadata.name, specInfo.path, types[x], container.name]),
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}} has no capability added other than NET_BIND_SERVICE", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}} has a capability added other than NET_BIND_SERVICE", [metadata.name, specInfo.path, types[x], container.name]),
	}
}
