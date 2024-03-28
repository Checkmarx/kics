package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].command[name][_]

	common_lib.contains_element(resource.Value, "as")
    contains(resource.Cmd, "from")
	not common_lib.contains_with_size(resource.Flags, "--platform")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} should use the flag '--platform'", [name, resource.Original]),
		"keyActualValue": sprintf("FROM={{%s}}.{{%s}} not use the flag '--platform'", [name, resource.Original]),
	}
}
