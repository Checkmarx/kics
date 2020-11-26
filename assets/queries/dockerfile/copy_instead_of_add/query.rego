package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource[j]
  check(resource, input.document[i].resource[j+1]) == true
  
	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource["Value"][0]]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Using Command COPY",
                "keyActualValue": 	"Using Command ADD"
              }
}

check(com, nextCom) = true{
  com["Cmd"] == "add"
  not nextCom["Cmd"] == "run"
  value := nextCom["Value"][_]
  not contains(value, "tar")
}
