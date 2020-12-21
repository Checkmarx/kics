package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "run"
  contains(resource.Value[j], "yum")
  
  not containsCleanAfterYum(resource.Value[j])
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("FROM={{%s}}.{{%s}} does have 'yum clean all' after yum command", [name, resource.Original]),
                "keyActualValue": 	sprintf("FROM={{%s}}.{{%s}} doesn't have 'yum clean all' after yum command", [name, resource.Original]),
              }
}

containsCleanAfterYum(command) {

	contains(command, "yum clean all")

  install := indexof(command, "yum install")
  install != -1

  clean := indexof(command, "yum clean all")
  clean != -1

  install < clean
}