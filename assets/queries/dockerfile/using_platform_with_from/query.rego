package Cx

CxPolicy[result] {
	resource := input.document[i].command[name][_]
	contains(resource.Flags[j], "--platform")
	contains(resource.Cmd, "from")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} doesn't use the flag '--platform'", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} uses the flag '--platform'", [name, resource.Original]),
	}
}
