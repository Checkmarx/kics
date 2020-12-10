package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    spec := document.spec.template.spec
    containers := spec.containers
    cap := containers[c].securityContext.capabilities
    not contains(cap.drop,"ALL")
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop", [metadata.name, containers[c].name]),
                "issueType":		"IncorrectValue",
				        "keyExpectedValue": sprintf("spec.containers[%s].securityContext.capabilities.drop is not Defined", [metadata.name, containers[c].name]),
                "keyActualValue": 	sprintf("spec.containers[%s].securityContext.capabilities.drop", [metadata.name, containers[c].name])
              }
}

contains(array, elem) = true {
  upper(array[_]) == elem
} else = false { true }
