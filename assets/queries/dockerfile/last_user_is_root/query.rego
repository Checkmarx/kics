package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name]
	dockerLib.check_multi_stage(name, document.command)

	userCmd := [x | resource[j].Cmd == "user"; x := resource[j]]
	userCmd[count(userCmd) - 1].Value[0] == "root"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, userCmd[count(userCmd) - 1].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Last User shouldn't be root",
		"keyActualValue": "Last User is root",
	}
}
