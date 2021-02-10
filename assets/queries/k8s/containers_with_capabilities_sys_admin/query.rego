package Cx

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers

	add := object.get(containers[index].securityContext.capabilities, "add", "undefined")
	add != "undefined"
	add[_] == "SYS_ADMIN"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s. does not use CAP_SYS_ADMIN Linux capability", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s. uses CAP_SYS_ADMIN Linux capability", [specInfo.path, containers[index].name]),
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
