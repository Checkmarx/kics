package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

	ports := service.spec.ports
	servicePorts := ports[j]
	ret := match_label(service.spec.selector)
	count(ret) != 0
	not confirmPorts(ret, servicePorts)

	result := {
		"documentId": service.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.ports.port={{%d}}", [metadata.name, servicePorts.port]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.ports.port={{%d}} has a Pod port", [metadata.name, servicePorts.port]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.ports.port={{%d}} does not have a Pod port", [metadata.name, servicePorts.port]),
	}
}

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

	label := service.spec.selector
	ret := match_label(label)
	count(ret) == 0

	result := {
		"documentId": service.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.selector label refers to a Pod label", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.selector label does not match with any Pod label", [metadata.name]),
	}
}

listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob"]

confirmPorts(label, servicePort) {
	types := {"initContainers", "containers"}
	resource := input.document[_]
	resource.kind == listKinds[x]
	resource.metadata.labels[_] == label[_]
	[path, value] := walk(resource.spec)
	cont := value[types[j]]
	matchPort(cont[_].ports[_], servicePort)
}

match_label(string) = ret {
	ret := {x | resource := input.document[_]; resource.kind == listKinds[_]; n := string[k]; n == resource.metadata.labels[k]; x := n}
}

matchPort(port, servicePort) {
	is_number(servicePort.targetPort)
	port.containerPort == servicePort.targetPort
} else {
	is_string(servicePort.targetPort)
	port.name == servicePort.targetPort
} else {
	not servicePort.targetPort
	port.containerPort == servicePort.port
} else = false {
	true
}