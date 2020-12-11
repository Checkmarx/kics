package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    spec := document.spec.template.spec
    containers := spec.containers
    cap := containers[c].securityContext.capabilities
    object.get(cap, "drop", "undefined") == "undefined"
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities", [metadata.name, containers[c].name]),
                "issueType":		"MissingAttribute",
				        "keyExpectedValue": sprintf("spec.containers[%s].securityContext.capabilities.drop is Defined", [metadata.name, containers[c].name]),
                "keyActualValue": 	sprintf("spec.containers[%s].securityContext.capabilities.drop is not Defined", [metadata.name, containers[c].name])
              }
}

