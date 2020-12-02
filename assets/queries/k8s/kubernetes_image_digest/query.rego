package Cx

CxPolicy [ result ] {
	document := input.document[i]
  metadata:= document.metadata
  spec := document.spec
  containers := spec.containers
  not containers[c].imagePullPolicy == "Always"
    
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("metadata.name=%s.spec.containers.name=%s.imagePullPolicy", [metadata.name, containers[c].name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("spec[%s].containers[%s].imagePullPolicy is Always", [metadata.name, containers[c].name]),
                "keyActualValue": 	sprintf("spec[%s].containers[%s].imagePullPolicy is not Always", [metadata.name, containers[c].name])
              }
}

