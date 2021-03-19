package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "add"
	httpRequestChecker(resource.Value)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'CURL' or 'WGET' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}

httpRequestChecker(cmdValue) {
	regex.match("https?", cmdValue[_])
}
