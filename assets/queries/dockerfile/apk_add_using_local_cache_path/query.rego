package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	command := input.document[i].command[name][_]
	command.Cmd == "run"

	# Split the commands (e.g., RUN command1 && command2 && command3)
	runCommands := dockerLib.getCommands(command.Value[0])
	containsApkAddWithoutNoCache(runCommands)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, command.Original]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'RUN' should not contain 'apk add' command without '--no-cache' switch",
		"keyActualValue": "'RUN' contains 'apk add' command without '--no-cache' switch",
	}
}

containsApkAddWithoutNoCache(commands) {
	some i
	command := trim_space(commands[i])
	startswith(command, "apk ")
	contains(command, " add ")
	not contains(command, "--no-cache")
}
