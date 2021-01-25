package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Ingress"
	specInfo := getSpecInfo(document)
	metadata := document.metadata
	annotations := metadata.annotations

	object.get(annotations, "kubernetes.io/ingress.class", "undefined") != "undefined"

	spec := document.spec

	backend := spec.rules[x].http.paths[j].backend

	serviceName := backend.serviceName
	servicePort := backend.servicePort

	ingressControllerExposesWorload(serviceName, servicePort)

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.rules.http.paths.backend", [metadata.name, specInfo.path]),
		"keyExpectedValue": sprintf("metadata.name=%s is not exposing the workload", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is exposing the workload", [metadata.name]),
	}
}

getSpecInfo(document) = specInfo {
	templates := {"job_template", "jobTemplate"}
	spec := document.spec[templates[t]].spec.template.spec
	specInfo := {"spec": spec, "path": sprintf("spec.%s.spec.template.spec", [templates[t]])}
} else = specInfo {
	spec := document.spec.template.spec
	specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
	spec := document.spec
	specInfo := {"spec": spec, "path": "spec"}
}

ingressControllerExposesWorload(serviceName, servicePort) = allow {
	documents := input.document

	services := [service | documents[index].kind == "Service"; service = documents[index]]

	services[x].spec.ports[j].targetPort == servicePort

	services[x].metadata.name == serviceName

	allow = true
}
