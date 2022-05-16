package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "run"
	count(resource.Value) == 1
	commands := resource.Value[0]

	commandsSplit = dockerLib.getCommands(commands)

	some j
	regex.match("apt-get (-(-)?[a-zA-Z]+ *)*install", commandsSplit[j]) == true
	not avoidAdditionalPackages(commandsSplit[j])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses '--no-install-recommends' flag to avoid installing additional packages", [resource.Original]),
		"keyActualValue": sprintf("'%s' does not use '--no-install-recommends' flag to avoid installing additional packages", [resource.Original]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "run"
	count(resource.Value) > 1

	commands := resource.Value

	commands[_] == "apt-get"
	commands[_] == "install"

	not avoidAdditionalPackages(commands)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses '--no-install-recommends' flag to avoid installing additional packages", [resource.Original]),
		"keyActualValue": sprintf("'%s' does not use '--no-install-recommends' flag to avoid installing additional packages", [resource.Original]),
	}
}

avoidAdditionalPackages(cmd) {
	is_string(cmd) == true
	flags := ["--no-install-recommends", "apt::install-recommends=false"]
	contains(cmd, flags[_])
}

avoidAdditionalPackages(cmd) {
	is_array(cmd) == true
    dockerLib.arrayContains(cmd, {"--no-install-recommends", "apt::install-recommends=false"})
}
