package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]

    kind := document.kind
    listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob"]
	k8sLib.checkKind(kind, listKinds)

	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	object.get(specInfo.spec, "automountServiceAccountToken", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.automountServiceAccountToken' is false", [specInfo.path]),
		"keyActualValue": sprintf("'%s.automountServiceAccountToken' is undefined", [specInfo.path]),
	}
}

CxPolicy[result] {
	document := input.document[i]

    kind := document.kind
    listKinds := ["Pod", "Deployment", "DaemonSet", "StatefulSet", "ReplicaSet", "ReplicationController", "Job", "CronJob"]
	k8sLib.checkKind(kind, listKinds)

	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec.automountServiceAccountToken == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.automountServiceAccountToken", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.automountServiceAccountToken' is false", [specInfo.path]),
		"keyActualValue": sprintf("'%s.automountServiceAccountToken' is true", [specInfo.path]),
	}
}
