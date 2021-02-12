package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)

	metadata := document.metadata

	spec := document.spec

	document.kind == "Pod"

	object.get(spec, "securityContext", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": sprintf("metadata.name=%s.%s has a security context", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name=%s.%s does not have a security context", [metadata.name, specInfo.path]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)

	metadata := document.metadata

	containers := document.spec.containers

	object.get(containers[index], "securityContext", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s has a security context", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s does not have a security context", [specInfo.path, containers[index].name]),
	}
}
