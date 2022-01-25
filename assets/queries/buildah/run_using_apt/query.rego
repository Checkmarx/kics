package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].command[name][idx]
	resource.Cmd == "buildah run"

	contains(resource.Value, "apt ")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("from[{{%s}}].{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instructions should not use the 'apt' program",
		"keyActualValue": "RUN instruction is invoking the 'apt' program",
	}
}
