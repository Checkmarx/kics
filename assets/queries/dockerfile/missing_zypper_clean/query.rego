package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	document := input.document[i]
	commands = document.command
	
	commands[img][c].Cmd == "run"
	dockerLib.check_multi_stage(img, commands)

	command := commands[img][c].Value[j]

	commandHasZypperUsage(command)

	not hasCleanAfterInstall(commands[img], c, j)
	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "There should be a zypper clean after a zypper usage",
		"keyActualValue": sprintf("The command '%s' does not have a zypper clean after it", [commands[img][c].Value[j]]),
	}
}

hasCleanAfterInstall(commands, installCommandIndex, valueIndex) {
	some c
	c > installCommandIndex
	some i
	commandHasZypperClean(commands[c].Value[i])
}

hasCleanAfterInstall(commands, installCommandIndex, valueIndex) {
	some i
	i > valueIndex
	commandHasZypperClean(commands[installCommandIndex].Value[i])
}

# If a command has zypper install and clean in same line
# assume that the clean comes after the install
hasCleanAfterInstall(commands, installCommandIndex, valueIndex) {
	commandString := commands[installCommandIndex].Value[valueIndex]
	commandHasZypperUsage(commandString)
	commandHasZypperClean(commandString)
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

commandHasZypperClean(command) {
    list := ["zypper clean", "zypper cc"][_]
	index := indexof(command, list)
	index != -1
}
