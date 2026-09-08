package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]

	contains(resource[j].Flags[f], "--chown")

	from_command := dockerLib.get_original_from_command(resource)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource[j].Original]), from_command.LineHint),
		"category": "Best Practices",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "The 'Dockerfile' shouldn´t contain the 'chown' flag",
		"keyActualValue": "The 'Dockerfile' contains the 'chown' flag",
	}
}
