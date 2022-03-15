package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[t]][c]

	resources := object.get(container, "resources", {})
	limits := object.get(resources, "limits", {})
	not common_lib.valid_key(limits, "memory")

	metadata := document.metadata
	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[t], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.limits.memory is defined", [metadata.name, specInfo.path, types[t], container.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.limits.memory is undefined", [metadata.name, specInfo.path, types[t], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[t], c, "resources", "limits"])
	}
}
