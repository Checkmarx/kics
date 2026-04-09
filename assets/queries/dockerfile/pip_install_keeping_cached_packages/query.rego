package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) == 1
	values := resource.Value[0]

	hasCacheFlag(values)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, values]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag should be set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	count(resource.Value) > 1

	isPip(resource.Value)

	not hasCacheFlagInList(resource.Value)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The '--no-cache-dir' flag should be set when running 'pip/pip3 install'",
		"keyActualValue": "The '--no-cache-dir' flag isn't set when running 'pip/pip3 install'",
	}
}

hasCacheFlag(values) {
	commands = dockerLib.getCommands(values)

	some i
	instruction := commands[i]
	regex.match("pip(3)? (-(-)?[a-zA-Z]+ *)*install", instruction) == true
	not contains(instruction, "--no-cache-dir")
}

isPip(commands) {
	pip := {"pip", "pip3"}
	commands[j] == pip[x]
}

hasCacheFlagInList(commands) {
	contains(commands[j], "--no-cache-dir")
}
