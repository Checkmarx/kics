package Cx

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) == 1 #command is in a single string

	cmd := value[0]

	splittedCmd := regex.split(`(\&\& | \|\| | \| | \& | \;)`, cmd)

	currentCmd := splittedCmd[_]
	installCmd := ["npm install ", "npm i ", "npm add "][_]
	searchIndex := indexof(currentCmd, installCmd)

	searchIndex != -1

	not isValidInstall(currentCmd)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses npm install with a pinned version", [runCmd.Original]),
		"keyActualValue": sprintf("'%s' does not uses npm install with a pinned version", [runCmd.Original]),
	}
}

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	isRunCmd(runCmd)

	value := runCmd.Value
	count(value) > 1 #command is in several tokens

	npmInstallIndex := getNPMInstallCmdIdx(value)
	npmInstallIndex != -1
	npmInstallCmd := value[npmInstallIndex]

	not isValidInstallArray(value, npmInstallIndex)

	cmdFormatted := replace(runCmd.Original, "\"", "'")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses npm install with a pinned version", [cmdFormatted]),
		"keyActualValue": sprintf("'%s' does not uses npm install with a pinned version", [cmdFormatted]),
	}
}

isRunCmd(com) {
	com.Cmd == "run"
}

isValidInstall(install) {
	install == ""
} else {
	tokens := split(install, " ")
	validMatch(tokens[_])
}

validMatch(token) {
	startswith(token, "git") # npm install from git repository
} else {
	hasScope := re_match("@.+/.*", token)
	hasScope

	scopeEnd := indexof(token, "/")
	packageID := substring(token, scopeEnd + 1, count(token) - scopeEnd)
	atIndex := indexof(packageID, "@")
	atIndex != -1 #package must refer the version or tag
} else {
	hasScope := re_match("@.+/.*", token)
	not hasScope
	atIndex := indexof(token, "@")
	atIndex != -1 #package must refer the version or tag
}

isValidInstallArray(value, npmIdx) {
	j >= npmIdx
	j < count(value)
	validMatch(value[j])
}

getNPMInstallCmdIdx(value) = idx {
	install := ["install", "i", "add"]
	value[i] == "npm"
	value[plus(i, 1)] == install[_]
	idx := i + 2
} else = -1 {
	true
}
