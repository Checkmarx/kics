package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]

	object.get(containers[index].securityContext, "allowPrivilegeEscalation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name=%s.securityContext", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.%s[%s].securityContext is set", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s[%s].securityContext is undefined", [specInfo.path, types[x], containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]
	containers[index].securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name=%s.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is false", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s[%s].securityContext.allowPrivilegeEscalation is true", [specInfo.path, types[x], containers[index].name]),
	}
}
