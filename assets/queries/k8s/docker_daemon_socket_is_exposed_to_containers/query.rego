package Cx

import data.generic.k8s as k8s

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
    kind := document.kind
    listKinds := ["Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job"]

	k8s.checkKind(kind, listKinds)

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
