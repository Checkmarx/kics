package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	container := resource.spec.container

	container.image_pull_policy != "Always"

	not contains(container.image, ":latest")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.container.image_pull_policy", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'image_pull_policy' should be defined as 'Always'",
		"keyActualValue": "Attribute 'image_pull_policy' is incorrect",
	}
}
