package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

flags := {
	"--kubelet-client-certificate",
	"--kubelet-client-key"
}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]

	common_lib.inArray(container.command, "kube-apiserver")
	flag := flags[_]
	not k8sLib.startWithFlag(container, flag)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("%s flag should be set",[flag]),
		"keyActualValue": sprintf("%s flag is not set",[flag]),
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

