package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec 
   containers := spec.containers
   containers[c].imagePullPolicy != "Always"
   
   not contains(containers[c].image, ":latest")
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].imagePullPolicy", [c]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("spec.containers[%d].imagePullPolicy should be Always", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].imagePullPolicy is incorrect", [c])
              }
}