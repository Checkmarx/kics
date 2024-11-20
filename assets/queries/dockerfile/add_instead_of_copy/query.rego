package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some document in input.keywords.in
	resource := document.command[name][_]
	resource.Cmd == "add"

	not dockerLib.arrayContains(resource.Value, {".tar", ".tar."})

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
		"keyActualValue": sprintf("'ADD' %s", [resource.Value[0]]),
	}
}
