package Cx

CxPolicy[result] {
	document := input.document[i]
	commands = document.command
	some img
	some c
	commands[img][c].Cmd == "run"

	some j
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
	index := indexof(command, "zypper install")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper in")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper remove")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper rm")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper source-install")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper si")
	index != -1
}

commandHasZypperUsage(command) {
	index := indexof(command, "zypper patch")
	index != -1
}

commandHasZypperClean(command) {
	index := indexof(command, "zypper clean")
	index != -1
}

commandHasZypperClean(command) {
	index := indexof(command, "zypper cc")
	index != -1
}
