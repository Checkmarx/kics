package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_ingress[name]
    metadata := resource.metadata
    annotations := metadata.annotations

	common_lib.valid_key(annotations, "kubernetes.io/ingress.class")

	spec := resource.spec

	contentRule(spec)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_ingress",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_ingress[%s].spec.rule.http.path.backend", [name]),
	    "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_ingress[%s] should not be exposing the workload", [name]),
		"keyActualValue": sprintf("kubernetes_ingress[%s] is exposing the workload", [name]),
	}
}

ingressControllerExposesWorload(service_name, service_port) {
	services :=  input.document[i].resource.kubernetes_service[name]

	services.spec.port.target_port == service_port
	name == service_name
}

contentRule(spec) { #rule[r] and path
	is_array(spec.rule)
    backend := spec.rule[r].http.path.backend
	ingressControllerExposesWorload(backend.service_name, backend.service_port)
} else { #rule and path
    backend := spec.rule.http.path.backend
	ingressControllerExposesWorload(backend.service_name, backend.service_port)
} else { #rule[r] and path[p]
	is_array(spec.rule)
    is_array(spec.rule[r].http.path)
    backend := spec.rule[r].http.path[p].backend
	ingressControllerExposesWorload(backend.service_name, backend.service_port)
} else { #rule and path[p]
	is_array(spec.rule.http.path)
	backend := spec.rule.http.path[p].backend
	ingressControllerExposesWorload(backend.service_name, backend.service_port)
}
