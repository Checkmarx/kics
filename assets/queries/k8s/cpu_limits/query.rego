package Cx

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    containers := document.spec.containers
    
    
    object.get(containers[index]["resources"]["limits"], "cpu", "undefined") == "undefined"
 
    result := {
                "documentId":        input.document[i].id,
                "issueType":         "MissingAttribute",
                "searchKey":         sprintf("metadata.name=%s.%s.containers.name=%s.resources.limits", [metadata.name, specInfo.path, containers[index].name]),
                "keyExpectedValue":  sprintf("%s.containers.name=%s does have CPU limits",[specInfo.path, containers[index].name]),
                "keyActualValue":    sprintf("%s.containers.name=%s doesn't have CPU limits",[specInfo.path, containers[index].name])
              }
}

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    containers := document.spec.containers
    
    
    object.get(containers[index]["resources"], "limits", "undefined") == "undefined"
 
    result := {
                "documentId":        input.document[i].id,
                "issueType":         "MissingAttribute",
                "searchKey":         sprintf("metadata.name=%s.%s.containers.name=%s.resources", [metadata.name, specInfo.path, containers[index].name]),
                "keyExpectedValue":  sprintf("%s.containers.name=%s. does have limits defined",[specInfo.path, containers[index].name]),
                "keyActualValue":    sprintf("%s.containers.name=%s. doesn't have limits defined",[specInfo.path, containers[index].name])
              }
}

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    containers := document.spec.containers
    
    
    object.get(containers[index], "resources", "undefined") == "undefined"
 
    result := {
                "documentId":        input.document[i].id,
                "issueType":         "MissingAttribute",
                "searchKey":         sprintf("metadata.name=%s.%s.containers.name=%s", [metadata.name, specInfo.path, containers[index].name]),
                "keyExpectedValue":  sprintf("%s.containers.name=%s. does have resources defined",[specInfo.path, containers[index].name]),
                "keyActualValue":    sprintf("%s.containers.name=%s. doesn't have resources defined",[specInfo.path, containers[index].name])
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