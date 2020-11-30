package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec 
   containers := spec.containers
   containers[c].securityContext.privileged == true 
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].securityContext.privileged", [c]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("spec.containers[%d].securityContext.privileged is false", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].securityContext.privileged is true", [c])
              }
}