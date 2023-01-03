package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	object.get(document, "kind", "undefined") == "Service"

    metadata = document.metadata
	document.spec.type == "LoadBalancer"

	not common_lib.valid_key(metadata, "annotations")

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'metadata.annotations' should be set",
		"keyActualValue": "'metadata.annotations' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	object.get(document, "kind", "undefined") == "Service"

    metadata = document.metadata
	document.spec.type == "LoadBalancer"

	common_lib.valid_key(metadata, "annotations")

    annotations = metadata.annotations
    not checkLoadBalancer(annotations)

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.annotations", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}} using an external Load Balancer provider by cloud provider", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}} is exposing a workload, not using an external Load Balancer provider by cloud provider", [metadata.name]),
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
