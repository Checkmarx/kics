package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	cmdInst := [x | resource[j].Cmd == "entrypoint"; x := resource[j]]
	count(cmdInst) > 1

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, cmdInst[0].Original]), from_command.LineHint),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "There should be only one ENTRYPOINT instruction",
		"keyActualValue": sprintf("There are %d ENTRYPOINT instructions", [count(cmdInst)]),
	}
}
