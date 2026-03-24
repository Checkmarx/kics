package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][cmd]
	resource.Cmd == "run"
	values := resource.Value[0]
	commands = dockerLib.getCommands(values)

	some k
	c := hasInstallCommandWithoutFlag(commands[k])

	not hasYesFlag(c)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	run_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.%s={{%s}}", [from_command, name, run_command, resource.Value[0]]),
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
