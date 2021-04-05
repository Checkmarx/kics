package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service[name]

	resource.spec.type == "NodePort"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service[%s].spec.type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_service[%s].spec.type is not 'NodePort'", [name]),
		"keyActualValue": sprintf("kubernetes_service[%s].spec.type is 'NodePort'", [name]),
	}
}
