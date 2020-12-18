package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
  some img
	some c
  commands[img][c].Cmd == "run"

  some j
  command := commands[img][c].Value[j]

  commandHasZypperUsage(command)
  not commandHasNonInteractiveSwitch(command)

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "zypper usages should have the non-interactive switch activated",
                "keyActualValue": 	sprintf("The command '%s' does not have the non-interactive switch activated (-y | --no-confirm)", [commands[img][c].Original])
              }
}

commandHasNonInteractiveSwitch(command){
  regex.match("zypper \\w+ (-y|--no-confirm)", command)
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper install")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper in")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper remove")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper rm")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper source-install")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper si")
  index != -1
}

commandHasZypperUsage(command){
  index := indexof(command, "zypper patch")
  index != -1
}
