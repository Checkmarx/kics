package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	document := input.document[i]
	commands = document.command

	commands[img][c].Cmd == "run"
	dockerLib.check_multi_stage(img, commands)

	command := commands[img][c].Value[j]

	commandHasZypperUsage(command)
	not commandHasNonInteractiveSwitch(command)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "zypper usages should have the non-interactive switch activated",
		"keyActualValue": sprintf("The command '%s' does not have the non-interactive switch activated (-y | --no-confirm)", [commands[img][c].Original]),
	}
}

commandHasNonInteractiveSwitch(command) {
	regex.match("zypper \\w+ (-y|--no-confirm)", command)
}

commandHasZypperUsage(command) {
    list := ["zypper in", "zypper remove", "zypper rm", "zypper source-install", "zypper si", "zypper patch"][_]
	index := indexof(command, list)
	index != -1
}

commandHasZypperUsage(command) {
    output := regex.find_n("zypper (-(-)?[a-zA-Z]+ *)*install", command, -1)
    output != null
    index := indexof(command, output[0])
    index != -1
}
