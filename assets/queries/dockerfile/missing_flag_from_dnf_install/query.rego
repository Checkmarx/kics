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
		"keyExpectedValue": "When running `dnf install`, `-y` or `--assume-yes` switch is set to avoid build failure ",
		"keyActualValue": sprintf("Command `FROM={{%s}}.RUN={{%s}}` doesn't have the `-y` or `--assume-yes` switch set", [name, trim_space(commands[k])]),
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
	regex.match("\\b(dnf *install (-y|-[\\D]{1}y|-y[\\D]{1}|-yes|--assume-yes))\\b [\\w\\W]*", command)
}
