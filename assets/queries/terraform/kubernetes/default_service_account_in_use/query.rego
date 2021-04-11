package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service_account[name]

	resource.metadata.name == "default"

	object.get(resource, "automount_service_account_token", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is set", [name]),
		"keyActualValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_service_account[name]

	resource.metadata.name == "default"

	resource.automount_service_account_token == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_service_account[%s].automount_service_account_token", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is set to false", [name]),
		"keyActualValue": sprintf("kubernetes_service_account[%s].automount_service_account_token is not set to false", [name]),
	}
}
