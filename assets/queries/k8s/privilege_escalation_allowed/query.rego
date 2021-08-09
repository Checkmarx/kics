package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]

	not common_lib.valid_key(containers[index].securityContext, "allowPrivilegeEscalation")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is set", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is undefined", [specInfo.path, types[x], containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := specInfo.spec[types[x]]
	containers[index].securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is false", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is true", [specInfo.path, types[x], containers[index].name]),
	}
}
