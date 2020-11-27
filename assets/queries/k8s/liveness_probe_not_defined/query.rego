package Cx

CxPolicy [ result ] {
   spec := input.document[i].spec
   exists_containers := object.get(spec, "containers", "undefined") != "undefined"
   exists_containers
   
   containers := spec.containers
   exists_liveness_probe := object.get(containers[_], "livenessProbe", "undefined") != "undefined"
   exists_liveness_probe
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    "spec.containers.livenessProbe",
                "issueType":		   "MissingAttribute",
                "keyExpectedValue": "spec.containers.livenessProbe is undefined",
                "keyActualValue": 	"spec.containers.livenessProbe is defined"
              }
}