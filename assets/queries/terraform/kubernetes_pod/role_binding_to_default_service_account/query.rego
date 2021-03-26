package Cx

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_role_binding[name]

	resource.subject[k].kind == "ServiceAccount"

	resource.subject[k].name == "default"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resource.kubernetes_role_binding[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.kubernetes_role_binding[%s].subject[%d].name is not default", [name, k]),
		"keyActualValue": sprintf("resource.kubernetes_role_binding[%s].subject[%d].name is default", [name, k]),
	}
}
