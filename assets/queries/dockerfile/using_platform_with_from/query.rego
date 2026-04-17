package Cx

import data.generic.common as common_lib
import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	contains(resource.Flags[j], "--platform")
	contains(resource.Cmd, "from")

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("%s={{%s}}.{{%s}} should not use the '--platform' flag", [from_command, name, resource.Original]),
		"keyActualValue": sprintf("%s={{%s}}.{{%s}} is using the '--platform' flag", [from_command, name, resource.Original]),
	}
}
