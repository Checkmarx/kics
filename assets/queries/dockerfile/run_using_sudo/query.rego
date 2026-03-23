package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1

	hasSudo(resource.Value[0])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.RUN={{%s}}", [from_command, name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction shouldn't contain sudo",
		"keyActualValue": "RUN instruction contains sudo",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) > 1

	resource.Value[0] == "sudo"

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.RUN={{%s}}", [from_command, name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instruction shouldn't contain sudo",
		"keyActualValue": "RUN instruction contains sudo",
	}
}

hasSudo(commands) {
	commandsList = dockerLib.getCommands(commands)

	some i
	instruction := commandsList[i]
	regex.match("^( )*sudo", instruction) == true
}
