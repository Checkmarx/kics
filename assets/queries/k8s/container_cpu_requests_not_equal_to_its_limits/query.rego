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

	not common_lib.valid_key(container.resources[rec[t]], "cpu")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources.%s", [document.metadata.name, specInfo.path, types[x], container.name, rec[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.%s.cpu should be defined", [types[x], container.name, rec[t]]),
		"keyActualValue": sprintf("spec.%s[%s].resources.%s.cpu is not defined", [types[x], container.name, rec[t]]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "resources", rec[t]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == k8sLib.valid_pod_spec_kind_list[_]
	specInfo := k8sLib.getSpecInfo(document)
	container := specInfo.spec[types[x]][c]

	container.resources.requests.cpu != container.resources.limits.cpu

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.resources", [document.metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.cpu is equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.cpu is not equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], c, "resources"]),
	}
}
