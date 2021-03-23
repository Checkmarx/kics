package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.privileged != false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.privileged", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.privileged is set to false", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.privileged is not set to false", [name]),
	}
}
