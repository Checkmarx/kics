package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    document.kind == "PodSecurityPolicy"

    document.spec.hostIPC == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.hostIPC", [metadata.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": "'spec.hostIPC' is false or undefined",
                "keyActualValue": 	"'spec.hostIPC' is true"
              }
} 