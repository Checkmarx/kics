package Cx

CxPolicy[result] {
	service := input.document[i]
	service.kind == "Service"
	metadata := service.metadata

    service.spec.type == "LoadBalancer"
    service.spec.selector.app

	documents := input.document
	pod := [pod | documents[index].spec.template.metadata.labels.app == service.spec.selector.app; pod = documents[index]]
	count(pod) != 0
	checkLabels(pod, service.spec.selector.app)
	res := checkPorts(pod, service.spec.ports[k].targetPort)
	res == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}} is not exposing a workload", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}} is exposing a workload", [metadata.name]),
	}
}


checkLabels(array, string) = labels {
	array[a].spec.template.metadata.labels.app == string
    labels := 1
} else {
	labels := 0
}
checkPorts(array, string) = port {
	array[a].spec.template.spec.containers[c].ports[p].containerPort == string
    port := 1
} else {
	port := 0
}
