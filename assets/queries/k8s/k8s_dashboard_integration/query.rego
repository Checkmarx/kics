package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   
   spec := get_spec_info(document[i]).spec
   containers := spec.containers
   check_image_content(containers[j])
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.spec.template.spec.containers[%d].image", [metadata.name, j]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.template.spec.containers[%d].image has not kubernetes-dashboard deployed", [metadata.name, j]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.template.spec.containers[%d].image has kubernetes-dashboard deployed", [metadata.name, j])
             }
}

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   
   spec := get_spec_info(document[i]).spec
   init_containers := spec.initContainers
   check_image_content(init_containers[j])
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.spec.template.spec.initContainers[%d].image", [metadata.name, j]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.template.spec.initContainers[%d].image has not kubernetes-dashboard deployed", [metadata.name, j]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.template.spec.initContainers[%d].image has kubernetes-dashboard deployed", [metadata.name, j])
             }
}

check_image_content(containers) {
  contains(containers.image, "kubernetes-dashboard")
}

check_image_content(containers) {
  contains(containers.image, "kubernetesui")
}

get_spec_info(document) = specInfo {
  templates := {"job_template", "jobTemplate"}
  spec := document.spec[templates[t]].spec.template.spec
  specInfo := {"spec": spec, "path": sprintf("spec.%s.spec.template.spec", [templates[t]])}
} else = specInfo {
  spec := document.spec.template.spec
  specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
  spec := document.spec
  specInfo := {"spec": spec, "path": "spec"}
}