package Cx

CxPolicy [ result ] {
   resource := input.document[i].resource.kubernetes_pod[name]
   spec := resource.spec
   exists_container := object.get(spec, "container", "undefined") != "undefined"
   exists_container
   
   container := resource.spec.container
   exists_resources := object.get(container, "resources", "undefined") != "undefined"
   exists_resources
   
   resources := resource.spec.container.resources
   exists_requests := object.get(resources, "requests", "undefined") != "undefined"
   exists_requests
   
   requests := resource.spec.container.resources.requests
   exists_memory := object.get(requests, "memory", "undefined") != "undefined"
   exists_memory
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("kubernetes_pod[%s].spec.container.resources.requests.memory", [name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("kubernetes_pod[%s].spec.container.resources.requests.memory is undefined", [name]),
                "keyActualValue": 	sprintf("kubernetes_pod[%s].spec.container..resources.requests.memory is defined", [name])
              }
}