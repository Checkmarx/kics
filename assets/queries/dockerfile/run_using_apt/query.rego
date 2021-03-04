package Cx

CxPolicy[result] {
	document := input.document[i]
	commands = document.command
	some img
	some c
	commands[img][c].Cmd == "run"
	some j
	contains(commands[img][c].Value[j], "apt ")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instructions should not use the 'apt' program",
		"keyActualValue": "RUN instruction is invoking the 'apt' program",
	}
}
