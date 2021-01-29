package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers

	object.get(containers[index].securityContext, "allowPrivilegeEscalation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.containers[%s].securityContext is set", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers[%s].securityContext is undefined", [specInfo.path, containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers
	containers[index].securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is false", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is true", [specInfo.path, containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.initContainers

	object.get(containers[index].securityContext, "allowPrivilegeEscalation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.initContainers.name=%s.securityContext", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s.containers[%s].securityContext is set", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers[%s].securityContext is undefined", [specInfo.path, containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.initContainers
	containers[index].securityContext.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.initContainers.name=%s.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, containers[index].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is false", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is true", [specInfo.path, containers[index].name]),
	}
}
