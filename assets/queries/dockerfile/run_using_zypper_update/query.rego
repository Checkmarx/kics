package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
	some c
  commands[c].Cmd == "run"
  some j

  isZypperUnsafeCommand(commands[c].Value[j])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("RUN=%s", [commands[c].Value[j]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "RUN instructions should not use 'zypper update'",
                "keyActualValue": 	sprintf("RUN instruction is invoking the '%s'", [commands[c].Value[j]])
              }
}

isZypperUnsafeCommand(command){
  startswith(command, "zypper update")
}

isZypperUnsafeCommand(command){
  startswith(command, "zypper dist-upgrade")
}

isZypperUnsafeCommand(command){
  startswith(command, "zypper dup")
}

isZypperUnsafeCommand(command){
  startswith(command, "zypper up")
}
