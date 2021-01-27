package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "run"
	containsCommand(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run instructions are not invoking 'dnf update'",
		"keyActualValue": sprintf("Run instruction is executing the %s command", [resource.Value[0]]),
	}
}

containsCommand(cmds) {
	commands = [
		"dnf update",
		"dnf upgrade",
		"dnf upgrade-minimal",
	]

	contains(cmds.Value[_], commands[_])
}
