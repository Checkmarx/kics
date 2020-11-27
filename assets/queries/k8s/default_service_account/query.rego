package Cx

CxPolicy [ result ] {
    document := input.document[i]
    
    document.kind == "ServiceAccount"
    
    document.metadata.name == "default"
    
    object.get(document.metadata, "automountServiceAccountToken", "undefined") == "undefined"

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "MissingAttribute",
                "searchKey": 	      "metadata",
                "keyExpectedValue":   sprintf("Attribute 'automountServiceAccountToken' is set in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Attribute 'automountServiceAccountToken' is undefined in document[%d]",[i])
              }
}



CxPolicy [ result ] {
    document := input.document[i]
    
    document.kind == "ServiceAccount"
    
    document.metadata.name == "default"
    
    document.metadata.automountServiceAccountToken != false

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "IncorrectValue",
                "searchKey": 	      "metadata.automountServiceAccountToken",
                "keyExpectedValue":   sprintf("Attribute 'automountServiceAccountToken' is false in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Attribute 'automountServiceAccountToken' is true in document[%d]",[i])
              }
}
