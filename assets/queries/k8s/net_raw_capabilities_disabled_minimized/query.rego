package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    spec := document.spec
    containers := spec.containers
    capabilities := spec.containers[k].securityContext.capabilities
    not contains(capabilities.drop, ["ALL","NET_RAW"])
	

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	   sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop",[metadata.name, containers[k].name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop is ALL or NET_RAW",[metadata.name, containers[k].name]),
                "keyActualValue": sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop is not ALL or NET_RAW",[metadata.name, containers[k].name])
              }
}

contains(array, elem) = true {
  upper(array[_]) == elem[_]
} else = false { true }

