package Cx

CxPolicy [ result ] {
    document := input.document[i]
    
    document.kind == "ServiceAccount"
    
    metadata := document.metadata
    metadata.name == "default"
    
    object.get(document.metadata, "automountServiceAccountToken", "undefined") == "undefined"

	  result := {
                "documentId": 		    input.document[i].id,
                "issueType":		      "MissingAttribute",
                "searchKey": 	        sprintf("metadata.name=%s", [metadata.name]),
                "keyExpectedValue":   sprintf("Attribute 'automountServiceAccountToken' is set in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Attribute 'automountServiceAccountToken' is undefined in document[%d]",[i])
              }
}


CxPolicy [ result ] {
    document := input.document[i]
    
    document.kind == "ServiceAccount"
    
    metadata := document.metadata
    metadata.name == "default" 
    
    metadata.automountServiceAccountToken == true
	   
    result := {
                "documentId": 		    input.document[i].id,
                "issueType":		      "IncorrectValue",
                "searchKey": 	        sprintf("metadata.name=%s.automountServiceAccountToken", [metadata.name]),
                "keyExpectedValue":   sprintf("Attribute 'automountServiceAccountToken' is false in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Attribute 'automountServiceAccountToken' is true in document[%d]",[i])
              }
}