package Cx

CxPolicy[result] {
	instruction := input.document[i].command[name][j]

	instruction.Cmd == "run"
	regex.match(`.*apk.*upgrade`, instruction.Value[0])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, instruction.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("RUN command '%s' should not have apk upgrade instruction", [instruction.Value[0]]),
		"keyActualValue": sprintf("RUN '%s' has apk upgrade instruction", [instruction.Value[0]]),
	}
}
