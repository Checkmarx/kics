package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	container := resource.spec.container

	container.allow_privilege_escalation == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container.allow_privilege_escalation", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'allow_privilege_escalation' is undefined or false",
		"keyActualValue": "Attribute 'allow_privilege_escalation' is true",
	}
}
