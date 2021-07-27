package Cx

CxPolicy[result] {
	content := input.document[i].contentVersion
	content == "1.0.0.0"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "contentVersion",
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "1.0.0.0 content version",
		"keyActualValue": sprintf("%s content version", [content]),
	}
}
