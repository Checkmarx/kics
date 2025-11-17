package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	commands := input.document[i].command[name]
	runCmd := commands[j]
	runCmd.Cmd == "run"

	value := runCmd.Value
	count(value) == 1 #command is in a single string

	cmd := value[0]

	matches := shell_matches(cmd)
	match := matches[_]

	hasPipe(substring(cmd, match.index, count(cmd) - match.index))

	not hasPipefail(commands, match.shell, j)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"searchValue": match.shell,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' has pipefail option set for pipe command with shell %s.", [runCmd.Original, match.shell]),
		"keyActualValue": sprintf("'%s' does not have pipefail option set for pipe command with shell %s.", [runCmd.Original, match.shell]),
		"searchLine": common_lib.build_search_line(["command", name, j], []),
	}
}

CxPolicy[result] {
	commands := input.document[i].command[name]
	runCmd := commands[j]
	runCmd.Cmd == "run"

	value := runCmd.Value
	count(value) > 1 #command is in several tokens

	matches := shell_matches(value)
	match := matches[_]

	hasPipeInArray(value, match.index)

	not hasPipefail(commands, match.shell, j)

	cmdFormatted := replace(runCmd.Original, "\"", "'")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"searchValue": match.shell,
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' has pipefail option set for pipe command with shell %s.", [cmdFormatted, match.shell]),
		"keyActualValue": sprintf("'%s' does not have pipefail option set for pipe command with shell %s.", [cmdFormatted, match.shell]),
		"searchLine": common_lib.build_search_line(["command", name, j], []),
	}
}

shell_matches(cmd) := matches {
	is_string(cmd)
	shells := ["zsh", "bash", "ash", "/bin/zsh", "/bin/bash", "/bin/ash"]
	all_matches := {{"index": index, "shell": shell} |
		shell := shells[_]
		index := indexof(cmd, shell)
		index != -1
	}
	matches := {match | match := all_matches[_]; not is_submatch(match, all_matches)}
} else := matches {
	is_array(cmd)
	shells := ["zsh", "bash", "ash", "/bin/zsh", "/bin/bash", "/bin/ash"]
	matches := {{"index": index, "shell": shell} |
		shell := shells[_]
		cmd[index] == shell
	}
}

is_submatch(match, matches) {
	other := matches[_]
	other != match
	contains(other.shell, match.shell)
}

hasPipe(cmd) {
	splitStr := split(cmd, " ")
	some i
	splitStr[i] == "|"
	not findTermOpBeforeIdx(splitStr, i)
}

findTermOpBeforeIdx(tokens, maxIdx) {
	termOps := ["&&", "||", "&", ";"]
	some i
	tokens[i] == termOps[_]
	i < maxIdx
}

hasPipeInArray(arr, initCmdIdx) {
	some i
	i > initCmdIdx
	arr[i] == "|"
	not findTermOpBetweenIdxs(arr, initCmdIdx, i)
}

findTermOpBetweenIdxs(arr, startIdx, endIdx) {
	termOps := ["&&", "||", "&", ";"]
	some i
	arr[i] == termOps[_]
	i > startIdx
	i < endIdx
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
}

shellMatch(tokens, shellName) = shellIdx {
	contains(tokens[shellIdx], shellName)
} else = shellIdx {
	contains(shellName, tokens[shellIdx])
} else = -1 {
	true
}
