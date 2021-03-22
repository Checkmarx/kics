package Cx

CxPolicy[result] {
	resource := input.document[i].command[name]
	instruction := "run"

	some j
	cmdInst := [x | resource[j].Cmd == instruction; x := resource[j]]

	some n, m
	lineCounter := [x | cmdInst[n].StartLine - cmdInst[m].StartLine == -1; x := cmdInst[n]]

	upperName := upper(instruction)
	countCmdInst := count(lineCounter)
	countCmdInst > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, lineCounter[0].Original]),
		"issueType": "Best Practices",
		"keyExpectedValue": sprintf("There isn´t any %s instruction that could be grouped", [upperName]),
		"keyActualValue": sprintf("There are %s instructions that could be grouped", [upperName]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name]
	instruction := "copy"

	some j
	cmdInst := [x | resource[j].Cmd == instruction; x := resource[j]]

	some n, m
	lineCounter := [x | cmdInst[n].StartLine - cmdInst[m].StartLine == -1; x := cmdInst[n]]

	upperName := upper(instruction)
	countCmdInst := count(lineCounter)
	countCmdInst > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, lineCounter[0].Original]),
		"issueType": "Best Practices",
		"keyExpectedValue": sprintf("There isn´t any %s instruction that could be grouped", [upperName]),
		"keyActualValue": sprintf("There are %s instructions that could be grouped", [upperName]),
	}
}

CxPolicy[result] {
	resource := input.document[i].command[name]
	instruction := "add"

	some j
	cmdInst := [x | resource[j].Cmd == instruction; x := resource[j]]

	some n, m
	lineCounter := [x | cmdInst[n].StartLine - cmdInst[m].StartLine == -1; x := cmdInst[n]]

	upperName := upper(instruction)
	countCmdInst := count(lineCounter)
	countCmdInst > 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, lineCounter[0].Original]),
		"issueType": "Best Practices",
		"keyExpectedValue": sprintf("There isn´t any %s instruction that could be grouped", [upperName]),
		"keyActualValue": sprintf("There are %s instructions that could be grouped", [upperName]),
	}
}
