package Cx

CxPolicy[result] {
	document1 := input.document[i].resource.kubernetes_service[name]
	metadata := document1.metadata
	specs := document1.spec
	specs.cluster_ip != "None"

	document2 := input.document[j].resource.kubernetes_stateful_set[x]
	document2.spec.selector.match_labels == document2.spec.template.metadata.labels
	metadata.name == document2.spec.service_name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_stateful_set[%s].spec.service_name", [x]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_stateful_set[%s].spec.service_name refers to a Headless Service", [x]),
		"keyActualValue": sprintf("kubernetes_stateful_set[%s].spec.service_name doesn't refers to a Headless Service", [x]),
	}
}
