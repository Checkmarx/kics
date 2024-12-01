package Cx

import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata

	specInfo := k8sLib.getSpecInfo(document)
	some volume in specInfo.spec.volumes

	volume.hostPath.path == "/var/run/docker.sock"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path", [metadata.name, specInfo.path, volume.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path should not be '/var/run/docker.sock'", [metadata.name, specInfo.path, volume.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.%s.volumes.name={{%s}}.hostPath.path is '/var/run/docker.sock'", [metadata.name, specInfo.path, volume.name]),
	}
}
