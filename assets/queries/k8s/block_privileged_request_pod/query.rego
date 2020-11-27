package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec
   spec.privileged 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec.privileged",
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": "spec.privileged is false",
                "keyActualValue": 	"spec.privileged is true"
              }
}