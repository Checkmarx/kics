package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name][_]

	contains(resource.Flags[j], "--platform")
	contains(resource.Cmd, "from")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} should not use the '--platform' flag", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} is using the '--platform' flag", [name, resource.Original]),
	}
}
