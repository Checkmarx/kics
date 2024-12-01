package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some resource in input.document
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	k8sLib.startWithFlag(container, "--audit-log-maxsize")
	not k8sLib.hasFlagEqualOrGreaterThanValue(container, "--audit-log-maxsize", 100)

	result := {
		"documentId": resource.id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--audit-log-maxsize flag should be set to 100 or more MegaBytes",
		"keyActualValue": "--audit-log-maxsize flag is set to less than 100 MegaBytes",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

CxPolicy[result] {
	some resource in input.document
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-apiserver")
	not k8sLib.startWithFlag(container, "--audit-log-maxsize")

	result := {
		"documentId": resource.id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--audit-log-maxsize flag should be defined and set to 100 or more MegaBytes",
		"keyActualValue": "--audit-log-maxsize flag is not defined",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}
