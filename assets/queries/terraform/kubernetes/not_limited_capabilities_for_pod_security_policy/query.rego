package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	object.get(resource.spec, "required_drop_capabilities", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod_security_policy[%s].spec.required_drop_capabilities is set", [name]),
		"keyActualValue": sprintf("kubernetes_pod_security_policy[%s].spec.required_drop_capabilities is undefined", [name]),
	}
}
