package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	resource.spec.container

	not resource.spec.container.resources

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'resources' is set",
		"keyActualValue": "Attribute 'resources' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	resource.spec.container.resources

	not resource.spec.container.resources.limits

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container.resources", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'container' has resource limitations defined",
		"keyActualValue": "Attribute 'container' does not have resource limitations defined",
	}
}
