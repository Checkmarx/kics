package Cx

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)
	metadata := document.metadata

	containers := document.spec.containers

	object.get(containers[index].securityContext.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.containers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, containers[index].name]),
		"keyExpectedValue": sprintf("%s.containers.name=%s. does not have added capability", [specInfo.path, containers[index].name]),
		"keyActualValue": sprintf("%s.containers.name=%s. has added capability", [specInfo.path, containers[index].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := getSpecInfo(document)
	metadata := document.metadata

	initContainers := document.spec.initContainers

	object.get(initContainers[index].securityContext.capabilities, "add", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.initContainers.name=%s.securityContext.capabilities.add", [metadata.name, specInfo.path, initContainers[index].name]),
		"keyExpectedValue": sprintf("%s.initContainers.name=%s. does not have added capability", [specInfo.path, initContainers[index].name]),
		"keyActualValue": sprintf("%s.initContainers.name=%s. has added capability", [specInfo.path, initContainers[index].name]),
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
