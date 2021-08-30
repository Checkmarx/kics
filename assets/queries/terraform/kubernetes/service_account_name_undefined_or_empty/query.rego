package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	spec := resource.spec
    not common_lib.valid_key(spec, "service_account_name")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.service_account_name is defined and not null", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.service_account_name is undefined or null", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]

	service_account_name := resource.spec.service_account_name
    service_account_name == ""

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("kubernetes_pod[%s].spec.service_account_name", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].spec.service_account_name is correct", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].spec.service_account_name is null or empty", [name]),
	}
}
