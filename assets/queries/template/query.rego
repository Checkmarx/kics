package Cx

CxPolicy [ result ] {
  resource := "<RESOURCE>"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource]),
                "issueType":		"IncorrectValue",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "<RESOURCE>",
                "keyActualValue": 	resource
            }
}