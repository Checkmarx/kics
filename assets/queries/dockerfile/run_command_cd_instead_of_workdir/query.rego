package Cx

CxPolicy [ result ] {
	resource := input.document[i].command[_]
    resource.Cmd == "run"
    contains(resource.Value[_], "cd ") 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("RUN=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Using WORKDIR to change directory",
                "keyActualValue": 	sprintf("RUN %s'", [resource.Value[0]])
              } 
}



