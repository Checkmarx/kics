package Cx

import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)

	types := {"initContainers", "containers"}
	containers := specInfo.spec[types[x]]
	check_image_content(containers[j])

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image", [metadata.name, specInfo.path, types[x], containers[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image has not kubernetes-dashboard deployed", [metadata.name, specInfo.path, types[x], containers[j].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.image has kubernetes-dashboard deployed", [metadata.name, specInfo.path, types[x], containers[j].name]),
	}
}

check_image_content(containers) {
	contains(containers.image, "kubernetes-dashboard")
}

check_image_content(containers) {
	contains(containers.image, "kubernetesui")
}
