package Cx

CxPolicy [ result ] {
    document := input.document[i]
    
    not document.metadata.namespace

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "MissingAttribute",
                "searchKey": 	      "metadata",
                "keyExpectedValue":   sprintf("Namespace is set in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Namespace is not set in document[%d]",[i])
              }
}


CxPolicy [ result ] {
    document := input.document[i]
    
    document.metadata.namespace == "default"

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "IncorrectValue",
                "searchKey": 	      "metadata.namespace",
                "keyExpectedValue":   sprintf("Default namespace is not used in document[%d]",[i]),
                "keyActualValue": 	  sprintf("Default namespace is used in document[%d]",[i])
              }
}