package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
    service_account_name := resource.spec.service_account_name

    service := input.document[j].resource.kubernetes_service_account[name_service]

	service_account_name == name_service

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.service_account_name", [name]),
	    "issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.service_account_name is not shared with other workloads", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.service_account_name is shared with other workloads", [name]),
	}
}
