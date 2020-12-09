package Cx

CxPolicy [ result ] {
    document := input.document[i]
    metadata := document.metadata
    specInfo := getSpecInfo(document)

    specInfo.spec.hostPID == true

	result := {
                "documentId": 		input.document[i].id,
                "searchKey": 	    sprintf("metadata.name=%s.%s.hostPID", [metadata.name, specInfo.path]),
                "issueType":		"IncorrectValue",
                "keyExpectedValue": sprintf("'%s.hostPID' is false or undefined", [specInfo.path]),
                "keyActualValue": 	sprintf("'%s.hostPID' is true", [specInfo.path])
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