package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.allowed_capabilities

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_capabilities", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Pod Security Policy %s should not have allowed capabilities", [name]),
		"keyActualValue": sprintf("Pod Security Policy %s has allowed capabilities", [name]),
	}
}
