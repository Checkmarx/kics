package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	container := resource.spec.container

	object.get(container, "liveness_probe", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'livenessProbe' is defined",
		"keyActualValue": "Attribute 'livenessProbe' is undefined",
	}
}
