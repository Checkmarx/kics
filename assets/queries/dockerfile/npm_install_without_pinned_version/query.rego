package Cx

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	is_run_cmd(runCmd)

	cmd := concat(" ", runCmd.Value)

	// splits on '&&', '||', '|', '&', ';'
	splittedCmd := regex.split(`(\&\& | \|\| | \| | \& | \;)`, cmd)

	currentCmd := splittedCmd[_]
	installCmd := ["npm install ", "npm i ", "npm add "][_]
	indexof(currentCmd, installCmd) > -1

	tokens := split(currentCmd, " ")
	token := tokens[_]

	token != "npm"
	token != "install"
	not valid_match(token)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses npm install with a pinned version", [runCmd.Original]),
		"keyActualValue": sprintf("'%s' does not use npm install with a pinned version", [runCmd.Original]),
	}
}

is_run_cmd(com) {
	com.Cmd == "run"
}

valid_match(token) {
	startswith(token, "git") # npm install from git repository
} else {
	// skips things like '-g'
	startswith(token, "-")
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
