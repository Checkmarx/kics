package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as docker_lib

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"
	values := resource.Value[0]
	commands = docker_lib.getCommands(values)

	some k
	c := hasInstallCommandWithoutFlag(commands[k])

	not hasYesFlag(c)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"searchValue": trim_space(c),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "When running `dnf install`, `-y` or `--assumeyes` switch should be set to avoid build failure ",
		"keyActualValue": sprintf("Command `RUN={{%s}}` doesn't have the `-y` or `--assumeyes` switch set", [trim_space(commands[k])]),
		"searchLine": common_lib.build_search_line(["command", name, cmd], []),
	}
}

hasInstallCommandWithoutFlag(command) = c {
	commandList = [
		"dnf install",
		"dnf groupinstall",
		"dnf localinstall",
		"dnf reinstall",
		"dnf in",
		"dnf rei",
	]

	contains(command, commandList[_])
	c := command
}

hasYesFlag(command) {
	regex.match("\\b((tdnf|microdnf|dnf) *install (-y|-[\\D]{1}y|-y[\\D]{1}|-yes|--assumeyes))\\b [\\w\\W]*", command)
}
