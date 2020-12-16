package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
	some c
  commands[c].Cmd == "run"
  some j

  isZypperInstall(commands[c].Value[j])
  not isZypperInstallWithVersion(commands[c].Value[j])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("RUN=%s", [commands[c].Value[j]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "The package version should always be specified when using zypper install",
                "keyActualValue": 	sprintf("No version is specified in '%s'", [commands[c].Value[j]])
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

