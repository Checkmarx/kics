package Cx

CxPolicy [ result ] {
  resource := input.file[i].resource
  resource == "<VALUE>"

	result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("%s", [resource]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "<RESOURCE>",
                "keyActualValue": 	resource
              }
}