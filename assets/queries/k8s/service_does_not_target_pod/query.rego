package Cx

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	ports := service.spec.ports
	servicePorts := ports[j]
	contains(service.spec.selector.app)
	not confirmPorts(servicePorts)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.ports.name=%s.targetPort", [metadata.name, ports[k].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.ports=%s.targetPort has a Pod Port", [metadata.name, servicePorts.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.ports=%s.targetPort does not have a Pod Port", [metadata.name, servicePorts.name]),
	}
}

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata
	ports := service.spec.ports
	servicePorts := ports[j]
	not contains(service.spec.selector.app)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.selector.app", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.selector.app Pod label match with Service", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.selector.app Pod label does not match with Service", [metadata.name]),
	}
}

confirmPorts(servicePorts) {
	pod := input.document[i]
	pod.kind == "Pod"
	containers := pod.spec.containers[j]
	containers.ports[k].containerPort == servicePorts.targetPort
} else = false {
	true
}

contains(string) {
	pod := input.document[i]
	pod.kind == "Pod"
	pod.metadata.labels.app == string
} else = false {
	true
}
