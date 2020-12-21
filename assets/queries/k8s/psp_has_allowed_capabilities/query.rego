package Cx

CxPolicy [ result ] {
    document := input.document[i]
    specInfo := getSpecInfo(document)
    metadata := document.metadata

    document.kind == "PodSecurityPolicy"
    
    object.get(document.spec,"allowedCapabilities", "undefined") != "undefined"

	result := {
                "documentId": 		  input.document[i].id,
                "issueType":		  "IncorrectValue",
                "searchKey":          sprintf("metadata.name=%s.%s.allowedCapabilities", [metadata.name, specInfo.path]),
                "keyExpectedValue":   "PodSecurityPolicy does not have allowed capabilities",
                "keyActualValue": 	  "PodSecurityPolicy has allowed capabilities"
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