package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

	resource := matchResource(service.spec.selector)
	resource != false

	servicePorts := service.spec.ports[_]
	not confirmPorts(resource, servicePorts)

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

	not matchResource(service.spec.selector)

	result := {
		"documentId": service.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.selector label refers to a Pod label", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.selector label does not match with any Pod label", [metadata.name]),
	}
}

matchResource(serviceSelector) = resource {
	document := input.document[_]
	labels := getLabelsToMatch(document)
	count([ x | x := serviceSelector[k]; x == labels[k]]) == count(serviceSelector)
	resource := document
} else = false {
	true
}

getLabelsToMatch(document) = labels {
	matchLabelsKinds := {"Deployment", "DaemonSet", "ReplicaSet", "StatefulSet", "Job"}
	document.kind == matchLabelsKinds[_]
	labels := document.spec.selector.matchLabels
} else = labels {
	document.kind == "CronJob"
	jobTemplates := {"job_template", "jobTemplate"}
	labels := document.spec[jobTemplates[t]].spec.selector.matchLabels
} else = labels {
	podTemplateKinds := {"Pod", "ReplicationController"}
	document.kind == podTemplateKinds[_]
	labels := document.metadata.labels
}

confirmPorts(resource, servicePort) {
	types := {"initContainers", "containers"}
	specInfo := k8sLib.getSpecInfo(resource)
	matchPort(specInfo.spec[types[x]][_].ports[_], servicePort)
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