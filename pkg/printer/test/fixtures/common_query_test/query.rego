package Cx

CxPolicy[result] {
	input.document[i]

	result := {
		"documentId": input.document[i].id,
		"searchKey": "",
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "",
		"keyActualValue": "",
	}
}
