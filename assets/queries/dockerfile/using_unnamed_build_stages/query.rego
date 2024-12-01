package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	commands := document.command[name][_]

	commands.Cmd == "copy"
	flags := commands.Flags
	contains(flags[f], "--from=")
	flag_split := split(flags[f], "=")
	to_number(flag_split[1]) > -1

	result := {
		"documentId": document.id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY '--from' should reference a previously defined FROM alias",
		"keyActualValue": "COPY '--from' does not reference a previously defined FROM alias",
	}
}
