package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   
   specInfo := get_spec_info(document[i]) 
   containers := specInfo.spec.containers
   check_image_content(containers[j])
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.%s.containers.name=%s.image", [metadata.name, specInfo.path, containers[j].name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.%s.containers.name=%s.image has not kubernetes-dashboard deployed", [metadata.name, specInfo.path, containers[j].name]),
                "keyActualValue": 	sprintf("metadata.name=%s.%s.containers.name=%s.image has kubernetes-dashboard deployed", [metadata.name, specInfo.path, containers[j].name])
             }
}

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   
   specInfo := get_spec_info(document[i])
   init_containers := specInfo.spec.initContainers
   check_image_content(init_containers[j])
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.%s.initContainers.name=%s.image", [metadata.name, specInfo.path, init_containers[j].name]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.%s.initContainers.name=%s.image has not kubernetes-dashboard deployed", [metadata.name, specInfo.path, init_containers[j].name]),
                "keyActualValue": 	sprintf("metadata.name=%s.%s.initContainers.name=%s.image has kubernetes-dashboard deployed", [metadata.name, specInfo.path, init_containers[j].name])
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