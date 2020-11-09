package Cx

CxPolicy [ result ] {
    file := input.file[i]
    specInfo := getSpecInfo(file)

    contexts := {"securityContext", "security_context"}
    properties := {"allowPrivilegeEscalation", "allow_privilege_escalation"}
    specInfo.spec.containers[_][contexts[c]][properties[p]] == true

	result := {
                "fileId": 		    input.file[i].id,
                "searchKey": 	    sprintf("%s.containers.%s.%s", [specInfo.path, contexts[c], properties[p]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s.containers.%s.%s = false", [specInfo.path, contexts[c], properties[p]]),
                "keyActualValue": 	sprintf("%s.containers.%s.%s = true", [specInfo.path, contexts[c], properties[p]]),
                "line":             "COMPUTED",
                "queryId":          data.id,
                "queryName":        data.queryName,
                "severity":         data.severity,
                "category":         data.category,
                "descriptionText":  data.descriptionText,
                "descriptionUrl":   data.descriptionUrl
              }
}

getSpecInfo(file) = specInfo {
    templates := {"job_template", "jobTemplate"}
    spec := file.spec[templates[t]].spec.template.spec
    specInfo := {"spec": spec, "path": sprintf("spec.%s.spec.template.spec", [templates[t]])}
} else = specInfo {
    spec := file.spec.template.spec
    specInfo := {"spec": spec, "path": "spec.template.spec"}
} else = specInfo {
    spec := file.spec
    specInfo := {"spec": spec, "path": "spec"}
}