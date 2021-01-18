package Cx

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

	not CheckIfDestinationPortExists(service)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s is not exposing a workload", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s is exposing a workload", [metadata.name]),
	}
}

CheckIfDestinationPortExists(service) = result {
	documents := input.document
	pod := [pod | documents[index].spec.template.metadata.labels.app == service.spec.selector.app; pod = documents[index]]
	service.spec.type == "LoadBalancer"

	result := contains(pod, service.spec.selector.app)
	contains(pod, service.spec.ports[k].targetPort)
}

contains(array, string) {
	array[a].spec.template.metadata.labels.app == string
}

contains(array, string) {
	array[a].spec.template.spec.containers[c].ports[p].containerPort == string
}
