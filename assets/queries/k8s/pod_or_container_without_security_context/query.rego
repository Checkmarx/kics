package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)

	metadata := document.metadata

	spec := specInfo.spec

	document.kind == "Pod"

	object.get(spec, "securityContext", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s has a security context", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s does not have a security context", [metadata.name, specInfo.path]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)

	metadata := document.metadata

    types := {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]

	object.get(containers[index], "securityContext", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name=%s", [metadata.name, specInfo.path, types[x], containers[index].name]),
		"keyExpectedValue": sprintf("%s.%s.name=%s has a security context", [specInfo.path, types[x], containers[index].name]),
		"keyActualValue": sprintf("%s.%s.name=%s does not have a security context", [specInfo.path, types[x], containers[index].name]),
	}
}
