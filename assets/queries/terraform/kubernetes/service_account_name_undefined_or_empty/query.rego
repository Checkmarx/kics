package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
    object.get(spec, "service_account_name", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.service_account_name is defined", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.service_account_name is undefined", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	service_account_name := resource.spec.service_account_name
    service_account_name == ["", null][j]

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.service_account_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.service_account_name is correct", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.service_account_name is null or empty", [name]),
	}
}
