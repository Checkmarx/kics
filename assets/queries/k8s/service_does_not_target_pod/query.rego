package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	ports := service.spec.ports
	servicePorts := ports[j]
	label := service.spec.selector[_]
	match_label(label)
	not confirmPorts(label, servicePorts)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.ports.name={{%s}}.targetPort", [metadata.name, ports[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.ports={{%s}}.targetPort has a Pod Port", [metadata.name, servicePorts.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.ports={{%s}}.targetPort does not have a Pod Port", [metadata.name, servicePorts.name]),
	}
}

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	label := service.spec.selector[_]
	not match_label(label)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.selector label refers to a Pod label ", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.selector label does not match with any Pod label", [metadata.name]),
	}
}

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob"]

confirmPorts(label, servicePorts) {
	resource := input.document[_]
	resource.kind == listKinds[x]
	resource.metadata.labels[_] == label
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	containers := specInfo.spec[types[j]]
	containers[_].ports[_].containerPort == servicePorts.targetPort
}

match_label(string) {
	resource := input.document[_]
	resource.kind == listKinds[x]
	resource.metadata.labels[_] == string
}
