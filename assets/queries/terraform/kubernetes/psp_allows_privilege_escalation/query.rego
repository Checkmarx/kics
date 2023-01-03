package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	not common_lib.valid_key(resource.spec, "allow_privilege_escalation")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation should be set", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is undefined", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod_security_policy",name, "spec"],[]),
		"remediation": "allow_privilege_escalation = false",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.allow_privilege_escalation != false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod_security_policy",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation should be set to false", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is set to true", [name]),
		"searchLine": common_lib.build_search_line(["resource", "kubernetes_pod_security_policy",name, "spec"],["allow_privilege_escalation"]),
		"remediation": json.marshal({
			"before": sprintf("%s",[resource.spec.allow_privilege_escalation]),
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}
