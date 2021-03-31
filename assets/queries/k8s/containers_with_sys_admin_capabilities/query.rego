package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	types = {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]

	add := object.get(containers[index].securityContext.capabilities, "add", "undefined")
	add != "undefined"
	add[_] == "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.securityContext.capabilities.add", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s does not use CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s uses CAP_SYS_ADMIN Linux capability", [specInfo.path, types[x], containers[index].name]),
	}
}
