package Cx

import data.generic.dockerfile as dockerLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.command[name]
	dockerLib.check_multi_stage(name, document.command)

	cmdInst := [x | resource[j].Cmd == "entrypoint"; x := resource[j]]
	count(cmdInst) > 1

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, cmdInst[0].Original]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": "There should be only one ENTRYPOINT instruction",
		"keyActualValue": sprintf("There are %d ENTRYPOINT instructions", [count(cmdInst)]),
	}
}
