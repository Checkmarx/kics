package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := "kubelet"

	common_lib.inArray(container.command, command)
	k8sLib.hasFlag(container, "--feature-gates=RotateKubeletServerCertificate=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.command", []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--feature-gates=RotateKubeletServerCertificate flag to be true",
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
		"searchKey": "kind={{KubeletConfiguration}}.featureGates",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RotateKubeletServerCertificates to be true",
		"keyActualValue": "RotateKubeletServerCertificate is false",
	}
}
