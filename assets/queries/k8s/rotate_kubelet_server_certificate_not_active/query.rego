package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

commandList = {"kubelet", "kube-controller-manager"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := commandList[_]

	common_lib.inArray(container.command, command)
	k8sLib.startWithFlag(container,"--feature-gates=")
	contains_feature(container, "RotateKubeletServerCertificate=false")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--feature-gates=RotateKubeletServerCertificate flag should be true",
		"keyActualValue": "--feature-gates=RotateKubeletServerCertificate flag is false",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
    resource.kind == "KubeletConfiguration"
    featureGates := resource.featureGates
    featureGates.RotateKubeletServerCertificate == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.featureGates",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RotateKubeletServerCertificates should be true",
		"keyActualValue": "RotateKubeletServerCertificate is false",
	}
}


contains_feature(container, feature){
	contains_in_array(container.command, feature)
} else {
	contains_in_array(container.args, feature)
}

contains_in_array(arr, item) {
    contains(arr[_], item)
}
