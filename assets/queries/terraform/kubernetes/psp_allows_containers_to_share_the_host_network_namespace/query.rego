package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	spec := resource.spec

	object.get(spec, "host_network", "undefined") == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.host_network", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostNetwork' should be set to false or undefined",
		"keyActualValue": "'spec.hostNetwork' is true",
	}
}
