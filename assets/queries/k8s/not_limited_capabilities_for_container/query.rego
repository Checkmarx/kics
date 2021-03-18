package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)

	types := {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]
	drop := containers[c].securityContext.capabilities.drop

	not k8sLib.compareArrays(drop, ["ALL"])

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s.%s.%s.name=%s.securityContext.capabilities.drop", [metadata.name, specInfo.path, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("In metadata.name=%s.%s.%s.name=%s.securityContext.capabilities.drop, 'ALL' should be listed ", [metadata.name, specInfo.path, types[x], containers[c].name]),
		"keyActualValue": sprintf("In metadata.name=%s.%s.%s.name=%s.securityContext.capabilities.drop, 'ALL' is not listed", [metadata.name, specInfo.path, types[x], containers[c].name]),
	}
}
