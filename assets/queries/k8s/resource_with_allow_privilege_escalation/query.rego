package Cx

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)

    contexts := {"securityContext", "security_context"}
    properties := {"allowPrivilegeEscalation", "allow_privilege_escalation"}
    specInfo.spec.containers[_][contexts[c]][properties[p]] == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("%s.containers.%s.%s", [specInfo.path, contexts[c], properties[p]]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("%s.containers.%s.%s = false", [specInfo.path, contexts[c], properties[p]]),
                "keyActualValue": 	sprintf("%s.containers.%s.%s = true", [specInfo.path, contexts[c], properties[p]])
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