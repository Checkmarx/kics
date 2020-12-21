package Cx

CxPolicy [ result ] {
	document := input.document[i]
	metadata := input.document[i].metadata
  spec := input.document[i].spec

  document.kind == "PodSecurityPolicy"

  spec.allowedProcMountTypes[_] == "Unmasked"
    
	result := {
    			    "documentId": 		input.document[i].id,
              "searchKey": 	    sprintf("metadata.name=%s.spec.allowedProcMountTypes", [metadata.name]),
              "issueType":		"IncorrectValue",
              "keyExpectedValue": "AllowedProcMountTypes contains the value Default",
              "keyActualValue": 	"AllowedProcMountTypes contains the value Unmasked",
            }
  
}