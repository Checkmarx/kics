package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Ingress"
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata
	annotations := metadata.annotations

	object.get(annotations, "kubernetes.io/ingress.class", "undefined") != "undefined"

	spec := specInfo.spec

	backend := spec.rules[x].http.paths[j].backend

	serviceName := backend.serviceName
	servicePort := backend.servicePort

	ingressControllerExposesWorload(serviceName, servicePort)

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.rules.http.paths.backend", [metadata.name, specInfo.path]),
		"keyExpectedValue": sprintf("metadata.name=%s is not exposing the workload", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is exposing the workload", [metadata.name]),
	}
}

ingressControllerExposesWorload(serviceName, servicePort) = allow {
	documents := input.document

	services := [service | documents[index].kind == "Service"; service = documents[index]]

	services[x].spec.ports[j].targetPort == servicePort

	services[x].metadata.name == serviceName

	allow = true
}
