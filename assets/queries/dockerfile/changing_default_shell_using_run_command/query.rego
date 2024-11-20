package Cx

import data.generic.common as common_lib
import future.keywords.in

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
	some document in input.keywords
	resource := document.command[name][_]
	resource.Cmd == "run"
	value := resource.Value

	contains(value[v], shell_possibilities[p])
	run_values := split(value[v], " ")
	command := run_values[0]
	command_possibilities := {"mv", "chsh", "usermod", "ln"}
	command == command_possibilities[cp]

	result := {
		"debug": sprintf("%s", [value[v]]),
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should use the SHELL command to change the default shell", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} uses the RUN command to change the default shell", [resource.Original]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.command[name][_]
	resource.Cmd == "run"
	value := resource.Value
	run_values := split(value[v], " ")
	command := run_values[0]
	contains(command, "powershell")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("{{%s}} should use the SHELL command to change the default shell", [resource.Original]),
		"keyActualValue": sprintf("{{%s}} uses the RUN command to change the default shell", [resource.Original]),
	}
}
