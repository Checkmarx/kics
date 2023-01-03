package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]
	resource.spec.type == "LoadBalancer"
	not common_lib.valid_key(resource.metadata, "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_service[%s].metadata.name", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'metadata.annotations' should be set",
		"keyActualValue": "'metadata.annotations' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]
	common_lib.valid_key(resource.metadata, "annotations")
	not checkLoadBalancer(resource.metadata.annotations)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
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
