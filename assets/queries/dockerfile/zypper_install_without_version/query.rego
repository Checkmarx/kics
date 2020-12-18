package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
  some img
	some c
  commands[img][c].Cmd == "run"
  some j

  isZypperInstall(commands[img][c].Value[j])
  not isZypperInstallWithVersion(commands[img][c].Value[j])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "The package version should always be specified when using zypper install",
                "keyActualValue": 	sprintf("No version is specified in '%s'", [commands[img][c].Value[j]])
              }
}

isZypperInstall(command){
  contains(command, "zypper install")
}

isZypperInstall(command){
  contains(command, "zypper in")
}

isZypperInstallWithVersion(command){
  regex.match("zypper in(stall)? (-[a-z]+ )*\\w+(>|<|=|>=|<=)([0-9]+\\.)+[0-9]+", command)
}

