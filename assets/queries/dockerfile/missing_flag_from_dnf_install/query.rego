package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	values := resource.Value[0]
	commands = dockerLib.getCommands(values)

	some k
	c := hasInstallCommandWithoutFlag(commands[k])

	not hasYesFlag(c)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "When running `dnf install`, `-y` or `--assumeyes` switch should be set to avoid build failure ",
		"keyActualValue": sprintf("Command `RUN={{%s}}` doesn't have the `-y` or `--assumeyes` switch set", [trim_space(commands[k])]),
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
