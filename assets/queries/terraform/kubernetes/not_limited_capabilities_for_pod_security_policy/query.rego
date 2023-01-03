package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	not common_lib.valid_key(resource.spec, "required_drop_capabilities")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.required_drop_capabilities should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.required_drop_capabilities is undefined", [name]),
	}
}
