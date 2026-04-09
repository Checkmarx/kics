package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "workdir"
	not regex.match("(^\"?/[A-z0-9-_+]*)|(^\"?[A-z0-9-_+]:\\\\.*)|(^\"?\\$[{}A-z0-9-_+].*)", resource.Value[0])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	workdir_command := substring(resource.Original, 0, 7)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, workdir_command, resource.Value[0]]), from_command.EndLine-1),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'WORKDIR' Command has absolute path",
		"keyActualValue": "'WORKDIR' Command doesn't have absolute path",
	}
}
