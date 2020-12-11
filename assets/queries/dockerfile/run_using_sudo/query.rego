package Cx

CxPolicy [ result ] {
	resource := input.document[i].command[_]
    resource.Cmd == "run"
    contains(resource.Value[_], "sudo ") 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("RUN=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "RUN instruction doesn't contain sudo",
                "keyActualValue": 	"RUN instruction contains sudo"
              } 
}