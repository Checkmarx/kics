package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	volumes := spec.volumes
	volumes[c].hostPath.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.volumes[%s].hostPath.path is not '/var/run/docker.sock'", [volumes[c].name]),
		"keyActualValue": sprintf("spec.volumes[%s].hostPath.path is '/var/run/docker.sock'", [volumes[c].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind != "Pod"
	document.kind != "CronJob"
	metadata := document.metadata
	spec := document.spec.template.spec
	volumes := spec.volumes
	volumes[c].hostPath.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.volumes[%s].hostPath.path is not '/var/run/docker.sock'", [volumes[c].name]),
		"keyActualValue": sprintf("spec.volumes[%s].hostPath.path is '/var/run/docker.sock'", [volumes[c].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "CronJob"
	metadata := document.metadata
	spec := document.spec.jobTemplate.spec.template.spec
	volumes := spec.volumes
	volumes[c].hostPath.path == "/var/run/docker.sock"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.volumes.name=%s.hostPath.path", [metadata.name, volumes[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.volumes[%s].hostPath.path is not '/var/run/docker.sock'", [volumes[c].name]),
		"keyActualValue": sprintf("spec.volumes[%s].hostPath.path is '/var/run/docker.sock'", [volumes[c].name]),
	}
}
