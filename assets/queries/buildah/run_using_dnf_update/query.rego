package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "buildah run"
	contains_command(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("from[{{%s}}].{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Run instructions are not invoking 'dnf update'",
		"keyActualValue": sprintf("Run instruction is executing the %s command", [resource.Value]),
	}
}

contains_command(resource) {
	commands = [
		"dnf update",
		"dnf upgrade",
		"dnf upgrade-minimal",
	]

	contains(resource.Value, commands[_])
}
