package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	contains(resource.Flags[j], "--platform")
	contains(resource.Cmd, "from")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} should not use the '--platform' flag", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} is using the '--platform' flag", [name, resource.Original]),
	}
}
