package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service_account[name]

	resource.metadata.name == "default"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service_account[%s].metadata.name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_service_account[%s].metadata.name is not default", [name]),
		"keyActualValue": sprintf("kubernetes_service_account[%s].metadata.name is default", [name]),
	}
}
