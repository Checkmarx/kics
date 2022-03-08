package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[t]][_]

	resources := object.get(container, "resources", {})
	requests := object.get(resources, "requests", {})
	not common_lib.valid_key(requests, "memory")

	metadata := document.metadata
	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests", [metadata.name, specInfo.path, types[t], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests.memory is defined", [metadata.name, specInfo.path, types[t], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.requests.memory is undefined", [metadata.name, specInfo.path, types[t], container.name]),
	}
}
