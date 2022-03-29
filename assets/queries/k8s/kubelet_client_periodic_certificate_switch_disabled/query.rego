package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := "kubelet"

	common_lib.inArray(container.command, command)
	k8sLib.hasFlag(container, "--rotate-certificates=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--rotate-certificates flag to be true",
		"keyActualValue": "--rotate-certificates flag is false",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
    resource.kind == "KubeletConfiguration"
    resource.rotateCertificates == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{KubeletConfiguration}}.rotateCertificates",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "rotateCertificates to be true",
		"keyActualValue": "rotateCertificates is false",
	}
}

CxPolicy[result] {
	resource := input.document[i]
    resource.kind == "KubeletConfiguration"
    not common_lib.valid_key(resource, "rotateCertificates")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{KubeletConfiguration}}.rotateCertificates",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "rotateCertificates to be true",
		"keyActualValue": "rotateCertificates is not set (default is false)",
	}
}
