package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec 
   requests := spec.containers[c].resources.requests
   exists_memory := object.get(requests, "memory", "undefined") != "undefined"
   not exists_memory
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].requests.memory", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].resources.requests.memory is defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].resources.requests.memory is undefined", [c])
              }
}


CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   not exists_containers
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec",
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": "spec.containers are defined",
                "keyActualValue": 	"spec.containers are undefined"
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
   not exists_resources
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d]", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].resources are defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].resources are undefined", [c])
              }
}

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
   exists_resources
   
   resources := spec.containers[c].resources
   exists_requests := object.get(resources, "requests", "undefined") != "undefined"
   not exists_requests
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d]", [c]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].resources.requests are defined", [c]),
                "keyActualValue": 	sprintf("spec.containers[%d].resources.requests are undefined", [c])
              }
}