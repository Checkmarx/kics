package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	container.securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is false", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is true", [metadata.name, specInfo.path, types[x], container.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	containerCtx := object.get(container, "securityContext", {})
	not common_lib.valid_key(containerCtx, "allowPrivilegeEscalation")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is set and is true", [metadata.name, specInfo.path, types[x], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation is undefined", [metadata.name, specInfo.path, types[x], container.name]),
	}
}
