package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	spec := resource.spec

	spec.host_pid == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.host_pid", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_pid' is undefined or false",
		"keyActualValue": "Attribute 'host_pid' is true",
	}
}
