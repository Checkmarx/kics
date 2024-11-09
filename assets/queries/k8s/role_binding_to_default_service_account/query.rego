package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	document.kind == "RoleBinding"
	subjects := document.subjects
	subjects[c].kind == "ServiceAccount"
	subjects[c].name == "default"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("subjects.name=%s", [subjects[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "subjects.kind=ServiceAccount.name should not be default",
		"keyActualValue": "subjects.kind=ServiceAccount.name is default",
	}
}
