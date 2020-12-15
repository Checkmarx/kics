package Cx

CxPolicy [ result ] {
  command := input.document[i].command[j]
  command.Cmd == "run"
  
  # Split the commands (e.g., RUN command1 && command2 && command3)
  runCommands := split(command.Value[0], "&&")
  containsApkAddWithoutNoCache(runCommands)
	
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "'RUN' does not contain 'apk add' command without '--no-cache' switch",
                "keyActualValue": 	"'RUN' contains 'apk add' command without '--no-cache' switch"
              }
}

containsApkAddWithoutNoCache(commands) {
  some i
    command := trim_space(commands[i])
    startswith(command, "apk ")
    contains(command, " add ")
    not contains(command, "--no-cache")
}