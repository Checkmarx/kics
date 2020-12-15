package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[_]
  resource.Cmd == "run"
  contains(resource.Value[0], "gem install ") 
  not contains(resource.Value[0], ":") 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource.Value[0]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s is 'gem install <gem>:<version>'", [resource.Value[0]]),
                "keyActualValue": 	sprintf("%s is 'gem install <gem>', you should use 'gem install <gem>:<version>", [resource.Value[0]])
              }
}