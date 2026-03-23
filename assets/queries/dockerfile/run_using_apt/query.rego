package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	document := input.document[i]
	commands = document.command
	some img
	some c
	commands[img][c].Cmd == "run"
	some j
	contains(commands[img][c].Value[j], "apt ")

	from_command := dockerLib.get_original_from_command(commands[img])
	result := {
		"documentId": document.id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, img, commands[img][c].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instructions should not use the 'apt' program",
		"keyActualValue": "RUN instruction is invoking the 'apt' program",
	}
}
