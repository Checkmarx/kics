package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]
	resource.spec.type == "LoadBalancer"
	object.get(resource.metadata, "annotations", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service[%s].metadata.name", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'metadata.annotations' is set",
		"keyActualValue": "'metadata.annotations' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]
	object.get(resource.metadata, "annotations", "undefined") != "undefined"
	not checkLoadBalancer(resource.metadata.annotations)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service[%s].metadata.name.annotations", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.annotations using an external Load Balancer provider by cloud provider", [name]),
		"keyActualValue": sprintf("metadata.annotations is exposing a workload, not using an external Load Balancer provider by cloud provider", [name]),
	}
}

checkLoadBalancer(annotation) {
	annotation["networking.gke.io/load-balancer-type"] == "Internal"
}

checkLoadBalancer(annotation) {
	annotation["cloud.google.com/load-balancer-type"] == "Internal"
}

checkLoadBalancer(annotation) {
	annotation["service.beta.kubernetes.io/aws-load-balancer-internal"] == "true"
}

checkLoadBalancer(annotation) {
	annotation["service.beta.kubernetes.io/azure-load-balancer-internal"] == "true"
}
