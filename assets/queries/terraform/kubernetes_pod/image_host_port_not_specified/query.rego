package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	container := resource.spec.container

	object.get(container.port, "host_port", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container.port", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'host_port' is defined",
		"keyActualValue": "Attribute 'host_port' is undefined",
	}
}
