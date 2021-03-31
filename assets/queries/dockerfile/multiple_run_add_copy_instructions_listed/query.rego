package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]
	instructions := {"copy", "add", "run"}
	some j
	cmdInst := [x | resource[j].Cmd == instructions[y]; x := resource[j]]

	some n, m
	lineCounter := [x | cmdInst[n].StartLine - cmdInst[m].StartLine == -1; x := cmdInst[n]]

	upperName := upper(instructions[y])
	countCmdInst := count(lineCounter)
	countCmdInst > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, lineCounter[0].Original]),
		"issueType": "Redundant Attribute",
		"keyExpectedValue": sprintf("There isn´t any %s instruction that could be grouped", [upperName]),
		"keyActualValue": sprintf("There are %s instructions that could be grouped", [upperName]),
	}
}
