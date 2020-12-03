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
                "searchKey": 	   sprintf("metadata.name=%s.spec.containers.name=%s.ports.hostIP=%s.hostPort", [metadata.name, containers[c].name, ports[k].hostIP]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("spec[%s].containers[%s].ports[%s].hostPort is not Defined", [metadata.name, containers[c].name, ports[k].hostIP]),
                "keyActualValue": 	sprintf("spec[%s].containers[%s].ports[%s].hostPort is Defined", [metadata.name, containers[c].name, ports[k].hostIP])
              }
}
