package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource[resourceType]

	specInfo := tf_lib.getSpecInfo(resource[name])

	service_account_name := specInfo.spec.service_account_name

	service := input.document[j].resource.kubernetes_service_account[name_service]

	service_account_name == name_service

	result := {
		"documentId": input.document[i].id,
		"resourceType": resourceType,
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s].%s.service_account_name", [resourceType, name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s[%s].%s.service_account_name should not be shared with other workloads", [resourceType, name, specInfo.path]),
		"keyActualValue": sprintf("%s[%s].%s.service_account_name is shared with other workloads", [resourceType, name, specInfo.path]),
	}
}
