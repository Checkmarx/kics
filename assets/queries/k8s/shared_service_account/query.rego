package Cx

CxPolicy [ result ] {
  document := input.document[i]
  metadata := document.metadata
  specInfo := getSpecInfo(document)
  serviceAccount := specInfo.spec.serviceAccountName

  document_other := input.document[j]
  i != j
  specInfo_other := getSpecInfo(document_other)
  serviceAccount_other := specInfo_other.spec.serviceAccountName

  serviceAccount == serviceAccount_other

  result := {
              "documentId":       input.document[i].id,
              "searchKey": 	      sprintf("metadata.name=%s.%s.serviceAccountName", [metadata.name, specInfo.path]),
              "issueType":		    "IncorrectValue",
              "keyExpectedValue": sprintf("'%s.serviceAccountName' is not shared with other workloads", [specInfo.path]),
              "keyActualValue": 	sprintf("'%s.serviceAccountName' is shared with other workloads", [specInfo.path])
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