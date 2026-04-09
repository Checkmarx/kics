package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "run"

	containsCommand(resource) == true

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.EndLine-1),
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
