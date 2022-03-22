package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

command = {"kube-apiserver", "kubelet", "kube-controller-manager"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
    cmd := command[_]
	common_lib.inArray(container.command, cmd)
	featureGatesHasFlag(container)
    

	result := {

		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Rotate Kubelet Server Certificate feature gate should be set to true",
		"keyActualValue": "Rotate Kubelet Server Certificate feature gate is set to false",
	}
}

featureGatesHasFlag(container){
	featureGatesContains(container.command)
} else {
	featureGatesContains(container.args)
}

featureGatesContains(arr) {
	index := arr[_]
	startswith(index,"--feature-gates")
    contains(index,"'RotateKubeletServerCertificate=false'")
}


CxPolicy[result] {
	doc :=input.document[i]
    doc.kind == "KubeletConfiguration"
    doc.featureGates.RotateKubeletClientCertificate == false

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("kind={{%s}}", ["KubeletConfiguration"]),
		"issueType": "IncorrectValue",
		"keyExpectedValue":  "Rotate Kubelet Server Certificate feature gate should be set to true",
		"keyActualValue": "Rotate Kubelet Server Certificate feature gate is set to false",
	}
}
