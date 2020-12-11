package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[_]
  resource.Cmd == "workdir"
  not regex.match("(^\/[A-z0-9-_+].*)|(^[A-z0-9-_+]:\\\\.*)|(^\\$[A-z0-9-_+].*)",resource.Value[0])
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("WORKDIR=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "'WORKDIR' Command has absolute path",
                "keyActualValue": 	"'WORKDIR' Command doesn't have absolute path"
              }
}
