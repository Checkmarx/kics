package Cx

CxPolicy [ result ] {
   document := input.document
   metadata := document[i].metadata
   kind := document[i].kind
   check_kind(kind)
   
   spec := input.document[i].spec
   template_spec := spec.template.spec
   containers := template_spec.containers
	
   check_image_content(containers[j])
   
   result := {
                "documentId": 		input.document[i].id,
                "searchKey":      sprintf("metadata.name=%s.spec.template.spec.containers[%d].image", [metadata.name, j]),
                "issueType":		   "IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.template.spec.containers[%d].image has not kubernetes-dashboard deployed", [metadata.name]),
                "keyActualValue": 	sprintf("metadata.name=%s.spec.template.spec.containers[%d].image has kubernetes-dashboard deployed", [metadata.name, j])
              }
}

check_kind(kind) {
	kind == "Deployment"
}

check_image_content(containers) {
  contains(containers.image, "kubernetes-dashboard")
}

check_image_content(containers) {
  contains(containers.image, "kubernetesui")
}