package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	resource.spec.host_ipc == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.host_ipc", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_ipc' is undefined or false",
		"keyActualValue": "Attribute 'host_ipc' is true",
	}
}
