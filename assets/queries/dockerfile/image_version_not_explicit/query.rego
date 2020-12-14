package Cx

CxPolicy [ result ] {
	resource := input.document[i].command[_]
    resource.Cmd == "from"
    not resource.Value[0] == "scratch"
    not contains(resource.Value[0], ":") 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM=%s", [resource.Value[0]]),
                "issueType":		"MissingAttribute",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("FROM %s:'version'", [resource.Value[0]]),
                "keyActualValue": 	sprintf("FROM %s'", [resource.Value[0]])
              } 
}



