package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.allowed_capabilities

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_capabilities", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Pod Security Policy %s does not have allowed capabilities", [name]),
		"keyActualValue": sprintf("Pod Security Policy %s has allowed capabilities", [name]),
	}
}
