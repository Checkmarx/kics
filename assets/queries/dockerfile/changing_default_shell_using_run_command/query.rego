package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as dockerLib

shell_possibilities := {
	"/bin/bash",
	"/bin/tcsh",
	"/bin/ksh",
	"/bin/csh",
	"/bin/dash",
	"etc/shells",
	"/bin/zsh",
	"/bin/fish",
	"/bin/tmux",
	"/bin/rbash",
	"/bin/sh",
	"/usr/bin/zsh",
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
    value := resource.Value

	contains(value[v], shell_possibilities[p])
	run_values := split(value[v], " ")
	command := run_values[0]
	command_possibilities := {"mv", "chsh", "usermod", "ln"}
	command == command_possibilities[cp]

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
    	"debug": sprintf("%s", [value[v]]),
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should use the SHELL command to change the default shell", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} uses the RUN command to change the default shell", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
    value := resource.Value
	run_values := split(value[v], " ")
	command := run_values[0]
	contains(command, "powershell")

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should use the SHELL command to change the default shell", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} uses the RUN command to change the default shell", [resource.Original]),
	}
}
