package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "run"

	command := resource.Value[0]

	containsCommand(command)
	not regex.match(`dnf\s+(-*[a-zA-Z]+\s*)*(in|rei)n?(stall)?(-*[a-z]+\s*)*\s*\w*(-|_|~|=)(\d+\.)(.+)`, command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Package version is specified when using 'dnf install'",
		"keyActualValue": "Package version should be pinned when running ´dnf install´",
	}
}

containsCommand(command) {
	instructions := split(command, "&& ")

	installCommands = [
		"install",
		"in",
		"reinstall",
		"rei",
	]

	some i
	contains(instructions[i], "dnf")
	some j
	contains(instructions[i], installCommands[j])
}
