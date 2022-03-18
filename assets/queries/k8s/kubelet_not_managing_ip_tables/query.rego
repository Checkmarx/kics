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
		"searchKey": sprintf("spec.command", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--make-iptables-util-chains flag is true or not set",
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
		"searchKey": sprintf("kind={{%s}}.makeIPTablesUtilChains", [resource.kind]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "makeIPTablesUtilChains is true",
		"keyActualValue": "makeIPTablesUtilChains is false",
	}
}
