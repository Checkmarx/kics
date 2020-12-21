package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   spec := document[i].spec 
   containers := spec.containers
   containers[c].imagePullPolicy != "Always"
   
   not contains(containers[c].image, ":latest")
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers[%d].imagePullPolicy", [metadata.name, c]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].imagePullPolicy should be Always", [metadata.name, c]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.containers[%d].imagePullPolicy is incorrect", [metadata.name, c])
              }
}