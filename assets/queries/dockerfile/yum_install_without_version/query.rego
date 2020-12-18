package Cx

CxPolicy [ result ] {
	document := input.document[i]
  commands = document.command
  some img
	some c
  commands[img][c].Cmd == "run"
  some j

  isYumInstall(commands[img][c].Value[j])
  not isYumInstallWithVersion(commands[img][c].Value[j])

	result := {
                "documentId": 		document.id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [img, commands[img][c].Original]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "The package version should always be specified when using yum install",
                "keyActualValue": 	sprintf("No version is specified in '%s'", [commands[img][c].Original])
              }
}

isYumInstall(command){
  contains(command, "yum install")
}

isYumInstallWithVersion(command){
  regex.match("yum install (--?[a-z]+ )*\\w+-([0-9]+\\.)+[0-9]+", command)
}

