package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role_binding[name]

	resource.subject[k].kind == "ServiceAccount"

	resource.subject[k].name == "default"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_role_binding",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("resource.kubernetes_role_binding[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.kubernetes_role_binding[%s].subject[%d].name should not be default", [name, k]),
		"keyActualValue": sprintf("resource.kubernetes_role_binding[%s].subject[%d].name is default", [name, k]),
	}
}
