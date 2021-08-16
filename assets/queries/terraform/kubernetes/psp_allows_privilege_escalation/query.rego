package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	not common_lib.valid_key(resource.spec, "allow_privilege_escalation")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is set", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.allow_privilege_escalation != false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is set to false", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.allow_privilege_escalation is set to true", [name]),
	}
}
