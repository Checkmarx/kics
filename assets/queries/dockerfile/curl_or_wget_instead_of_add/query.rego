package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][j]
	resource.Cmd == "add"
	httpRequestChecker(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Should use 'curl' or 'wget' to download %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}

httpRequestChecker(cmdValue) {
	regex.match("https?://", cmdValue[_])
}
