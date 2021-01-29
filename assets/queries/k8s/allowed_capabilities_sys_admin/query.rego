package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers

	add := object.get(containers[index].securityContext.capabilities, "add", "undefined")
	add != "undefined"
	add[_] == "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s. does not use CAP_SYS_ADMIN Linux capability", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s. uses CAP_SYS_ADMIN Linux capability", [specInfo.path, containers[index].name]),
	}
}
