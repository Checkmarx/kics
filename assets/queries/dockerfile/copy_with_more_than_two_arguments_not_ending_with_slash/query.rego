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
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.COPY={{%s}}", [from_command, name, resource.Value[0]]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "When COPY command has more than two arguments, the last one should end with a slash",
		"keyActualValue": "COPY command has more than two arguments and the last one does not end with a slash",
	}
}
