package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "add"
  not tarfileChecker(resource.Value, ".tar")
  not tarfileChecker(resource.Value, ".tar.")
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
                "keyActualValue": 	sprintf("'ADD' %s", [resource.Value[0]])
              }
}

tarfileChecker(cmdValue, elem) {
  contains(cmdValue[_], elem)
}