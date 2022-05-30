package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

	common_lib.valid_key(service.spec, "selector")

	resources := [x | x := input.document[_]; matchResource(x, service.spec.selector)]
	count(resources) > 0

	servicePorts := service.spec.ports[_]
	not confirmPorts(resources, servicePorts)

	result := {
		"documentId": service.id,
		"resourceType": service.kind,
		"resourceName": metadata.name,
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

	common_lib.valid_key(service.spec, "selector")

	resources := [x | x := input.document[_]; matchResource(x, service.spec.selector)]
	count(resources) == 0

	result := {
		"documentId": service.id,
		"resourceType": service.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.selector", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.selector label refers to a Pod label", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.selector label does not match with any Pod label", [metadata.name]),
	}
}

matchResource(resource, serviceSelector) = result {
	labels := getLabelsToMatch(resource)
	count([ x | x := serviceSelector[k]; x == labels[k]]) == count(serviceSelector)
	result := resource
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

confirmPorts(resources, servicePort) {
	types := {"initContainers", "containers"}
	specInfo := k8sLib.getSpecInfo(resources[_])
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
