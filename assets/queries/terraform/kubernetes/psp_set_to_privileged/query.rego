package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.privileged != false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.privileged should be set to false", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.privileged is not set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod_security_policy",name, "spec"],["privileged"]),
		"remediation": json.marshal({
			"before": sprintf("%s", [resource.spec.privileged]),
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
