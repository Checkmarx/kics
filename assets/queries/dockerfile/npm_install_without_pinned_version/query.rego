package Cx

import data.generic.dockerfile as dockerLib

CxPolicy[result] {
	runCmd := input.document[i].command[name][_]
	is_run_cmd(runCmd)

	cmd := concat(" ", runCmd.Value)

	splittedCmd := regex.split(`(\&\& | \|\| | \| | \& | \;)`, cmd)

	currentCmd := splittedCmd[_]
	installCmd := ["npm install ", "npm i ", "npm add "][_]
	indexof(currentCmd, installCmd) > -1

	tokens := split(currentCmd, " ")
    refactor_tokens := [x | x := tokens[_]; x != ""]

	token := refactor_tokens[_]

	token != "npm"
	token != "install"
	not valid_match(token)

	stage := input.document[i].command[name]
	from_command := dockerLib.get_original_from_command(stage)
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("%s={{%s}}.{{%s}}", [from_command, name, runCmd.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' uses npm install with a pinned version", [runCmd.Original]),
		"keyActualValue": sprintf("'%s' does not uses npm install with a pinned version", [runCmd.Original]),
	}
}

is_run_cmd(com) {
	com.Cmd == "run"
}

valid_match(token) {
	startswith(token, "git") # npm install from git repository
} else {
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
