package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	resource.Cmd == "copy"

	command := resource.Value

	numElems := count(command)
	numElems > 2

	not endswith(command[minus(numElems, 1)], "/")

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	copy_command := substring(resource.Original, 0, 3)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.%s={{%s}}", [from_command.Value, name, copy_command, resource.Value[0]]), from_command.EndLine-1),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "When COPY command has more than two arguments, the last one should end with a slash",
		"keyActualValue": "COPY command has more than two arguments and the last one does not end with a slash",
	}
}
