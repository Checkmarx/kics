package Cx

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	ports := service.spec.ports
	servicePorts := ports[j]
	contains(service.spec.selector[_])
	confirmPorts(servicePorts) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.ports.name=%s.targetPort", [metadata.name, ports[j].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.ports=%s.targetPort has a Pod Port", [metadata.name, servicePorts.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.ports=%s.targetPort does not have a Pod Port", [metadata.name, servicePorts.name]),
	}
}

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	contains(service.spec.selector[_]) == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.selector label refers to a Pod label ", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.selector label does not match with any Pod label", [metadata.name]),
	}
}

confirmPorts(servicePorts) {
	pod := input.document[i]
	pod.kind == "Pod"
	types := {"initContainers", "containers"}
	containers := pod.spec[types[x]][j]
	containers.ports[k].containerPort == servicePorts.targetPort
} else = false {
	true
}

contains(string) {
	pod := input.document[i]
	pod.kind == "Pod"
	pod.metadata.labels[_] == string
} else = false {
	true
}
