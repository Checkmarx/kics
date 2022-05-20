package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

kubernetesCommand := {"kube-apiserver", "kube-controller-manager", "kube-scheduler"}
kubernetesCommandWithoutDeprecation := {"kube-apiserver", "kube-controller-manager"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := kubernetesCommand[_]
	common_lib.inArray(container.command, command)
	k8sLib.hasFlag(container, "--profiling=true")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--profiling flag should be set to false",
		"keyActualValue": "--profiling flag is set to true",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := kubernetesCommandWithoutDeprecation[_]
	common_lib.inArray(container.command, command)
	not k8sLib.startWithFlag(container, "--profiling")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--profiling flag should be defined and set to false",
		"keyActualValue": "--profiling flag is not defined",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "KubeSchedulerConfiguration"
	document.enableProfiling == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeSchedulerConfiguration}}.enableProfiling",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "enableProfiling argument flag should be set to false",
		"keyActualValue": "enableProfiling argument is set to true",
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "KubeSchedulerConfiguration"
	not common_lib.valid_key(document, "enableProfiling")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeSchedulerConfiguration}}",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "enableProfiling argument flag should be defined and set to false",
		"keyActualValue": "enableProfiling argument is not defined",
	}
}
