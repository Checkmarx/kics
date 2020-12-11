package Cx

CxPolicy [ result ] {
	  document := input.document[i]
    metadata:= document.metadata
    spec := document.spec
    lower(spec.type) == "nodeport"
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("metadata.name=%s.spec.type", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "spec.type is not 'NodePort'",
                "keyActualValue": 	"spec.type is 'NodePort'"
              }
}
