package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some doc in input.document
	resource := doc.command[name][idx]
	resource.Cmd == "buildah run"

	contains(resource.Value, "apt ")

	result := {
		"documentId": doc.id,
		"searchKey": sprintf("from[{{%s}}].{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "RUN instructions should not use the 'apt' program",
		"keyActualValue": "RUN instruction is invoking the 'apt' program",
	}
}
