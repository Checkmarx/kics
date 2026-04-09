package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name][com]
	resource.Cmd == "from"

	idx := getIndex(resource.Value)

	nameAlias := resource.Value[idx]

	aliasResource := input.document[i].command[name2][alias]
	aliasResource != resource
	aliasResource.Cmd == "from"
	idx_2 := getIndex(aliasResource.Value)
	aliasResource.Value[idx_2] == nameAlias

	from_command := dockerLib.get_original_from_command(input.document[i].command[name2])
	result := {
		"documentId": input.document[i].id,
		"searchKey": dockerLib.add_line_hint(sprintf("%s={{%s}}", [from_command.Value, aliasResource.Value[idx_2]]), from_command.EndLine-1),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Different FROM commands don't have the same alias defined",
		"keyActualValue": sprintf("Different FROM commands with the same alias '%s' defined", [aliasResource.Value[idx_2]]),
	}
}

getIndex(val) = idx {
	val[i] == "as"
	idx = i + 1
}
