package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]

	resource.spec.type == "NodePort"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_service",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_service[%s].spec.type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_service[%s].spec.type should not be 'NodePort'", [name]),
		"keyActualValue": sprintf("kubernetes_service[%s].spec.type is 'NodePort'", [name]),
	}
}
