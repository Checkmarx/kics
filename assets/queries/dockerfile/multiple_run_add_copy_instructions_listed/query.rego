package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	resource := input.document[i].command[name]
	dockerLib.check_multi_stage(name, input.document[i].command)
	
	instructions := {"copy", "add", "run"}
	some j
	cmdInst := [x | resource[j].Cmd == instructions[y]; x := resource[j]]
	typeCMD := [x | cmd := cmdInst[_]; x := {"cmd": cmd.Cmd, "dest": cmd.Value[minus(count(cmd.Value), 1)]}]
	newCmdInst := [x | cmd := cmdInst[_]; check_dest(typeCMD, cmd); x := cmd]

	some n, m
	lineCounter := [x |
		newCmdInst[n]._kics_line - newCmdInst[m]._kics_line == -1
		x := newCmdInst[n]
	]

	upperName := upper(instructions[y])
	countCmdInst := count(lineCounter)
	countCmdInst > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, lineCounter[0].Original]),
		"issueType": "RedundantAttribute",
		"keyExpectedValue": sprintf("There isn´t any %s instruction that could be grouped", [upperName]),
		"keyActualValue": sprintf("There are %s instructions that could be grouped", [upperName]),
	}
}

check_dest(typeCMD, cmd) {
	types := {"copy", "add"}
	cmd.Cmd == types[y]
	cmdCheck = [x | cmd.Value[minus(count(cmd.Value), 1)] == typeCMD[z].dest; x := typeCMD[z]]
	count(cmdCheck) > 1
} else {
	cmd.Cmd == "run"
} else = false {
	true
}
