package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "run"
	containsCommand(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There are no dangerous commands or utilities being executed",
		"keyActualValue": sprintf("Run instruction is executing the %s command", [resource.Value[0]]),
	}
}

containsCommand(cmds) {
	commands = [
		"shutdown",
		"service",
		"ps",
		"free",
		"top",
		"kill",
		"mount",
		"ifconfig",
		"nano",
		"vim",
	]

	contains(cmds.Value[_], commands[_])
}
