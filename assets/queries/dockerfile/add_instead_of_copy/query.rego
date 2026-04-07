package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	stage := input.document[i].command[name]

	resource = stage[s]
	stage[s].Cmd = "add"
	not dockerLib.arrayContains(stage[s].Value, {".tar", ".tar."})

	from_commands := dockerLib.get_original_from_commands(stage)
	from_command := get_from_command(from_commands, resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}--%d", [substring(from_command.Original, 0, 4), name, resource.Original, from_command.EndLine-1]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}

get_from_command(from_commands, resource) = cmd {
	closest_endline := max([cmd.EndLine | cmd := from_commands[_]; cmd.EndLine < resource.EndLine])
    cmd := from_commands[_]
    cmd.EndLine == closest_endline
}

