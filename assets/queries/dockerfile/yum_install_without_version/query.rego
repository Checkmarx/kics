package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
	some c
  commands[c].Cmd == "run"
  some j

  isYumInstall(commands[c].Value[j])
  not isYumInstallWithVersion(commands[c].Value[j])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("RUN=%s", [commands[c].Value[j]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "The package version should always be specified when using yum install",
                "keyActualValue": 	sprintf("No version is specified in '%s'", [commands[c].Value[j]])
              }
}

isYumInstall(command){
  contains(command, "yum install")
}

isYumInstallWithVersion(command){
  regex.match("yum install (--?[a-z]+ )*\\w+-([0-9]+\\.)+[0-9]+", command)
}

