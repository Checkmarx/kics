package Cx

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) == 1 #command is in a single string

	cmd := value[0]

	searchIndex := indexof(cmd, "apt-get")

	searchIndex != -1

	aptGetCmd := trimCmdEnd(substring(cmd, searchIndex + 8, (count(cmd) - searchIndex) - 8))

	not hasNoRecommendsFlag(aptGetCmd)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses '--no-install-recommends' flag to avoid installing additional packages", [runCmd.Original]),
		"keyActualValue": sprintf("'%s' does not use '--no-install-recommends' flag to avoid installing additional packages", [runCmd.Original]),
	}
}

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) > 1 #command is in several tokens

	aptGetIdx := getAptGetIdx(value)
	aptGetIdx != -1
	aptGetCmdLastIdx := getCmdLastIdx(value, aptGetIdx)

	not checkRecommendsFlag(value, aptGetIdx, aptGetCmdLastIdx)

	cmdFormatted := replace(runCmd.Original, "\"", "'")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses '--no-install-recommends' flag to avoid installing additional packages", [cmdFormatted]),
		"keyActualValue": sprintf("'%s' does not use '--no-install-recommends' flag to avoid installing additional packages", [cmdFormatted]),
	}
}

isRunCmd(com) {
	com.Cmd == "run"
} else = false {
	true
}

trimCmdEnd(cmd) = trimmed {
	termOps := ["&&", "||", "|", "&", ";"]

	splitStr := split(cmd, " ")
	some i, j
	splitStr[i] == termOps[j]
	indexTerm := indexof(cmd, termOps[j])
	trimmed := substring(cmd, 0, count(cmd) - indexTerm)
} else = cmd {
	true
}

hasNoRecommendsFlag(arg) {
	flags := ["--no-install-recommends", "apt::install-recommends=false"]
	contains(arg, flags[_])
} else = false {
	true
}

getAptGetIdx(value) = idx {
	some i
	value[i] == "apt-get"
	idx := i + 1
} else = -1 {
	true
}

getCmdLastIdx(arr, initCmdIdx) = idx {
	termOps := ["&&", "||", "|", "&", ";"]
	some i
	i > initCmdIdx
	arr[i] == termOps[i]
	idx := i - 1
} else = count(arr) - 1 {
	true
}

checkRecommendsFlag(cmd, start, end) {
	some i
	i >= start
	i <= end
	hasNoRecommendsFlag(cmd[i])
} else = false {
	true
}
