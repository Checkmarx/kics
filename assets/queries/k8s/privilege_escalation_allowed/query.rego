package Cx

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    containers := document.spec.containers
    
    object.get(containers[index]["securityContext"],"allowPrivilegeEscalation", "undefined") == "undefined"
    

	result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("metadata.name=%s.%s.containers.name=%s.securityContext", [metadata.name, specInfo.path, containers[index].name]),
                "issueType":         "MissingAttribute",
                "keyExpectedValue":  sprintf("%s.containers[%s].securityContext is set", [specInfo.path, containers[index].name]),
                "keyActualValue":    sprintf("%s.containers[%s].securityContext is undefined", [specInfo.path, containers[index].name])
              }
}

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    containers := document.spec.containers
    containers[index].securityContext.allowPrivilegeEscalation == true
    

	result := {
                "documentId":        input.document[i].id,
                "searchKey":         sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.allowPrivilegeEscalation", [metadata.name, specInfo.path, containers[index].name]),
                "issueType":         "IncorrectValue",
                "keyExpectedValue":  sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is false", [specInfo.path, containers[index].name]),
                "keyActualValue":    sprintf("%s.containers[%s].securityContext.allowPrivilegeEscalation is true", [specInfo.path, containers[index].name])
              }
}

getSpecInfo(document) = specInfo {
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