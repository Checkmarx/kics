package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	command := resource.Value[0]

	contains(command, "update")
	not updateFollowedByInstall(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Instruction 'RUN <package-manager> update' is followed by 'RUN <package-manager> install' ",
		"keyActualValue": "Instruction 'RUN <package-manager> update' isn't followed by 'RUN <package-manager> install in the same 'RUN' statement",
	}
}

updateFollowedByInstall(command) {
	commandList = [
		"install",
		"source-install",
		"reinstall",
		"groupinstall",
		"localinstall",
	]

	update := indexof(command, "update")
	update != -1

	install := indexof(command, commandList[_])
	install != -1

	update < install
}
