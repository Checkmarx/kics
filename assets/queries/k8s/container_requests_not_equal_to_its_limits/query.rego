package Cx

import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][_]

	resourceTypes := {"cpu", "memory"}
	container.resources.requests[resourceTypes[t]] != container.resources.limits[resourceTypes[t]]

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests.%s is equal to resources.limits.%s", [metadata.name, specInfo.path, types[x], container.name, resourceTypes[t], resourceTypes[t]]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests.%s is not equal to resources.limits.%s", [metadata.name, specInfo.path, types[x], container.name, resourceTypes[t], resourceTypes[t]]),
	}
}
