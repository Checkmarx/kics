package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][j]
	resource.Cmd == "add"
	httpRequestChecker(resource.Value)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}.{{%s}}", [from_command.Value, name, resource.Original]), from_command.LineHint),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Should use 'curl' or 'wget' to download %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}

httpRequestChecker(cmdValue) {
	regex.match("https?://", cmdValue[_])
}
