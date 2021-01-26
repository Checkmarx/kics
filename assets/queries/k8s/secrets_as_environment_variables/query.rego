package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := getSpecInfo(document)

	containers := ["containers", "initContainers"]

	specInfo.spec[containers[c]][j].env[k].valueFrom.secretKeyRef

	container_name := specInfo.spec[containers[c]][j].name
	env_name := specInfo.spec[containers[c]][j].env[k].name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.%s.name=%s.env.name=%s.valueFrom.secretKeyRef", [metadata.name, specInfo.path, containers[c], container_name, env_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s.name=%s.env.name=%s.valueFrom.secretKeyRef' is undefined", [specInfo.path, containers[c], container_name, env_name]),
		"keyActualValue": sprintf("'%s.%s.name=%s.env.name=%s.valueFrom.secretKeyRef' is defined", [specInfo.path, containers[c], container_name, env_name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := getSpecInfo(document)

	containers := ["containers", "initContainers"]

	specInfo.spec[containers[c]][j].envFrom[k].secretRef

	container_name := specInfo.spec[containers[c]][j].name

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.%s.%s.name=%s.envFrom", [metadata.name, specInfo.path, containers[c], container_name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.%s.name=%s.envFrom.secretRef' is undefined", [specInfo.path, containers[c], container_name]),
		"keyActualValue": sprintf("'%s.%s.name=%s.envFrom.secretRef' is defined", [specInfo.path, containers[c], container_name]),
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
