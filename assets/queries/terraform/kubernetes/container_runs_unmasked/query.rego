package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod_security_policy[name]

	allowed_proc_mount_types := resource.spec.allowed_proc_mount_types
	allowed_proc_mount_types[_] == "Unmasked"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod_security_policy[%s].spec.allowed_proc_mount_types", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "allowed_proc_mount_types contains the value Default",
		"keyActualValue": "allowed_proc_mount_types contains the value Unmasked",
	}
}
