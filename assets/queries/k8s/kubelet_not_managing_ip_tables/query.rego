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
	k8sLib.hasFlag(container, "--make-iptables-util-chains=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--make-iptables-util-chains flag to be true",
		"keyActualValue": "--make-iptables-util-chains= flag is false",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
    resource.kind == "KubeletConfiguration"
    resource.makeIPTablesUtilChains == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{KubeletConfiguration}}.makeIPTablesUtilChains",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "makeIPTablesUtilChains to be true",
		"keyActualValue": "makeIPTablesUtilChains is false",
	}
}
