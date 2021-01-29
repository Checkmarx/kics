package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers

	object.get(containers[index].securityContext.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s. does not have added capability", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s. has added capability", [specInfo.path, containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	initContainers := document.spec.initContainers

	object.get(initContainers[index].securityContext.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.initContainers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, initContainers[index].name]),
		"keyExpectedValue": sprintf("%s.initContainers.name=%s. does not have added capability", [specInfo.path, initContainers[index].name]),
		"keyActualValue": sprintf("%s.initContainers.name=%s. has added capability", [specInfo.path, initContainers[index].name]),
	}
}
