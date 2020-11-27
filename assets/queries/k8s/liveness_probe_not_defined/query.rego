package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers[name]
   not exists_liveness_probe(containers)
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("spec.containers[%d].livenessProbe", [name]),
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": sprintf("spec.containers[%d].livenessProbe is defined", [name]),
                "keyActualValue": 	sprintf("spec.containers[%d].livenessProbe is undefined", [name])
              }
}

exists_liveness_probe(container) = true {
	container.livenessProbe != null
}