package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.host_ipc == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.host_ipc", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' should be undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod_security_policy",name, "spec"],["host_ipc"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
