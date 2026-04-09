package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	userCmd := [x | resource[j].Cmd == "user"; x := resource[j]]
	userCmd[minus(count(userCmd), 1)].Value[0] == "root"

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, userCmd[minus(count(userCmd), 1)].Original]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Last User shouldn't be root",
		"keyActualValue": "Last User is root",
	}
}
