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
  contains(command, "zypper update")
}

isZypperUnsafeCommand(command){
  contains(command, "zypper dist-upgrade")
}

isZypperUnsafeCommand(command){
  contains(command, "zypper dup")
}

isZypperUnsafeCommand(command){
  contains(command, "zypper up")
}
