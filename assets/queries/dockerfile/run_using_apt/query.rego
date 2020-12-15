package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
	some c
  commands[c].Cmd == "run"
  some j
  startswith(commands[c].Value[j], "apt ")

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("RUN=%s", [commands[c].Value[j]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "RUN instructions should not use the 'apt' program",
                "keyActualValue": 	"RUN instruction is invoking the 'apt' program"
              }
}
