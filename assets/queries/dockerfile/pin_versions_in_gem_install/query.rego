package Cx

CxPolicy [ result ] {
  resource := input.document[i].command[name][_]
  resource.Cmd == "run"
  contains(resource.Original, "gem install ") 
  not contains(resource.Original, ":") 

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("FROM={{%s}}.{{%s}}", [name, resource.Original]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s is 'gem install <gem>:<version>'", [resource.Original]),
                "keyActualValue": 	sprintf("%s is 'gem install <gem>', you should use 'gem install <gem>:<version>", [resource.Original])
              }
}