package Cx

CxPolicy[result] {
	stateful := input.document[i].resource.kubernetes_stateful_set[name]

	count({x | resource := input.document[_].resource.kubernetes_service[x]; resource.spec.cluster_ip == "None"; stateful.metadata.namespace == resource.metadata.namespace; stateful.spec.service_name == resource.metadata.name; labelsMatch(stateful, resource) == true}) == 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.service_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.service_name refers to a Headless Service", [name]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.service_name does not refer to a Headless Service", [name]),
	}
}

labelsMatch(stateful, service) {
	service.spec.selector == stateful.spec.template.metadata.labels
}
