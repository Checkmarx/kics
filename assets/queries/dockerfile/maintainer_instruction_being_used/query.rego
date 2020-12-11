package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[_]
  resource.Cmd == "maintainer"
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("MAINTAINER=%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": sprintf("Maintainer instruction being used in Label 'LABEL maintainer=%s'", [resource.Value[0]]),
                "keyActualValue": 	sprintf("Maintainer instruction not being used in Label 'MAINTAINER %s'", [resource.Value[0]])
              }
}
