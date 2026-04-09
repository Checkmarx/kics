package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {

	commands := input.document[i].command[name][_]
	
	commands.Cmd == "copy"
    flags := commands.Flags
    contains(flags[f], "--from=")
    flag_split := split(flags[f], "=")
    to_number(flag_split[1]) > -1
	

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, commands.Original]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY '--from' should reference a previously defined FROM alias",
		"keyActualValue": "COPY '--from' does not reference a previously defined FROM alias",
	}
}
