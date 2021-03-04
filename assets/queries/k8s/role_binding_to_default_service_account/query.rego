package Cx

CxPolicy[result] {
	document := input.document[i]
	subjects := document.subjects
	subjects[c].kind == "ServiceAccount"
	subjects[c].name == "default"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("subjects.name=%s", [subjects[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "subjects.kind=ServiceAccount.name is not default",
		"keyActualValue": "subjects.kind=ServiceAccount.name is default",
	}
}
