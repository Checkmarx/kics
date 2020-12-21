package Cx

CxPolicy [ result ] {
	  document := input.document[i]
    metadata:= document.metadata
    spec := document.spec
    containers := spec.containers
	  ports := containers[c].ports
    object.get(ports[k],"hostPort","undefined") != "undefined"
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("metadata.name=%s.spec.containers.name=%s.ports", [metadata.name, containers[c].name]), 
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("spec[%s].containers[%s].ports[%s].hostPort is not Defined", [metadata.name, containers[c].name, ports[k].hostIP]),
                "keyActualValue": 	sprintf("spec[%s].containers[%s].ports[%s].hostPort is Defined", [metadata.name, containers[c].name, ports[k].hostIP])
              }
}

CxPolicy [ result ] {
	  document := input.document[i]
    document.kind = "Pod"
    metadata:= document.metadata
    spec := document.spec.template.spec
    containers := spec.containers
	  ports := containers[c].ports
    object.get(ports[k],"hostPort","undefined") != "undefined"
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("metadata.name=%s.spec.template.spec.containers.name=%s.ports", [metadata.name, containers[c].name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("spec[%s].template.spec.containers[%s].ports[%s].hostPort is not Defined", [metadata.name, containers[c].name, ports[k].hostIP]),
                "keyActualValue": 	sprintf("spec[%s].template.spec.containers[%s].ports[%s].hostPort is Defined", [metadata.name, containers[c].name, ports[k].hostIP])
              }
}
