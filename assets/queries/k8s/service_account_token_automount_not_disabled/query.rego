package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := getSpecInfo(document)

	object.get(specInfo.spec, "automountServiceAccountToken", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s", [metadata.name, specInfo.path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.automountServiceAccountToken' is false", [specInfo.path]),
		"keyActualValue": sprintf("'%s.automountServiceAccountToken' is undefined", [specInfo.path]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := getSpecInfo(document)

	specInfo.spec.automountServiceAccountToken == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.automountServiceAccountToken", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.automountServiceAccountToken' is false", [specInfo.path]),
		"keyActualValue": sprintf("'%s.automountServiceAccountToken' is true", [specInfo.path]),
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
