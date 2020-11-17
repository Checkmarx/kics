package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource.github_repository[example]
  object.get(resource, "private", "undefined") == "undefined"
  object.get(resource, "visibility", "undefined") == "undefined"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("github_repository[%s]", [example]),
                "issueType":		"MissingAttribute", 
                "keyExpectedValue": "Attribute 'private' is defined or Attribute 'visibility' is defined",
                "keyActualValue": 	"Attribute 'private' is undefined and Attribute 'visibility' is undefined"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.github_repository[example]
  resource.private == false
  not resource.visibility

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("github_repository[%s]", [example]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'private' is true",
                "keyActualValue": 	"Attribute 'private' is false"
              }
}

CxPolicy [ result ] {
  resource := input.document[i].resource.github_repository[example]
  resource.visibility == "public"

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("github_repository[%s]", [example]),
                "issueType":		"IncorrectValue", 
                "keyExpectedValue": "Attribute 'visibility' is 'private'",
                "keyActualValue": 	"Attribute 'visibility' is 'public'"
              }
}