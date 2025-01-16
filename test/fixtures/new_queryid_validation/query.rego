package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)

	userCmd := [x | resource[j].Cmd == "user"; x := resource[j]]
	userCmd[minus(count(userCmd), 1)].Value[0] == "root"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, userCmd[minus(count(userCmd), 1)].Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Last User shouldn't be root",
		"keyActualValue": "Last User is root",
	}
}
