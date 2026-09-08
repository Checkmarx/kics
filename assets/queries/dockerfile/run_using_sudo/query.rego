package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	count(resource.Value) == 1

	hasSudo(resource.Value[0])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	run_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, run_command, resource.Value[0]]), from_command.LineHint),
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
	run_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, run_command, resource.Value[0]]), from_command.LineHint),
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
