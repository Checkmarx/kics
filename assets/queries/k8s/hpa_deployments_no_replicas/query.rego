package Cx

CxPolicy [ result ] {
  
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  kindCheck := input.document[i].kind
  replicasCheck := spec.replicas
    
  replicasCheck > 0 
  kindCheck == "Deployment"
   
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("metadata.name=%s.spec.replicas", [metadata.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": "metadata.name=%s.spec.replicas doesn't create static replicas",
                "keyActualValue": 	"metadata.name=%s.spec.replicas creates static replicas"
              }
}

CxPolicy [ result ] {
  metadata := input.document[i].metadata
  spec := input.document[i].spec
  kindCheck := input.document[i].kind
  replicasCheck := spec.maxreplicas
  
  replicasCheck > 0 
  kindCheck == "Deployment"
  
	result := {
                "documentId": 		  input.document[i].id,
                "searchKey": 	      sprintf("metadata.name=%s.spec.maxreplicas", [metadata.name]),
                "issueType":		    "IncorrectValue",
                "keyExpectedValue": "metadata.name=%s.spec.replicas doesn't create static replicas",
                "keyActualValue": 	"metadata.name=%s.spec.replicas creates static replicas"
              }
}