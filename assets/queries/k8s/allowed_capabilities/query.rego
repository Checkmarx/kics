package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	containers := document.spec[types[x]]

	object.get(containers[index].securityContext.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.%s.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s. does not have added capability", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s. has added capability", [specInfo.path, types[x], containers[index].name]),
	}
}
