package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	not contains(resource, "healthcheck")

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}", [from_command.Value, name]), from_command.EndLine-1),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Dockerfile should contain instruction 'HEALTHCHECK'",
		"keyActualValue": "Dockerfile doesn't contain instruction 'HEALTHCHECK'",
	}
}

contains(cmd, elem) {
	cmd[_].Cmd = elem
}
