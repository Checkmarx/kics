package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	document.kind == k8sLib.valid_pod_spec_kind_list[_]
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]
	rec := {"requests", "limits"}

	not common_lib.valid_key(container.resources[rec[t]], "memory")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.%s", [document.metadata.name,specInfo.path, types[x], container.name, rec[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.%s.memory should be defined", [types[x], container.name, rec[t]]),
		"keyActualValue": sprintf("spec.%s[%s].resources.%s.memory is not defined", [types[x], container.name, rec[t]]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "resources", rec[t]])
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == k8sLib.valid_pod_spec_kind_list[_]

	specInfo := k8sLib.getSpecInfo(document)
	types := {"initContainers", "containers"}

	container := specInfo.spec[types[x]][c]

	container.resources.requests.memory != container.resources.limits.memory

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources", [document.metadata.name, specInfo.path,types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.memory is equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.memory is not equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "resources"])
	}
}
