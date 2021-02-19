package Cx

CxPolicy[result] {
	commands := input.document[i].command[name]
	runCmd := commands[j]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) == 1 #command is in a single string

	cmd := value[0]

	shells := ["zsh", "bash", "ash", "/bin/zsh", "/bin/bash", "/bin/ash"]

	searchIndex := indexof(cmd, shells[shell])

	searchIndex != -1

	hasPipe(substring(cmd, searchIndex, count(cmd) - searchIndex))

	not hasPipefail(commands, shells[shell], j)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' has pipefail option set for pipe command with shell %s.", [runCmd.Original, shells[shell]]),
		"keyActualValue": sprintf("'%s' does not have pipefail option set for pipe command with shell %s.", [runCmd.Original, shells[shell]]),
	}
}

CxPolicy[result] {
	commands := input.document[i].command[name]
	runCmd := commands[j]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) > 1 #command is in several tokens

	shellIdx := getShellIdx(value)
	shellIdx != -1
	hasPipeInArray(value, shellIdx)

	not hasPipefail(commands, value[shellIdx], j)

	cmdFormatted := replace(runCmd.Original, "\"", "'")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' has pipefail option set for pipe command with shell %s.", [cmdFormatted, value[shellIdx]]),
		"keyActualValue": sprintf("'%s' does not have pipefail option set for pipe command with shell %s.", [cmdFormatted, value[shellIdx]]),
	}
}

isRunCmd(com) {
	com.Cmd == "run"
} else = false {
	true
}

hasPipe(cmd) {
	splitStr := split(cmd, " ")
	some i
	splitStr[i] == "|"
	not findTermOpBeforeIdx(splitStr, i)
} else = false {
	true
}

findTermOpBeforeIdx(tokens, maxIdx) {
	termOps := ["&&", "||", "&", ";"]
	some i
	tokens[i] == termOps[_]
	i < maxIdx
} else = false {
	true
}

getShellIdx(value) = idx {
	shells := ["zsh", "bash", "ash", "/bin/zsh", "/bin/bash", "/bin/ash"]
	some i
	value[i] == shells[_]
	idx := i
} else = -1 {
	true
}

hasPipeInArray(arr, initCmdIdx) {
	some i
	i > initCmdIdx
	arr[i] == "|"
	not findTermOpBetweenIdxs(arr, initCmdIdx, i)
} else = false {
	true
}

findTermOpBetweenIdxs(arr, startIdx, endIdx) {
	termOps := ["&&", "||", "&", ";"]
	some i
	arr[i] == termOps[_]
	i > startIdx
	i < endIdx
} else = false {
	true
}

hasPipefail(commands, shellName, idx) {
	some i
	shell := commands[i]
	shell.Cmd == "shell"
	tokens := shell.Value
	shellIdx := shellMatch(tokens, shellName)
	shellIdx != -1
	tokens[plus(shellIdx, 1)] == "-o"
	tokens[plus(shellIdx, 2)] == "pipefail"
	i < idx
} else = false {
	true
}

shellMatch(tokens, shellName) = shellIdx {
	contains(tokens[shellIdx], shellName)
} else = shellIdx {
	contains(shellName, tokens[shellIdx])
} else = -1 {
	true
}
