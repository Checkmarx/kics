package Cx

CxPolicy [ result ] {
   metadata := input.document[i].metadata
   spec := input.document[i].spec 
   containers := spec.containers
   requests := containers[c].resources.requests
   exists_memory := object.get(requests, "memory", "undefined") != "undefined"
   not exists_memory
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":        sprintf("metadata.name=%s.spec.containers[%d].name=%s.requests.memory", [metadata.name, c, containers[c].name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.requests.memory is defined", [metadata.name, c, containers[c].name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.containers[%d].name=%s.requests.memory is undefined", [metadata.name, c, containers[c].name])
              }
}