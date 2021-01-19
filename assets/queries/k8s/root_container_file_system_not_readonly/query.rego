package Cx

CxPolicy [ result ] {
    document := input.document[i]

    some j
      container := document.spec.containers[j]
      object.get(container,"securityContext","undefined") == "undefined"
    
    metadata := document.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s",[metadata.name,container.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'spec.containers[%d].securityContext' is set",[j]),
                "keyActualValue": sprintf("'spec.containers[%d].securityContext' is undefined",[j])
              }
}

CxPolicy [ result ] {
    document := input.document[i]

    some j
      container := document.spec.containers[j]
      securityContext := container.securityContext
      object.get(securityContext,"readOnlyRootFilesystem","undefined") == "undefined"
    
    metadata := document.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s.securityContext",[metadata.name,container.name]),
                "issueType":		"MissingAttribute",
                "keyExpectedValue": sprintf("'spec.containers[%d].securityContext.readOnlyRootFilesystem' is set and is true",[j]),
                "keyActualValue": sprintf("'spec.containers[%d].securityContext.readOnlyRootFilesystem' is undefined",[j])
              }
}

CxPolicy [ result ] {
    document := input.document[i]

    some j
      container := document.spec.containers[j]
      container.securityContext.readOnlyRootFilesystem == false
    
    metadata := document.metadata
    result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.readOnlyRootFilesystem",[metadata.name,container.name]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'spec.containers[%d].securityContext.readOnlyRootFilesystem' is true",[j]),
                "keyActualValue": sprintf("'spec.containers[%d].securityContext.readOnlyRootFilesystem' is false",[j])
              }
}