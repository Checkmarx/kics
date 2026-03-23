package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	resource.Cmd == "workdir"
	not regex.match("(^\"?/[A-z0-9-_+]*)|(^\"?[A-z0-9-_+]:\\\\.*)|(^\"?\\$[{}A-z0-9-_+].*)", resource.Value[0])

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.WORKDIR={{%s}}", [from_command, name, resource.Value[0]]),
		"issueType": "IncorrectValue", #"MissingAttribute" / "RedundantAttribute"
		"keyExpectedValue": "'WORKDIR' Command has absolute path",
		"keyActualValue": "'WORKDIR' Command doesn't have absolute path",
	}
}
