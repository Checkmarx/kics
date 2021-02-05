package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"
	command := resource.Value[0]

	containsInstallCommand(command)
	not containsDnfClean(input.document[i].command[name], resource.StartLine)
	not containsCleanAfterInstall(command)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.RUN={{%s}}", [name, resource.Value[0]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "After installing a package with dnf, command 'dnf clean all' is run.",
		"keyActualValue": "Command `dnf clean all` should be run after installing packages.",
	}
}

containsDnfClean(inputs, startLine) {
	commands := inputs[_]
	commands.Cmd == "run"
	contains(commands.Value[_], "dnf clean")
	commands.StartLine > startLine
}

containsInstallCommand(command) {
	installCommands = [
		"dnf install",
		"dnf in",
		"dnf reinstall",
		"dnf rei",
		"dnf install-n",
		"dnf install-na",
		"dnf install-nevra",
	]

	contains(command, installCommands[_])
}

# `dnf clean all` should come after `dnf install`
containsCleanAfterInstall(command) {
	contains(command, "dnf clean all")

	installCommands = [
		"dnf install",
		"dnf in",
		"dnf reinstall",
		"dnf rei",
		"dnf install-n",
		"dnf install-na",
		"dnf install-nevra",
	]

	some cmd
	install := indexof(command, installCommands[cmd])
	install != -1

	clean := indexof(command, "dnf clean")
	clean != -1

	install < clean
}
