package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    document.kind == "PodSecurityPolicy"
    
    document.spec.hostPID == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.hostPID", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'spec.hostPID' is false or undefined",
                "keyActualValue": 	"'spec.hostPID' is true"
              }
}