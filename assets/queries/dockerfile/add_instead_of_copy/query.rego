package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[j]
  check(resource) 
  not tarfileChecker(resource.Value, ".tar")
  not tarfileChecker(resource.Value, ".tar.")
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("ADD=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": sprintf("'COPY' %s", [resource.Value[0]]),
                "keyActualValue": 	sprintf("'ADD' %s", [resource.Value[0]])
              }
}

check(com) = true{
  com.Cmd == "add"
}

tarfileChecker(cmdValue, elem) {
  contains(cmdValue[_], elem)
}