package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	containsCommand(resource) == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "There should be no dangerous commands or utilities executed",
		"keyActualValue": sprintf("Run instruction is executing the %s command", [resource.Value[0]]),
	}
}

hasInstall(cmds) {
	is_array(cmds) == true
	contains(cmds[_], "install")
}

hasInstall(cmd) {
	is_string(cmd) == true
	contains(cmd, "install")
}

containsCommand(cmds) {
	count(cmds.Value) > 1
	not hasInstall(cmds.Value)
	regex.match("\\b(ps|shutdown|service|free|top|kill|mount|ifconfig|nano|vim)\\b", cmds.Value[_])
}

containsCommand(cmds) {
	count(cmds.Value) == 1

	commandsList = split(cmds.Value[0], "&&")

	some i
	not hasInstall(commandsList[i])
	regex.match("\\b(ps|shutdown|service|free|top|kill|mount|ifconfig|nano|vim)\\b ", commandsList[i])
}

containsCommand(cmds) {
	count(cmds.Value) == 1

	commandsList = split(cmds.Value[0], "&&")

	some i
	not hasInstall(commandsList[i])
	regex.match("^\\b(ps|shutdown|service|free|top|kill|mount|ifconfig|nano|vim)\\b$", commandsList[i])
}
