package Cx

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	object.get(document.spec, "allowPrivilegeEscalation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is set",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	document.spec.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.allowPrivilegeEscalation", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is false",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is true",
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
