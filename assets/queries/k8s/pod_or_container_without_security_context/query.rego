package Cx

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)

	metadata := document.metadata

	spec := document.spec

	document.kind == "Pod"

	object.get(spec, "securityContext", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": sprintf("metadata.name=%s.%s has a security context", [metadata.name, specInfo.path]),
		"keyActualValue": sprintf("metadata.name=%s.%s does not have a security context", [metadata.name, specInfo.path]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)

	metadata := document.metadata

	containers := document.spec.containers

	object.get(containers[index], "securityContext", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s has a security context", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s does not have a security context", [specInfo.path, containers[index].name]),
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
