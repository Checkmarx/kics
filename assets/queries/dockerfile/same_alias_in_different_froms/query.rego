package Cx

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

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}", [aliasResource.Value[idx_2]]),
		"issueType": "IncorrectValue", 
		"keyExpectedValue": "Different FROM commands don't have the same alias defined",
		"keyActualValue": sprintf("Different FROM commands with with the same alias '%s' defined", [aliasResource.Value[idx_2]]),
	}
}

getIndex(val) = idx {
	val[i] == "as"
	idx = i + 1
}
