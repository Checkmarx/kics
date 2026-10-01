package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	userCmd := [x | resource[j].Cmd == "user"; x := resource[j]]
	is_root_user(userCmd[minus(count(userCmd), 1)].Value[0])

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, userCmd[minus(count(userCmd), 1)].Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Last User shouldn't be root",
		"keyActualValue": "Last User is root",
	}
}

# Root privileges come from UID 0 alone - USER <user>:<group>
is_root_user(value) {
	split(value, ":")[0] == "root"
}

# Docker parses numeric users as integers, so "00", "+0" and "-0" also resolve to UID 0
is_root_user(value) {
	regex.match(`^[+-]?0+$`, split(value, ":")[0])
}
