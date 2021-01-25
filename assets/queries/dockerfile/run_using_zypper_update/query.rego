package Cx

CxPolicy[result] {
	document := input.document[i]
	commands = document.command
	some img
	some c
	commands[img][c].Cmd == "run"
	some j

	isZypperUnsafeCommand(commands[img][c].Value[j])

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instructions should not use 'zypper update'",
		"keyActualValue": sprintf("RUN instruction is invoking the '%s'", [commands[img][c].Value[j]]),
	}
}

isZypperUnsafeCommand(command) {
	contains(command, "zypper update")
}

isZypperUnsafeCommand(command) {
	contains(command, "zypper dist-upgrade")
}

isZypperUnsafeCommand(command) {
	contains(command, "zypper dup")
}

isZypperUnsafeCommand(command) {
	contains(command, "zypper up")
}
