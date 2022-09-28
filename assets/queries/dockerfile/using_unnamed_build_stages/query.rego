package Cx

CxPolicy[result] {

	commands := input.document[i].command[name][_]
	
	commands.Cmd == "copy"
    flags := commands.Flags
    contains(flags[f], "--from=")
    flag_split := split(flags[f], "=")
    to_number(flag_split[1]) > -1
	

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("FROM={{%s}}.{{%s}}", [name, commands.Original]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "COPY '--from' should reference a previously defined FROM alias",
		"keyActualValue": "COPY '--from' does not reference a previously defined FROM alias",
	}
}
