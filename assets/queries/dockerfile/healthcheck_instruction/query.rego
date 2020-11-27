package Cx

CxPolicy [ result ] {
  resource := input.document[i].resource
  not contains(resource, "healthcheck")

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s", [resource[0].Cmd]),
                "issueType":		"MissingAttribute",  #"MissingAttribute" / "RedundantAttribute"
                "keyExpectedValue": "Dockerfile contains instruction 'HEALTHCHECK'",
                "keyActualValue": 	"Dockerfile doesn't contain instruction 'HEALTHCHECK'"
              }
}

contains(cmd, elem) {
  cmd[_].Cmd = elem
}